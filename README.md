# Pictou

![example workflow](https://github.com/tistech0/Pictou/actions/workflows/mirror.yml/badge.svg)

# Description

- TODO

## Setting up a Development Environment

### Linux / MacOS
```sh
cd PROJECT_DIR
# Install pre-commit
pre-commit install
```

**CMake** needs to be installed on your system.

Run the following commands to configure the [image classifier](./back/image-classifier/):

```sh
export TMPDIR="$home/tmp"
mkdir "$TMPDIR"
cd back/image-classifier
source configure.sh
```

You may run without the image classifier (and the dependency on Python) by running the following command:
```sh
cargo run --no-default-features
```

You then need to run `cargo build/run` inside the python venv (see [how to activate a venv](https://docs.python.org/3/tutorial/venv.html#creating-virtual-environments)).

### NixOS

On NixOS, the dev environment will set itself up upon `cd`-ing into the directory.

```sh
cd PROJECT_DIR
# If Direnv is allowed
direnv allow
# Or
nix-shell
```

### Migrations
For migrations, we use `diesel` as the ORM.
```sh
cargo install diesel_cli --no-default-features --features postgres
diesel setup # need to have a .env file with the DATABASE_URL set
diesel migration generate migration_name # to generate a new migration
diesel migration run # to run the migrations
diesel migration revert # to revert the last migration
diesel migration redo # to revert and re-run the last migrationDiesel
```

### Pictou Flutter
## Description

- TODO

## Configuration de l'environnement de développement

### Démarrage d'un projet Flutter

Pour démarrer avec Flutter, assurez-vous d'avoir Flutter et Dart installé sur votre machine. Suivez les instructions sur le site officiel de Flutter pour installer l'outil sur votre système d'exploitation.

Ou utilser FVM - pour flutter
#### Création d'un nouveau projet

Exécutez les commandes suivantes pour créer un nouveau projet Flutter :

```sh
flutter create front
cd front
```

Ajout de dépendances
Ajoutez les dépendances suivantes dans votre fichier pubspec.yaml sous la section dependencies :

```sh
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  provider: ^6.0.0
  image_picker: ^1.0.7
  dio: ^5.4.2+1
  webview_flutter: ^3.0.0
  flutter_dotenv: ^5.1.0
  openapi_generator_annotations: ^5.0.2
  dotenv: ^3.0.0
  image: ^3.0.1
  mime: ^1.0.2
  pictouapi:
    path: ./api

dev_dependencies:
  flutter_test:
    sdk: flutter
  openapi_generator: ^5.0.2
  analyzer: ^6.2.0
  flutter_lints: ^3.0.1
```
Configuration initiale

Après avoir ajouté les dépendances et démarrer le projet, récupérez-les avec :
```sh
flutter pub get
flutter run
```




### API documentation

You can access the openapi json schema at `/api-docs/openapi.json` and to the swaggerui at `/swagger-ui/index.html`.

### Flutter openAPI command

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```


