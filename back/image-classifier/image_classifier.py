
from typing import List, Tuple
import io
import os
from imageai.Classification import ImageClassification
from PIL import Image

classifier: ImageClassification = None

def load_model(model_path: str):
    print("Loading inception model from %s (in %s)" % (model_path, os.getcwd()))
    global classifier
    classifier = ImageClassification()
    classifier.setModelTypeAsInceptionV3()
    classifier.setModelPath(model_path)
    classifier.loadModel()
    return None

def classify_image(image_bytes: bytes) -> List[Tuple[str, float]]:
    image = Image.open(io.BytesIO(image_bytes))
    predictions, probabilities = classifier.classifyImage(image, result_count=10)
    return list(zip(predictions, probabilities))
