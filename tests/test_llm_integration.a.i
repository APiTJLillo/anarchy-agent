// test_llm_integration.a.i
// Test suite for the LLM integration system

// Import dependencies
🧠 llm_integration = require("../src/llm/integration/llm_integration.a.i")
🧠 api_key_manager = require("../src/llm/utils/api_key_manager.a.i")
🧠 fallback_manager = require("../src/llm/utils/fallback_manager.a.i")

// Main test function
🔠 run_tests() {
  // Print test header
  print_header("LLM INTEGRATION TEST SUITE")
  
  // Run all tests
  test_initialization()
  test_api_key_management()
  test_provider_availability()
  test_response_generation()
  test_fallback_mechanism()
  
  // Print test summary
  print_header("TEST SUMMARY")
  print("✅ All tests completed")
}

// Test initialization
🔠 test_initialization() {
  print_header("Testing Initialization")
  
  try {
    // Initialize the LLM integration
    🧠 integration = llm_integration.create_llm_integration().initialize()
    
    // Check if initialization was successful
    if (integration && integration.manager) {
      print("✅ LLM integration initialized successfully")
    } else {
      print("❌ LLM integration initialization failed")
    }
    
    // Get available providers
    🧠 providers = integration.get_available_providers()
    print("Available providers: " + providers.join(", "))
  } catch (error) {
    print("❌ Error during initialization: " + error)
  }
}

// Test API key management
🔠 test_api_key_management() {
  print_header("Testing API Key Management")
  
  try {
    // Initialize the API key manager
    🧠 key_manager = api_key_manager.create_api_key_manager().initialize()
    
    // Test setting an API key
    🧠 result = key_manager.set_api_key("test_provider", "test_api_key_123")
    if (result) {
      print("✅ API key set successfully")
    } else {
      print("❌ Failed to set API key")
    }
    
    // Test getting an API key
    🧠 api_key = key_manager.get_api_key("test_provider")
    if (api_key === "test_api_key_123") {
      print("✅ API key retrieved successfully")
    } else {
      print("❌ Failed to retrieve API key")
    }
    
    // Test checking if API key exists
    🧠 has_key = key_manager.has_api_key("test_provider")
    if (has_key) {
      print("✅ API key existence check successful")
    } else {
      print("❌ API key existence check failed")
    }
    
    // Test removing an API key
    🧠 remove_result = key_manager.remove_api_key("test_provider")
    if (remove_result) {
      print("✅ API key removed successfully")
    } else {
      print("❌ Failed to remove API key")
    }
  } catch (error) {
    print("❌ Error during API key management test: " + error)
  }
}

// Test provider availability
🔠 test_provider_availability() {
  print_header("Testing Provider Availability")
  
  try {
    // Initialize the LLM integration
    🧠 integration = llm_integration.create_llm_integration().initialize()
    
    // Get available providers
    🧠 providers = integration.get_available_providers()
    
    // Check each provider
    for (🧠 i = 0; i < providers.length; i++) {
      🧠 provider = providers[i]
      🧠 is_valid = integration.validate_credentials(provider)
      
      if (is_valid) {
        print("✅ Provider '" + provider + "' is available")
      } else {
        print("ℹ️ Provider '" + provider + "' is not available (API key may be missing)")
      }
    }
  } catch (error) {
    print("❌ Error during provider availability test: " + error)
  }
}

// Test response generation
🔠 test_response_generation() {
  print_header("Testing Response Generation")
  
  try {
    // Initialize the LLM integration
    🧠 integration = llm_integration.create_llm_integration().initialize()
    
    // Get available providers
    🧠 providers = integration.get_available_providers()
    
    // Find an available provider
    🧠 available_provider = null
    for (🧠 i = 0; i < providers.length; i++) {
      if (integration.validate_credentials(providers[i])) {
        available_provider = providers[i]
        break
      }
    }
    
    if (available_provider) {
      print("✅ Found available provider: " + available_provider)
      
      // Test response generation
      🧠 response = integration.generate("Hello, world!", { provider: available_provider })
      
      if (response && !response.error) {
        print("✅ Response generated successfully")
        print("Response: " + response)
      } else {
        print("❌ Failed to generate response: " + (response.error || "Unknown error"))
      }
    } else {
      print("ℹ️ No available providers found, skipping response generation test")
    }
  } catch (error) {
    print("❌ Error during response generation test: " + error)
  }
}

// Test fallback mechanism
🔠 test_fallback_mechanism() {
  print_header("Testing Fallback Mechanism")
  
  try {
    // Initialize the fallback manager
    🧠 manager = fallback_manager.create_fallback_manager().initialize()
    
    // Check if we're in offline mode
    🧠 offline = manager.is_offline()
    
    if (offline) {
      print("ℹ️ System is in offline mode")
    } else {
      print("ℹ️ System is in online mode")
    }
    
    // Test fallback response generation
    🧠 response = manager.generate_with_fallback("Hello, can you help me?")
    
    if (response) {
      print("✅ Fallback response generated successfully")
      print("Response: " + response)
    } else {
      print("❌ Failed to generate fallback response")
    }
    
    // Test offline responses
    🧠 greeting = manager.get_offline_response("greeting")
    if (greeting) {
      print("✅ Offline greeting response retrieved successfully")
    } else {
      print("❌ Failed to retrieve offline greeting response")
    }
    
    // Test adding custom offline response
    🧠 add_result = manager.add_offline_response("custom_response", "This is a custom offline response")
    if (add_result) {
      print("✅ Custom offline response added successfully")
    } else {
      print("❌ Failed to add custom offline response")
    }
  } catch (error) {
    print("❌ Error during fallback mechanism test: " + error)
  }
}

// Helper function to print a header
🔠 print_header(text) {
  print("\n=== " + text + " ===\n")
}

// Helper function to print a message
🔠 print(message) {
  // In a real implementation, this would use console.log or similar
  // For now, we'll use a placeholder
  console.log(message)
}

// Run the tests
run_tests()

// Export the test functions
📤 {
  run_tests: run_tests
}
