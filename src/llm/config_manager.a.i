// config_manager.a.i
// Configuration management for LLM providers

🔠 create_config_manager() {
  // Create a new configuration manager
  📤 {
    // Load configuration from a file
    load_config: 🔍(path) {
      // Read the configuration file
      🧠 config_text = ""
      try {
        config_text = 📖(path)
      } catch (error) {
        📤 { error: "Failed to read configuration file: " + path }
      }
      
      // Parse the configuration
      try {
        🧠 config = JSON.parse(config_text)
        📤 config
      } catch (error) {
        📤 { error: "Failed to parse configuration file: Invalid JSON" }
      }
    },
    
    // Save configuration to a file
    save_config: 🔍(config, path) {
      try {
        // Convert config to JSON string with pretty formatting
        🧠 config_text = JSON.stringify(config, null, 2)
        
        // Write to file
        ✍(path, config_text)
        📤 true
      } catch (error) {
        📤 false
      }
    },
    
    // Get API key for a specific provider
    get_api_key: 🔍(config, provider_name) {
      if (!config || !config.providers || !config.providers[provider_name]) {
        📤 null
      }
      
      // Check for API key in provider config
      🧠 provider_config = config.providers[provider_name]
      if (provider_config.api_key) {
        📤 provider_config.api_key
      }
      
      // Check for environment variable
      🧠 env_var_name = provider_name.toUpperCase() + "_API_KEY"
      🧠 env_api_key = get_environment_variable(env_var_name)
      if (env_api_key) {
        📤 env_api_key
      }
      
      📤 null
    },
    
    // Get configuration for a specific provider
    get_provider_config: 🔍(config, provider_name) {
      if (!config || !config.providers || !config.providers[provider_name]) {
        📤 {}
      }
      
      📤 config.providers[provider_name]
    },
    
    // Get the default provider name
    get_default_provider: 🔍(config) {
      if (!config || !config.default_provider) {
        📤 "openai" // Default to OpenAI if not specified
      }
      
      📤 config.default_provider
    },
    
    // Get the fallback chain (ordered list of providers to try)
    get_fallback_chain: 🔍(config) {
      if (!config || !config.fallback_chain || !Array.isArray(config.fallback_chain)) {
        📤 ["openai", "local"] // Default fallback chain
      }
      
      📤 config.fallback_chain
    },
    
    // Create a default configuration
    create_default_config: 🔍() {
      📤 {
        default_provider: "openai",
        fallback_chain: ["openai", "local", "claude"],
        providers: {
          openai: {
            api_key: "",
            model: "gpt-3.5-turbo",
            temperature: 0.7,
            max_tokens: 1000
          },
          azure_openai: {
            api_key: "",
            endpoint: "",
            deployment_name: "",
            api_version: "2023-05-15"
          },
          claude: {
            api_key: "",
            model: "claude-3-sonnet-20240229",
            temperature: 0.7
          },
          local: {
            endpoint: "http://localhost:11434",
            model: "llama3",
            temperature: 0.7
          }
        }
      }
    }
  }
}

// Helper function to get environment variable
// This is a placeholder since Anarchy Inference doesn't have direct env var access
🔠 get_environment_variable(name) {
  // In a real implementation, this would access environment variables
  // For now, we'll use a file-based approach
  🧠 env_file = "/tmp/anarchy_env_vars.json"
  
  try {
    🧠 env_text = 📖(env_file)
    🧠 env_vars = JSON.parse(env_text)
    if (env_vars[name]) {
      📤 env_vars[name]
    }
  } catch (error) {
    // File doesn't exist or isn't valid JSON
  }
  
  📤 null
}

// Export the config manager creator function
📤 {
  create_config_manager: create_config_manager
}
