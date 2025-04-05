use anyhow::Result;
use std::collections::HashMap;
use std::path::Path;
use std::fs::{self, File};
use std::io::{Read, Write};
use serde::{Serialize, Deserialize};
use std::time::{SystemTime, UNIX_EPOCH};

use crate::error::Error;
use super::vector_store::{VectorStore, MemoryVector};

/// Enhanced database for storing and retrieving memory entries
pub struct EnhancedDatabase {
    /// Key-value store path
    kv_store_path: String,
    
    /// Vector store for semantic search
    vector_store: VectorStore,
    
    /// In-memory key-value cache
    kv_cache: HashMap<String, String>,
    
    /// Maximum number of key-value pairs to keep in memory
    max_kv_cache: usize,
}

/// Memory entry structure with enhanced metadata
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct EnhancedMemoryEntry {
    /// Unique identifier
    pub id: String,
    
    /// Task description
    pub task: String,
    
    /// Anarchy-Inference code
    pub code: String,
    
    /// Execution result
    pub result: String,
    
    /// Timestamp
    pub timestamp: u64,
    
    /// Tags for categorization
    pub tags: Vec<String>,
    
    /// Importance score (0-100)
    pub importance: u8,
    
    /// Access count
    pub access_count: u32,
    
    /// Last access timestamp
    pub last_access: u64,
}

impl EnhancedDatabase {
    /// Create a new EnhancedDatabase instance
    pub fn new(db_path: &Path, max_vectors: usize, max_kv_cache: usize) -> Result<Self> {
        // Create vector store
        let vector_store_path = db_path.join("vectors.json");
        let vector_store = VectorStore::new(&vector_store_path, max_vectors)?;
        
        // Create key-value store path
        let kv_store_path = db_path.join("keyvalues.json").to_string_lossy().to_string();
        
        // Create directory if it doesn't exist
        if !db_path.exists() {
            fs::create_dir_all(db_path)?;
        }
        
        // Load existing key-value pairs if the file exists
        let mut kv_cache = HashMap::new();
        let kv_path = Path::new(&kv_store_path);
        if kv_path.exists() {
            let mut file = File::open(kv_path)?;
            let mut contents = String::new();
            file.read_to_string(&mut contents)?;
            
            if !contents.is_empty() {
                kv_cache = serde_json::from_str(&contents)?;
            }
        }
        
        Ok(Self {
            kv_store_path,
            vector_store,
            kv_cache,
            max_kv_cache,
        })
    }
    
    /// Initialize the database
    pub fn initialize(&self) -> Result<()> {
        // Create parent directories if they don't exist
        if let Some(parent) = Path::new(&self.kv_store_path).parent() {
            if !parent.exists() {
                fs::create_dir_all(parent)?;
            }
        }
        
        Ok(())
    }
    
    /// Store an execution in the database with enhanced metadata
    pub fn store_execution(
        &mut self, 
        task: &str, 
        code: &str, 
        result: &str,
        tags: Vec<String>,
        importance: u8
    ) -> Result<String> {
        let id = generate_id();
        let timestamp = SystemTime::now()
            .duration_since(UNIX_EPOCH)?
            .as_secs();
        
        // Create enhanced memory entry
        let entry = EnhancedMemoryEntry {
            id: id.clone(),
            task: task.to_string(),
            code: code.to_string(),
            result: result.to_string(),
            timestamp,
            tags,
            importance,
            access_count: 0,
            last_access: timestamp,
        };
        
        // Create a simple vector representation (in a real implementation, this would use embeddings)
        // Here we're just using a placeholder implementation
        let content = format!("{} {}", task, result);
        let vector = simple_embedding(&content);
        
        // Create metadata
        let mut metadata = HashMap::new();
        metadata.insert("task".to_string(), task.to_string());
        metadata.insert("timestamp".to_string(), timestamp.to_string());
        
        // Create memory vector
        let memory_vector = MemoryVector {
            id: id.clone(),
            vector,
            content,
            metadata,
            timestamp,
        };
        
        // Store in vector store
        self.vector_store.add_vector(memory_vector)?;
        
        // Store the full entry in a separate file
        let entry_path = Path::new(&self.kv_store_path).parent().unwrap().join("entries").join(format!("{}.json", id));
        
        // Create directory if it doesn't exist
        if let Some(parent) = entry_path.parent() {
            if !parent.exists() {
                fs::create_dir_all(parent)?;
            }
        }
        
        // Write entry to file
        let entry_json = serde_json::to_string(&entry)?;
        let mut file = File::create(entry_path)?;
        file.write_all(entry_json.as_bytes())?;
        
        Ok(id)
    }
    
    /// Query relevant entries for a task description
    pub fn query_relevant(&mut self, task_description: &str, limit: usize) -> Result<Vec<EnhancedMemoryEntry>> {
        // Create a simple vector representation of the query
        let query_vector = simple_embedding(task_description);
        
        // Find similar vectors
        let similar_vectors = self.vector_store.find_similar(&query_vector, limit);
        
        // Load the full entries
        let mut entries = Vec::new();
        for vector in similar_vectors {
            if let Some(entry) = self.load_entry(&vector.id)? {
                // Update access count and last access time
                let mut updated_entry = entry.clone();
                updated_entry.access_count += 1;
                updated_entry.last_access = SystemTime::now()
                    .duration_since(UNIX_EPOCH)?
                    .as_secs();
                
                // Save the updated entry
                self.save_entry(&updated_entry)?;
                
                entries.push(updated_entry);
            }
        }
        
        Ok(entries)
    }
    
    /// Set a key-value pair
    pub fn set_key_value(&mut self, key: &str, value: &str) -> Result<()> {
        // Update the cache
        self.kv_cache.insert(key.to_string(), value.to_string());
        
        // If we've exceeded the maximum cache size, remove the least recently used entries
        if self.kv_cache.len() > self.max_kv_cache {
            // In a real implementation, we would track access times and remove the least recently used
            // For now, just remove a random entry
            if let Some(remove_key) = self.kv_cache.keys().next().cloned() {
                self.kv_cache.remove(&remove_key);
            }
        }
        
        // Save the cache to disk
        self.save_kv_cache()?;
        
        Ok(())
    }
    
    /// Get a value by key
    pub fn get_key_value(&self, key: &str) -> Result<String> {
        // Check the cache
        if let Some(value) = self.kv_cache.get(key) {
            return Ok(value.clone());
        }
        
        // If not in cache, return an error
        Err(Error::KeyNotFoundError(key.to_string()).into())
    }
    
    /// Delete a key-value pair
    pub fn delete_key_value(&mut self, key: &str) -> Result<()> {
        // Remove from cache
        self.kv_cache.remove(key);
        
        // Save the cache to disk
        self.save_kv_cache()?;
        
        Ok(())
    }
    
    /// Save the key-value cache to disk
    fn save_kv_cache(&self) -> Result<()> {
        let json = serde_json::to_string(&self.kv_cache)?;
        let mut file = File::create(&self.kv_store_path)?;
        file.write_all(json.as_bytes())?;
        Ok(())
    }
    
    /// Load an entry by ID
    fn load_entry(&self, id: &str) -> Result<Option<EnhancedMemoryEntry>> {
        let entry_path = Path::new(&self.kv_store_path).parent().unwrap().join("entries").join(format!("{}.json", id));
        
        if !entry_path.exists() {
            return Ok(None);
        }
        
        let mut file = File::open(entry_path)?;
        let mut contents = String::new();
        file.read_to_string(&mut contents)?;
        
        let entry: EnhancedMemoryEntry = serde_json::from_str(&contents)?;
        Ok(Some(entry))
    }
    
    /// Save an entry
    fn save_entry(&self, entry: &EnhancedMemoryEntry) -> Result<()> {
        let entry_path = Path::new(&self.kv_store_path).parent().unwrap().join("entries").join(format!("{}.json", &entry.id));
        
        // Create directory if it doesn't exist
        if let Some(parent) = entry_path.parent() {
            if !parent.exists() {
                fs::create_dir_all(parent)?;
            }
        }
        
        // Write entry to file
        let entry_json = serde_json::to_string(entry)?;
        let mut file = File::create(entry_path)?;
        file.write_all(entry_json.as_bytes())?;
        
        Ok(())
    }
    
    /// Search entries by tags
    pub fn search_by_tags(&mut self, tags: &[String], limit: usize) -> Result<Vec<EnhancedMemoryEntry>> {
        // Get all vector IDs
        let all_vectors = self.vector_store.get_all_vectors();
        
        // Load entries and filter by tags
        let mut matching_entries = Vec::new();
        for vector in all_vectors {
            if let Some(entry) = self.load_entry(&vector.id)? {
                // Check if entry has all the specified tags
                let has_all_tags = tags.iter().all(|tag| entry.tags.contains(tag));
                
                if has_all_tags {
                    // Update access count and last access time
                    let mut updated_entry = entry.clone();
                    updated_entry.access_count += 1;
                    updated_entry.last_access = SystemTime::now()
                        .duration_since(UNIX_EPOCH)?
                        .as_secs();
                    
                    // Save the updated entry
                    self.save_entry(&updated_entry)?;
                    
                    matching_entries.push(updated_entry);
                    
                    // Limit the number of results
                    if matching_entries.len() >= limit {
                        break;
                    }
                }
            }
        }
        
        Ok(matching_entries)
    }
    
    /// Close the database
    pub fn close(&self) -> Result<()> {
        // Nothing to do for now
        Ok(())
    }
}

/// Generate a unique ID
fn generate_id() -> String {
    use std::time::{SystemTime, UNIX_EPOCH};
    let now = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_nanos();
    
    format!("mem_{}", now)
}

/// Create a simple embedding vector from text
/// This is a placeholder implementation - in a real system, you would use a proper embedding model
fn simple_embedding(text: &str) -> Vec<f32> {
    // Create a simple hash-based embedding
    // This is just for demonstration purposes
    let mut result = vec![0.0; 128];
    
    for (i, c) in text.chars().enumerate() {
        let index = i % 128;
        result[index] += c as u32 as f32 / 1000.0;
    }
    
    // Normalize the vector
    let magnitude: f32 = result.iter().map(|x| x * x).sum::<f32>().sqrt();
    if magnitude > 0.0 {
        for value in &mut result {
            *value /= magnitude;
        }
    }
    
    result
}
