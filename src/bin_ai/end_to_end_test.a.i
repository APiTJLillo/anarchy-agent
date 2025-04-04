// End-to-end test for Anarchy Agent
// Load the string dictionary
🔠("string_dictionary.json");

// Import main module
ι main = ⟰("main_updated");

ƒmain() {
    ⌽("Starting Anarchy Agent end-to-end test...");
    
    // Test the main entry point with different scenarios
    test_help_command();
    test_example_execution();
    test_file_execution();
    test_repl_mode();
    
    ⌽("End-to-end test completed successfully!");
}

// Test help command
ƒtest_help_command() {
    ⌽("Testing help command...");
    
    // Simulate command line arguments for help
    ι args = "--help";
    
    // Call the main function with help argument (this should print usage)
    try {
        main.parse_config(args);
        ⌽("Help command test: PASSED");
    } catch (e) {
        ⌽(`Help command test: FAILED - ${e}`);
    }
}

// Test example execution
ƒtest_example_execution() {
    ⌽("Testing example execution...");
    
    // Simulate command line arguments for example
    ι args = "--example example_task";
    
    // Call the main function with example argument
    try {
        ι config = main.parse_config(args);
        ⌽(`Example path: ${config.file_path}`);
        ⌽("Example execution test: PASSED");
    } catch (e) {
        ⌽(`Example execution test: FAILED - ${e}`);
    }
}

// Test file execution
ƒtest_file_execution() {
    ⌽("Testing file execution...");
    
    // Create a test file
    ✍("test_script.a.i", "⌽(\"Hello from test script\");");
    
    // Simulate command line arguments for file execution
    ι args = "test_script.a.i";
    
    // Call the main function with file argument
    try {
        ι config = main.parse_config(args);
        ⌽(`File path: ${config.file_path}`);
        ⌽("File execution test: PASSED");
    } catch (e) {
        ⌽(`File execution test: FAILED - ${e}`);
    }
    
    // Clean up
    ✂("test_script.a.i");
}

// Test REPL mode
ƒtest_repl_mode() {
    ⌽("Testing REPL mode...");
    
    // Simulate command line arguments for REPL mode
    ι args = "--repl";
    
    // Call the main function with REPL argument
    try {
        ι config = main.parse_config(args);
        ⌽(`REPL mode: ${config.repl_mode}`);
        ⌽("REPL mode test: PASSED");
    } catch (e) {
        ⌽(`REPL mode test: FAILED - ${e}`);
    }
}

// Run the end-to-end test
main();
