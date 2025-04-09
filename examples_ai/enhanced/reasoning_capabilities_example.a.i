// reasoning_capabilities_example.a.i - Example demonstrating the enhanced reasoning capabilities
// Shows how to use chain-of-thought reasoning, planning system, and self-correction

// Import required modules
ιChainOfThought = require("../src/reasoning/chain_of_thought");
ιPlanningSystem = require("../src/reasoning/planning_system");
ιSelfCorrection = require("../src/reasoning/self_correction");
ιReasoningIntegration = require("../src/reasoning/reasoning_integration");
ιLLMIntegration = require("../src/llm/llm_integration");

// Define string dictionary entries
📝("example_init", "Initializing reasoning capabilities example...");
📝("example_task", "Processing task: {}");
📝("example_reasoning", "Chain of thought reasoning: {}");
📝("example_plan", "Generated plan: {}");
📝("example_correction", "Self-correction: {}");
📝("example_complete", "Example completed successfully!");

// Main example function
ƒrun_example() {
    ⌽(:example_init);
    
    // Initialize LLM integration
    ιllm = LLMIntegration();
    llm.initialize({
        model: "local/large-model",
        context_size: 8192
    });
    
    // Initialize reasoning components
    ιchain_of_thought = ChainOfThought();
    chain_of_thought.initialize({
        llm_integration: llm,
        reasoning_depth: "detailed"
    });
    
    ιplanning_system = PlanningSystem();
    planning_system.initialize({
        llm_integration: llm,
        max_steps: 10
    });
    
    ιself_correction = SelfCorrection();
    self_correction.initialize({
        llm_integration: llm,
        max_correction_attempts: 3
    });
    
    // Initialize reasoning integration
    ιreasoning = ReasoningIntegration();
    reasoning.initialize({
        llm_integration: llm,
        chain_of_thought: chain_of_thought,
        planning_system: planning_system,
        self_correction: self_correction
    });
    
    // Example 1: Chain of thought reasoning for a complex problem
    ⌽(:example_task, "Solve a complex algorithmic problem");
    
    ιproblem_description = 
        "Design an algorithm to find the longest increasing subsequence in an array of integers. " +
        "Analyze its time and space complexity, and implement it in Anarchy Inference.";
    
    ιreasoning_result = chain_of_thought.reason({
        task: problem_description,
        output_format: "detailed"
    });
    
    ⌽(:example_reasoning, reasoning_result.reasoning.substring(0, 150) + "...");
    ⌽(`Solution: ${reasoning_result.solution.substring(0, 100)}...`);
    ⌽(`Confidence: ${reasoning_result.confidence}`);
    
    // Example 2: Planning system for a multi-step task
    ⌽(:example_task, "Create a web scraper with multiple components");
    
    ιtask_description = 
        "Create a web scraper in Anarchy Inference that extracts product information from an e-commerce site, " +
        "processes the data, and stores it in a structured format. The scraper should handle pagination, " +
        "error recovery, and respect the site's robots.txt.";
    
    ιplan = planning_system.create_plan({
        task: task_description,
        include_subtasks: true
    });
    
    ⌽(:example_plan, `Plan with ${plan.steps.length} steps`);
    ∀(plan.steps, λstep, ιindex {
        ⌽(`Step ${index + 1}: ${step.description.substring(0, 100)}...`);
    });
    
    // Execute first step of the plan
    ιstep_execution = planning_system.execute_step({
        plan_id: plan.id,
        step_index: 0
    });
    
    ⌽(`Step execution result: ${step_execution.result.substring(0, 100)}...`);
    ⌽(`Step status: ${step_execution.status}`);
    
    // Example 3: Self-correction for code with errors
    ⌽(:example_task, "Fix code with logical errors");
    
    ιerroneous_code = 
        "// Function to find the maximum value in an array\n" +
        "ƒfind_maximum(αarray) {\n" +
        "    ιmax_value = 0;\n" +
        "    \n" +
        "    ∀(array, λvalue {\n" +
        "        if (value > max_value) {\n" +
        "            max_value = value;\n" +
        "        }\n" +
        "    });\n" +
        "    \n" +
        "    ⟼(max_value);\n" +
        "}";
    
    ιcorrection_result = self_correction.correct_code({
        code: erroneous_code,
        language: "anarchy_inference",
        description: "Function to find the maximum value in an array",
        test_cases: [
            { input: "[1, 2, 3, 4, 5]", expected_output: "5" },
            { input: "[-10, -5, -2, -1]", expected_output: "-1" },
            { input: "[0]", expected_output: "0" }
        ]
    });
    
    ⌽(:example_correction, correction_result.explanation.substring(0, 150) + "...");
    ⌽(`Corrected code: ${correction_result.corrected_code.substring(0, 100)}...`);
    ⌽(`Correction successful: ${correction_result.success}`);
    
    // Example 4: Integrated reasoning for a complete task
    ⌽(:example_task, "Complete task requiring multiple reasoning capabilities");
    
    ιcomplex_task = 
        "Develop a memory-efficient algorithm for finding all prime numbers up to n using the Sieve of Eratosthenes. " +
        "Implement it in Anarchy Inference, optimize it for large values of n, and create a visualization function " +
        "that displays the distribution of primes.";
    
    ιintegrated_result = reasoning.process_task({
        task: complex_task,
        use_planning: true,
        use_chain_of_thought: true,
        use_self_correction: true
    });
    
    ⌽(`Integrated reasoning result: ${integrated_result.summary.substring(0, 150)}...`);
    ⌽(`Generated code size: ${integrated_result.code.length} characters`);
    ⌽(`Reasoning steps: ${integrated_result.reasoning_steps.length}`);
    ⌽(`Final confidence: ${integrated_result.confidence}`);
    
    // Get reasoning statistics
    ιstats = reasoning.get_stats();
    ⌽(`Reasoning statistics: ${JSON.stringify(stats, null, 2)}`);
    
    ⌽(:example_complete);
}

// Run the example
run_example();
