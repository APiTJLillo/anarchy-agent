use anyhow::Result;
use std::collections::HashMap;
use serde::{Serialize, Deserialize};

use super::pattern_matcher::{Pattern, PatternMatcher};
use super::template_engine::TemplateEngine;

/// Reasoning system with improved pattern matching
pub struct ReasoningSystem {
    /// Template engine for code generation
    template_engine: TemplateEngine,
    
    /// Context for reasoning
    context: HashMap<String, String>,
    
    /// History of reasoning steps
    history: Vec<ReasoningStep>,
    
    /// Maximum history size
    max_history: usize,
}

/// A single reasoning step
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ReasoningStep {
    /// Input task or query
    pub input: String,
    
    /// Generated code or response
    pub output: String,
    
    /// Reasoning process
    pub reasoning: String,
    
    /// Timestamp
    pub timestamp: u64,
}

impl ReasoningSystem {
    /// Create a new ReasoningSystem with the provided patterns
    pub fn new(patterns: Vec<Pattern>, max_history: usize) -> Result<Self> {
        let template_engine = TemplateEngine::new(patterns)?;
        
        Ok(Self {
            template_engine,
            context: HashMap::new(),
            history: Vec::new(),
            max_history,
        })
    }
    
    /// Process a task description and generate code
    pub fn process_task(&mut self, task_description: &str) -> Result<String> {
        // Generate code using the template engine
        let code = self.template_engine.generate_code(task_description)?;
        
        // Create a reasoning step
        let reasoning = format!("Analyzed task: '{}' and generated appropriate code", task_description);
        let timestamp = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)?
            .as_secs();
        
        let step = ReasoningStep {
            input: task_description.to_string(),
            output: code.clone(),
            reasoning,
            timestamp,
        };
        
        // Add to history
        self.add_to_history(step);
        
        Ok(code)
    }
    
    /// Process a task with detailed reasoning
    pub fn process_task_with_reasoning(&mut self, task_description: &str) -> Result<(String, String)> {
        // Generate code using the template engine
        let code = self.template_engine.generate_code(task_description)?;
        
        // Generate reasoning
        let reasoning = self.generate_reasoning(task_description, &code);
        
        // Create a reasoning step
        let timestamp = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)?
            .as_secs();
        
        let step = ReasoningStep {
            input: task_description.to_string(),
            output: code.clone(),
            reasoning: reasoning.clone(),
            timestamp,
        };
        
        // Add to history
        self.add_to_history(step);
        
        Ok((code, reasoning))
    }
    
    /// Generate reasoning for a task and code
    fn generate_reasoning(&self, task_description: &str, code: &str) -> String {
        let mut reasoning = String::new();
        
        reasoning.push_str(&format!("Task Analysis: '{}'\n\n", task_description));
        
        // Identify key components of the task
        let components = self.identify_task_components(task_description);
        reasoning.push_str("Task Components:\n");
        for (i, component) in components.iter().enumerate() {
            reasoning.push_str(&format!("{}. {}\n", i + 1, component));
        }
        
        // Explain the code generation process
        reasoning.push_str("\nCode Generation Process:\n");
        reasoning.push_str("1. Matched task against known patterns\n");
        reasoning.push_str("2. Selected appropriate templates\n");
        reasoning.push_str("3. Applied task-specific parameters\n");
        reasoning.push_str("4. Generated structured Anarchy-Inference code\n");
        
        // Explain the generated code
        reasoning.push_str("\nCode Explanation:\n");
        let code_lines: Vec<&str> = code.lines().collect();
        let mut i = 0;
        while i < code_lines.len() {
            let line = code_lines[i].trim();
            
            if line.starts_with("ƒ") {
                reasoning.push_str(&format!("- Function definition: {}\n", line));
            } else if line.contains("⌽(") {
                reasoning.push_str(&format!("- Print statement: {}\n", line));
            } else if line.contains("📂(") {
                reasoning.push_str(&format!("- List directory: {}\n", line));
            } else if line.contains("📖(") {
                reasoning.push_str(&format!("- Read file or memory: {}\n", line));
            } else if line.contains("✍(") {
                reasoning.push_str(&format!("- Write file: {}\n", line));
            } else if line.contains("↗(") {
                reasoning.push_str(&format!("- HTTP GET request: {}\n", line));
            } else if line.contains("📝(") {
                reasoning.push_str(&format!("- Store in memory: {}\n", line));
            } else if line.contains("📥(") {
                reasoning.push_str(&format!("- Get input from file: {}\n", line));
            } else if line.contains("📤(") {
                reasoning.push_str(&format!("- Write output to file: {}\n", line));
            } else if line.contains("📩(") {
                reasoning.push_str(&format!("- Wait for input file: {}\n", line));
            } else if line.contains("⟼(") {
                reasoning.push_str(&format!("- Return statement: {}\n", line));
            }
            
            i += 1;
        }
        
        reasoning
    }
    
    /// Identify key components of a task
    fn identify_task_components(&self, task_description: &str) -> Vec<String> {
        let mut components = Vec::new();
        
        // Check for file operations
        if task_description.contains("file") || task_description.contains("directory") || 
           task_description.contains("folder") || task_description.contains("read") || 
           task_description.contains("write") {
            components.push("File system operations".to_string());
        }
        
        // Check for network operations
        if task_description.contains("http") || task_description.contains("web") || 
           task_description.contains("url") || task_description.contains("download") || 
           task_description.contains("fetch") {
            components.push("Network operations".to_string());
        }
        
        // Check for memory operations
        if task_description.contains("memory") || task_description.contains("store") || 
           task_description.contains("remember") || task_description.contains("recall") {
            components.push("Memory operations".to_string());
        }
        
        // Check for input operations
        if task_description.contains("input") || task_description.contains("ask") || 
           task_description.contains("prompt") || task_description.contains("question") {
            components.push("Input operations".to_string());
        }
        
        // If no specific components identified, add a generic one
        if components.is_empty() {
            components.push("General task processing".to_string());
        }
        
        components
    }
    
    /// Add a step to the reasoning history
    fn add_to_history(&mut self, step: ReasoningStep) {
        self.history.push(step);
        
        // Trim history if it exceeds the maximum size
        if self.history.len() > self.max_history {
            self.history.remove(0);
        }
    }
    
    /// Get the reasoning history
    pub fn get_history(&self) -> &[ReasoningStep] {
        &self.history
    }
    
    /// Clear the reasoning history
    pub fn clear_history(&mut self) {
        self.history.clear();
    }
    
    /// Set a context variable
    pub fn set_context(&mut self, key: &str, value: &str) {
        self.context.insert(key.to_string(), value.to_string());
    }
    
    /// Get a context variable
    pub fn get_context(&self, key: &str) -> Option<&String> {
        self.context.get(key)
    }
    
    /// Clear the context
    pub fn clear_context(&mut self) {
        self.context.clear();
    }
    
    /// Add a new pattern
    pub fn add_pattern(&mut self, pattern: Pattern) -> Result<()> {
        self.template_engine.add_pattern(pattern)
    }
    
    /// Get all patterns
    pub fn get_patterns(&self) -> Vec<Pattern> {
        self.template_engine.get_patterns()
    }
}
