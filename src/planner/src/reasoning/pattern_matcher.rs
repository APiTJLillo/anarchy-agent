use anyhow::Result;
use std::collections::HashMap;
use regex::Regex;
use serde::{Serialize, Deserialize};

/// Pattern definition for matching task descriptions
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Pattern {
    /// Unique identifier for the pattern
    pub id: String,
    
    /// Regular expression pattern
    pub regex: String,
    
    /// Priority (higher values take precedence)
    pub priority: u8,
    
    /// Tags associated with this pattern
    pub tags: Vec<String>,
    
    /// Template for code generation
    pub template: String,
    
    /// Description of what this pattern matches
    pub description: String,
}

/// Pattern matcher for identifying task patterns
pub struct PatternMatcher {
    /// Compiled patterns
    patterns: Vec<(Pattern, Regex)>,
}

impl PatternMatcher {
    /// Create a new PatternMatcher with the provided patterns
    pub fn new(patterns: Vec<Pattern>) -> Result<Self> {
        // Compile the regex patterns
        let mut compiled_patterns = Vec::new();
        
        for pattern in patterns {
            let regex = Regex::new(&pattern.regex)?;
            compiled_patterns.push((pattern, regex));
        }
        
        // Sort by priority (highest first)
        compiled_patterns.sort_by(|a, b| b.0.priority.cmp(&a.0.priority));
        
        Ok(Self {
            patterns: compiled_patterns,
        })
    }
    
    /// Match a task description against the patterns
    pub fn match_task(&self, task_description: &str) -> Vec<PatternMatch> {
        let mut matches = Vec::new();
        
        for (pattern, regex) in &self.patterns {
            if let Some(captures) = regex.captures(task_description) {
                // Create a map of capture groups
                let mut capture_groups = HashMap::new();
                
                for name in regex.capture_names().flatten() {
                    if let Some(value) = captures.name(name) {
                        capture_groups.insert(name.to_string(), value.as_str().to_string());
                    }
                }
                
                // Create a match result
                let match_result = PatternMatch {
                    pattern_id: pattern.id.clone(),
                    capture_groups,
                    template: pattern.template.clone(),
                    tags: pattern.tags.clone(),
                };
                
                matches.push(match_result);
            }
        }
        
        matches
    }
    
    /// Add a new pattern
    pub fn add_pattern(&mut self, pattern: Pattern) -> Result<()> {
        let regex = Regex::new(&pattern.regex)?;
        self.patterns.push((pattern, regex));
        
        // Re-sort by priority
        self.patterns.sort_by(|a, b| b.0.priority.cmp(&a.0.priority));
        
        Ok(())
    }
    
    /// Remove a pattern by ID
    pub fn remove_pattern(&mut self, pattern_id: &str) {
        self.patterns.retain(|(pattern, _)| pattern.id != pattern_id);
    }
    
    /// Get all patterns
    pub fn get_patterns(&self) -> Vec<Pattern> {
        self.patterns.iter().map(|(pattern, _)| pattern.clone()).collect()
    }
}

/// Result of a pattern match
#[derive(Clone, Debug)]
pub struct PatternMatch {
    /// ID of the matched pattern
    pub pattern_id: String,
    
    /// Captured groups from the regex
    pub capture_groups: HashMap<String, String>,
    
    /// Template for code generation
    pub template: String,
    
    /// Tags associated with this pattern
    pub tags: Vec<String>,
}

impl PatternMatch {
    /// Apply the captured groups to the template
    pub fn apply_template(&self) -> String {
        let mut result = self.template.clone();
        
        for (name, value) in &self.capture_groups {
            let placeholder = format!("{{{{{}}}}}",  name);
            result = result.replace(&placeholder, value);
        }
        
        result
    }
}
