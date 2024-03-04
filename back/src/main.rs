extern crate actix_web;

// use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use tokio_postgres::{NoTls, Error};

// #[get("/")]
// async fn hello() -> impl Responder {
//     HttpResponse::Ok().body("Hello world!")
// }
//
// #[post("/echo")]
// async fn echo(req_body: String) -> impl Responder {
//     HttpResponse::Ok().body(req_body)
// }

// async fn manual_hello() -> impl Responder {
//     HttpResponse::Ok().body("Hey there!")
// }

#[actix_web::main]
async fn main() -> Result<(), Error> {

    dotenv::dotenv().ok();
    let host = std::env::var("PG_HOST").expect("PG_HOST not set in .env");
    let user = std::env::var("PG_USER").expect("PG_USER not set in .env");
    let password = std::env::var("PG_PASSWORD").expect("PG_PASSWORD not set in .env");
    let dbname = std::env::var("PG_DATABASE").expect("PG_DATABASE not set in .env");

    let conn_string = format!("host={} user={} password={} dbname={}", host, user, password, dbname);
    let (client, connection) = tokio_postgres::connect(&conn_string, NoTls).await?;


    // The connection object performs the actual communication with the database,
    // so spawn it off to run on its own.
    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
        }
    });

    // Now we can execute a simple statement that just returns its parameter.
    let rows = client
        .query("SELECT * FROM User", &[])
        .await?;

    println!("{rows:?}");


    // HttpServer::new(|| {
    //     App::new()
    //         .service(hello)
    //         .service(echo)
    //         .route("/hey", web::get().to(manual_hello))
    // })
    //     .bind(("127.0.0.1", 8081))?
    //     .run()
    //     .await?;

    Ok(())
}
