# LLM Integration Documentation

## Overview

The LLM Integration system provides a flexible, modular approach to connecting the anarchy-agent with various Large Language Model providers. This system allows you to use different LLM providers interchangeably, configure API keys securely, and handle offline scenarios gracefully.

## Supported Providers

The current implementation supports the following LLM providers:

1. **OpenAI** - Access to GPT models through the OpenAI API
2. **Azure OpenAI** - Access to GPT models through the Azure OpenAI service
3. **Anthropic Claude** - Access to Claude models through the Anthropic API
4. **Local Models** - Support for local models through Ollama (e.g., Llama, Mistral)

## Directory Structure

```
src/llm/
├── config_manager.a.i         # Configuration management
├── llm_manager.a.i            # Central LLM management
├── provider_registry.a.i      # Registry of available providers
├── integration/
│   └── llm_integration.a.i    # Integration with anarchy-agent
├── providers/
│   ├── provider_interface.a.i # Common interface for all providers
│   ├── openai_provider.a.i    # OpenAI implementation
│   ├── azure_provider.a.i     # Azure OpenAI implementation
│   ├── claude_provider.a.i    # Anthropic Claude implementation
│   └── local_provider.a.i     # Local model implementation
└── utils/
    ├── api_key_manager.a.i    # Secure API key management
    ├── fallback_manager.a.i   # Offline fallback mechanisms
    └── http_utils.a.i         # HTTP request utilities
```

## Configuration

### Setting Up API Keys

To use the LLM integration system, you need to configure API keys for your preferred providers. The system will look for a configuration file at `/home/user/.anarchy-agent/llm_config.json`. If this file doesn't exist, a default configuration will be created.

You can set API keys using the API Key Manager:

```javascript
// Initialize the API key manager
🧠 key_manager = api_key_manager.create_api_key_manager().initialize()

// Set API key for OpenAI
key_manager.set_api_key("openai", "your-openai-api-key")

// Set API key for Azure OpenAI
key_manager.set_api_key("azure_openai", "your-azure-api-key")

// Set API key for Claude
key_manager.set_api_key("claude", "your-claude-api-key")
```

### Provider Configuration

In addition to API keys, you can configure provider-specific settings:

```javascript
// Configure OpenAI
key_manager.set_provider_config("openai", {
  model: "gpt-4",
  temperature: 0.7,
  max_tokens: 2000
})

// Configure Azure OpenAI
key_manager.set_provider_config("azure_openai", {
  endpoint: "https://your-resource-name.openai.azure.com",
  deployment_name: "your-deployment-name",
  api_version: "2023-05-15"
})

// Configure local model
key_manager.set_provider_config("local", {
  endpoint: "http://localhost:11434",
  model: "llama3"
})
```

### Setting Default Provider and Fallback Chain

You can specify which provider to use by default and define a fallback chain for when a provider is unavailable:

```javascript
// Set default provider
key_manager.set_default_provider("openai")

// Set fallback chain
key_manager.set_fallback_chain(["openai", "local", "claude", "azure_openai"])
```

## Basic Usage

### Initializing the LLM Integration

```javascript
// Import the LLM integration
🧠 llm_integration = require("./src/llm/integration/llm_integration.a.i")

// Initialize the integration
🧠 integration = llm_integration.create_llm_integration().initialize()
```

### Generating Responses

```javascript
// Generate a response using the default provider
🧠 response = integration.generate("What is the capital of France?")

// Generate a response using a specific provider
🧠 response = integration.generate("What is the capital of France?", { provider: "claude" })

// Generate code
🧠 code = integration.generate_code("Write a function to calculate fibonacci numbers")
```

### Using the Fallback Manager

The fallback manager ensures your application continues to work even when LLM APIs are unavailable:

```javascript
// Import the fallback manager
🧠 fallback_manager = require("./src/llm/utils/fallback_manager.a.i")

// Initialize the fallback manager
🧠 manager = fallback_manager.create_fallback_manager().initialize()

// Generate a response with fallback to offline mode if needed
🧠 response = manager.generate_with_fallback("What is the capital of France?")

// Check if we're in offline mode
🧠 offline = manager.is_offline()
```

## Advanced Usage

### Streaming Responses

Some providers support streaming responses, which can be used for real-time output:

```javascript
// Stream a response
integration.generate_stream("Tell me a story", function(chunk) {
  // Process each chunk of the response as it arrives
  console.log(chunk)
})
```

### Adding Custom Providers

The system is designed to be extensible. To add a new provider:

1. Create a new provider implementation in `src/llm/providers/`
2. Implement the provider interface
3. Register the provider in the provider registry

Example of a custom provider:

```javascript
// custom_provider.a.i
🧠 provider_interface = require("./provider_interface.a.i")

🔠 create_custom_provider() {
  // Get the base provider interface
  🧠 base = provider_interface.create_provider_interface()
  
  // Implement the required methods
  🧠 custom_provider = {
    name: "custom",
    description: "Custom LLM provider",
    // ... implement other methods
  }
  
  // Merge with base interface
  for (🧠 key in base) {
    if (!custom_provider[key]) {
      custom_provider[key] = base[key]
    }
  }
  
  📤 custom_provider
}

📤 {
  create_custom_provider: create_custom_provider
}
```

## Testing

A comprehensive test suite is included to verify the functionality of the LLM integration system:

```javascript
// Run the tests
🧠 tests = require("./tests/test_llm_integration.a.i")
tests.run_tests()
```

## Troubleshooting

### API Key Issues

If you encounter issues with API keys:

1. Verify that your API keys are correct
2. Check that the provider configuration is correct (endpoint, model, etc.)
3. Ensure you have sufficient quota/credits with your provider

### Offline Mode

If the system is operating in offline mode:

1. Check your internet connection
2. Verify that at least one provider is configured correctly
3. For local models, ensure Ollama is running (`http://localhost:11434`)

### Performance Considerations

- Different providers have different performance characteristics and pricing
- Local models are free but may have lower quality or performance
- Consider using the fallback chain to balance quality and cost
