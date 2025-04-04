use std::path::PathBuf;

/// Configuration for the Core module
#[derive(Clone)]
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
    
    /// Path to the Anarchy-Inference file to execute
    pub file_path: Option<PathBuf>,
    
    /// Name of the example to run
    pub example_name: Option<String>,
    
    /// Whether to run in REPL mode
    pub repl_mode: bool,
    
    /// Whether to enable verbose logging
    pub verbose: bool,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            llm_model_path: PathBuf::from("./models/mistral-7b-instruct-v0.2.Q4_0.gguf"),
            memory_path: PathBuf::from("./data/memory.db"),
            headless: true,
            working_directory: PathBuf::from("./workspace"),
            sandbox_enabled: true,
            file_path: None,
            example_name: None,
            repl_mode: false,
            verbose: false,
        }
    }
}
