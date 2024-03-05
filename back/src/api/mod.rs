pub mod images;
use actix_web::web;

pub fn configure(cfg: &mut web::ServiceConfig) {
    //define your methods here
    cfg.service(web::scope("/images").configure(images::configure));
}
