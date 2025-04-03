use std::path::PathBuf;

/// Configuration for the Browser module
pub struct Config {
    /// Whether to run in headless mode
    pub headless: bool,
    
    /// Browser executable path (optional)
    pub browser_path: Option<PathBuf>,
    
    /// Default timeout in seconds
    pub timeout: u64,
    
    /// User agent string
    pub user_agent: String,
    
    /// Whether to enable JavaScript
    pub javascript_enabled: bool,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            headless: true,
            browser_path: None,
            timeout: 30,
            user_agent: String::from("Anarchy-Agent/0.1.0"),
            javascript_enabled: true,
        }
    }
}
