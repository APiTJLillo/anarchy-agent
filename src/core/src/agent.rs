use anyhow::Result;
use std::sync::Arc;
use tokio::sync::Mutex;

use crate::Core;
use crate::Config;

/// Agent struct that provides a simplified interface to the Core functionality
pub struct Agent {
    core: Arc<Core>,
}

impl Agent {
    /// Create a new Agent instance with default configuration
    pub async fn new() -> Result<Self> {
        let config = Config::default();
        Self::with_config(config).await
    }
    
    /// Create a new Agent instance with custom configuration
    pub async fn with_config(config: Config) -> Result<Self> {
        let core = Arc::new(Core::new(config).await?);
        
        Ok(Self {
            core,
        })
    }
    
    /// Initialize the agent
    pub async fn initialize(&self) -> Result<()> {
        self.core.initialize().await
    }
    
    /// Run a task using natural language description
    pub async fn run_task(&self, task_description: &str) -> Result<String> {
        self.core.run_task(task_description).await
    }
    
    /// Run Anarchy-Inference code directly
    pub async fn run_code(&self, anarchy_code: &str) -> Result<String> {
        let executor = self.core.executor.lock().await;
        executor.execute_code(anarchy_code).await
    }
    
    /// Shutdown the agent
    pub async fn shutdown(&self) -> Result<()> {
        self.core.shutdown().await
    }
}
