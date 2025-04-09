// integration_test.a.i - Integration test for Anarchy Agent components
// Tests all components working together

// Import required modules
// Note: In a real implementation, these would be properly imported
// For this example, we'll assume they're available in the global scope

ƒmain() {
    ⌽("Starting integration test for Anarchy Agent components...");
    
    // Initialize test environment
    _setup_test_environment();
    
    // Run tests
    _test_memory_system();
    _test_input_workaround();
    _test_browser_automation();
    _test_file_system_operations();
    _test_string_dictionary();
    _test_workflow_integration();
    
    // Clean up test environment
    _cleanup_test_environment();
    
    ⌽("Integration test completed successfully!");
}

// Set up test environment
ƒ_setup_test_environment() {
    ⌽("Setting up test environment...");
    
    // Create test directories
    !("mkdir -p ./test_data");
    !("mkdir -p ./test_input");
    !("mkdir -p ./test_output");
    !("mkdir -p ./test_screenshots");
    
    // Create test files
    ✍("./test_data/test_file.txt", "This is a test file for file system operations.");
    ✍("./test_data/test_json.json", '{"name": "Test", "value": 42}');
    
    ⌽("Test environment setup completed.");
}

// Test memory system
ƒ_test_memory_system() {
    ⌽("Testing enhanced memory system...");
    
    // Initialize memory system
    ιmemory = Memory();
    memory.initialize({});
    
    // Test storing and retrieving values
    memory.store("test_key", "test_value", ["test"], 1);
    ιretrieved = memory.retrieve("test_key");
    
    if (retrieved !== "test_value") {
        ⌽("ERROR: Memory store/retrieve test failed!");
        ⟼(⊥);
    }
    
    // Test searching
    memory.store("search_test_1", "apple banana orange", ["fruit"], 1);
    memory.store("search_test_2", "apple pie recipe", ["recipe"], 1);
    memory.store("search_test_3", "orange juice recipe", ["recipe", "juice"], 1);
    
    ιsearch_results = memory.search("apple", 2);
    
    if (search_results.length !== 2) {
        ⌽("ERROR: Memory search test failed! Expected 2 results, got " + search_results.length);
        ⟼(⊥);
    }
    
    // Test tag-based search
    ιtag_results = memory.search_by_tag("recipe", 2);
    
    if (tag_results.length !== 2) {
        ⌽("ERROR: Memory tag search test failed! Expected 2 results, got " + tag_results.length);
        ⟼(⊥);
    }
    
    // Test importance scoring
    memory.update_importance("search_test_1", 3);
    ιhigh_importance = memory.retrieve("search_test_1");
    
    if (!high_importance) {
        ⌽("ERROR: Memory importance update test failed!");
        ⟼(⊥);
    }
    
    ⌽("Memory system tests passed successfully.");
}

// Test input workaround
ƒ_test_input_workaround() {
    ⌽("Testing input function workaround...");
    
    // Initialize input workaround
    ιinput = InputWorkaround();
    input.initialize({input_dir: "./test_input"});
    
    // Test writing output
    input.write_output("test_prompt.txt", "This is a test prompt");
    
    // Verify file was created
    ιfile_exists = ?("./test_input/test_prompt.txt");
    if (!file_exists) {
        ⌽("ERROR: Input workaround write test failed! File not created.");
        ⟼(⊥);
    }
    
    // Test reading input (simulate user response)
    ✍("./test_input/test_response.txt", "This is a test response");
    
    // Test reading input
    ιresponse = input.read_input("test_response.txt");
    
    if (response !== "This is a test response") {
        ⌽("ERROR: Input workaround read test failed!");
        ⟼(⊥);
    }
    
    // Test emoji operators
    input.📤("emoji_test_prompt.txt", "Emoji operator test");
    ιemoji_file_exists = ?("./test_input/emoji_test_prompt.txt");
    if (!emoji_file_exists) {
        ⌽("ERROR: Input workaround emoji operator test failed! File not created.");
        ⟼(⊥);
    }
    
    ⌽("Input function workaround tests passed successfully.");
}

// Test browser automation
ƒ_test_browser_automation() {
    ⌽("Testing browser automation...");
    
    // Initialize browser automation
    ιbrowser_automation = BrowserAutomation();
    browser_automation.initialize({screenshot_dir: "./test_screenshots"});
    
    // Test opening browser
    ιbrowser = browser_automation.open("https://example.com");
    
    if (!browser) {
        ⌽("ERROR: Browser automation open test failed!");
        ⟼(⊥);
    }
    
    // Test getting text
    ιtext = browser_automation.get_text(browser, "h1");
    
    if (text !== "Example Domain") {
        ⌽("ERROR: Browser automation get_text test failed!");
        ⟼(⊥);
    }
    
    // Test emoji operators
    ιemoji_browser = browser_automation.🌐("https://duckduckgo.com");
    browser_automation.⌨(emoji_browser, "input[name='q']", "test query");
    browser_automation.🖱(emoji_browser, "button[type='submit']");
    
    // Test taking screenshot
    ιscreenshot = browser_automation.📸(emoji_browser, "./test_screenshots/test_screenshot.png");
    
    ιscreenshot_exists = ?("./test_screenshots/test_screenshot.png");
    if (!screenshot_exists) {
        ⌽("ERROR: Browser automation screenshot test failed! File not created.");
        ⟼(⊥);
    }
    
    // Test closing browser
    browser_automation.❌(emoji_browser);
    
    ⌽("Browser automation tests passed successfully.");
}

// Test file system operations
ƒ_test_file_system_operations() {
    ⌽("Testing file system operations...");
    
    // Initialize file system operations
    ιfilesystem = FileSystem();
    filesystem.initialize({base_dir: ".", allowed_dirs: ["./test_data", "./test_output"]});
    
    // Test listing directory
    ιfiles = filesystem.list_directory("./test_data");
    
    if (!files || files.length < 2) {
        ⌽("ERROR: File system list_directory test failed!");
        ⟼(⊥);
    }
    
    // Test reading file
    ιcontent = filesystem.read_file("./test_data/test_file.txt");
    
    if (content !== "This is a test file for file system operations.") {
        ⌽("ERROR: File system read_file test failed!");
        ⟼(⊥);
    }
    
    // Test writing file
    filesystem.write_file("./test_output/write_test.txt", "This is a write test.", ⊥);
    
    ιwrite_file_exists = ?("./test_output/write_test.txt");
    if (!write_file_exists) {
        ⌽("ERROR: File system write_file test failed! File not created.");
        ⟼(⊥);
    }
    
    // Test copying file
    filesystem.copy_file("./test_data/test_file.txt", "./test_output/copy_test.txt");
    
    ιcopy_file_exists = ?("./test_output/copy_test.txt");
    if (!copy_file_exists) {
        ⌽("ERROR: File system copy_file test failed! File not created.");
        ⟼(⊥);
    }
    
    // Test emoji operators
    filesystem.📂("./test_data");
    ιemoji_content = filesystem.📖("./test_data/test_file.txt");
    
    if (emoji_content !== "This is a test file for file system operations.") {
        ⌽("ERROR: File system emoji operator test failed!");
        ⟼(⊥);
    }
    
    ⌽("File system operations tests passed successfully.");
}

// Test string dictionary
ƒ_test_string_dictionary() {
    ⌽("Testing string dictionary...");
    
    // Initialize string dictionary
    ιdictionary = StringDictionary();
    dictionary.initialize({dict_dir: "./test_output"});
    
    // Test setting and getting strings
    dictionary.set("test_key", "test_value");
    ιvalue = dictionary.get("test_key");
    
    if (value !== "test_value") {
        ⌽("ERROR: String dictionary set/get test failed!");
        ⟼(⊥);
    }
    
    // Test formatting
    dictionary.set("format_test", "Hello, {}!");
    ιformatted = dictionary.format("format_test", "World");
    
    if (formatted !== "Hello, World!") {
        ⌽("ERROR: String dictionary format test failed!");
        ⟼(⊥);
    }
    
    // Test saving and loading dictionary
    dictionary.save_to_file("test_dictionary.json");
    
    ιdict_file_exists = ?("./test_output/test_dictionary.json");
    if (!dict_file_exists) {
        ⌽("ERROR: String dictionary save test failed! File not created.");
        ⟼(⊥);
    }
    
    // Create a new dictionary and load the saved one
    ιnew_dictionary = StringDictionary();
    new_dictionary.initialize({dict_dir: "./test_output"});
    new_dictionary.load_from_file("test_dictionary.json");
    
    ιloaded_value = new_dictionary.get("test_key");
    if (loaded_value !== "test_value") {
        ⌽("ERROR: String dictionary load test failed!");
        ⟼(⊥);
    }
    
    // Test emoji operators
    dictionary.📝("emoji_test", "Emoji test value");
    ιemoji_value = dictionary.📖("emoji_test");
    
    if (emoji_value !== "Emoji test value") {
        ⌽("ERROR: String dictionary emoji operator test failed!");
        ⟼(⊥);
    }
    
    ⌽("String dictionary tests passed successfully.");
}

// Test workflow integration
ƒ_test_workflow_integration() {
    ⌽("Testing workflow integration...");
    
    // Initialize workflow integration
    ιintegration = WorkflowIntegration();
    integration.initialize({
        memory: {}, 
        input: {input_dir: "./test_input"}, 
        browser: {screenshot_dir: "./test_screenshots"}, 
        filesystem: {base_dir: ".", allowed_dirs: ["./test_data", "./test_output"]}, 
        dictionary: {dict_dir: "./test_output"}
    });
    
    // Test component status
    ιstatus = integration.get_status();
    
    if (!status.memory || !status.input || !status.browser || !status.filesystem || !status.dictionary) {
        ⌽("ERROR: Workflow integration initialization test failed! Not all components initialized.");
        ⟼(⊥);
    }
    
    // Create a test workflow file
    ιtest_workflow = {
        task: "Test workflow",
        steps: [
            {
                type: "filesystem",
                action: "read",
                path: "./test_data/test_file.txt"
            },
            {
                type: "memory",
                action: "store",
                key: "test_workflow_result",
                value: "Workflow test successful",
                tags: ["test", "workflow"]
            }
        ]
    };
    
    ✍("./test_output/test_workflow.json", ⎋(test_workflow));
    
    // Test executing workflow from file
    ιworkflow_result = integration.execute_workflow_file("./test_output/test_workflow.json");
    
    if (!workflow_result) {
        ⌽("ERROR: Workflow integration execute_workflow_file test failed!");
        ⟼(⊥);
    }
    
    // Test shutdown
    integration.shutdown();
    
    ⌽("Workflow integration tests passed successfully.");
}

// Clean up test environment
ƒ_cleanup_test_environment() {
    ⌽("Cleaning up test environment...");
    
    // Remove test directories and files
    !("rm -rf ./test_data");
    !("rm -rf ./test_input");
    !("rm -rf ./test_output");
    !("rm -rf ./test_screenshots");
    
    ⌽("Test environment cleanup completed.");
}

// Run the main function
main();
