use std::path::PathBuf;

/// Configuration for the System module
#[derive(Clone)]
pub struct Config {
    /// Working directory for file operations
    pub working_directory: PathBuf,
    
    /// Whether to enable sandboxing
    pub sandbox_enabled: bool,
    
    /// Allowed file system paths
    pub allowed_paths: Vec<PathBuf>,
    
    /// Allowed shell commands
    pub allowed_commands: Vec<String>,
    
    /// Maximum command execution time in seconds
    pub command_timeout: u64,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            working_directory: PathBuf::from("./workspace"),
            sandbox_enabled: true,
            allowed_paths: vec![PathBuf::from("./workspace")],
            allowed_commands: vec![
                "ls".to_string(),
                "cat".to_string(),
                "grep".to_string(),
                "find".to_string(),
                "echo".to_string(),
            ],
            command_timeout: 10,
        }
    }
}
