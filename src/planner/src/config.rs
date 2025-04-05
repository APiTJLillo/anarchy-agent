use std::path::PathBuf;

/// Configuration for the planner module
pub struct Config {
    /// System prompt for the LLM
    pub system_prompt: String,
    
    /// Maximum number of tokens to generate
    pub max_tokens: usize,
    
    /// Temperature for generation
    pub temperature: f32,
    
    /// Directory for pattern definitions
    pub patterns_dir: PathBuf,
    
    /// Maximum number of history entries to keep
    pub max_history_size: usize,
    
    /// Whether to use the reasoning system
    pub use_reasoning_system: bool,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            system_prompt: "You are an AI assistant that generates Anarchy-Inference code to accomplish tasks. Use the symbolic syntax (e.g., !, ↗, 📂, etc.) for all operations.".to_string(),
            max_tokens: 1000,
            temperature: 0.7,
            patterns_dir: PathBuf::from("./data/patterns"),
            max_history_size: 20,
            use_reasoning_system: true,
        }
    }
}
