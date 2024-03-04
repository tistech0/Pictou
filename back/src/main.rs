use std::io;

use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
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

async fn manual_hello() -> impl Responder {
    HttpResponse::Ok().body("Hey there!")
}

#[actix_web::main]
#[tracing::instrument]
async fn main() -> io::Result<()> {
    let _guard = log::init();

    let address = "127.0.0.1";
    let port = 8080;
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
