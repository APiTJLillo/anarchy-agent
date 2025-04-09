// external_tools_test.a.i - Test suite for the external tool interfaces
// Tests tool interface, web tools, file system tools, and shell tools

// Import required modules
ιToolInterface = require("../../src/tools/tool_interface");
ιWebTools = require("../../src/tools/web_tools");
ιFileSystemTools = require("../../src/tools/file_system_tools");
ιShellTools = require("../../src/tools/shell_tools");
ιToolsIntegration = require("../../src/tools/tools_integration");

// Define string dictionary entries
📝("test_init", "Initializing external tools tests...");
📝("test_run", "Running test: {}");
📝("test_pass", "✅ Test passed: {}");
📝("test_fail", "❌ Test failed: {} - {}");
📝("test_complete", "Tests completed: {} passed, {} failed");

// Test suite for external tools
λExternalToolsTest {
    // Initialize test suite
    ƒinitialize() {
        ⌽(:test_init);
        
        // Initialize test counters
        ιthis.tests_run = 0;
        ιthis.tests_passed = 0;
        ιthis.tests_failed = 0;
        
        // Initialize test directory
        ιthis.test_dir = "./test_tools_dir";
        
        // Create test directory
        !(`mkdir -p ${this.test_dir}`);
        
        // Initialize components for testing
        this._initialize_components();
        
        ⟼(⊤);
    }
    
    // Run all tests
    ƒrun_tests() {
        // Tool interface tests
        this.test_tool_interface_registration();
        this.test_tool_interface_execution();
        
        // Web tools tests
        this.test_web_tools_browse();
        this.test_web_tools_search();
        this.test_web_tools_api_call();
        
        // File system tools tests
        this.test_file_system_tools_write_read();
        this.test_file_system_tools_list_directory();
        this.test_file_system_tools_copy_move();
        
        // Shell tools tests
        this.test_shell_tools_execute_command();
        this.test_shell_tools_background_process();
        
        // Tools integration tests
        this.test_tools_integration_combined_operation();
        
        // Report results
        ⌽(:test_complete, this.tests_passed, this.tests_failed);
        
        // Clean up test directory
        !(`rm -rf ${this.test_dir}`);
        
        ⟼(this.tests_failed === 0);
    }
    
    // Test tool interface registration
    ƒtest_tool_interface_registration() {
        ⌽(:test_run, "tool_interface_registration");
        this.tests_run++;
        
        ÷{
            // Register a test tool
            ιregistration_result = this.tool_interface.register_tool({
                name: "test_tool",
                description: "A test tool for testing",
                category: "test",
                handler: (params) => {
                    return {
                        success: true,
                        result: `Executed test_tool with params: ${JSON.stringify(params)}`
                    };
                },
                parameters: {
                    param1: { type: "string", required: true },
                    param2: { type: "number", required: false }
                }
            });
            
            // Verify registration
            if (!registration_result) {
                ⌽(:test_fail, "tool_interface_registration", "Tool registration failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify tool is registered
            ιregistered_tools = this.tool_interface.get_registered_tools();
            
            if (!registered_tools || !registered_tools.test_tool) {
                ⌽(:test_fail, "tool_interface_registration", "Tool not found in registered tools");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify tool metadata
            ιtool_info = registered_tools.test_tool;
            
            if (!tool_info || 
                tool_info.name !== "test_tool" || 
                tool_info.category !== "test" || 
                !tool_info.parameters || 
                !tool_info.parameters.param1) {
                ⌽(:test_fail, "tool_interface_registration", "Tool metadata incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "tool_interface_registration");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "tool_interface_registration", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test tool interface execution
    ƒtest_tool_interface_execution() {
        ⌽(:test_run, "tool_interface_execution");
        this.tests_run++;
        
        ÷{
            // Execute the test tool
            ιexecution_result = this.tool_interface.execute_tool("test_tool", {
                param1: "test_value",
                param2: 42
            });
            
            // Verify execution
            if (!execution_result || !execution_result.success) {
                ⌽(:test_fail, "tool_interface_execution", "Tool execution failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify result
            if (!execution_result.result || 
                !execution_result.result.includes("test_value") || 
                !execution_result.result.includes("42")) {
                ⌽(:test_fail, "tool_interface_execution", "Tool execution result incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            // Test parameter validation
            ιvalidation_result = this.tool_interface.execute_tool("test_tool", {
                // Missing required param1
                param2: 42
            });
            
            // Verify validation failure
            if (validation_result.success) {
                ⌽(:test_fail, "tool_interface_execution", "Parameter validation did not fail as expected");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify error message
            if (!validation_result.error || !validation_result.error.includes("param1")) {
                ⌽(:test_fail, "tool_interface_execution", "Validation error message incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "tool_interface_execution");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "tool_interface_execution", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test web tools browse
    ƒtest_web_tools_browse() {
        ⌽(:test_run, "web_tools_browse");
        this.tests_run++;
        
        ÷{
            // Browse a webpage
            ιbrowse_result = this.web_tools.browse("https://example.com", {
                headers: {
                    "User-Agent": "Anarchy Agent Test/1.0"
                }
            });
            
            // Verify browse result
            if (!browse_result || !browse_result.success) {
                ⌽(:test_fail, "web_tools_browse", "Browse operation failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify content
            if (!browse_result.content || browse_result.content.length === 0) {
                ⌽(:test_fail, "web_tools_browse", "Browse returned empty content");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify URL
            if (browse_result.url !== "https://example.com") {
                ⌽(:test_fail, "web_tools_browse", "URL in result does not match requested URL");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "web_tools_browse");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "web_tools_browse", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test web tools search
    ƒtest_web_tools_search() {
        ⌽(:test_run, "web_tools_search");
        this.tests_run++;
        
        ÷{
            // Search for information
            ιsearch_result = this.web_tools.search("Anarchy Inference programming language", {
                engine: "mock_engine",
                num_results: 3
            });
            
            // Verify search result
            if (!search_result || !search_result.success) {
                ⌽(:test_fail, "web_tools_search", "Search operation failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify results
            if (!search_result.results || search_result.results.length === 0) {
                ⌽(:test_fail, "web_tools_search", "Search returned no results");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify result count
            if (search_result.results.length !== 3) {
                ⌽(:test_fail, "web_tools_search", "Search returned incorrect number of results");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify result structure
            ιfirst_result = search_result.results[0];
            if (!first_result.title || !first_result.url || !first_result.snippet) {
                ⌽(:test_fail, "web_tools_search", "Search result structure incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "web_tools_search");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "web_tools_search", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test web tools API call
    ƒtest_web_tools_api_call() {
        ⌽(:test_run, "web_tools_api_call");
        this.tests_run++;
        
        ÷{
            // Call a REST API
            ιapi_result = this.web_tools.api_call({
                url: "https://jsonplaceholder.typicode.com/posts/1",
                method: "GET",
                headers: {
                    "Accept": "application/json"
                }
            });
            
            // Verify API call result
            if (!api_result || !api_result.success) {
                ⌽(:test_fail, "web_tools_api_call", "API call failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify response
            if (!api_result.response || typeof api_result.response !== "object") {
                ⌽(:test_fail, "web_tools_api_call", "API response not an object");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify response structure (for mock or real)
            if ((!api_result.response.id && !api_result.response.mock) || 
                (!api_result.response.title && !api_result.response.mock)) {
                ⌽(:test_fail, "web_tools_api_call", "API response structure incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "web_tools_api_call");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "web_tools_api_call", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test file system tools write and read
    ƒtest_file_system_tools_write_read() {
        ⌽(:test_run, "file_system_tools_write_read");
        this.tests_run++;
        
        ÷{
            // Write a file
            ιwrite_result = this.file_system_tools.write_file({
                path: `${this.test_dir}/test.txt`,
                content: "This is a test file.",
                create_dirs: true
            });
            
            // Verify write result
            if (!write_result || !write_result.success) {
                ⌽(:test_fail, "file_system_tools_write_read", "File write failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Read the file
            ιread_result = this.file_system_tools.read_file({
                path: `${this.test_dir}/test.txt`
            });
            
            // Verify read result
            if (!read_result || !read_result.success) {
                ⌽(:test_fail, "file_system_tools_write_read", "File read failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify content
            if (read_result.content !== "This is a test file.") {
                ⌽(:test_fail, "file_system_tools_write_read", "File content does not match written content");
                this.tests_failed++;
                ⟼();
            }
            
            // Append to the file
            ιappend_result = this.file_system_tools.write_file({
                path: `${this.test_dir}/test.txt`,
                content: " Additional content.",
                append: true
            });
            
            // Verify append result
            if (!append_result || !append_result.success) {
                ⌽(:test_fail, "file_system_tools_write_read", "File append failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Read the file again
            ιread_again_result = this.file_system_tools.read_file({
                path: `${this.test_dir}/test.txt`
            });
            
            // Verify appended content
            if (read_again_result.content !== "This is a test file. Additional content.") {
                ⌽(:test_fail, "file_system_tools_write_read", "Appended content incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "file_system_tools_write_read");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "file_system_tools_write_read", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test file system tools list directory
    ƒtest_file_system_tools_list_directory() {
        ⌽(:test_run, "file_system_tools_list_directory");
        this.tests_run++;
        
        ÷{
            // Create test files
            this.file_system_tools.write_file({
                path: `${this.test_dir}/file1.txt`,
                content: "File 1"
            });
            
            this.file_system_tools.write_file({
                path: `${this.test_dir}/file2.txt`,
                content: "File 2"
            });
            
            // Create subdirectory
            this.file_system_tools.create_directory({
                path: `${this.test_dir}/subdir`
            });
            
            // List directory
            ιlist_result = this.file_system_tools.list_directory({
                path: this.test_dir,
                detailed: true
            });
            
            // Verify list result
            if (!list_result || !list_result.success) {
                ⌽(:test_fail, "file_system_tools_list_directory", "Directory listing failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify entries
            if (!list_result.entries || list_result.entries.length < 3) {
                ⌽(:test_fail, "file_system_tools_list_directory", "Directory listing missing entries");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify file entries
            ιfound_file1 = false;
            ιfound_file2 = false;
            ιfound_subdir = false;
            
            ∀(list_result.entries, λentry {
                if (entry.name === "file1.txt" && entry.type === "file") found_file1 = true;
                if (entry.name === "file2.txt" && entry.type === "file") found_file2 = true;
                if (entry.name === "subdir" && entry.type === "directory") found_subdir = true;
            });
            
            if (!found_file1 || !found_file2 || !found_subdir) {
                ⌽(:test_fail, "file_system_tools_list_directory", "Directory listing missing expected entries");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "file_system_tools_list_directory");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "file_system_tools_list_directory", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test file system tools copy and move
    ƒtest_file_system_tools_copy_move() {
        ⌽(:test_run, "file_system_tools_copy_move");
        this.tests_run++;
        
        ÷{
            // Create test file
            this.file_system_tools.write_file({
                path: `${this.test_dir}/source.txt`,
                content: "Source file content"
            });
            
            // Copy file
            ιcopy_result = this.file_system_tools.copy({
                source: `${this.test_dir}/source.txt`,
                destination: `${this.test_dir}/copy.txt`
            });
            
            // Verify copy result
            if (!copy_result || !copy_result.success) {
                ⌽(:test_fail, "file_system_tools_copy_move", "File copy failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify copied file
            ιcopy_read = this.file_system_tools.read_file({
                path: `${this.test_dir}/copy.txt`
            });
            
            if (!copy_read.success || copy_read.content !== "Source file content") {
                ⌽(:test_fail, "file_system_tools_copy_move", "Copied file content incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            // Move file
            ιmove_result = this.file_system_tools.move({
                source: `${this.test_dir}/source.txt`,
                destination: `${this.test_dir}/moved.txt`
            });
            
            // Verify move result
            if (!move_result || !move_result.success) {
                ⌽(:test_fail, "file_system_tools_copy_move", "File move failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify moved file
            ιmoved_read = this.file_system_tools.read_file({
                path: `${this.test_dir}/moved.txt`
            });
            
            if (!moved_read.success || moved_read.content !== "Source file content") {
                ⌽(:test_fail, "file_system_tools_copy_move", "Moved file content incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify source file is gone
            ιsource_read = this.file_system_tools.read_file({
                path: `${this.test_dir}/source.txt`
            });
            
            if (source_read.success) {
                ⌽(:test_fail, "file_system_tools_copy_move", "Source file still exists after move");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "file_system_tools_copy_move");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "file_system_tools_copy_move", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test shell tools execute command
    ƒtest_shell_tools_execute_command() {
        ⌽(:test_run, "shell_tools_execute_command");
        this.tests_run++;
        
        ÷{
            // Execute a simple command
            ιcommand_result = this.shell_tools.execute_command({
                command: "echo 'Hello from test'",
                working_dir: this.test_dir
            });
            
            // Verify command result
            if (!command_result || !command_result.success) {
                ⌽(:test_fail, "shell_tools_execute_command", "Command execution failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify output
            if (!command_result.output || !command_result.output.includes("Hello from test")) {
                ⌽(:test_fail, "shell_tools_execute_command", "Command output incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify exit code
            if (command_result.exit_code !== 0) {
                ⌽(:test_fail, "shell_tools_execute_command", "Command exit code not zero");
                this.tests_failed++;
                ⟼();
            }
            
            // Execute a command with error
            ιerror_result = this.shell_tools.execute_command({
                command: "ls /nonexistent_directory",
                working_dir: this.test_dir
            });
            
            // Verify error handling
            if (!error_result) {
                ⌽(:test_fail, "shell_tools_execute_command", "Error command returned null");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify non-zero exit code
            if (error_result.exit_code === 0) {
                ⌽(:test_fail, "shell_tools_execute_command", "Error command exit code is zero");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "shell_tools_execute_command");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "shell_tools_execute_command", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test shell tools background process
    ƒtest_shell_tools_background_process() {
        ⌽(:test_run, "shell_tools_background_process");
        this.tests_run++;
        
        ÷{
            // Start a background process
            ιprocess_result = this.shell_tools.start_background_process({
                command: "sleep 1 && echo 'Background process completed' > bg_output.txt",
                name: "test_bg_process",
                working_dir: this.test_dir,
                output_file: `${this.test_dir}/bg_process.log`
            });
            
            // Verify process result
            if (!process_result || !process_result.success) {
                ⌽(:test_fail, "shell_tools_background_process", "Background process start failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify process ID
            if (!process_result.pid || process_result.pid <= 0) {
                ⌽(:test_fail, "shell_tools_background_process", "Invalid process ID");
                this.tests_failed++;
                ⟼();
            }
            
            // Check process status
            ιstatus_result = this.shell_tools.check_process({
                pid: process_result.pid
            });
            
            // Verify status result
            if (!status_result) {
                ⌽(:test_fail, "shell_tools_background_process", "Process status check failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Wait for process to complete
            !(sleep 2);
            
            // Verify output file was created
            ιoutput_check = this.file_system_tools.read_file({
                path: `${this.test_dir}/bg_output.txt`
            });
            
            if (!output_check.success || !output_check.content.includes("Background process completed")) {
                ⌽(:test_fail, "shell_tools_background_process", "Background process output incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "shell_tools_background_process");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "shell_tools_background_process", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test tools integration combined operation
    ƒtest_tools_integration_combined_operation() {
        ⌽(:test_run, "tools_integration_combined_operation");
        this.tests_run++;
        
        ÷{
            // Use tools integration for a combined operation
            ιresult = this.tools_integration.execute_tool("fs_write_file", {
                path: `${this.test_dir}/combined.txt`,
                content: "This is a test of combined operations."
            });
            
            // Verify write result
            if (!result || !result.success) {
                ⌽(:test_fail, "tools_integration_combined_operation", "Write operation failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Execute a shell command on the file
            ιshell_result = this.tools_integration.execute_tool("shell_execute_command", {
                command: `cat ${this.test_dir}/combined.txt | wc -w > ${this.test_dir}/word_count.txt`,
                working_dir: "."
            });
            
            // Verify shell result
            if (!shell_result || !shell_result.success) {
                ⌽(:test_fail, "tools_integration_combined_operation", "Shell operation failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Read the word count file
            ιread_result = this.tools_integration.execute_tool("fs_read_file", {
                path: `${this.test_dir}/word_count.txt`
            });
            
            // Verify read result
            if (!read_result || !read_result.success) {
                ⌽(:test_fail, "tools_integration_combined_operation", "Read operation failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify word count (should be 8)
            ιword_count = parseInt(read_result.result.trim());
            if (isNaN(word_count) || word_count !== 8) {
                ⌽(:test_fail, "tools_integration_combined_operation", `Word count incorrect: ${read_result.result}`);
                this.tests_failed++;
                ⟼();
            }
            
            // Get tool execution history
            ιhistory = this.tools_integration.get_execution_history();
            
            // Verify history
            if (!history || history.length < 3) {
                ⌽(:test_fail, "tools_integration_combined_operation", "Execution history incomplete");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "tools_integration_combined_operation");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "tools_integration_combined_operation", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Private: Initialize components for testing
    ƒ_initialize_components() {
        // Initialize tool interface
        this.tool_interface = ToolInterface();
        this.tool_interface.initialize({
            base_directory: this.test_dir
        });
        
        // Initialize web tools with mocks
        this.web_tools = WebTools();
        this.web_tools.initialize({
            tool_interface: this.tool_interface
        });
        
        // Mock web tools methods
        this.web_tools.browse = (url, options) => {
            return {
                success: true,
                url: url,
                content: "<html><head><title>Mock Page</title></head><body><h1>Mock Content</h1><p>This is mock content for testing.</p></body></html>",
                status_code: 200
            };
        };
        
        this.web_tools.search = (query, options) => {
            return {
                success: true,
                query: query,
                results: [
                    {
                        title: "Mock Result 1",
                        url: "https://example.com/result1",
                        snippet: "This is a mock search result about " + query
                    },
                    {
                        title: "Mock Result 2",
                        url: "https://example.com/result2",
                        snippet: "Another mock search result about " + query
                    },
                    {
                        title: "Mock Result 3",
                        url: "https://example.com/result3",
                        snippet: "Yet another mock search result about " + query
                    }
                ]
            };
        };
        
        this.web_tools.api_call = (options) => {
            return {
                success: true,
                url: options.url,
                method: options.method,
                response: {
                    mock: true,
                    id: 1,
                    title: "Mock API Response",
                    body: "This is a mock API response for testing."
                }
            };
        };
        
        // Initialize file system tools
        this.file_system_tools = FileSystemTools();
        this.file_system_tools.initialize({
            tool_interface: this.tool_interface,
            base_directory: "."
        });
        
        // Initialize shell tools
        this.shell_tools = ShellTools();
        this.shell_tools.initialize({
            tool_interface: this.tool_interface
        });
        
        // Initialize tools integration
        this.tools_integration = ToolsIntegration();
        this.tools_integration.initialize({
            base_directory: ".",
            working_directory: ".",
            allow_absolute_paths: true
        });
    }
}

// Create and run test suite
ιtest_suite = ExternalToolsTest();
test_suite.initialize();
test_suite.run_tests();
