use std::path::PathBuf;

/// Configuration for the executor module
pub struct Config {
    /// Maximum execution time in milliseconds
    pub max_execution_time_ms: u64,
    
    /// Maximum memory usage in bytes
    pub max_memory_bytes: usize,
    
    /// Whether to allow file system operations
    pub allow_file_system: bool,
    
    /// Whether to allow shell operations
    pub allow_shell: bool,
    
    /// Whether to allow network operations
    pub allow_network: bool,
    
    /// Directory for input/output files (for input workaround)
    pub input_directory: String,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            max_execution_time_ms: 5000,
            max_memory_bytes: 100 * 1024 * 1024, // 100 MB
            allow_file_system: true,
            allow_shell: true,
            allow_network: true,
            input_directory: "./input_files".to_string(),
        }
    }
}

impl Config {
    /// Create a new Config with custom settings
    pub fn new(
        max_execution_time_ms: u64,
        max_memory_bytes: usize,
        allow_file_system: bool,
        allow_shell: bool,
        allow_network: bool,
        input_directory: &str,
    ) -> Self {
        Self {
            max_execution_time_ms,
            max_memory_bytes,
            allow_file_system,
            allow_shell,
            allow_network,
            input_directory: input_directory.to_string(),
        }
    }
}
