//! Global logging/tracing/telemetry configuration.

use tracing::Subscriber;
use tracing_appender::{
    non_blocking::WorkerGuard,
    rolling::{RollingFileAppender, Rotation},
};
use tracing_subscriber::{filter::EnvFilter, layer::SubscriberExt, Registry};

/// Registers a Tracing subcriber that logs events to `STDOUT` and to a file in the `logs/`
/// directory.
///
/// The default log level is fetched from the `RUST_LOG` environment variable, if not present
/// [`INFO`] is chosen.
/// Returns a guard struct that releases its ressources (such as the log file) upon going out of scope.
///
/// # Panics
/// This function panics if `tracing` could not be setup properly for some reason.
///
/// [`INFO`]: tracing::Level::INFO
pub fn init() -> Guard {
    let (subscriber, guard) = make_subscriber();
    tracing::subscriber::set_global_default(subscriber).expect("Failed to setup logger");
    guard
}

fn make_subscriber() -> (impl Subscriber + Send + Sync, Guard) {
    let env_filter = EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("info"));

    let (stdout_appender, stdout_appender_guard) =
        tracing_appender::non_blocking(std::io::stdout());
    let (file_appender, file_appender_guard) = tracing_appender::non_blocking(
        RollingFileAppender::builder()
            .rotation(Rotation::HOURLY)
            .filename_prefix("server")
            .filename_suffix("log")
            .build("logs")
            .expect("failed to create appender for logging file"),
    );

    let stdout_layer = tracing_subscriber::fmt::layer()
        .pretty()
        .with_writer(stdout_appender);
    let file_layer = tracing_subscriber::fmt::layer()
        .with_ansi(false) // disable ANSI colors in file
        .with_writer(file_appender);

    let subscriber = Registry::default()
        .with(env_filter)
        .with(stdout_layer)
        .with(file_layer);

    (
        subscriber,
        Guard {
            stdout_appender_guard,
            file_appender_guard,
        },
    )
}

/// RAII guard struct that releases its resources when going out of scope.
#[allow(dead_code)]
pub struct Guard {
    stdout_appender_guard: WorkerGuard,
    file_appender_guard: WorkerGuard,
}
