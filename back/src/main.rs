use std::env::var;
use std::io;

use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use dotenv::dotenv;
use tokio_postgres::{Error, NoTls};
use tracing::{info, warn};
use tracing_actix_web::TracingLogger;

mod log;

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello world!")
}

#[post("/echo")]
async fn echo(req_body: String) -> impl Responder {
    warn!("somebody echoed us!");
    HttpResponse::Ok().body(req_body)
}

async fn connect_to_db() -> Result<(), Error> {
    dotenv().ok();
    let host = var("PG_HOST").expect("PG_HOST not set in .env");
    let user = var("PG_USER").expect("PG_USER not set in .env");
    let password = var("PG_PASSWORD").expect("PG_PASSWORD not set in .env");
    let dbname = var("PG_DATABASE").expect("PG_DATABASE not set in .env");

    let conn_string = format!(
        "host={} user={} password={} dbname={}",
        host, user, password, dbname
    );
    let (client, connection) = tokio_postgres::connect(&conn_string, NoTls).await?;

    // The connection object performs the actual communication with the database,
    // so spawn it off to run on its own.
    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
        }
    });

    // Now we can execute a simple statement that just returns its parameter.
    let rows = client.query("SELECT * FROM User", &[]).await?;

    println!("{rows:?}");

    Ok(())
}

async fn manual_hello() -> impl Responder {
    HttpResponse::Ok().body("Hey there!")
}

#[actix_web::main]
#[tracing::instrument]
async fn main() -> io::Result<()> {
    let _guard = log::init();
    connect_to_db().await.expect("failed to connect to db");
    dotenv().ok();
    let port = var("PORT")
        .expect("PORT not set in .env")
        .as_str()
        .parse::<u16>()
        .expect("PORT is not a valid number");
    let address = &*var("ADDRESS").expect("ADDRESS not set in .env");
    let server = HttpServer::new(|| {
        App::new()
            .wrap(TracingLogger::default())
            .service(hello)
            .service(echo)
            .route("/hey", web::get().to(manual_hello))
    })
    .bind((address, port))?;

    info!(address, port, "starting Pictou server");
    server.run().await
}
