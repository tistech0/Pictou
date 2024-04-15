use actix_web::web;

use crate::{config::AppConfiguration, image::DecodedImage};

use super::{ClassifierError, ImageTagPrediction};

#[derive(Debug)]
pub struct ImageClassifier {
    _private: (),
}

impl ImageClassifier {
    pub fn new(app_cfg: web::Data<AppConfiguration>) -> Result<Self, ClassifierError> {
        let _ = app_cfg;
        Ok(ImageClassifier { _private: () })
    }

    pub fn classify(
        &self,
        image: &DecodedImage,
    ) -> Result<Vec<ImageTagPrediction>, ClassifierError> {
        let _ = image;
        Ok(Vec::new())
    }
}
