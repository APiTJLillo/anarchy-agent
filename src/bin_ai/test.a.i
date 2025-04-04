// Test script for Anarchy-Agent components
// Load the string dictionary
🔠("string_dictionary.json");

// Import the integration module
ι integration = ⟰("./integration");

// Define the test module
ƒTest() {
    ι self = {};
    ι agent = null;
    ι test_results = {};
    
    // Initialize the test module
    self.initialize = λ() {
        ⌽("Initializing test module...");
        
        // Create and initialize the agent
        agent = integration();
        agent.initialize({});
        
        ⌽("Test module initialized");
        ↩ true;
    };
    
    // Run all tests
    self.run_all_tests = λ() {
        ⌽("Running all component tests...");
        
        // Test each component
        self.test_sandbox();
        self.test_parser();
        self.test_file_system();
        self.test_shell();
        self.test_network();
        self.test_db();
        self.test_llm();
        self.test_browser();
        self.test_integration();
        
        // Print test summary
        self.print_summary();
        
        ↩ test_results;
    };
    
    // Test the sandbox component
    self.test_sandbox = λ() {
        ⌽("Testing Sandbox component...");
        
        ι sandbox = agent.get_component("sandbox");
        ι tests = [];
        
        // Test 1: Check if sandbox is initialized
        tests.push({
            name: "sandbox_initialization",
            result: sandbox != null,
            expected: true
        });
        
        // Test 2: Register and retrieve a symbol
        sandbox.register("test_symbol", λ() { ↩ "test_value"; });
        tests.push({
            name: "register_symbol",
            result: sandbox.has_symbol("test_symbol"),
            expected: true
        });
        
        // Test 3: Execute a simple node
        ι result = sandbox.execute_node({
            type: "symbol_call",
            symbol: "test_symbol",
            arguments: []
        });
        tests.push({
            name: "execute_symbol",
            result: result,
            expected: "test_value"
        });
        
        // Store test results
        test_results.sandbox = {
            passed: tests.filter(λt { ↩ t.result === t.expected; }).length,
            total: tests.length,
            tests: tests
        };
        
        ⌽(`Sandbox tests: ${test_results.sandbox.passed}/${test_results.sandbox.total} passed`);
    };
    
    // Test the parser component
    self.test_parser = λ() {
        ⌽("Testing Parser component...");
        
        ι parser = agent.get_component("parser");
        ι tests = [];
        
        // Test 1: Check if parser is initialized
        tests.push({
            name: "parser_initialization",
            result: parser != null,
            expected: true
        });
        
        // Test 2: Parse a simple expression
        ι code = "ι x = 10;";
        ι tokens = parser.tokenize(code);
        tests.push({
            name: "tokenize",
            result: tokens.length > 0,
            expected: true
        });
        
        // Test 3: Parse tokens into AST
        ι ast = parser.parse_tokens(tokens);
        tests.push({
            name: "parse_tokens",
            result: ast.type === "program" && ast.body.length > 0,
            expected: true
        });
        
        // Store test results
        test_results.parser = {
            passed: tests.filter(λt { ↩ t.result === t.expected; }).length,
            total: tests.length,
            tests: tests
        };
        
        ⌽(`Parser tests: ${test_results.parser.passed}/${test_results.parser.total} passed`);
    };
    
    // Test the file system component
    self.test_file_system = λ() {
        ⌽("Testing File System component...");
        
        ι file = agent.get_component("file");
        ι tests = [];
        
        // Test 1: Check if file system is initialized
        tests.push({
            name: "file_initialization",
            result: file != null,
            expected: true
        });
        
        // Test 2: Write a test file
        ι test_file = "/tmp/anarchy_test_file.txt";
        ι write_result = file.write_file(test_file, "Test content");
        tests.push({
            name: "write_file",
            result: write_result.success,
            expected: true
        });
        
        // Test 3: Read the test file
        ι read_result = file.read_file(test_file);
        tests.push({
            name: "read_file",
            result: read_result.success && read_result.content === "Test content",
            expected: true
        });
        
        // Test 4: Check if file exists
        ι exists_result = file.file_exists(test_file);
        tests.push({
            name: "file_exists",
            result: exists_result.success && exists_result.exists,
            expected: true
        });
        
        // Test 5: Remove the test file
        ι remove_result = file.remove_path(test_file);
        tests.push({
            name: "remove_file",
            result: remove_result.success,
            expected: true
        });
        
        // Store test results
        test_results.file_system = {
            passed: tests.filter(λt { ↩ t.result === t.expected; }).length,
            total: tests.length,
            tests: tests
        };
        
        ⌽(`File System tests: ${test_results.file_system.passed}/${test_results.file_system.total} passed`);
    };
    
    // Test the shell component
    self.test_shell = λ() {
        ⌽("Testing Shell component...");
        
        ι shell = agent.get_component("shell");
        ι tests = [];
        
        // Test 1: Check if shell is initialized
        tests.push({
            name: "shell_initialization",
            result: shell != null,
            expected: true
        });
        
        // Test 2: Execute a simple command
        ι exec_result = shell.execute("echo 'Hello, Anarchy!'");
        tests.push({
            name: "execute_command",
            result: exec_result.success && exec_result.output.includes("Hello, Anarchy!"),
            expected: true
        });
        
        // Test 3: Get OS info
        ι os_info = shell.get_os_info();
        tests.push({
            name: "get_os_info",
            result: os_info.success && os_info.os.name != null,
            expected: true
        });
        
        // Store test results
        test_results.shell = {
            passed: tests.filter(λt { ↩ t.result === t.expected; }).length,
            total: tests.length,
            tests: tests
        };
        
        ⌽(`Shell tests: ${test_results.shell.passed}/${test_results.shell.total} passed`);
    };
    
    // Test the network component
    self.test_network = λ() {
        ⌽("Testing Network component...");
        
        ι network = agent.get_component("network");
        ι tests = [];
        
        // Test 1: Check if network is initialized
        tests.push({
            name: "network_initialization",
            result: network != null,
            expected: true
        });
        
        // Test 2: Validate URL (positive case)
        ι valid_url = "https://example.com";
        tests.push({
            name: "validate_url_valid",
            result: network.validate_url(valid_url),
            expected: true
        });
        
        // Test 3: Validate URL (negative case)
        ι invalid_url = "http://localhost:8080";
        tests.push({
            name: "validate_url_invalid",
            result: network.validate_url(invalid_url),
            expected: false
        });
        
        // Store test results
        test_results.network = {
            passed: tests.filter(λt { ↩ t.result === t.expected; }).length,
            total: tests.length,
            tests: tests
        };
        
        ⌽(`Network tests: ${test_results.network.passed}/${test_results.network.total} passed`);
    };
    
    // Test the database component
    self.test_db = λ() {
        ⌽("Testing Database component...");
        
        ι db = agent.get_component("db");
        ι tests = [];
        
        // Test 1: Check if database is initialized
        tests.push({
            name: "db_initialization",
            result: db != null,
            expected: true
        });
        
        // Test 2: Set a key-value pair
        ι set_result = db.set_key_value("test_key", "test_value");
        tests.push({
            name: "set_key_value",
            result: set_result,
            expected: true
        });
        
        // Test 3: Get the value by key
        ι get_result = db.get_key_value("test_key");
        tests.push({
            name: "get_key_value",
            result: get_result,
            expected: "test_value"
        });
        
        // Test 4: Delete the key-value pair
        ι delete_result = db.delete_key_value("test_key");
        tests.push({
            name: "delete_key_value",
            result: delete_result,
            expected: true
        });
        
        // Store test results
        test_results.db = {
            passed: tests.filter(λt { ↩ t.result === t.expected; }).length,
            total: tests.length,
            tests: tests
        };
        
        ⌽(`Database tests: ${test_results.db.passed}/${test_results.db.total} passed`);
    };
    
    // Test the LLM component
    self.test_llm = λ() {
        ⌽("Testing LLM component...");
        
        ι llm = agent.get_component("llm");
        ι tests = [];
        
        // Test 1: Check if LLM is initialized
        tests.push({
            name: "llm_initialization",
            result: llm != null,
            expected: true
        });
        
        // Test 2: Generate a response
        ι prompt = "Task: Print hello world";
        ι response = llm.generate(prompt);
        tests.push({
            name: "generate_response",
            result: response != null && response.length > 0,
            expected: true
        });
        
        // Store test results
        test_results.llm = {
            passed: tests.filter(λt { ↩ t.result === t.expected; }).length,
            total: tests.length,
            tests: tests
        };
        
        ⌽(`LLM tests: ${test_results.llm.passed}/${test_results.llm.total} passed`);
    };
    
    // Test the browser component
    self.test_browser = λ() {
        ⌽("Testing Browser component...");
        
        ι browser = agent.get_component("browser");
        ι tests = [];
        
        // Test 1: Check if browser is initialized
        tests.push({
            name: "browser_initialization",
            result: browser != null,
            expected: true
        });
        
        // Test 2: Validate URL (positive case)
        ι valid_url = "https://example.com";
        tests.push({
            name: "validate_url_valid",
            result: browser.validate_url(valid_url),
            expected: true
        });
        
        // Test 3: Validate URL (negative case)
        ι invalid_url = "http://localhost:8080";
        tests.push({
            name: "validate_url_invalid",
            result: browser.validate_url(invalid_url),
            expected: false
        });
        
        // Store test results
        test_results.browser = {
            passed: tests.filter(λt { ↩ t.result === t.expected; }).length,
            total: tests.length,
            tests: tests
        };
        
        ⌽(`Browser tests: ${test_results.browser.passed}/${test_results.browser.total} passed`);
    };
    
    // Test the integration
    self.test_integration = λ() {
        ⌽("Testing Integration...");
        
        ι tests = [];
        
        // Test 1: Check if all components are registered
        ι components = ["sandbox", "parser", "file", "shell", "network", "db", "llm", "browser"];
        ι all_registered = true;
        
        ∀(components, λcomp {
            ↪(agent.get_component(comp) == null) {
                all_registered = false;
            }
        });
        
        tests.push({
            name: "all_components_registered",
            result: all_registered,
            expected: true
        });
        
        // Test 2: Execute simple code
        ι code = `ƒmain() {
            ι result = "Integration test";
            ↩ result;
        }
        
        main();`;
        
        ι exec_result = agent.execute(code);
        tests.push({
            name: "execute_code",
            result: exec_result.success,
            expected: true
        });
        
        // Store test results
        test_results.integration = {
            passed: tests.filter(λt { ↩ t.result === t.expected; }).length,
            total: tests.length,
            tests: tests
        };
        
        ⌽(`Integration tests: ${test_results.integration.passed}/${test_results.integration.total} passed`);
    };
    
    // Print test summary
    self.print_summary = λ() {
        ⌽("\n=== Test Summary ===");
        
        ι total_passed = 0;
        ι total_tests = 0;
        
        ∀(Object.keys(test_results), λcomponent {
            ι result = test_results[component];
            total_passed += result.passed;
            total_tests += result.total;
            
            ⌽(`${component}: ${result.passed}/${result.total} passed`);
        });
        
        ι pass_percentage = Math.round((total_passed / total_tests) * 100);
        ⌽(`\nOverall: ${total_passed}/${total_tests} passed (${pass_percentage}%)`);
        
        ↪(total_passed === total_tests) {
            ⌽("All tests passed successfully!");
        } ↛ {
            ⌽("Some tests failed. Check the results for details.");
        }
    };
    
    // Shutdown the test module
    self.shutdown = λ() {
        ⌽("Shutting down test module...");
        
        // Shutdown the agent
        ↪(agent != null) {
            agent.shutdown();
        }
        
        ⌽("Test module shut down");
        ↩ true;
    };
    
    ↩ self;
}

// Run the tests
ƒmain() {
    ι tester = Test();
    tester.initialize();
    ι results = tester.run_all_tests();
    tester.shutdown();
    ↩ results;
}

main();
