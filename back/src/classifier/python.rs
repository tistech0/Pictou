use std::{fs::File, io::Read};

use actix_web::web;
use pyo3::prelude::*;

use super::{ClassifierError, ImageTagPrediction};
use crate::{config::AppConfiguration, image::DecodedImage};

#[derive(Debug)]
pub struct ImageClassifier {
    module: Py<PyModule>,
}

impl ImageClassifier {
    pub fn new(app_cfg: web::Data<AppConfiguration>) -> Result<Self, ClassifierError> {
        Python::with_gil(|py| {
            let mut file = File::open(&app_cfg.image_classifier_module).unwrap();
            let mut code = String::new();
            file.read_to_string(&mut code).unwrap();

            // Compile and import the Python module
            let image_classifier =
                PyModule::from_code_bound(py, &code, "image_classifier.py", "image_classifier")
                    .unwrap();

            image_classifier
                .getattr("load_model")
                .unwrap()
                .call((app_cfg.image_classifier_model.to_owned(),), None)
                .unwrap();

            Ok(ImageClassifier {
                module: image_classifier.unbind(),
            })
        })
    }

    pub fn classify(
        &self,
        image: &DecodedImage,
    ) -> Result<Vec<ImageTagPrediction>, ClassifierError> {
        Python::with_gil(|py| {
            let bound_module = self.module.bind(py);
            let result = bound_module
                .getattr("classify_image")
                .unwrap()
                .call((image.original_bytes(),), None)?;

            let converted_vec: Vec<ImageTagPrediction> = result
                .extract::<Vec<(String, f64)>>()?
                .into_iter()
                .map(|(tag, probability)| ImageTagPrediction { tag, probability })
                .collect();

            Ok(converted_vec)
        })
    }
}
