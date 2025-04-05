use anyhow::Result;
use std::path::Path;
use super::database::EnhancedDatabase;
use crate::config::Config;
use crate::error::Error;

/// Enhanced memory module with improved features
pub struct EnhancedMemory {
    config: Config,
    db: EnhancedDatabase,
}

impl EnhancedMemory {
    /// Create a new EnhancedMemory instance
    pub fn new(db_path: &Path, config: &Config) -> Result<Self> {
        // Create enhanced database
        let db = EnhancedDatabase::new(
            db_path,
            config.max_vectors,
            config.max_kv_cache,
        )?;
        
        Ok(Self {
            config: config.clone(),
            db,
        })
    }
    
    /// Initialize the enhanced memory
    pub fn initialize(&self) -> Result<()> {
        self.db.initialize()
    }
    
    /// Store an execution in memory with enhanced metadata
    pub fn store_execution(
        &self,
        task: &str,
        code: &str,
        result: &str,
        tags: Vec<String>,
        importance: u8,
    ) -> Result<String> {
        // Store in enhanced database
        let mut db = self.db.clone();
        db.store_execution(task, code, result, tags, importance)
    }
    
    /// Retrieve context relevant to a task description
    pub fn retrieve_context(&self, task_description: &str) -> Result<String> {
        // Query relevant entries
        let limit = self.config.max_context_entries;
        let mut db = self.db.clone();
        let entries = db.query_relevant(task_description, limit)?;
        
        // Format the entries into a context string
        let mut context = String::new();
        
        for entry in entries {
            context.push_str(&format!(
                "Task: {}\nCode:\n{}\nResult:\n{}\nTags: {}\nImportance: {}\n\n",
                entry.task,
                entry.code,
                entry.result,
                entry.tags.join(", "),
                entry.importance
            ));
        }
        
        Ok(context)
    }
    
    /// Set a key-value pair
    pub fn set_key_value(&self, key: &str, value: &str) -> Result<()> {
        let mut db = self.db.clone();
        db.set_key_value(key, value)
    }
    
    /// Get a value by key
    pub fn get_key_value(&self, key: &str) -> Result<String> {
        self.db.get_key_value(key)
    }
    
    /// Delete a key-value pair
    pub fn delete_key_value(&self, key: &str) -> Result<()> {
        let mut db = self.db.clone();
        db.delete_key_value(key)
    }
    
    /// Search memory by tags
    pub fn search_by_tags(&self, tags: &[String]) -> Result<String> {
        let limit = self.config.max_search_results;
        let mut db = self.db.clone();
        let entries = db.search_by_tags(tags, limit)?;
        
        // Format the entries into a result string
        let mut result = String::new();
        
        for entry in entries {
            result.push_str(&format!(
                "Task: {}\nCode:\n{}\nResult:\n{}\nTags: {}\nImportance: {}\nAccess Count: {}\n\n",
                entry.task,
                entry.code,
                entry.result,
                entry.tags.join(", "),
                entry.importance,
                entry.access_count
            ));
        }
        
        Ok(result)
    }
    
    /// Close the enhanced memory
    pub fn close(&self) -> Result<()> {
        self.db.close()
    }
}

impl Clone for EnhancedMemory {
    fn clone(&self) -> Self {
        // This is a simplified clone implementation
        // In a real implementation, you would properly clone the database
        Self {
            config: self.config.clone(),
            db: self.db.clone(),
        }
    }
}
