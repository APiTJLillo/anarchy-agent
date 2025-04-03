use std::path::PathBuf;

/// Configuration for the LLM Engine
pub struct Config {
    /// Path to the LLM model
    pub model_path: PathBuf,
    
    /// Maximum tokens to generate
    pub max_tokens: usize,
    
    /// Temperature for generation
    pub temperature: f32,
    
    /// Top-p sampling
    pub top_p: f32,
    
    /// System prompt for the LLM
    pub system_prompt: String,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            model_path: PathBuf::from("./models/mistral-7b-instruct-v0.2.Q4_0.gguf"),
            max_tokens: 2048,
            temperature: 0.7,
            top_p: 0.9,
            system_prompt: String::from(
                "You are an AI assistant that generates Anarchy-Inference code to accomplish tasks. \
                Use the symbolic syntax of Anarchy-Inference for all operations."
            ),
        }
    }
}
