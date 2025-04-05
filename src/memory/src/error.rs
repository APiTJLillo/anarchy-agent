use thiserror::Error;

/// Errors that can occur in the memory module
#[derive(Error, Debug)]
pub enum Error {
    /// Error during database initialization
    #[error("Database initialization error: {0}")]
    DatabaseInitializationError(String),
    
    /// Error during database connection
    #[error("Database connection error: {0}")]
    DatabaseConnectionError(String),
    
    /// Error during query execution
    #[error("Query execution error: {0}")]
    QueryExecutionError(String),
    
    /// Error when key is not found
    #[error("Key not found: {0}")]
    KeyNotFoundError(String),
    
    /// Error during vector store operations
    #[error("Vector store error: {0}")]
    VectorStoreError(String),
    
    /// Error during semantic search
    #[error("Semantic search error: {0}")]
    SemanticSearchError(String),
    
    /// Error during file operations
    #[error("File operation error: {0}")]
    FileOperationError(String),
    
    /// Error during serialization/deserialization
    #[error("Serialization error: {0}")]
    SerializationError(String),
    
    /// Error when operation is not supported
    #[error("Unsupported operation: {0}")]
    UnsupportedOperationError(String),
}
