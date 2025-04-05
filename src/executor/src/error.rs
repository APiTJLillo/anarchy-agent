use thiserror::Error;

/// Errors that can occur in the executor module
#[derive(Error, Debug)]
pub enum Error {
    /// Error during sandbox initialization
    #[error("Sandbox initialization error: {0}")]
    SandboxInitializationError(String),
    
    /// Error during code execution
    #[error("Code execution error: {0}")]
    CodeExecutionError(String),
    
    /// Error during symbol registration
    #[error("Symbol registration error: {0}")]
    SymbolRegistrationError(String),
    
    /// Error during code parsing
    #[error("Code parsing error: {0}")]
    CodeParsingError(String),
    
    /// Error during sandbox shutdown
    #[error("Sandbox shutdown error: {0}")]
    SandboxShutdownError(String),
    
    /// Error during input operations
    #[error("Input error: {0}")]
    InputError(String),
    
    /// Error during output operations
    #[error("Output error: {0}")]
    OutputError(String),
    
    /// Error during file waiting
    #[error("File wait error: {0}")]
    FileWaitError(String),
}
