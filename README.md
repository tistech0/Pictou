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

Install [libjxl 10.0.2](https://github.com/libjxl/libjxl/releases/tag/v0.10.2) on your system for the back.

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

### API documentation

You can access the openapi json schema at `/api-docs/openapi.json` and to the swaggerui at `/swagger-ui/index.html`.
