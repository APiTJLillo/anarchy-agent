use crate::config::Config;
use anyhow::Result;

/// Functions for creating prompts and validating generated code
pub mod planning {
    use anyhow::Result;
    use crate::config::Config;
    use crate::error::Error;

    /// Create a prompt for the LLM based on the task description and context
    pub fn create_prompt(task_description: &str, context: &str, config: &Config) -> String {
        let system_prompt = &config.system_prompt;
        
        format!(
            "{}\n\n\
            Task: {}\n\n\
            Relevant Context:\n{}\n\n\
            Generate Anarchy-Inference code to accomplish this task. \
            Use the symbolic syntax (e.g., !, ↗, 📂, etc.) for all operations. \
            The code should be complete and executable.",
            system_prompt, task_description, context
        )
    }

    /// Validate the generated Anarchy-Inference code
    pub fn validate_code(code: &str) -> Result<String> {
        // In a real implementation, this would parse and validate the code
        // For now, just do some basic checks
        
        if !code.contains("ƒ") {
            return Err(Error::ValidationError(
                "Generated code does not contain any function definitions".to_string()
            ).into());
        }
        
        // Check for basic syntax elements
        if !code.contains("⟼") && !code.contains("⌽") {
            return Err(Error::ValidationError(
                "Generated code does not contain return or print statements".to_string()
            ).into());
        }
        
        // Ensure the code has a main function or immediate execution
        if !code.contains("main()") && !code.contains("ƒmain()") {
            // Add a main function wrapper if not present
            return Ok(format!(
                "ƒmain() {{\n{}\n}}\n\nmain();",
                code
            ));
        }
        
        Ok(code.to_string())
    }
}

// Re-export the planning functions
pub use planning::*;
