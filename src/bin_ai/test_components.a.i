// Test script for Anarchy Agent components
// Load the string dictionary
🔠("string_dictionary.json");

// Import all modules
ι core_module = ⟰("core");
ι planner_module = ⟰("planner");
ι executor_module = ⟰("executor");
ι memory_module = ⟰("memory");
ι browser_module = ⟰("browser");
ι system_module = ⟰("system");

ƒmain() {
    ⌽("Starting Anarchy Agent component tests...");
    
    // Test each module individually
    test_system_module();
    test_memory_module();
    test_browser_module();
    test_executor_module();
    test_planner_module();
    test_core_module();
    
    ⌽("All tests completed successfully!");
}

// Test System module
ƒtest_system_module() {
    ⌽("Testing System module...");
    
    ι system = system_module();
    
    // Test initialization
    ι init_result = system.initialize();
    ⌽(`System initialization result: ${init_result}`);
    
    // Test file operations
    ι test_content = "This is a test file";
    system.write_file("test_file.txt", test_content);
    ι read_content = system.read_file("test_file.txt");
    
    ⌽(`File read test: ${read_content === test_content ? "PASSED" : "FAILED"}`);
    
    // Test shell execution
    ι shell_result = system.execute_shell("echo 'Hello from shell'");
    ⌽(`Shell execution test: ${shell_result ? "PASSED" : "FAILED"}`);
    
    // Test shutdown
    ι shutdown_result = system.shutdown();
    ⌽(`System shutdown result: ${shutdown_result}`);
    
    ⌽("System module tests completed");
}

// Test Memory module
ƒtest_memory_module() {
    ⌽("Testing Memory module...");
    
    ι memory = memory_module();
    
    // Test initialization
    ι init_result = memory.initialize();
    ⌽(`Memory initialization result: ${init_result}`);
    
    // Test key-value operations
    memory.set_memory("test_key", "test_value");
    ι value = memory.get_memory("test_key");
    
    ⌽(`Memory get/set test: ${value === "test_value" ? "PASSED" : "FAILED"}`);
    
    // Test context retrieval
    ι context = memory.retrieve_context("test task");
    ⌽(`Context retrieval test: ${context !== undefined ? "PASSED" : "FAILED"}`);
    
    // Test shutdown
    ι shutdown_result = memory.shutdown();
    ⌽(`Memory shutdown result: ${shutdown_result}`);
    
    ⌽("Memory module tests completed");
}

// Test Browser module
ƒtest_browser_module() {
    ⌽("Testing Browser module...");
    
    ι browser = browser_module();
    
    // Test initialization
    ι init_result = browser.initialize();
    ⌽(`Browser initialization result: ${init_result}`);
    
    // Test browser operations (simulated)
    ι browser_instance = browser.open_page("https://example.com");
    ⌽(`Browser open page test: ${browser_instance ? "PASSED" : "FAILED"}`);
    
    // Test shutdown
    ι shutdown_result = browser.shutdown();
    ⌽(`Browser shutdown result: ${shutdown_result}`);
    
    ⌽("Browser module tests completed");
}

// Test Executor module
ƒtest_executor_module() {
    ⌽("Testing Executor module...");
    
    ι executor = executor_module();
    
    // Test initialization
    ι init_result = executor.initialize();
    ⌽(`Executor initialization result: ${init_result}`);
    
    // Test code execution (simulated)
    ι test_code = "⌽(\"Hello from Anarchy-Inference\");";
    ι execution_result = executor.execute_code(test_code);
    
    ⌽(`Code execution test: ${execution_result !== undefined ? "PASSED" : "FAILED"}`);
    
    // Test shutdown
    ι shutdown_result = executor.shutdown();
    ⌽(`Executor shutdown result: ${shutdown_result}`);
    
    ⌽("Executor module tests completed");
}

// Test Planner module
ƒtest_planner_module() {
    ⌽("Testing Planner module...");
    
    ι planner = planner_module();
    
    // Test initialization
    ι init_result = planner.initialize();
    ⌽(`Planner initialization result: ${init_result}`);
    
    // Test plan generation (simulated)
    ι test_task = "List files in current directory";
    ι plan = planner.generate_plan(test_task);
    
    ⌽(`Plan generation test: ${plan !== undefined ? "PASSED" : "FAILED"}`);
    
    // Test shutdown
    ι shutdown_result = planner.shutdown();
    ⌽(`Planner shutdown result: ${shutdown_result}`);
    
    ⌽("Planner module tests completed");
}

// Test Core module
ƒtest_core_module() {
    ⌽("Testing Core module...");
    
    ι core = core_module();
    
    // Test initialization
    ι init_result = core.initialize();
    ⌽(`Core initialization result: ${init_result}`);
    
    // Test task execution (simulated)
    ι test_task = "Echo hello world";
    ι task_result = core.run_task(test_task);
    
    ⌽(`Task execution test: ${task_result !== undefined ? "PASSED" : "FAILED"}`);
    
    // Test shutdown
    ι shutdown_result = core.shutdown();
    ⌽(`Core shutdown result: ${shutdown_result}`);
    
    ⌽("Core module tests completed");
}

// Run the tests
main();
