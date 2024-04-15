use actix_web::web;
use dotenv::dotenv;
use pictou::config::AppConfiguration;

#[ignore]
#[actix_rt::test]
#[tracing::instrument]
async fn start_server() {
    let _guard = pictou::log::init();

    dotenv().unwrap();

    let app_cfg = web::Data::from(AppConfiguration::from_env().unwrap());

    let _ = tokio::time::timeout(std::time::Duration::from_secs(1), async {
        pictou::start_server(app_cfg).await.unwrap()
    })
    .await;

    assert!(true)
}
