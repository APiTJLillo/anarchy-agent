use thiserror::Error;

/// Error types for the Browser module
#[derive(Error, Debug)]
pub enum Error {
    #[error("Browser initialization error: {0}")]
    BrowserInitializationError(String),
    
    #[error("Navigation error: {0}")]
    NavigationError(String),
    
    #[error("Element interaction error: {0}")]
    ElementInteractionError(String),
    
    #[error("JavaScript execution error: {0}")]
    JavaScriptError(String),
    
    #[error("Timeout error: {0}")]
    TimeoutError(String),
    
    #[error("Unknown error: {0}")]
    Unknown(String),
}
