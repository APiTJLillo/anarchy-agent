use anyhow::Result;
use std::path::Path;
use std::sync::Arc;
use tokio::sync::Mutex;

mod config;
mod error;
mod file;
mod shell;
mod sandbox;

pub use config::Config;
pub use error::Error;

/// System module that interfaces with the operating system for file and process operations
pub struct System {
    config: Config,
    sandbox: sandbox::Sandbox,
}

impl System {
    /// Create a new System instance with the specified working directory and sandbox mode
    pub fn new(working_dir: &Path, sandbox_enabled: bool) -> Result<Self> {
        let config = Config {
            working_directory: working_dir.to_path_buf(),
            sandbox_enabled,
            ..Config::default()
        };
        
        let sandbox = sandbox::Sandbox::new(&config)?;
        
        Ok(Self {
            config,
            sandbox,
        })
    }
    
    /// Initialize the system module
    pub async fn initialize(&self) -> Result<()> {
        // Initialize the sandbox
        self.sandbox.initialize()?;
        
        Ok(())
    }
    
    /// List directory contents (for Anarchy-Inference 📂 symbol)
    pub async fn list_directory(&self, path: &str) -> Result<Vec<String>> {
        file::list_directory(&self.config.working_directory, path, &self.sandbox)
    }
    
    /// Read file contents (for Anarchy-Inference 📖 symbol)
    pub async fn read_file(&self, path: &str) -> Result<String> {
        file::read_file(&self.config.working_directory, path, &self.sandbox)
    }
    
    /// Write to a file (for Anarchy-Inference ✍ symbol)
    pub async fn write_file(&self, path: &str, contents: &str) -> Result<()> {
        file::write_file(&self.config.working_directory, path, contents, &self.sandbox)
    }
    
    /// Remove a file or directory (for Anarchy-Inference ✂ symbol)
    pub async fn remove_path(&self, path: &str) -> Result<()> {
        file::remove_path(&self.config.working_directory, path, &self.sandbox)
    }
    
    /// Copy a file (for Anarchy-Inference ⧉ symbol)
    pub async fn copy_file(&self, src: &str, dst: &str) -> Result<()> {
        file::copy_file(&self.config.working_directory, src, dst, &self.sandbox)
    }
    
    /// Move a file (for Anarchy-Inference ↷ symbol)
    pub async fn move_file(&self, src: &str, dst: &str) -> Result<()> {
        file::move_file(&self.config.working_directory, src, dst, &self.sandbox)
    }
    
    /// Check if a file exists (for Anarchy-Inference ? symbol)
    pub async fn file_exists(&self, path: &str) -> Result<bool> {
        file::file_exists(&self.config.working_directory, path, &self.sandbox)
    }
    
    /// Execute a shell command (for Anarchy-Inference ! symbol)
    pub async fn execute_shell(&self, command: &str) -> Result<shell::ShellResult> {
        shell::execute(&self.config.working_directory, command, &self.sandbox)
    }
    
    /// Get current OS information (for Anarchy-Inference 🖥 symbol)
    pub async fn get_os_info(&self) -> Result<String> {
        shell::get_os_info()
    }
    
    /// Get environment variable (for Anarchy-Inference 🌐 symbol)
    pub async fn get_env_var(&self, name: &str) -> Result<String> {
        shell::get_env_var(name, &self.sandbox)
    }
    
    /// Shutdown the system module
    pub async fn shutdown(&self) -> Result<()> {
        // Shutdown the sandbox
        self.sandbox.shutdown()?;
        
        Ok(())
    }
}
