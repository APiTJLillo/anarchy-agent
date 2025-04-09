// api_key_manager.a.i
// Secure API key management for LLM providers

// Import dependencies
🧠 config_manager = require("../config_manager.a.i")

🔠 create_api_key_manager() {
  // Create a new API key manager
  📤 {
    // Internal storage
    _config: null,
    _config_path: null,
    
    // Initialize the API key manager
    initialize: 🔍(config_path) {
      this._config_path = config_path || "/home/user/.anarchy-agent/llm_config.json"
      
      // Create the config manager
      🧠 config_mgr = config_manager.create_config_manager()
      
      // Load or create configuration
      try {
        this._config = config_mgr.load_config(this._config_path)
        if (this._config.error) {
          // If loading fails, create default config
          this._config = config_mgr.create_default_config()
          // Save the default config
          config_mgr.save_config(this._config, this._config_path)
        }
      } catch (error) {
        // Create default config if loading fails
        this._config = config_mgr.create_default_config()
        // Save the default config
        config_mgr.save_config(this._config, this._config_path)
      }
      
      📤 this
    },
    
    // Set API key for a provider
    set_api_key: 🔍(provider_name, api_key) {
      if (!provider_name || !api_key) {
        📤 false
      }
      
      // Ensure providers section exists
      if (!this._config.providers) {
        this._config.providers = {}
      }
      
      // Ensure provider config exists
      if (!this._config.providers[provider_name]) {
        this._config.providers[provider_name] = {}
      }
      
      // Set the API key
      this._config.providers[provider_name].api_key = api_key
      
      // Save the updated config
      🧠 config_mgr = config_manager.create_config_manager()
      🧠 result = config_mgr.save_config(this._config, this._config_path)
      
      📤 result
    },
    
    // Get API key for a provider
    get_api_key: 🔍(provider_name) {
      if (!provider_name) {
        📤 null
      }
      
      // Get the API key from config
      🧠 config_mgr = config_manager.create_config_manager()
      📤 config_mgr.get_api_key(this._config, provider_name)
    },
    
    // Check if API key is set for a provider
    has_api_key: 🔍(provider_name) {
      🧠 api_key = this.get_api_key(provider_name)
      📤 !!api_key
    },
    
    // Remove API key for a provider
    remove_api_key: 🔍(provider_name) {
      if (!provider_name || !this._config.providers || !this._config.providers[provider_name]) {
        📤 false
      }
      
      // Remove the API key
      delete this._config.providers[provider_name].api_key
      
      // Save the updated config
      🧠 config_mgr = config_manager.create_config_manager()
      🧠 result = config_mgr.save_config(this._config, this._config_path)
      
      📤 result
    },
    
    // Set additional configuration for a provider
    set_provider_config: 🔍(provider_name, config) {
      if (!provider_name || !config) {
        📤 false
      }
      
      // Ensure providers section exists
      if (!this._config.providers) {
        this._config.providers = {}
      }
      
      // Ensure provider config exists
      if (!this._config.providers[provider_name]) {
        this._config.providers[provider_name] = {}
      }
      
      // Update the provider config (preserving API key if it exists)
      🧠 api_key = this._config.providers[provider_name].api_key
      this._config.providers[provider_name] = config
      
      // Restore API key if it existed
      if (api_key) {
        this._config.providers[provider_name].api_key = api_key
      }
      
      // Save the updated config
      🧠 config_mgr = config_manager.create_config_manager()
      🧠 result = config_mgr.save_config(this._config, this._config_path)
      
      📤 result
    },
    
    // Get configuration for a provider
    get_provider_config: 🔍(provider_name) {
      if (!provider_name) {
        📤 null
      }
      
      // Get the provider config from config
      🧠 config_mgr = config_manager.create_config_manager()
      📤 config_mgr.get_provider_config(this._config, provider_name)
    },
    
    // Set default provider
    set_default_provider: 🔍(provider_name) {
      if (!provider_name) {
        📤 false
      }
      
      // Set the default provider
      this._config.default_provider = provider_name
      
      // Save the updated config
      🧠 config_mgr = config_manager.create_config_manager()
      🧠 result = config_mgr.save_config(this._config, this._config_path)
      
      📤 result
    },
    
    // Get default provider
    get_default_provider: 🔍() {
      🧠 config_mgr = config_manager.create_config_manager()
      📤 config_mgr.get_default_provider(this._config)
    },
    
    // Set fallback chain
    set_fallback_chain: 🔍(fallback_chain) {
      if (!fallback_chain || !Array.isArray(fallback_chain)) {
        📤 false
      }
      
      // Set the fallback chain
      this._config.fallback_chain = fallback_chain
      
      // Save the updated config
      🧠 config_mgr = config_manager.create_config_manager()
      🧠 result = config_mgr.save_config(this._config, this._config_path)
      
      📤 result
    },
    
    // Get fallback chain
    get_fallback_chain: 🔍() {
      🧠 config_mgr = config_manager.create_config_manager()
      📤 config_mgr.get_fallback_chain(this._config)
    },
    
    // Get the entire configuration
    get_config: 🔍() {
      📤 this._config
    }
  }
}

// Export the API key manager creator function
📤 {
  create_api_key_manager: create_api_key_manager
}
