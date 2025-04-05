// Add input_workaround module
mod config;
mod error;
mod parser;
mod sandbox;
mod symbols;
mod input_workaround;

pub use config::Config;
pub use error::Error;
pub use input_workaround::InputWorkaround;

use memory::Memory;
use browser::Browser;
use system::System;
use std::sync::Arc;
use tokio::sync::Mutex;
use anyhow::Result;

/// Executor module that safely runs Anarchy-Inference code in a sandboxed environment
pub struct Executor {
    config: Config,
    memory: Arc<Mutex<Memory>>,
    browser: Arc<Mutex<Browser>>,
    system: Arc<Mutex<System>>,
    sandbox: sandbox::Sandbox,
    input_workaround: Arc<Mutex<InputWorkaround>>,
}

impl Executor {
    /// Create a new Executor instance with the provided dependencies
    pub fn new(
        memory: Arc<Mutex<Memory>>,
        browser: Arc<Mutex<Browser>>,
        system: Arc<Mutex<System>>,
    ) -> Result<Self> {
        let config = Config::default();
        let sandbox = sandbox::Sandbox::new(&config)?;
        
        // Initialize input workaround with default directory
        let input_workaround = Arc::new(Mutex::new(
            InputWorkaround::new(&config.input_directory)?
        ));
        
        Ok(Self {
            config,
            memory,
            browser,
            system,
            sandbox,
            input_workaround,
        })
    }
    
    /// Initialize the executor
    pub async fn initialize(&self) -> Result<()> {
        // Initialize the sandbox
        self.sandbox.initialize()?;
        
        // Register symbol handlers
        self.register_symbol_handlers().await?;
        
        Ok(())
    }
    
    /// Register handlers for Anarchy-Inference symbols
    async fn register_symbol_handlers(&self) -> Result<()> {
        // Register file system symbols
        symbols::register_file_symbols(&self.sandbox, Arc::clone(&self.system))?;
        
        // Register shell symbols
        symbols::register_shell_symbols(&self.sandbox, Arc::clone(&self.system))?;
        
        // Register network symbols
        symbols::register_network_symbols(&self.sandbox)?;
        
        // Register browser symbols
        symbols::register_browser_symbols(&self.sandbox, Arc::clone(&self.browser))?;
        
        // Register memory symbols
        symbols::register_memory_symbols(&self.sandbox, Arc::clone(&self.memory))?;
        
        // Register input workaround symbols
        input_workaround::register_input_symbols(&self.sandbox, Arc::clone(&self.input_workaround))?;
        
        Ok(())
    }
    
    /// Execute Anarchy-Inference code in the sandbox
    pub async fn execute_code(&self, code: &str) -> Result<String> {
        // 1. Parse the code
        let parsed = parser::parse(code)?;
        
        // 2. Execute in sandbox
        let result = self.sandbox.execute(&parsed)?;
        
        Ok(result)
    }
    
    /// Shutdown the executor
    pub async fn shutdown(&self) -> Result<()> {
        // Shutdown the sandbox
        self.sandbox.shutdown()?;
        
        Ok(())
    }
}
