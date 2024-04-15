#!/usr/bin/env bash

[ ! -f model.pth ] && wget https://github.com/OlafenwaMoses/ImageAI/releases/download/3.0.0-pretrained/inception_v3_google-1a9a5a14.pth -O model.pth
python -m venv venv
source ./venv/bin/activate

python -m pip install --upgrade pip
pip install -r requirements.txt

export PYTHON=`realpath ./venv/bin/python`
export PYO3_PYTHON="$PYTHON"
