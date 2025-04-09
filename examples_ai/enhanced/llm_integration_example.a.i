// llm_integration_example.a.i - Example demonstrating the enhanced LLM integration
// Shows how to use advanced prompt engineering, context management, and model selection

// Import required modules
ιLLMIntegration = require("../src/llm/llm_integration");
ιModelSelector = require("../src/llm/model_selector");
ιLLMContextManager = require("../src/llm/llm_context_manager");

// Define string dictionary entries
📝("example_init", "Initializing LLM integration example...");
📝("example_prompt", "Sending prompt: {}");
📝("example_response", "Received response: {}");
📝("example_code", "Generated code: {}");
📝("example_complete", "Example completed successfully!");

// Main example function
ƒrun_example() {
    ⌽(:example_init);
    
    // Initialize model selector
    ιmodel_selector = ModelSelector();
    model_selector.initialize({
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
    ιcontext_manager = LLMContextManager();
    context_manager.initialize({
        max_context_size: 4096,
        compression_threshold: 3072
    });
    
    // Initialize LLM integration
    ιllm = LLMIntegration();
    llm.initialize({
        model_selector: model_selector,
        context_manager: context_manager
    });
    
    // Add system message to context
    context_manager.add_system_message(
        "You are an assistant that helps with programming in the Anarchy Inference language. " +
        "Anarchy Inference uses emoji operators and symbolic syntax."
    );
    
    // Add conversation history
    context_manager.add_user_message(
        "I need help with the Anarchy Inference language."
    );
    
    context_manager.add_assistant_message(
        "I'd be happy to help you with the Anarchy Inference language! " +
        "What specific aspect would you like assistance with?"
    );
    
    // Generate a response to a simple query
    ⌽(:example_prompt, "What are the basic emoji operators in Anarchy Inference?");
    
    context_manager.add_user_message(
        "What are the basic emoji operators in Anarchy Inference?"
    );
    
    ιresponse = llm.generate_response({
        task_type: "general",
        temperature: 0.7
    });
    
    context_manager.add_assistant_message(response);
    
    ⌽(:example_response, response.substring(0, 100) + "...");
    
    // Generate code with specialized prompt
    ⌽(:example_prompt, "Write a function to calculate fibonacci numbers");
    
    context_manager.add_user_message(
        "Write a function to calculate fibonacci numbers in Anarchy Inference."
    );
    
    ιcode = llm.generate_code({
        task_description: "Calculate fibonacci numbers",
        code_type: "function",
        include_comments: true,
        temperature: 0.2
    });
    
    context_manager.add_assistant_message(code);
    
    ⌽(:example_code, code.substring(0, 100) + "...");
    
    // Demonstrate model selection for complex reasoning
    ⌽(:example_prompt, "Complex reasoning task about algorithm optimization");
    
    context_manager.add_user_message(
        "I need to optimize my vector embedding algorithm in Anarchy Inference. " +
        "It's currently using a simple dot product for similarity, but I need better performance. " +
        "What approaches would you recommend?"
    );
    
    // This should automatically select a more capable model
    ιreasoning_response = llm.generate_reasoning({
        task_description: "Algorithm optimization for vector embeddings",
        reasoning_depth: "detailed",
        include_code_examples: true
    });
    
    context_manager.add_assistant_message(reasoning_response);
    
    ⌽(:example_response, reasoning_response.substring(0, 100) + "...");
    
    // Demonstrate context compression when approaching limits
    ⌽("Current context size: " + context_manager.get_current_size());
    ⌽("Adding large content to trigger compression...");
    
    // Add a large message to approach context limit
    ιlarge_content = "This is a large message that will help demonstrate context compression. ".repeat(50);
    context_manager.add_user_message(large_content);
    
    ⌽("Context size after addition: " + context_manager.get_current_size());
    ⌽("Compressed: " + context_manager.is_compressed());
    
    // Get context summary
    ιcontext_summary = context_manager.get_summary();
    ⌽("Context summary: " + context_summary.substring(0, 100) + "...");
    
    // Demonstrate error correction for Anarchy Inference code
    ⌽(:example_prompt, "Fix this code with errors");
    
    context_manager.add_user_message(
        "Can you fix the errors in this Anarchy Inference code?\n\n" +
        "f fibonacci(n) {\n" +
        "  if (n <= 1) {\n" +
        "    return n;\n" +
        "  }\n" +
        "  return fibonacci(n - 1) + fibonacci(n - 2);\n" +
        "}"
    );
    
    ιcorrected_code = llm.correct_code({
        code: "f fibonacci(n) {\n" +
              "  if (n <= 1) {\n" +
              "    return n;\n" +
              "  }\n" +
              "  return fibonacci(n - 1) + fibonacci(n - 2);\n" +
              "}",
        language: "anarchy_inference",
        explain_corrections: true
    });
    
    context_manager.add_assistant_message(corrected_code);
    
    ⌽(:example_code, corrected_code.substring(0, 100) + "...");
    
    // Get model selection stats
    ιmodel_stats = model_selector.get_selection_stats();
    ⌽("Model selection statistics: " + JSON.stringify(model_stats, null, 2));
    
    ⌽(:example_complete);
}

// Run the example
run_example();
