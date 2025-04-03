use std::sync::Arc;
use anyhow::Result;
use tokio::sync::Mutex;

mod config;
mod error;
mod agent;

pub use config::Config;
pub use error::Error;
pub use agent::Agent;

use planner::Planner;
use executor::Executor;
use memory::Memory;
use browser::Browser;
use system::System;

/// Core module that coordinates all components of the Anarchy Agent
pub struct Core {
    config: Config,
    planner: Arc<Mutex<Planner>>,
    executor: Arc<Mutex<Executor>>,
    memory: Arc<Mutex<Memory>>,
    browser: Arc<Mutex<Browser>>,
    system: Arc<Mutex<System>>,
}

impl Core {
    /// Create a new Core instance with the provided configuration
    pub async fn new(config: Config) -> Result<Self> {
        let memory = Arc::new(Mutex::new(Memory::new(&config.memory_path)?));
        
        let planner = Arc::new(Mutex::new(Planner::new(
            &config.llm_model_path,
            Arc::clone(&memory),
        )?));
        
        let browser = Arc::new(Mutex::new(Browser::new(config.headless)?));
        
        let system = Arc::new(Mutex::new(System::new(
            &config.working_directory,
            config.sandbox_enabled,
        )?));
        
        let executor = Arc::new(Mutex::new(Executor::new(
            Arc::clone(&memory),
            Arc::clone(&browser),
            Arc::clone(&system),
        )?));
        
        Ok(Self {
            config,
            planner,
            executor,
            memory,
            browser,
            system,
        })
    }
    
    /// Initialize the agent and all its components
    pub async fn initialize(&self) -> Result<()> {
        // Initialize all components
        self.memory.lock().await.initialize().await?;
        self.planner.lock().await.initialize().await?;
        self.executor.lock().await.initialize().await?;
        self.browser.lock().await.initialize().await?;
        self.system.lock().await.initialize().await?;
        
        Ok(())
    }
    
    /// Run a task using the Anarchy-Inference language
    pub async fn run_task(&self, task_description: &str) -> Result<String> {
        // 1. Generate a plan using the planner
        let anarchy_code = self.planner.lock().await.generate_plan(task_description).await?;
        
        // 2. Execute the plan using the executor
        let result = self.executor.lock().await.execute_code(&anarchy_code).await?;
        
        // 3. Store the result in memory
        self.memory.lock().await.store_result(task_description, &anarchy_code, &result).await?;
        
        Ok(result)
    }
    
    /// Shutdown the agent and all its components
    pub async fn shutdown(&self) -> Result<()> {
        // Shutdown all components in reverse order
        self.system.lock().await.shutdown().await?;
        self.browser.lock().await.shutdown().await?;
        self.executor.lock().await.shutdown().await?;
        self.planner.lock().await.shutdown().await?;
        self.memory.lock().await.shutdown().await?;
        
        Ok(())
    }
}
