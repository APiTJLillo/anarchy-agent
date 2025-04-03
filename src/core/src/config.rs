use std::path::PathBuf;

/// Configuration for the Core module
pub struct Config {
    /// Path to the LLM model
    pub llm_model_path: PathBuf,
    
    /// Path to store memory database
    pub memory_path: PathBuf,
    
    /// Whether to run browser in headless mode
    pub headless: bool,
    
    /// Working directory for file operations
    pub working_directory: PathBuf,
    
    /// Whether to enable sandboxing for system operations
    pub sandbox_enabled: bool,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            llm_model_path: PathBuf::from("./models/mistral-7b-instruct-v0.2.Q4_0.gguf"),
            memory_path: PathBuf::from("./data/memory.db"),
            headless: true,
            working_directory: PathBuf::from("./workspace"),
            sandbox_enabled: true,
        }
    }
}
