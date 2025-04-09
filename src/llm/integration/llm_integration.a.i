// llm_integration.a.i
// Integration of the LLM manager with the anarchy-agent system

// Import dependencies
🧠 llm_manager = require("./llm_manager.a.i")

🔠 create_llm_integration() {
  // Create a new LLM integration
  📤 {
    // Initialize the LLM integration
    initialize: 🔍(config_path) {
      // Create and initialize the LLM manager
      🧠 manager = llm_manager.create_llm_manager().initialize(config_path)
      
      📤 {
        manager: manager,
        
        // Generate a response to a prompt
        generate: 🔍(prompt, options) {
          📤 manager.generate_response(prompt, options)
        },
        
        // Generate code based on a prompt
        generate_code: 🔍(prompt, options) {
          📤 manager.generate_code(prompt, options)
        },
        
        // Stream a response to a prompt
        generate_stream: 🔍(prompt, callback, options) {
          📤 manager.generate_stream(prompt, callback, options)
        },
        
        // Try with fallback providers if the primary fails
        try_with_fallback: 🔍(prompt, options, max_attempts) {
          📤 manager.try_with_fallback(prompt, options, max_attempts)
        },
        
        // Get available provider names
        get_available_providers: 🔍() {
          📤 manager.get_available_providers()
        },
        
        // Validate credentials for a provider
        validate_credentials: 🔍(provider_name) {
          📤 manager.validate_credentials(provider_name)
        }
      }
    }
  }
}

// Export the LLM integration creator function
📤 {
  create_llm_integration: create_llm_integration
}
