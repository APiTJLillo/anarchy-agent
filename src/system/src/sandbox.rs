use anyhow::Result;
use std::path::{Path, PathBuf};
use log::warn;

use crate::config::Config;
use crate::error::Error;

/// Sandbox for secure system operations
pub struct Sandbox {
    pub config: Config,
}

impl Sandbox {
    /// Create a new Sandbox instance
    pub fn new(config: &Config) -> Result<Self> {
        Ok(Self {
            config: config.clone(),
        })
    }
    
    /// Initialize the sandbox
    pub fn initialize(&self) -> Result<()> {
        // In a real implementation, this would set up the sandbox environment
        if !self.config.sandbox_enabled {
            warn!("Warning: Sandbox is disabled. System operations will run with full permissions.");
        }
        
        // Create the working directory if it doesn't exist
        let working_dir = &self.config.working_directory;
        if !working_dir.exists() {
            // In a real implementation, this would create the directory
            // std::fs::create_dir_all(working_dir)?;
            warn!("Creating working directory: {:?}", working_dir);
        }
        
        Ok(())
    }
    
    /// Check if a path is allowed
    pub fn check_path_allowed(&self, path: &Path) -> Result<()> {
        if !self.config.sandbox_enabled {
            return Ok(());
        }
        
        // Check if the path is within any of the allowed paths
        for allowed_path in &self.config.allowed_paths {
            if is_path_within(path, allowed_path) {
                return Ok(());
            }
        }
        
        Err(Error::PathNotAllowed(format!(
            "Path {:?} is not within any allowed paths",
            path
        )).into())
    }
    
    /// Check if a command is allowed
    pub fn check_command_allowed(&self, command: &str) -> Result<()> {
        if !self.config.sandbox_enabled {
            return Ok(());
        }
        
        // Extract the command name (first word before any spaces or special characters)
        let command_name = command.split_whitespace().next().unwrap_or("");
        
        // Check if the command is in the allowed list
        if self.config.allowed_commands.iter().any(|c| c == command_name) {
            return Ok(());
        }
        
        Err(Error::CommandNotAllowed(format!(
            "Command '{}' is not in the allowed list",
            command_name
        )).into())
    }
    
    /// Shutdown the sandbox
    pub fn shutdown(&self) -> Result<()> {
        // In a real implementation, this would clean up the sandbox environment
        Ok(())
    }
}

/// Check if a path is within another path
fn is_path_within(path: &Path, container: &Path) -> bool {
    // In a real implementation, this would canonicalize both paths and check
    // if one is a prefix of the other
    
    // For now, just do a simple string prefix check
    let path_str = path.to_string_lossy();
    let container_str = container.to_string_lossy();
    
    path_str.starts_with(&*container_str)
}
