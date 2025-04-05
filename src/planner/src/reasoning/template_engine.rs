use anyhow::Result;
use std::collections::HashMap;
use serde::{Serialize, Deserialize};

use super::pattern_matcher::{Pattern, PatternMatcher, PatternMatch};

/// Template engine for generating code from patterns
pub struct TemplateEngine {
    /// Pattern matcher
    pattern_matcher: PatternMatcher,
    
    /// Template variables
    variables: HashMap<String, String>,
    
    /// Default templates for common operations
    default_templates: HashMap<String, String>,
}

impl TemplateEngine {
    /// Create a new TemplateEngine with the provided patterns
    pub fn new(patterns: Vec<Pattern>) -> Result<Self> {
        let pattern_matcher = PatternMatcher::new(patterns)?;
        
        // Initialize default templates
        let mut default_templates = HashMap::new();
        
        // File operations
        default_templates.insert(
            "list_files".to_string(),
            "ιfiles = 📂(\"{{path}}\");\n∀(files, λfile {\n    ⌽(file);\n});".to_string()
        );
        
        // HTTP operations
        default_templates.insert(
            "http_get".to_string(),
            "ιresponse = ↗(\"{{url}}\");\n⌽(`Status code: ${response.s}`);\nιcontent = response.b;".to_string()
        );
        
        // Memory operations
        default_templates.insert(
            "store_memory".to_string(),
            "📝(\"{{key}}\", \"{{value}}\");".to_string()
        );
        
        // Input operations (using our new workaround)
        default_templates.insert(
            "get_input".to_string(),
            "📤(\"prompt.txt\", \"{{prompt}}\");\nιinput_ready = 📩(\"response.txt\", \"30000\");\nif (input_ready == \"true\") {\n    ιuser_input = 📥(\"response.txt\");\n}".to_string()
        );
        
        Ok(Self {
            pattern_matcher,
            variables: HashMap::new(),
            default_templates,
        })
    }
    
    /// Match a task description and generate code
    pub fn generate_code(&self, task_description: &str) -> Result<String> {
        // Match the task against patterns
        let matches = self.pattern_matcher.match_task(task_description);
        
        if matches.is_empty() {
            // No pattern matches, use a generic template
            return Ok(self.generate_generic_code(task_description));
        }
        
        // Use the highest priority match (first in the list)
        let best_match = &matches[0];
        
        // Apply the template
        let code = best_match.apply_template();
        
        // Add function wrapper if needed
        if !code.contains("ƒmain()") && !code.contains("main()") {
            return Ok(format!(
                "ƒmain() {{\n    // Task: {}\n    {}\n    \n    ⟼(\"Task completed\");\n}}\n\nmain();",
                task_description, code
            ));
        }
        
        Ok(code)
    }
    
    /// Generate code for multiple pattern matches
    pub fn generate_combined_code(&self, task_description: &str) -> Result<String> {
        // Match the task against patterns
        let matches = self.pattern_matcher.match_task(task_description);
        
        if matches.is_empty() {
            // No pattern matches, use a generic template
            return Ok(self.generate_generic_code(task_description));
        }
        
        // Combine code from all matches
        let mut combined_code = String::new();
        combined_code.push_str(&format!("// Task: {}\n", task_description));
        
        for (i, match_result) in matches.iter().enumerate() {
            let code = match_result.apply_template();
            combined_code.push_str(&format!("\n// Pattern match {}\n{}\n", i + 1, code));
        }
        
        // Add function wrapper
        let wrapped_code = format!(
            "ƒmain() {{\n{}\n    \n    ⟼(\"Task completed\");\n}}\n\nmain();",
            combined_code
        );
        
        Ok(wrapped_code)
    }
    
    /// Generate generic code for when no patterns match
    fn generate_generic_code(&self, task_description: &str) -> String {
        format!(
            "ƒmain() {{\n    // Task: {}\n    ⌽(\"Starting task: {}\");\n    \n    // TODO: Implement task-specific logic\n    \n    ⟼(\"Task completed\");\n}}\n\nmain();",
            task_description, task_description
        )
    }
    
    /// Set a template variable
    pub fn set_variable(&mut self, name: &str, value: &str) {
        self.variables.insert(name.to_string(), value.to_string());
    }
    
    /// Get a template variable
    pub fn get_variable(&self, name: &str) -> Option<&String> {
        self.variables.get(name)
    }
    
    /// Add a new pattern
    pub fn add_pattern(&mut self, pattern: Pattern) -> Result<()> {
        self.pattern_matcher.add_pattern(pattern)
    }
    
    /// Remove a pattern by ID
    pub fn remove_pattern(&mut self, pattern_id: &str) {
        self.pattern_matcher.remove_pattern(pattern_id);
    }
    
    /// Get all patterns
    pub fn get_patterns(&self) -> Vec<Pattern> {
        self.pattern_matcher.get_patterns()
    }
    
    /// Get a default template by name
    pub fn get_default_template(&self, name: &str) -> Option<&String> {
        self.default_templates.get(name)
    }
    
    /// Add or update a default template
    pub fn set_default_template(&mut self, name: &str, template: &str) {
        self.default_templates.insert(name.to_string(), template.to_string());
    }
}
