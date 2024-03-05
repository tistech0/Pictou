use actix_web::{get, post, web, HttpResponse, Responder};
use serde::Deserialize;

#[derive(Clone, Deserialize)]
pub enum ImageQuality {
    Low,
    Medium,
    High
}

#[derive(Deserialize)]
struct ImageQuery {
    limit: Option<i32>,
    offset: Option<i32>,
    quality: Option<ImageQuality>,
}

#[get("{id}")]
pub async fn get_image(img_id: web::Path<u16>, query: web::Query<ImageQuery>) -> impl Responder {
    let quality = query.quality.as_ref().unwrap_or(&ImageQuality::Low).clone();
    HttpResponse::Ok().body(format!("Get image {} in {} quality ({})", img_id, serde_json::to_string(&quality).unwrap() , query.limit.unwrap_or(0)))
}


pub fn configure(cfg: &mut web::ServiceConfig) {
    //define your methods here
    cfg
        .service(get_image);
}
