use std::path::PathBuf;

/// Configuration for the Memory module
pub struct Config {
    /// Path to the database file
    pub db_path: PathBuf,
    
    /// Maximum number of entries to store
    pub max_entries: usize,
    
    /// Maximum size of a single entry in bytes
    pub max_entry_size: usize,
    
    /// Whether to enable persistence
    pub persistence_enabled: bool,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            db_path: PathBuf::from("./data/memory.db"),
            max_entries: 1000,
            max_entry_size: 1024 * 1024, // 1MB
            persistence_enabled: true,
        }
    }
}
