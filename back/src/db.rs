use std::env::var;
use dotenv::dotenv;
use tokio_postgres::{Error, NoTls};

pub async fn connect_to_db() -> Result<(), Error> {
    dotenv().ok();
    let host = var("POSTGRES_HOST").expect("PG_HOST not set in .env");
    let user = var("POSTGRES_USER").expect("PG_USER not set in .env");
    let password = var("POSTGRES_PASSWORD").expect("PG_PASSWORD not set in .env");
    let dbname = var("POSTGRES_DB").expect("PG_DATABASE not set in .env");

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
    Ok(())
}

