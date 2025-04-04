// Integration test for Anarchy Agent
// Load the string dictionary
🔠("string_dictionary.json");

// Import all modules
ι core = ⟰("core");
ι planner = ⟰("planner");
ι executor = ⟰("executor");
ι memory = ⟰("memory");
ι browser = ⟰("browser");
ι system = ⟰("system");

ƒmain() {
    ⌽("Starting Anarchy Agent integration test...");
    
    // Test a complete workflow
    test_complete_workflow();
    
    ⌽("Integration test completed successfully!");
}

// Test a complete workflow
ƒtest_complete_workflow() {
    ⌽("Testing complete workflow...");
    
    // 1. Initialize all components
    initialize_components();
    
    // 2. Create a test task
    ι test_task = "List files in the current directory and write them to a file";
    ⌽(`Running task: ${test_task}`);
    
    // 3. Generate a plan using the planner
    ι plan = planner().generate_plan(test_task);
    ⌽("Plan generated:");
    ⌽(plan);
    
    // 4. Execute the plan
    ι result = executor().execute_code(plan);
    ⌽("Execution result:");
    ⌽(result);
    
    // 5. Store the result in memory
    memory().store_result(test_task, plan, result);
    
    // 6. Retrieve the context for a similar task
    ι context = memory().retrieve_context("List directory contents");
    ⌽("Retrieved context:");
    ⌽(context);
    
    // 7. Shutdown all components
    shutdown_components();
    
    ⌽("Complete workflow test finished");
}

// Initialize all components
ƒinitialize_components() {
    ⌽("Initializing all components...");
    
    system().initialize();
    memory().initialize();
    browser().initialize();
    executor().initialize();
    planner().initialize();
    core().initialize();
    
    ⌽("All components initialized");
}

// Shutdown all components
ƒshutdown_components() {
    ⌽("Shutting down all components...");
    
    core().shutdown();
    planner().shutdown();
    executor().shutdown();
    browser().shutdown();
    memory().shutdown();
    system().shutdown();
    
    ⌽("All components shut down");
}

// Run the integration test
main();
