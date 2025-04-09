// fallback_manager.a.i
// Fallback mechanisms for offline use when LLM APIs are unavailable

// Import dependencies
🧠 llm_manager = require("../llm_manager.a.i")

🔠 create_fallback_manager() {
  // Create a new fallback manager
  📤 {
    // Internal storage
    _llm_manager: null,
    _offline_responses: {},
    
    // Initialize the fallback manager
    initialize: 🔍(config_path) {
      // Initialize the LLM manager
      this._llm_manager = llm_manager.create_llm_manager().initialize(config_path)
      
      // Initialize offline responses database
      this._initialize_offline_responses()
      
      📤 this
    },
    
    // Initialize offline responses database
    _initialize_offline_responses: 🔍() {
      // These are pre-defined responses for common operations when offline
      this._offline_responses = {
        // General responses
        "greeting": "Hello! I'm running in offline mode. My capabilities are limited, but I'll do my best to assist you.",
        "help": "I'm currently running in offline mode. I can perform basic tasks and provide simple responses, but complex operations requiring LLM APIs are unavailable.",
        "error": "I apologize, but I'm currently running in offline mode and cannot process this request. Please check your internet connection or try again later.",
        
        // Code generation responses
        "code_generation": "I'm currently in offline mode and cannot generate custom code. Here's a template that might help you get started:\n\n```\n// Basic structure\nfunction main() {\n  // Your code here\n  console.log('Hello, World!');\n}\n\nmain();\n```",
        
        // Memory operations
        "memory_store": "Memory item stored successfully (offline mode).",
        "memory_retrieve": "I'm in offline mode and cannot retrieve specific memories, but I can access basic information.",
        
        // Planning responses
        "planning": "I'm in offline mode and cannot create detailed plans. Consider breaking your task into smaller steps and tackling them one at a time."
      }
    },
    
    // Generate a response with fallback to offline mode
    generate_with_fallback: 🔍(prompt, options) {
      // Try to use the LLM manager first
      try {
        // Check if local provider is available
        if (this._llm_manager.validate_credentials("local")) {
          // Use local provider if available
          return this._llm_manager.generate_response(prompt, { ...options, provider: "local" })
        }
        
        // Try with the specified or default provider
        🧠 provider_name = options?.provider || this._llm_manager.get_default_provider()
        if (this._llm_manager.validate_credentials(provider_name)) {
          return this._llm_manager.generate_response(prompt, options)
        }
        
        // If we get here, try the fallback chain
        🧠 response = this._llm_manager.try_with_fallback(prompt, options)
        if (response && !response.error) {
          return response
        }
        
        // If all providers fail, fall back to offline mode
        return this._get_offline_response(prompt)
      } catch (error) {
        // If any error occurs, fall back to offline mode
        return this._get_offline_response(prompt)
      }
    },
    
    // Get an appropriate offline response based on the prompt
    _get_offline_response: 🔍(prompt) {
      // Convert prompt to lowercase for matching
      🧠 lower_prompt = prompt.toLowerCase()
      
      // Check for greeting patterns
      if (lower_prompt.includes("hello") || lower_prompt.includes("hi ") || lower_prompt.includes("hey")) {
        return this._offline_responses.greeting
      }
      
      // Check for help requests
      if (lower_prompt.includes("help") || lower_prompt.includes("assist") || lower_prompt.includes("support")) {
        return this._offline_responses.help
      }
      
      // Check for code generation requests
      if (lower_prompt.includes("code") || lower_prompt.includes("program") || lower_prompt.includes("function") || 
          lower_prompt.includes("script") || lower_prompt.includes("implement")) {
        return this._offline_responses.code_generation
      }
      
      // Check for memory operations
      if (lower_prompt.includes("remember") || lower_prompt.includes("store") || lower_prompt.includes("save")) {
        return this._offline_responses.memory_store
      }
      if (lower_prompt.includes("recall") || lower_prompt.includes("retrieve") || lower_prompt.includes("get")) {
        return this._offline_responses.memory_retrieve
      }
      
      // Check for planning requests
      if (lower_prompt.includes("plan") || lower_prompt.includes("steps") || lower_prompt.includes("how to")) {
        return this._offline_responses.planning
      }
      
      // Default error response
      return this._offline_responses.error
    },
    
    // Check if we're in offline mode (all providers unavailable)
    is_offline: 🔍() {
      // Check if local provider is available
      if (this._llm_manager.validate_credentials("local")) {
        return false
      }
      
      // Get all available providers
      🧠 providers = this._llm_manager.get_available_providers()
      
      // Check if any provider is available
      for (🧠 i = 0; i < providers.length; i++) {
        if (this._llm_manager.validate_credentials(providers[i])) {
          return false
        }
      }
      
      // If no providers are available, we're in offline mode
      return true
    },
    
    // Add a custom offline response
    add_offline_response: 🔍(key, response) {
      if (!key || !response) {
        return false
      }
      
      this._offline_responses[key] = response
      return true
    },
    
    // Get a specific offline response by key
    get_offline_response: 🔍(key) {
      if (!key || !this._offline_responses[key]) {
        return this._offline_responses.error
      }
      
      return this._offline_responses[key]
    }
  }
}

// Export the fallback manager creator function
📤 {
  create_fallback_manager: create_fallback_manager
}
