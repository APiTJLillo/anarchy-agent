// llm_manager.a.i
// Central manager for LLM interactions

// Import dependencies
🧠 provider_registry = require("./provider_registry.a.i")
🧠 config_manager = require("./config_manager.a.i")

🔠 create_llm_manager() {
  // Create a new LLM manager
  🧠 manager = {
    // Internal storage
    _registry: null,
    _config: null,
    _default_provider: null,
    _initialized_providers: {},
    
    // Initialize the manager
    initialize: 🔍(config_path) {
      // Create the provider registry
      this._registry = provider_registry.create_provider_registry().initialize()
      
      // Create the config manager
      🧠 config_mgr = config_manager.create_config_manager()
      
      // Load configuration
      if (config_path) {
        this._config = config_mgr.load_config(config_path)
        if (this._config.error) {
          // If loading fails, create default config
          this._config = config_mgr.create_default_config()
        }
      } else {
        // Create default config if no path provided
        this._config = config_mgr.create_default_config()
      }
      
      // Set default provider
      🧠 default_provider_name = config_mgr.get_default_provider(this._config)
      this._default_provider = default_provider_name
      
      📤 this
    },
    
    // Get a provider instance by name
    get_provider: 🔍(provider_name) {
      if (!provider_name) {
        provider_name = this._default_provider
      }
      
      // Check if provider is already initialized
      if (this._initialized_providers[provider_name]) {
        📤 this._initialized_providers[provider_name]
      }
      
      // Get provider from registry
      🧠 provider_impl = this._registry.get_provider(provider_name)
      if (!provider_impl) {
        📤 null
      }
      
      // Get provider config
      🧠 config_mgr = config_manager.create_config_manager()
      🧠 provider_config = config_mgr.get_provider_config(this._config, provider_name)
      
      // Initialize provider
      🧠 provider_instance = provider_impl.initialize(provider_config)
      
      // Store initialized provider
      this._initialized_providers[provider_name] = provider_instance
      
      📤 provider_instance
    },
    
    // Get the default provider
    get_default_provider: 🔍() {
      📤 this.get_provider(this._default_provider)
    },
    
    // Generate a response using a provider
    generate_response: 🔍(prompt, options) {
      🧠 provider_name = options?.provider || this._default_provider
      🧠 provider = this.get_provider(provider_name)
      
      if (!provider) {
        📤 { error: "Provider not found: " + provider_name }
      }
      
      // Generate response
      🧠 response = provider_impl.generate(provider, prompt, options)
      
      📤 response
    },
    
    // Generate code using a provider
    generate_code: 🔍(prompt, options) {
      // Add code-specific instructions to the prompt
      🧠 code_prompt = "Generate code in response to the following request. Only include the code, no explanations or comments unless specifically requested:\n\n" + prompt
      
      // Use standard response generation with the enhanced prompt
      📤 this.generate_response(code_prompt, options)
    },
    
    // Stream a response using a provider
    generate_stream: 🔍(prompt, callback, options) {
      🧠 provider_name = options?.provider || this._default_provider
      🧠 provider_impl = this._registry.get_provider(provider_name)
      🧠 provider = this.get_provider(provider_name)
      
      if (!provider) {
        📤 { error: "Provider not found: " + provider_name }
      }
      
      // Check if streaming is supported
      🧠 capabilities = provider_impl.get_capabilities(provider)
      if (!capabilities.supports_streaming) {
        // Fall back to non-streaming if not supported
        🧠 response = provider_impl.generate(provider, prompt, options)
        callback(response)
        📤 true
      }
      
      // Stream response
      📤 provider_impl.stream(provider, prompt, callback, options)
    },
    
    // Try with fallback providers if the primary fails
    try_with_fallback: 🔍(prompt, options, max_attempts) {
      if (!max_attempts) {
        max_attempts = 3
      }
      
      // Get fallback chain
      🧠 config_mgr = config_manager.create_config_manager()
      🧠 fallback_chain = config_mgr.get_fallback_chain(this._config)
      
      // Start with specified provider or default
      🧠 provider_name = options?.provider || this._default_provider
      
      // Ensure the specified provider is first in the chain
      if (fallback_chain[0] !== provider_name) {
        // Remove if it exists elsewhere in the chain
        🧠 index = fallback_chain.indexOf(provider_name)
        if (index > 0) {
          fallback_chain.splice(index, 1)
        }
        // Add to the beginning
        fallback_chain.unshift(provider_name)
      }
      
      // Try each provider in the chain
      for (🧠 i = 0; i < Math.min(fallback_chain.length, max_attempts); i++) {
        🧠 current_provider = fallback_chain[i]
        🧠 provider_impl = this._registry.get_provider(current_provider)
        🧠 provider = this.get_provider(current_provider)
        
        if (!provider) {
          continue
        }
        
        try {
          🧠 response = provider_impl.generate(provider, prompt, options)
          if (response && !response.error) {
            📤 response
          }
        } catch (error) {
          // Continue to next provider on error
          continue
        }
      }
      
      // If we get here, all providers failed
      📤 { error: "All providers failed to generate a response" }
    },
    
    // Get available provider names
    get_available_providers: 🔍() {
      📤 this._registry.get_provider_names()
    },
    
    // Validate credentials for a provider
    validate_credentials: 🔍(provider_name) {
      if (!provider_name) {
        provider_name = this._default_provider
      }
      
      🧠 provider_impl = this._registry.get_provider(provider_name)
      🧠 provider = this.get_provider(provider_name)
      
      if (!provider_impl || !provider) {
        📤 false
      }
      
      📤 provider_impl.validate_credentials(provider)
    }
  }
  
  📤 manager
}

// Export the LLM manager creator function
📤 {
  create_llm_manager: create_llm_manager
}
