use thiserror::Error;

/// Error types for the Executor module
#[derive(Error, Debug)]
pub enum Error {
    #[error("Sandbox initialization error: {0}")]
    SandboxInitializationError(String),
    
    #[error("Parser error: {0}")]
    ParserError(String),
    
    #[error("Execution error: {0}")]
    ExecutionError(String),
    
    #[error("Symbol registration error: {0}")]
    SymbolRegistrationError(String),
    
    #[error("Resource limit exceeded: {0}")]
    ResourceLimitExceeded(String),
    
    #[error("Permission denied: {0}")]
    PermissionDenied(String),
    
    #[error("Timeout error: {0}")]
    TimeoutError(String),
    
    #[error("Unknown error: {0}")]
    Unknown(String),
}
