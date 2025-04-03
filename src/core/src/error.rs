use thiserror::Error;

/// Error types for the Core module
#[derive(Error, Debug)]
pub enum Error {
    #[error("Initialization error: {0}")]
    InitializationError(String),
    
    #[error("Planner error: {0}")]
    PlannerError(String),
    
    #[error("Executor error: {0}")]
    ExecutorError(String),
    
    #[error("Memory error: {0}")]
    MemoryError(String),
    
    #[error("Browser error: {0}")]
    BrowserError(String),
    
    #[error("System error: {0}")]
    SystemError(String),
    
    #[error("Configuration error: {0}")]
    ConfigError(String),
    
    #[error("Unknown error: {0}")]
    Unknown(String),
}
