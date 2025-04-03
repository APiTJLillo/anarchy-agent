use thiserror::Error;

/// Error types for the Memory module
#[derive(Error, Debug)]
pub enum Error {
    #[error("Database initialization error: {0}")]
    DatabaseInitializationError(String),
    
    #[error("Database connection error: {0}")]
    DatabaseConnectionError(String),
    
    #[error("Query error: {0}")]
    QueryError(String),
    
    #[error("Storage error: {0}")]
    StorageError(String),
    
    #[error("Key not found: {0}")]
    KeyNotFoundError(String),
    
    #[error("Size limit exceeded: {0}")]
    SizeLimitExceeded(String),
    
    #[error("Unknown error: {0}")]
    Unknown(String),
}
