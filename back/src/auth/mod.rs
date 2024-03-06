use actix_web::web::{self, ServiceConfig};

use crate::config::AppConfiguration;

pub mod google;

/// Exposes all HTTP routes of this module.
pub fn routes(service_cfg: &mut ServiceConfig, app_cfg: web::Data<AppConfiguration>) {
    google::routes(service_cfg, app_cfg);
    // cfg.configure(google::routes);
    // cfg.service(web::scope("/google").configure(google::routes));
}
