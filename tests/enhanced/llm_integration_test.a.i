// llm_integration_test.a.i - Test suite for the enhanced LLM integration
// Tests advanced prompt engineering, context management, and model selection

// Import required modules
ιLLMIntegration = require("../../src/llm/llm_integration");
ιModelSelector = require("../../src/llm/model_selector");
ιLLMContextManager = require("../../src/llm/llm_context_manager");

// Define string dictionary entries
📝("test_init", "Initializing LLM integration tests...");
📝("test_run", "Running test: {}");
📝("test_pass", "✅ Test passed: {}");
📝("test_fail", "❌ Test failed: {} - {}");
📝("test_complete", "Tests completed: {} passed, {} failed");

// Test suite for LLM integration
λLLMIntegrationTest {
    // Initialize test suite
    ƒinitialize() {
        ⌽(:test_init);
        
        // Initialize test counters
        ιthis.tests_run = 0;
        ιthis.tests_passed = 0;
        ιthis.tests_failed = 0;
        
        // Initialize components for testing
        this._initialize_components();
        
        ⟼(⊤);
    }
    
    // Run all tests
    ƒrun_tests() {
        // Model selector tests
        this.test_model_selector_initialization();
        this.test_model_selector_selection();
        
        // Context manager tests
        this.test_context_manager_add_messages();
        this.test_context_manager_compression();
        this.test_context_manager_formatting();
        
        // LLM integration tests
        this.test_llm_generate_response();
        this.test_llm_generate_code();
        this.test_llm_correct_code();
        
        // Report results
        ⌽(:test_complete, this.tests_passed, this.tests_failed);
        
        ⟼(this.tests_failed === 0);
    }
    
    // Test model selector initialization
    ƒtest_model_selector_initialization() {
        ⌽(:test_run, "model_selector_initialization");
        this.tests_run++;
        
        ÷{
            // Verify model selector was initialized
            if (!this.model_selector) {
                ⌽(:test_fail, "model_selector_initialization", "Model selector not initialized");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify available models
            ιavailable_models = this.model_selector.get_available_models();
            
            if (!available_models || available_models.length !== 3) {
                ⌽(:test_fail, "model_selector_initialization", "Available models not set correctly");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify default model
            ιdefault_model = this.model_selector.get_default_model();
            
            if (!default_model || default_model.name !== "local/medium-model") {
                ⌽(:test_fail, "model_selector_initialization", "Default model not set correctly");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "model_selector_initialization");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "model_selector_initialization", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test model selector selection
    ƒtest_model_selector_selection() {
        ⌽(:test_run, "model_selector_selection");
        this.tests_run++;
        
        ÷{
            // Test selection for simple task
            ιsimple_model = this.model_selector.select_model({
                task_type: "general",
                complexity: "low"
            });
            
            if (!simple_model || simple_model.name !== "local/small-model") {
                ⌽(:test_fail, "model_selector_selection", "Simple task model selection failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Test selection for complex task
            ιcomplex_model = this.model_selector.select_model({
                task_type: "reasoning",
                complexity: "high"
            });
            
            if (!complex_model || complex_model.name !== "local/large-model") {
                ⌽(:test_fail, "model_selector_selection", "Complex task model selection failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Test selection with specific capability
            ιcode_model = this.model_selector.select_model({
                task_type: "code",
                required_capabilities: ["code"]
            });
            
            if (!code_model || !code_model.capabilities.includes("code")) {
                ⌽(:test_fail, "model_selector_selection", "Capability-based model selection failed");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "model_selector_selection");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "model_selector_selection", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test context manager add messages
    ƒtest_context_manager_add_messages() {
        ⌽(:test_run, "context_manager_add_messages");
        this.tests_run++;
        
        ÷{
            // Clear context
            this.context_manager.clear();
            
            // Add system message
            this.context_manager.add_system_message("You are a helpful assistant.");
            
            // Add user message
            this.context_manager.add_user_message("Hello, can you help me?");
            
            // Add assistant message
            this.context_manager.add_assistant_message("I'd be happy to help! What do you need?");
            
            // Get context
            ιcontext = this.context_manager.get_context();
            
            // Verify messages were added
            if (!context || context.length !== 3) {
                ⌽(:test_fail, "context_manager_add_messages", "Messages not added correctly");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify message types
            if (context[0].role !== "system" || 
                context[1].role !== "user" || 
                context[2].role !== "assistant") {
                ⌽(:test_fail, "context_manager_add_messages", "Message roles not set correctly");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify message content
            if (!context[0].content.includes("helpful assistant") || 
                !context[1].content.includes("can you help me") || 
                !context[2].content.includes("happy to help")) {
                ⌽(:test_fail, "context_manager_add_messages", "Message content not set correctly");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "context_manager_add_messages");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "context_manager_add_messages", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test context manager compression
    ƒtest_context_manager_compression() {
        ⌽(:test_run, "context_manager_compression");
        this.tests_run++;
        
        ÷{
            // Clear context
            this.context_manager.clear();
            
            // Add system message
            this.context_manager.add_system_message("You are a helpful assistant.");
            
            // Add many messages to trigger compression
            for (ιi = 0; i < 20; i++) {
                this.context_manager.add_user_message(`This is test message ${i} with some content to take up space.`);
                this.context_manager.add_assistant_message(`This is a response to message ${i} with additional content.`);
            }
            
            // Get context size
            ιsize_before = this.context_manager.get_current_size();
            
            // Compress context
            this.context_manager.compress();
            
            // Get compressed size
            ιsize_after = this.context_manager.get_current_size();
            
            // Verify compression occurred
            if (size_after >= size_before) {
                ⌽(:test_fail, "context_manager_compression", "Compression did not reduce context size");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify compression flag
            if (!this.context_manager.is_compressed()) {
                ⌽(:test_fail, "context_manager_compression", "Compression flag not set");
                this.tests_failed++;
                ⟼();
            }
            
            // Get summary
            ιsummary = this.context_manager.get_summary();
            
            // Verify summary exists
            if (!summary || summary.length === 0) {
                ⌽(:test_fail, "context_manager_compression", "Summary not generated");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "context_manager_compression");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "context_manager_compression", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test context manager formatting
    ƒtest_context_manager_formatting() {
        ⌽(:test_run, "context_manager_formatting");
        this.tests_run++;
        
        ÷{
            // Clear context
            this.context_manager.clear();
            
            // Add messages
            this.context_manager.add_system_message("You are a helpful assistant.");
            this.context_manager.add_user_message("Can you help me with code?");
            this.context_manager.add_assistant_message("Sure, what kind of code do you need?");
            
            // Get formatted context for different purposes
            ιgeneral_format = this.context_manager.format_for_task("general");
            ιcode_format = this.context_manager.format_for_task("code");
            ιreasoning_format = this.context_manager.format_for_task("reasoning");
            
            // Verify formats exist
            if (!general_format || !code_format || !reasoning_format) {
                ⌽(:test_fail, "context_manager_formatting", "Formatted contexts not generated");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify code format includes code-specific instructions
            if (!code_format.includes("code") && !code_format.includes("programming")) {
                ⌽(:test_fail, "context_manager_formatting", "Code format missing code-specific instructions");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify reasoning format includes reasoning-specific instructions
            if (!reasoning_format.includes("reason") && !reasoning_format.includes("step by step")) {
                ⌽(:test_fail, "context_manager_formatting", "Reasoning format missing reasoning-specific instructions");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "context_manager_formatting");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "context_manager_formatting", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test LLM generate response
    ƒtest_llm_generate_response() {
        ⌽(:test_run, "llm_generate_response");
        this.tests_run++;
        
        ÷{
            // Mock response generation since we can't actually call LLMs in tests
            ιoriginal_generate = this.llm._generate;
            this.llm._generate = (prompt, options) => {
                return `This is a mock response to: ${prompt.substring(0, 20)}...`;
            };
            
            // Clear context
            this.context_manager.clear();
            this.context_manager.add_system_message("You are a helpful assistant.");
            this.context_manager.add_user_message("What is artificial intelligence?");
            
            // Generate response
            ιresponse = this.llm.generate_response({
                temperature: 0.7
            });
            
            // Restore original function
            this.llm._generate = original_generate;
            
            // Verify response
            if (!response || response.length === 0) {
                ⌽(:test_fail, "llm_generate_response", "No response generated");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify response contains mock text
            if (!response.includes("mock response")) {
                ⌽(:test_fail, "llm_generate_response", "Response does not match expected format");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "llm_generate_response");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "llm_generate_response", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test LLM generate code
    ƒtest_llm_generate_code() {
        ⌽(:test_run, "llm_generate_code");
        this.tests_run++;
        
        ÷{
            // Mock code generation
            ιoriginal_generate = this.llm._generate;
            this.llm._generate = (prompt, options) => {
                if (prompt.includes("fibonacci")) {
                    return "ƒfibonacci(ιn) {\n  if (n <= 1) ⟼(n);\n  ⟼(fibonacci(n-1) + fibonacci(n-2));\n}";
                }
                return "// Mock code";
            };
            
            // Clear context
            this.context_manager.clear();
            this.context_manager.add_system_message("You are a coding assistant.");
            this.context_manager.add_user_message("Write a function to calculate fibonacci numbers.");
            
            // Generate code
            ιcode = this.llm.generate_code({
                task_description: "Calculate fibonacci numbers",
                code_type: "function",
                include_comments: true
            });
            
            // Restore original function
            this.llm._generate = original_generate;
            
            // Verify code
            if (!code || code.length === 0) {
                ⌽(:test_fail, "llm_generate_code", "No code generated");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify code contains fibonacci function
            if (!code.includes("fibonacci") && !code.includes("Mock code")) {
                ⌽(:test_fail, "llm_generate_code", "Code does not match expected format");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "llm_generate_code");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "llm_generate_code", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test LLM correct code
    ƒtest_llm_correct_code() {
        ⌽(:test_run, "llm_correct_code");
        this.tests_run++;
        
        ÷{
            // Mock code correction
            ιoriginal_generate = this.llm._generate;
            this.llm._generate = (prompt, options) => {
                if (prompt.includes("f fibonacci")) {
                    return "ƒfibonacci(ιn) {\n  if (n <= 1) ⟼(n);\n  ⟼(fibonacci(n-1) + fibonacci(n-2));\n}";
                }
                return "// Mock corrected code";
            };
            
            // Erroneous code
            ιerroneous_code = "f fibonacci(n) {\n  if (n <= 1) return n;\n  return fibonacci(n-1) + fibonacci(n-2);\n}";
            
            // Correct code
            ιcorrected = this.llm.correct_code({
                code: erroneous_code,
                language: "anarchy_inference",
                explain_corrections: true
            });
            
            // Restore original function
            this.llm._generate = original_generate;
            
            // Verify correction
            if (!corrected || !corrected.corrected_code || corrected.corrected_code.length === 0) {
                ⌽(:test_fail, "llm_correct_code", "No corrected code generated");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify corrected code contains proper function definition
            if (!corrected.corrected_code.includes("ƒfibonacci") && 
                !corrected.corrected_code.includes("Mock corrected")) {
                ⌽(:test_fail, "llm_correct_code", "Corrected code does not match expected format");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "llm_correct_code");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "llm_correct_code", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Private: Initialize components for testing
    ƒ_initialize_components() {
        // Initialize model selector
        this.model_selector = ModelSelector();
        this.model_selector.initialize({
            available_models: [
                {
                    name: "local/small-model",
                    context_size: 2048,
                    capabilities: ["general", "code"],
                    performance: 0.7,
                    speed: 0.9
                },
                {
                    name: "local/medium-model",
                    context_size: 4096,
                    capabilities: ["general", "code", "reasoning"],
                    performance: 0.8,
                    speed: 0.7
                },
                {
                    name: "local/large-model",
                    context_size: 8192,
                    capabilities: ["general", "code", "reasoning", "specialized"],
                    performance: 0.95,
                    speed: 0.5
                }
            ],
            default_model: "local/medium-model"
        });
        
        // Initialize context manager
        this.context_manager = LLMContextManager();
        this.context_manager.initialize({
            max_context_size: 4096,
            compression_threshold: 3072
        });
        
        // Initialize LLM integration with mock generation
        this.llm = LLMIntegration();
        this.llm.initialize({
            model_selector: this.model_selector,
            context_manager: this.context_manager
        });
        
        // Mock the actual LLM generation
        this.llm._generate = (prompt, options) => {
            return `Mock response for: ${prompt.substring(0, 30)}...`;
        };
    }
}

// Create and run test suite
ιtest_suite = LLMIntegrationTest();
test_suite.initialize();
test_suite.run_tests();
