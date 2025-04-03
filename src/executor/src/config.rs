use std::path::PathBuf;

/// Configuration for the Executor module
pub struct Config {
    /// Whether to enable sandboxing
    pub sandbox_enabled: bool,
    
    /// Maximum execution time in seconds
    pub execution_timeout: u64,
    
    /// Maximum memory usage in MB
    pub memory_limit: u64,
    
    /// Allowed file system paths
    pub allowed_paths: Vec<PathBuf>,
    
    /// Allowed network domains
    pub allowed_domains: Vec<String>,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            sandbox_enabled: true,
            execution_timeout: 30,
            memory_limit: 512,
            allowed_paths: vec![PathBuf::from("./workspace")],
            allowed_domains: vec![
                "example.com".to_string(),
                "github.com".to_string(),
                "wikipedia.org".to_string(),
            ],
        }
    }
}
