use anyhow::Result;
use std::path::Path;
use std::sync::Arc;
use tokio::sync::Mutex;

mod config;
mod error;
mod llm;
mod planning;

pub use config::Config;
pub use error::Error;

use memory::Memory;

/// Planner module that generates Anarchy-Inference code from task descriptions
pub struct Planner {
    config: Config,
    llm: llm::LlmEngine,
    memory: Arc<Mutex<Memory>>,
}

impl Planner {
    /// Create a new Planner instance with the provided model path and memory
    pub fn new(model_path: &Path, memory: Arc<Mutex<Memory>>) -> Result<Self> {
        let config = Config::default();
        let llm = llm::LlmEngine::new(model_path)?;
        
        Ok(Self {
            config,
            llm,
            memory,
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
        
        // 2. Create a prompt for the LLM
        let prompt = planning::create_prompt(task_description, &context, &self.config);
        
        // 3. Generate Anarchy-Inference code using the LLM
        let anarchy_code = self.llm.generate(&prompt)?;
        
        // 4. Validate the generated code
        let validated_code = planning::validate_code(&anarchy_code)?;
        
        Ok(validated_code)
    }
    
    /// Shutdown the planner
    pub async fn shutdown(&self) -> Result<()> {
        // Shutdown the LLM engine
        self.llm.shutdown()?;
        
        Ok(())
    }
}
