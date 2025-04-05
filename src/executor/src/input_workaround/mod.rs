use anyhow::Result;
use std::sync::Arc;
use tokio::sync::Mutex;
use std::fs;
use std::path::Path;

use crate::error::Error;
use crate::sandbox::Sandbox;

/// Input workaround module that provides alternative ways to get user input
pub struct InputWorkaround {
    file_watch_dir: String,
}

impl InputWorkaround {
    /// Create a new InputWorkaround instance
    pub fn new(file_watch_dir: &str) -> Result<Self> {
        // Create the directory if it doesn't exist
        let path = Path::new(file_watch_dir);
        if !path.exists() {
            fs::create_dir_all(path)?;
        }
        
        Ok(Self {
            file_watch_dir: file_watch_dir.to_string(),
        })
    }
    
    /// Get input from a file
    pub fn get_input_from_file(&self, filename: &str) -> Result<String> {
        let file_path = Path::new(&self.file_watch_dir).join(filename);
        
        if !file_path.exists() {
            return Err(Error::InputError(
                format!("Input file {} does not exist", filename)
            ).into());
        }
        
        let content = fs::read_to_string(file_path)?;
        Ok(content)
    }
    
    /// Write output to a file
    pub fn write_output_to_file(&self, filename: &str, content: &str) -> Result<()> {
        let file_path = Path::new(&self.file_watch_dir).join(filename);
        fs::write(file_path, content)?;
        Ok(())
    }
    
    /// Check if input file exists
    pub fn input_file_exists(&self, filename: &str) -> bool {
        let file_path = Path::new(&self.file_watch_dir).join(filename);
        file_path.exists()
    }
    
    /// Wait for input file to appear
    pub fn wait_for_input_file(&self, filename: &str, timeout_ms: u64) -> Result<bool> {
        let file_path = Path::new(&self.file_watch_dir).join(filename);
        let start = std::time::Instant::now();
        let timeout = std::time::Duration::from_millis(timeout_ms);
        
        while start.elapsed() < timeout {
            if file_path.exists() {
                return Ok(true);
            }
            std::thread::sleep(std::time::Duration::from_millis(100));
        }
        
        Ok(false)
    }
}

/// Register input workaround symbols with the sandbox
pub fn register_input_symbols(
    sandbox: &Sandbox,
    input_workaround: Arc<Mutex<InputWorkaround>>,
) -> Result<()> {
    // Register 📥 (get input from file)
    sandbox.register_symbol("📥", move |args| {
        if args.len() != 1 {
            return Err(Error::SymbolRegistrationError(
                "📥 requires exactly one argument (filename)".to_string()
            ).into());
        }
        
        let filename = args[0];
        let input_clone = Arc::clone(&input_workaround);
        
        // This would be properly async in a real implementation
        let content = tokio::runtime::Runtime::new()?.block_on(async {
            let input_lock = input_clone.lock().await;
            input_lock.get_input_from_file(filename)
        })?;
        
        Ok(content)
    })?;
    
    // Register 📤 (write output to file)
    let input_workaround_clone = Arc::clone(&input_workaround);
    sandbox.register_symbol("📤", move |args| {
        if args.len() != 2 {
            return Err(Error::SymbolRegistrationError(
                "📤 requires exactly two arguments (filename, content)".to_string()
            ).into());
        }
        
        let filename = args[0];
        let content = args[1];
        let input_clone = Arc::clone(&input_workaround_clone);
        
        // This would be properly async in a real implementation
        tokio::runtime::Runtime::new()?.block_on(async {
            let input_lock = input_clone.lock().await;
            input_lock.write_output_to_file(filename, content)
        })?;
        
        Ok("Output written".to_string())
    })?;
    
    // Register 📩 (wait for input file)
    let input_workaround_clone = Arc::clone(&input_workaround);
    sandbox.register_symbol("📩", move |args| {
        if args.len() != 2 {
            return Err(Error::SymbolRegistrationError(
                "📩 requires exactly two arguments (filename, timeout_ms)".to_string()
            ).into());
        }
        
        let filename = args[0];
        let timeout_ms = args[1].parse::<u64>().map_err(|_| {
            Error::SymbolRegistrationError("Invalid timeout value".to_string())
        })?;
        
        let input_clone = Arc::clone(&input_workaround_clone);
        
        // This would be properly async in a real implementation
        let result = tokio::runtime::Runtime::new()?.block_on(async {
            let input_lock = input_clone.lock().await;
            input_lock.wait_for_input_file(filename, timeout_ms)
        })?;
        
        Ok(format!("{}", result))
    })?;
    
    Ok(())
}
