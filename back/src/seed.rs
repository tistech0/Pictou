mod config;
mod database;
mod image;
mod schema;
mod storage;

use crate::config::AppConfiguration;
use crate::database::{Database, SimpleDatabaseError};
use crate::image::decode;
use actix_web::web;
use actix_web::web::Data;
use diesel::dsl::insert_into;
use diesel::prelude::*;
use dotenv::dotenv;
use fake::faker::name::en::Name;
use fake::Fake;
use std::pin::Pin;
use std::sync::Arc;
use tokio::io::AsyncWriteExt;
use tracing::{debug, error, info};
use zstd_safe::WriteBuf;

use crate::schema::*;
use crate::storage::{ImageHash, ImageStorage, LocalImageStorage, StoredImageKind};

#[derive(Insertable)]
#[diesel(table_name = crate::schema::users)]
struct NewUser {
    email: String,
    name: Option<String>,
}

#[derive(Insertable, Clone)]
#[diesel(table_name = crate::schema::stored_images)]
struct NewStoredImage {
    hash: ImageHash,
    compression_alg: String,
    size: i64,
    width: i64,
    height: i64,
    orignal_mime_type: String,
}
pub async fn seed_users(db: Data<Database>) {
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
        Ok(())
    })
    .await;
}

async fn seed_images(storage: Data<dyn ImageStorage>) -> Vec<NewStoredImage> {
    let images_url = "https://picsum.photos/200/300.jpg";
    let mut image_data_vec = Vec::new();

    for _ in 0..5 {
        let image_bytes = match reqwest::get(images_url).await {
            Ok(response) => match response.bytes().await {
                Ok(bytes) => bytes,
                Err(err) => {
                    error!("Failed to get image bytes: {}", err);
                    continue;
                }
            },
            Err(err) => {
                error!("Failed to fetch image: {}", err);
                continue;
            }
        };

        eprintln!("Image bytes: {:?}", image_bytes.len());

        let image_type = image::ImageType::Jpeg;

        let decoded = match decode(
            image_type,
            Pin::new(&mut image_bytes.as_slice()),
            image_bytes.len(),
        )
        .await
        {
            Ok(decoded) => decoded,
            Err(err) => {
                error!("Failed to decode image: {}", err);
                continue;
            }
        };

        let mut output = match storage
            .store(decoded.hash(), StoredImageKind::Original)
            .await
        {
            Ok(output) => output,
            Err(err) => {
                error!("Failed to store image: {}", err);
                continue;
            }
        };

        if let Err(err) = output.write_all(decoded.original_bytes()).await {
            error!("Failed to write image bytes to storage: {}", err);
            continue;
        }

        let image_data = NewStoredImage {
            hash: decoded.hash(),
            compression_alg: "jxl".to_owned(),
            size: decoded.size(),
            width: decoded.width(),
            height: decoded.height(),
            orignal_mime_type: image_type.as_mime().to_owned(),
        };

        image_data_vec.push(image_data);
    }
    image_data_vec
}
async fn insert_image_data(db: Data<Database>, image_data: Vec<NewStoredImage>) {
    let _ = database::open(db, move |conn| {
        let cloned_image_data = image_data.clone();
        insert_into(stored_images::table)
            .values(&cloned_image_data)
            .execute(conn)
            .map_err(SimpleDatabaseError::from)?;
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

    //seed_users(database).await;

    let image_storage =
        web::Data::from(Arc::new(LocalImageStorage::new("storage")) as Arc<dyn ImageStorage>);
    let image_data = seed_images(image_storage).await;
    insert_image_data(database, image_data).await;

    println!("Seeding complete!");
}
