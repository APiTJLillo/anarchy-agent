use thiserror::Error;

/// Error types for the System module
#[derive(Error, Debug)]
pub enum Error {
    #[error("Sandbox initialization error: {0}")]
    SandboxInitializationError(String),
    
    #[error("File system error: {0}")]
    FileSystemError(String),
    
    #[error("Shell execution error: {0}")]
    ShellExecutionError(String),
    
    #[error("Permission denied: {0}")]
    PermissionDenied(String),
    
    #[error("Path not allowed: {0}")]
    PathNotAllowed(String),
    
    #[error("Command not allowed: {0}")]
    CommandNotAllowed(String),
    
    #[error("Timeout error: {0}")]
    TimeoutError(String),
    
    #[error("Unknown error: {0}")]
    Unknown(String),
}
