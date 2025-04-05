use anyhow::Result;
use std::path::Path;
use std::sync::Arc;
use tokio::sync::Mutex;

mod config;
mod error;
mod storage;
mod context;
mod enhanced;

pub use config::Config;
pub use error::Error;
pub use enhanced::EnhancedMemory;

/// Memory module that stores and retrieves information from previous executions
pub struct Memory {
    config: Config,
    db: storage::Database,
    enhanced: Option<enhanced::EnhancedMemory>,
}

impl Memory {
    /// Create a new Memory instance with the provided database path
    pub fn new(db_path: &Path) -> Result<Self> {
        let config = Config::default();
        let db = storage::Database::new(db_path)?;
        
        // Initialize enhanced memory if enabled in config
        let enhanced = if config.use_enhanced_memory {
            Some(enhanced::EnhancedMemory::new(db_path, &config)?)
        } else {
            None
        };
        
        Ok(Self {
            config,
            db,
            enhanced,
        })
    }
    
    /// Initialize the memory module
    pub async fn initialize(&self) -> Result<()> {
        // Initialize the database
        self.db.initialize()?;
        
        // Initialize enhanced memory if available
        if let Some(enhanced) = &self.enhanced {
            enhanced.initialize()?;
        }
        
        Ok(())
    }
    
    /// Store a task result in memory
    pub async fn store_result(&self, task: &str, code: &str, result: &str) -> Result<()> {
        // Store in basic database
        self.db.store_execution(task, code, result)?;
        
        // Store in enhanced memory if available
        if let Some(enhanced) = &self.enhanced {
            // Default tags and importance
            let tags = vec!["execution".to_string()];
            let importance = 50; // Medium importance
            
            enhanced.store_execution(task, code, result, tags, importance)?;
        }
        
        Ok(())
    }
    
    /// Retrieve context relevant to a task description
    pub async fn retrieve_context(&self, task_description: &str) -> Result<String> {
        // If enhanced memory is available, use it for better context retrieval
        if let Some(enhanced) = &self.enhanced {
            let context = enhanced.retrieve_context(task_description)?;
            return Ok(context);
        }
        
        // Fall back to basic database
        let relevant_entries = self.db.query_relevant(task_description)?;
        let context = context::format_context(&relevant_entries);
        Ok(context)
    }
    
    /// Store a key-value pair in memory (for Anarchy-Inference 📝 symbol)
    pub async fn set_memory(&self, key: &str, value: &str) -> Result<()> {
        // Store in basic database
        self.db.set_key_value(key, value)?;
        
        // Store in enhanced memory if available
        if let Some(enhanced) = &self.enhanced {
            enhanced.set_key_value(key, value)?;
        }
        
        Ok(())
    }
    
    /// Retrieve a value by key from memory (for Anarchy-Inference 📖 symbol)
    pub async fn get_memory(&self, key: &str) -> Result<String> {
        // Try enhanced memory first if available
        if let Some(enhanced) = &self.enhanced {
            match enhanced.get_key_value(key) {
                Ok(value) => return Ok(value),
                Err(_) => {} // Fall back to basic database
            }
        }
        
        // Fall back to basic database
        let value = self.db.get_key_value(key)?;
        Ok(value)
    }
    
    /// Delete a key from memory (for Anarchy-Inference 🗑 symbol)
    pub async fn forget_key(&self, key: &str) -> Result<()> {
        // Delete from basic database
        self.db.delete_key_value(key)?;
        
        // Delete from enhanced memory if available
        if let Some(enhanced) = &self.enhanced {
            enhanced.delete_key_value(key)?;
        }
        
        Ok(())
    }
    
    /// Search memory by tags (for Anarchy-Inference 🏷️ symbol)
    pub async fn search_by_tags(&self, tags: &[String]) -> Result<String> {
        // If enhanced memory is available, use it for tag search
        if let Some(enhanced) = &self.enhanced {
            let results = enhanced.search_by_tags(tags)?;
            return Ok(results);
        }
        
        // Basic database doesn't support tags
        Err(Error::UnsupportedOperationError("Tag search requires enhanced memory".to_string()).into())
    }
    
    /// Shutdown the memory module
    pub async fn shutdown(&self) -> Result<()> {
        // Close the database connection
        self.db.close()?;
        
        // Close enhanced memory if available
        if let Some(enhanced) = &self.enhanced {
            enhanced.close()?;
        }
        
        Ok(())
    }
}
