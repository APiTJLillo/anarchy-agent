use std::path::PathBuf;

/// Configuration for the memory module
pub struct Config {
    /// Database path
    pub db_path: PathBuf,
    
    /// Maximum number of entries to return in queries
    pub max_entries: usize,
    
    /// Whether to use enhanced memory features
    pub use_enhanced_memory: bool,
    
    /// Maximum number of vectors to keep in memory
    pub max_vectors: usize,
    
    /// Maximum number of key-value pairs to keep in memory cache
    pub max_kv_cache: usize,
    
    /// Maximum number of entries to include in context
    pub max_context_entries: usize,
    
    /// Maximum number of search results to return
    pub max_search_results: usize,
    
    /// Whether to enable semantic search
    pub enable_semantic_search: bool,
    
    /// Whether to track access statistics
    pub track_access_stats: bool,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            db_path: PathBuf::from("./data/memory.db"),
            max_entries: 10,
            use_enhanced_memory: true,
            max_vectors: 1000,
            max_kv_cache: 500,
            max_context_entries: 5,
            max_search_results: 10,
            enable_semantic_search: true,
            track_access_stats: true,
        }
    }
}

impl Clone for Config {
    fn clone(&self) -> Self {
        Self {
            db_path: self.db_path.clone(),
            max_entries: self.max_entries,
            use_enhanced_memory: self.use_enhanced_memory,
            max_vectors: self.max_vectors,
            max_kv_cache: self.max_kv_cache,
            max_context_entries: self.max_context_entries,
            max_search_results: self.max_search_results,
            enable_semantic_search: self.enable_semantic_search,
            track_access_stats: self.track_access_stats,
        }
    }
}
