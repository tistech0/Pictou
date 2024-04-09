mod config;
mod database;
mod schema;
mod storage;

use crate::config::AppConfiguration;
use crate::database::{Database, SimpleDatabaseError};
use actix_web::web;
use actix_web::web::Data;
use diesel::dsl::insert_into;
use diesel::prelude::*;
use dotenv::dotenv;
use fake::faker::name::en::Name;
use fake::Fake;
use tracing::{debug, info};

use crate::schema::*;

#[derive(Insertable)]
#[diesel(table_name = crate::schema::users)]
struct NewUser {
    email: String,
    name: Option<String>,
}

pub async fn seed_database(db: Data<Database>) {
    let _ = database::open(db, move |conn| {
        // Create some fake users
        let new_users = (0..5)
            .map(|_| {
                let name: Option<String> = Some(Name().fake());
                let email_prefix = name.clone().unwrap().to_lowercase().replace(" ", ".");
                let email_domain = "example.com";
                info!("Creating user with email {}", email_prefix);
                let email = format!("{}@{}", email_prefix, email_domain);
                NewUser { email, name }
            })
            .collect::<Vec<_>>();

        for new_user in new_users {
            insert_into(users::table)
                .values(new_user)
                .execute(conn)
                .map_err(SimpleDatabaseError::from)?;
        }

        // Create some fake images

        Ok(())
    })
    .await;
}
#[actix_web::main]
async fn main() {
    dotenv().unwrap_or_else(|err| {
        eprintln!("Failed to read environment from .env: {:?}", err);
        std::process::exit(1);
    });

    let app_cfg = web::Data::from(AppConfiguration::from_env().unwrap_or_else(|err| {
        eprintln!("Failed to load configuration from environment: {:?}", err);
        std::process::exit(1);
    }));

    debug!(?app_cfg, "loaded configuration from environment");

    let database = Data::new(Database::new(&app_cfg).unwrap_or_else(|err| {
        eprintln!("Failed to initialize database: {:?}", err);
        std::process::exit(1);
    }));

    seed_database(database).await;

    println!("Seeding complete!");
}
