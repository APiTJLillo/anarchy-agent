use thiserror::Error;

/// Error types for the Planner module
#[derive(Error, Debug)]
pub enum Error {
    #[error("LLM initialization error: {0}")]
    LlmInitializationError(String),
    
    #[error("Model loading error: {0}")]
    ModelLoadingError(String),
    
    #[error("Generation error: {0}")]
    GenerationError(String),
    
    #[error("Validation error: {0}")]
    ValidationError(String),
    
    #[error("Memory access error: {0}")]
    MemoryError(String),
    
    #[error("Unknown error: {0}")]
    Unknown(String),
}
