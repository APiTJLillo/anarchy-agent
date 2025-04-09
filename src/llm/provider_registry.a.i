// provider_registry.a.i
// Registry for LLM providers

// Import provider implementations
🧠 openai_provider = require("./providers/openai_provider.a.i")
🧠 azure_provider = require("./providers/azure_provider.a.i")
🧠 claude_provider = require("./providers/claude_provider.a.i")
🧠 local_provider = require("./providers/local_provider.a.i")

🔠 create_provider_registry() {
  // Create a registry to manage all available providers
  🧠 registry = {
    // Internal storage for registered providers
    _providers: {},
    
    // Initialize the registry with default providers
    initialize: 🔍() {
      // Register the default providers
      this.register_provider(openai_provider.create_openai_provider())
      this.register_provider(azure_provider.create_azure_provider())
      this.register_provider(claude_provider.create_claude_provider())
      this.register_provider(local_provider.create_local_provider())
      
      📤 this
    },
    
    // Register a new provider
    register_provider: 🔍(provider) {
      if (!provider || !provider.name) {
        📤 false
      }
      
      this._providers[provider.name] = provider
      📤 true
    },
    
    // Get a provider by name
    get_provider: 🔍(name) {
      if (!name || !this._providers[name]) {
        📤 null
      }
      
      📤 this._providers[name]
    },
    
    // Get all registered providers
    get_all_providers: 🔍() {
      🧠 providers = []
      for (🧠 name in this._providers) {
        providers.push(this._providers[name])
      }
      
      📤 providers
    },
    
    // Get provider names
    get_provider_names: 🔍() {
      📤 Object.keys(this._providers)
    },
    
    // Check if a provider is registered
    has_provider: 🔍(name) {
      📤 !!this._providers[name]
    }
  }
  
  📤 registry
}

// Export the provider registry creator function
📤 {
  create_provider_registry: create_provider_registry
}
