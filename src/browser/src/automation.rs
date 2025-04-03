use anyhow::Result;
use std::time::Duration;

use crate::config::Config;
use crate::driver::WebDriver;
use crate::error::Error;

/// High-level browser automation functions
pub struct Automation {
    config: Config,
    driver: Option<WebDriver>,
}

impl Automation {
    /// Create a new Automation instance
    pub fn new(config: Config) -> Self {
        Self {
            config,
            driver: None,
        }
    }
    
    /// Initialize the browser
    pub async fn initialize(&mut self) -> Result<()> {
        if self.driver.is_none() {
            self.driver = Some(WebDriver::new(self.config.headless).await?);
        }
        
        Ok(())
    }
    
    /// Navigate to a URL with timeout
    pub async fn navigate_to(&mut self, url: &str) -> Result<()> {
        self.ensure_initialized().await?;
        
        if let Some(driver) = &self.driver {
            // Set a timeout for navigation
            let timeout = tokio::time::timeout(
                Duration::from_secs(self.config.timeout),
                driver.navigate(url)
            ).await;
            
            match timeout {
                Ok(result) => result?,
                Err(_) => {
                    return Err(Error::TimeoutError(format!(
                        "Navigation to {} timed out after {} seconds",
                        url, self.config.timeout
                    )).into());
                }
            }
        }
        
        Ok(())
    }
    
    /// Fill out a form with multiple fields
    pub async fn fill_form(&mut self, form_selector: &str, fields: &[(&str, &str)]) -> Result<()> {
        self.ensure_initialized().await?;
        
        if let Some(driver) = &self.driver {
            // First, find the form
            driver.get_text(form_selector).await?;
            
            // Then fill each field
            for (selector, value) in fields {
                driver.input(selector, value).await?;
            }
        }
        
        Ok(())
    }
    
    /// Extract structured data from a page
    pub async fn extract_data(&mut self, selectors: &[&str]) -> Result<Vec<String>> {
        self.ensure_initialized().await?;
        
        let mut results = Vec::new();
        
        if let Some(driver) = &self.driver {
            for selector in selectors {
                let text = driver.get_text(selector).await?;
                results.push(text);
            }
        }
        
        Ok(results)
    }
    
    /// Take a screenshot
    pub async fn take_screenshot(&mut self) -> Result<Vec<u8>> {
        self.ensure_initialized().await?;
        
        // In a real implementation, this would take a screenshot
        // if let Some(driver) = &self.driver {
        //     return driver.screenshot().await;
        // }
        
        // For now, just return an empty vector
        Ok(Vec::new())
    }
    
    /// Ensure the browser is initialized
    async fn ensure_initialized(&mut self) -> Result<()> {
        if self.driver.is_none() {
            self.initialize().await?;
        }
        
        Ok(())
    }
    
    /// Close the browser
    pub async fn close(&mut self) -> Result<()> {
        if let Some(driver) = &self.driver {
            driver.close().await?;
            self.driver = None;
        }
        
        Ok(())
    }
}
