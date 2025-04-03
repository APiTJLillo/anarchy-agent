use anyhow::Result;
use std::path::Path;
use std::sync::Arc;
use tokio::sync::Mutex;

mod config;
mod error;
mod storage;
mod context;

pub use config::Config;
pub use error::Error;

/// Memory module that stores and retrieves information from previous executions
pub struct Memory {
    config: Config,
    db: storage::Database,
}

impl Memory {
    /// Create a new Memory instance with the provided database path
    pub fn new(db_path: &Path) -> Result<Self> {
        let config = Config::default();
        let db = storage::Database::new(db_path)?;
        
        Ok(Self {
            config,
            db,
        })
    }
    
    /// Initialize the memory module
    pub async fn initialize(&self) -> Result<()> {
        // Initialize the database
        self.db.initialize()?;
        
        Ok(())
    }
    
    /// Store a task result in memory
    pub async fn store_result(&self, task: &str, code: &str, result: &str) -> Result<()> {
        self.db.store_execution(task, code, result)?;
        Ok(())
    }
    
    /// Retrieve context relevant to a task description
    pub async fn retrieve_context(&self, task_description: &str) -> Result<String> {
        let relevant_entries = self.db.query_relevant(task_description)?;
        let context = context::format_context(&relevant_entries);
        Ok(context)
    }
    
    /// Store a key-value pair in memory (for Anarchy-Inference 📝 symbol)
    pub async fn set_memory(&self, key: &str, value: &str) -> Result<()> {
        self.db.set_key_value(key, value)?;
        Ok(())
    }
    
    /// Retrieve a value by key from memory (for Anarchy-Inference 📖 symbol)
    pub async fn get_memory(&self, key: &str) -> Result<String> {
        let value = self.db.get_key_value(key)?;
        Ok(value)
    }
    
    /// Delete a key from memory (for Anarchy-Inference 🗑 symbol)
    pub async fn forget_key(&self, key: &str) -> Result<()> {
        self.db.delete_key_value(key)?;
        Ok(())
    }
    
    /// Shutdown the memory module
    pub async fn shutdown(&self) -> Result<()> {
        // Close the database connection
        self.db.close()?;
        
        Ok(())
    }
}
