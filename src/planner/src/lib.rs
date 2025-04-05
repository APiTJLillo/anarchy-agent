use anyhow::Result;
use std::path::Path;
use std::sync::Arc;
use tokio::sync::Mutex;
use std::fs;

mod config;
mod error;
mod llm;
mod planning;
mod reasoning;

pub use config::Config;
pub use error::Error;
pub use reasoning::{Pattern, ReasoningSystem};

use memory::Memory;

/// Planner module that generates Anarchy-Inference code from task descriptions
pub struct Planner {
    config: Config,
    llm: llm::LlmEngine,
    memory: Arc<Mutex<Memory>>,
    reasoning: reasoning::ReasoningSystem,
}

impl Planner {
    /// Create a new Planner instance with the provided model path and memory
    pub fn new(model_path: &Path, memory: Arc<Mutex<Memory>>) -> Result<Self> {
        let config = Config::default();
        let llm = llm::LlmEngine::new(model_path)?;
        
        // Load patterns from the patterns directory
        let patterns = Self::load_patterns(&config.patterns_dir)?;
        
        // Create reasoning system
        let reasoning = reasoning::ReasoningSystem::new(patterns, config.max_history_size)?;
        
        Ok(Self {
            config,
            llm,
            memory,
            reasoning,
        })
    }
    
    /// Initialize the planner
    pub async fn initialize(&self) -> Result<()> {
        // Initialize the LLM engine
        self.llm.initialize()?;
        
        Ok(())
    }
    
    /// Generate Anarchy-Inference code for a given task description
    pub async fn generate_plan(&self, task_description: &str) -> Result<String> {
        // 1. Retrieve relevant context from memory
        let memory_lock = self.memory.lock().await;
        let context = memory_lock.retrieve_context(task_description).await?;
        drop(memory_lock);
        
        // 2. Process the task with the reasoning system
        let (code, reasoning) = self.reasoning.process_task_with_reasoning(task_description)?;
        
        // 3. If the reasoning system produced valid code, return it
        if Self::is_valid_code(&code) {
            return Ok(code);
        }
        
        // 4. Otherwise, fall back to LLM-based generation
        let prompt = planning::create_prompt(task_description, &context, &self.config);
        let anarchy_code = self.llm.generate(&prompt)?;
        
        // 5. Validate the generated code
        let validated_code = planning::validate_code(&anarchy_code)?;
        
        Ok(validated_code)
    }
    
    /// Check if the generated code is valid
    fn is_valid_code(code: &str) -> bool {
        // Basic validation - check for function definition and return statement
        code.contains("ƒ") && (code.contains("⟼") || code.contains("⌽"))
    }
    
    /// Load patterns from the patterns directory
    fn load_patterns(patterns_dir: &Path) -> Result<Vec<Pattern>> {
        let mut patterns = Vec::new();
        
        // Create the directory if it doesn't exist
        if !patterns_dir.exists() {
            fs::create_dir_all(patterns_dir)?;
            
            // Add some default patterns
            Self::create_default_patterns(patterns_dir)?;
        }
        
        // Read all JSON files in the directory
        for entry in fs::read_dir(patterns_dir)? {
            let entry = entry?;
            let path = entry.path();
            
            if path.is_file() && path.extension().map_or(false, |ext| ext == "json") {
                let content = fs::read_to_string(&path)?;
                let pattern: Pattern = serde_json::from_str(&content)?;
                patterns.push(pattern);
            }
        }
        
        Ok(patterns)
    }
    
    /// Create default patterns
    fn create_default_patterns(patterns_dir: &Path) -> Result<()> {
        // File operations pattern
        let file_pattern = Pattern {
            id: "file_operations".to_string(),
            regex: r"(?i)(?P<action>list|read|write|delete|copy|move)\s+(?P<type>files?|directors?|folders?)\s+(?:in|from|to)?\s+(?P<path>.+)".to_string(),
            priority: 80,
            tags: vec!["file".to_string(), "filesystem".to_string()],
            template: "// File operation: {{action}} {{type}} in {{path}}\n\
                      if (\"{{action}}\" == \"list\") {\n\
                          ιfiles = 📂(\"{{path}}\");\n\
                          ∀(files, λfile {\n\
                              ⌽(file);\n\
                          });\n\
                      } else if (\"{{action}}\" == \"read\") {\n\
                          ιcontent = 📖(\"{{path}}\");\n\
                          ⌽(content);\n\
                      } else if (\"{{action}}\" == \"write\") {\n\
                          ιcontent = \"Content to write\";\n\
                          ✍(\"{{path}}\", content);\n\
                          ⌽(\"File written successfully\");\n\
                      } else if (\"{{action}}\" == \"delete\") {\n\
                          ✂(\"{{path}}\");\n\
                          ⌽(\"File deleted successfully\");\n\
                      } else if (\"{{action}}\" == \"copy\") {\n\
                          ιdest = \"destination/path\";\n\
                          ⧉(\"{{path}}\", dest);\n\
                          ⌽(\"File copied successfully\");\n\
                      } else if (\"{{action}}\" == \"move\") {\n\
                          ιdest = \"destination/path\";\n\
                          ↷(\"{{path}}\", dest);\n\
                          ⌽(\"File moved successfully\");\n\
                      }".to_string(),
            description: "Pattern for file system operations".to_string(),
        };
        
        // HTTP request pattern
        let http_pattern = Pattern {
            id: "http_request".to_string(),
            regex: r"(?i)(?P<method>get|fetch|download|post|send)\s+(?:data\s+(?:from|to))?\s+(?P<url>https?://\S+)".to_string(),
            priority: 75,
            tags: vec!["http".to_string(), "network".to_string()],
            template: "// HTTP request: {{method}} from {{url}}\n\
                      if (\"{{method}}\" == \"get\" || \"{{method}}\" == \"fetch\" || \"{{method}}\" == \"download\") {\n\
                          ⌽(\"Fetching data from {{url}}...\");\n\
                          ιresponse = ↗(\"{{url}}\");\n\
                          ⌽(`Status code: ${response.s}`);\n\
                          ιcontent = response.b;\n\
                          ⌽(content);\n\
                      } else if (\"{{method}}\" == \"post\" || \"{{method}}\" == \"send\") {\n\
                          ιdata = \"{\\\"key\\\": \\\"value\\\"}\";\n\
                          ⌽(\"Sending data to {{url}}...\");\n\
                          ιresponse = ↓(\"{{url}}\", data);\n\
                          ⌽(`Status code: ${response.s}`);\n\
                          ιcontent = response.b;\n\
                          ⌽(content);\n\
                      }".to_string(),
            description: "Pattern for HTTP requests".to_string(),
        };
        
        // Input pattern (using our new workaround)
        let input_pattern = Pattern {
            id: "user_input".to_string(),
            regex: r"(?i)(?:get|ask|prompt|request)\s+(?:for|user\s+for)?\s+(?P<input_type>input|name|value|text|response)(?:\s+about\s+(?P<topic>.+))?".to_string(),
            priority: 85,
            tags: vec!["input".to_string(), "user".to_string()],
            template: "// Get user input about {{topic}}\n\
                      ⌽(\"Requesting user input...\");\n\
                      ιprompt = \"Please provide {{input_type}}\";\n\
                      if (\"{{topic}}\" != \"\") {\n\
                          prompt = `Please provide {{input_type}} about {{topic}}`;\n\
                      }\n\
                      📤(\"prompt.txt\", prompt);\n\
                      ⌽(\"Waiting for user input...\");\n\
                      ιinput_ready = 📩(\"response.txt\", \"30000\");\n\
                      if (input_ready == \"true\") {\n\
                          ιuser_input = 📥(\"response.txt\");\n\
                          ⌽(`Received input: ${user_input}`);\n\
                      } else {\n\
                          ⌽(\"User did not provide input in time.\");\n\
                      }".to_string(),
            description: "Pattern for getting user input".to_string(),
        };
        
        // Memory pattern
        let memory_pattern = Pattern {
            id: "memory_operations".to_string(),
            regex: r"(?i)(?P<action>store|save|remember|retrieve|recall|get|forget|delete)\s+(?P<item>.+?)(?:\s+(?:in|from|to)\s+memory)?".to_string(),
            priority: 70,
            tags: vec!["memory".to_string(), "storage".to_string()],
            template: "// Memory operation: {{action}} {{item}}\n\
                      if (\"{{action}}\" == \"store\" || \"{{action}}\" == \"save\" || \"{{action}}\" == \"remember\") {\n\
                          ιkey = \"{{item}}\";\n\
                          ιvalue = \"Value to store\";\n\
                          📝(key, value);\n\
                          ⌽(`Stored ${key} in memory`);\n\
                      } else if (\"{{action}}\" == \"retrieve\" || \"{{action}}\" == \"recall\" || \"{{action}}\" == \"get\") {\n\
                          ιkey = \"{{item}}\";\n\
                          ÷{\n\
                              ιvalue = 📖(key);\n\
                              ⌽(`Retrieved ${key} from memory: ${value}`);\n\
                          }{\n\
                              ⌽(`Could not find ${key} in memory`);\n\
                          }\n\
                      } else if (\"{{action}}\" == \"forget\" || \"{{action}}\" == \"delete\") {\n\
                          ιkey = \"{{item}}\";\n\
                          🗑(key);\n\
                          ⌽(`Deleted ${key} from memory`);\n\
                      }".to_string(),
            description: "Pattern for memory operations".to_string(),
        };
        
        // Write patterns to files
        fs::write(
            patterns_dir.join("file_operations.json"),
            serde_json::to_string_pretty(&file_pattern)?
        )?;
        
        fs::write(
            patterns_dir.join("http_request.json"),
            serde_json::to_string_pretty(&http_pattern)?
        )?;
        
        fs::write(
            patterns_dir.join("user_input.json"),
            serde_json::to_string_pretty(&input_pattern)?
        )?;
        
        fs::write(
            patterns_dir.join("memory_operations.json"),
            serde_json::to_string_pretty(&memory_pattern)?
        )?;
        
        Ok(())
    }
    
    /// Shutdown the planner
    pub async fn shutdown(&self) -> Result<()> {
        // Shutdown the LLM engine
        self.llm.shutdown()?;
        
        Ok(())
    }
}
