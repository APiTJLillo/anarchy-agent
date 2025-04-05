use anyhow::Result;
use std::collections::HashMap;
use std::path::Path;
use std::fs::{self, File};
use std::io::{Read, Write};
use serde::{Serialize, Deserialize};

use crate::error::Error;

/// Vector representation of a memory entry for semantic search
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct MemoryVector {
    /// Unique identifier
    pub id: String,
    
    /// Vector representation (embedding)
    pub vector: Vec<f32>,
    
    /// Original content
    pub content: String,
    
    /// Metadata
    pub metadata: HashMap<String, String>,
    
    /// Timestamp
    pub timestamp: u64,
}

/// Vector store for semantic search
pub struct VectorStore {
    /// Path to the vector store file
    store_path: String,
    
    /// In-memory vectors
    vectors: Vec<MemoryVector>,
    
    /// Maximum number of vectors to keep in memory
    max_vectors: usize,
}

impl VectorStore {
    /// Create a new VectorStore
    pub fn new(store_path: &Path, max_vectors: usize) -> Result<Self> {
        let store_path_str = store_path.to_string_lossy().to_string();
        
        // Create directory if it doesn't exist
        if let Some(parent) = store_path.parent() {
            if !parent.exists() {
                fs::create_dir_all(parent)?;
            }
        }
        
        // Load existing vectors if the file exists
        let mut vectors = Vec::new();
        if store_path.exists() {
            let mut file = File::open(store_path)?;
            let mut contents = String::new();
            file.read_to_string(&mut contents)?;
            
            if !contents.is_empty() {
                vectors = serde_json::from_str(&contents)?;
            }
        }
        
        Ok(Self {
            store_path: store_path_str,
            vectors,
            max_vectors,
        })
    }
    
    /// Add a vector to the store
    pub fn add_vector(&mut self, vector: MemoryVector) -> Result<()> {
        // Check if a vector with this ID already exists
        if let Some(index) = self.vectors.iter().position(|v| v.id == vector.id) {
            // Replace the existing vector
            self.vectors[index] = vector;
        } else {
            // Add the new vector
            self.vectors.push(vector);
            
            // If we've exceeded the maximum number of vectors, remove the oldest one
            if self.vectors.len() > self.max_vectors {
                // Sort by timestamp (oldest first)
                self.vectors.sort_by_key(|v| v.timestamp);
                
                // Remove the oldest vector
                self.vectors.remove(0);
            }
        }
        
        // Save the vectors to disk
        self.save()?;
        
        Ok(())
    }
    
    /// Get a vector by ID
    pub fn get_vector(&self, id: &str) -> Option<&MemoryVector> {
        self.vectors.iter().find(|v| v.id == id)
    }
    
    /// Remove a vector by ID
    pub fn remove_vector(&mut self, id: &str) -> Result<bool> {
        let len_before = self.vectors.len();
        self.vectors.retain(|v| v.id != id);
        let removed = self.vectors.len() < len_before;
        
        if removed {
            // Save the vectors to disk
            self.save()?;
        }
        
        Ok(removed)
    }
    
    /// Find similar vectors using cosine similarity
    pub fn find_similar(&self, query_vector: &[f32], limit: usize) -> Vec<&MemoryVector> {
        // Calculate cosine similarity for each vector
        let mut similarities: Vec<(f32, &MemoryVector)> = self.vectors
            .iter()
            .map(|v| (cosine_similarity(query_vector, &v.vector), v))
            .collect();
        
        // Sort by similarity (highest first)
        similarities.sort_by(|a, b| b.0.partial_cmp(&a.0).unwrap_or(std::cmp::Ordering::Equal));
        
        // Return the top matches
        similarities
            .into_iter()
            .take(limit)
            .map(|(_, v)| v)
            .collect()
    }
    
    /// Search by content using simple keyword matching
    pub fn search_by_content(&self, query: &str, limit: usize) -> Vec<&MemoryVector> {
        let query_lower = query.to_lowercase();
        
        // Find vectors that contain the query in their content
        let mut matches: Vec<(usize, &MemoryVector)> = self.vectors
            .iter()
            .filter_map(|v| {
                let content_lower = v.content.to_lowercase();
                if content_lower.contains(&query_lower) {
                    // Count the number of matches
                    let count = content_lower.matches(&query_lower).count();
                    Some((count, v))
                } else {
                    None
                }
            })
            .collect();
        
        // Sort by number of matches (highest first)
        matches.sort_by(|a, b| b.0.cmp(&a.0));
        
        // Return the top matches
        matches
            .into_iter()
            .take(limit)
            .map(|(_, v)| v)
            .collect()
    }
    
    /// Save the vectors to disk
    fn save(&self) -> Result<()> {
        let json = serde_json::to_string(&self.vectors)?;
        let mut file = File::create(&self.store_path)?;
        file.write_all(json.as_bytes())?;
        Ok(())
    }
    
    /// Get all vectors
    pub fn get_all_vectors(&self) -> &[MemoryVector] {
        &self.vectors
    }
    
    /// Clear all vectors
    pub fn clear(&mut self) -> Result<()> {
        self.vectors.clear();
        self.save()?;
        Ok(())
    }
}

/// Calculate cosine similarity between two vectors
fn cosine_similarity(a: &[f32], b: &[f32]) -> f32 {
    if a.len() != b.len() || a.is_empty() {
        return 0.0;
    }
    
    let mut dot_product = 0.0;
    let mut a_magnitude = 0.0;
    let mut b_magnitude = 0.0;
    
    for i in 0..a.len() {
        dot_product += a[i] * b[i];
        a_magnitude += a[i] * a[i];
        b_magnitude += b[i] * b[i];
    }
    
    a_magnitude = a_magnitude.sqrt();
    b_magnitude = b_magnitude.sqrt();
    
    if a_magnitude == 0.0 || b_magnitude == 0.0 {
        return 0.0;
    }
    
    dot_product / (a_magnitude * b_magnitude)
}
