use anyhow::Result;
use std::sync::Arc;
use tokio::sync::Mutex;

mod config;
mod error;
mod driver;
mod automation;

pub use config::Config;
pub use error::Error;

/// Browser module that enables web automation and interaction
pub struct Browser {
    config: Config,
    driver: Option<driver::WebDriver>,
}

impl Browser {
    /// Create a new Browser instance with the specified headless mode
    pub fn new(headless: bool) -> Result<Self> {
        let config = Config {
            headless,
            ..Config::default()
        };
        
        Ok(Self {
            config,
            driver: None,
        })
    }
    
    /// Initialize the browser module
    pub async fn initialize(&self) -> Result<()> {
        // Browser is initialized on demand to save resources
        Ok(())
    }
    
    /// Open a web page (for Anarchy-Inference 🌐 symbol)
    pub async fn open_page(&mut self, url: &str) -> Result<()> {
        // Initialize the driver if not already done
        if self.driver.is_none() {
            self.driver = Some(driver::WebDriver::new(self.config.headless).await?);
        }
        
        // Navigate to the URL
        if let Some(driver) = &self.driver {
            driver.navigate(url).await?;
        }
        
        Ok(())
    }
    
    /// Click on an element (for Anarchy-Inference 🖱 symbol)
    pub async fn click_element(&self, selector: &str) -> Result<()> {
        if let Some(driver) = &self.driver {
            driver.click(selector).await?;
        }
        
        Ok(())
    }
    
    /// Input text into an element (for Anarchy-Inference ⌨ symbol)
    pub async fn input_text(&self, selector: &str, text: &str) -> Result<()> {
        if let Some(driver) = &self.driver {
            driver.input(selector, text).await?;
        }
        
        Ok(())
    }
    
    /// Get text from an element (for Anarchy-Inference 👁 symbol)
    pub async fn get_text(&self, selector: &str) -> Result<String> {
        if let Some(driver) = &self.driver {
            return driver.get_text(selector).await;
        }
        
        Ok(String::new())
    }
    
    /// Execute JavaScript in the browser (for Anarchy-Inference 🧠 symbol)
    pub async fn execute_js(&self, script: &str) -> Result<String> {
        if let Some(driver) = &self.driver {
            return driver.execute_js(script).await;
        }
        
        Ok(String::new())
    }
    
    /// Close the browser (for Anarchy-Inference ❌ symbol)
    pub async fn close(&mut self) -> Result<()> {
        if let Some(driver) = &self.driver {
            driver.close().await?;
            self.driver = None;
        }
        
        Ok(())
    }
    
    /// Shutdown the browser module
    pub async fn shutdown(&mut self) -> Result<()> {
        // Close the browser if it's open
        self.close().await?;
        
        Ok(())
    }
}
