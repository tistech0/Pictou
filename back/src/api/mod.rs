pub mod albums;
pub mod images;
pub mod users;
use actix_web::web;

pub fn configure(cfg: &mut web::ServiceConfig) {
    //define your methods here
    cfg.service(web::scope("/images").configure(images::configure))
        .service(web::scope("/albums").configure(albums::configure))
        .service(web::scope("/users").configure(users::configure));
}
