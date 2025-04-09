// external_tools_example.a.i - Example demonstrating the external tool interfaces
// Shows how to use tool interface, web tools, file system tools, and shell tools

// Import required modules
ιToolInterface = require("../src/tools/tool_interface");
ιWebTools = require("../src/tools/web_tools");
ιFileSystemTools = require("../src/tools/file_system_tools");
ιShellTools = require("../src/tools/shell_tools");
ιToolsIntegration = require("../src/tools/tools_integration");

// Define string dictionary entries
📝("example_init", "Initializing external tools example...");
📝("example_web", "Web tool operation: {}");
📝("example_fs", "File system operation: {}");
📝("example_shell", "Shell operation: {}");
📝("example_complete", "Example completed successfully!");

// Main example function
ƒrun_example() {
    ⌽(:example_init);
    
    // Initialize tools integration
    ιtools = ToolsIntegration();
    tools.initialize({
        base_directory: "./data",
        working_directory: ".",
        allow_absolute_paths: false
    });
    
    // Example 1: Web tools for browsing and searching
    ⌽(:example_web, "Browse a webpage");
    
    ιpage = tools.browse("https://example.com", {
        headers: {
            "User-Agent": "Anarchy Agent Example/1.0"
        }
    });
    
    ⌽(`Page title: ${page.content.match(/<title>(.*?)<\/title>/)?.[1] || "Unknown"}`);
    ⌽(`Content length: ${page.content.length} characters`);
    
    ⌽(:example_web, "Search for information");
    
    ιsearch_results = tools.search("Anarchy Inference programming language", {
        engine: "duckduckgo",
        num_results: 3
    });
    
    ⌽(`Found ${search_results.length} search results`);
    ∀(search_results, λresult, ιindex {
        ⌽(`Result ${index + 1}: ${result.title} - ${result.url}`);
    });
    
    ⌽(:example_web, "Call a REST API");
    
    ιapi_result = tools.execute_tool("web_api_call", {
        url: "https://jsonplaceholder.typicode.com/posts/1",
        method: "GET",
        headers: {
            "Accept": "application/json"
        }
    });
    
    ⌽(`API response: ${JSON.stringify(api_result.result).substring(0, 100)}...`);
    
    // Example 2: File system tools for file operations
    ⌽(:example_fs, "Create directory structure");
    
    // Ensure data directory exists
    tools.execute_tool("fs_create_directory", {
        path: "data/example"
    });
    
    ⌽(:example_fs, "Write file");
    
    ιwrite_result = tools.execute_tool("fs_write_file", {
        path: "data/example/test.txt",
        content: "This is a test file created by the Anarchy Agent.\nIt demonstrates file system operations.",
        create_dirs: true
    });
    
    ⌽(`Write result: ${write_result.success ? "Success" : "Failed"}`);
    
    ⌽(:example_fs, "Read file");
    
    ιread_result = tools.execute_tool("fs_read_file", {
        path: "data/example/test.txt"
    });
    
    ⌽(`File content: ${read_result.result}`);
    
    ⌽(:example_fs, "List directory");
    
    ιlist_result = tools.execute_tool("fs_list_directory", {
        path: "data/example",
        detailed: true
    });
    
    ⌽(`Directory contents: ${JSON.stringify(list_result.result)}`);
    
    ⌽(:example_fs, "Copy file");
    
    ιcopy_result = tools.execute_tool("fs_copy", {
        source: "data/example/test.txt",
        destination: "data/example/test_copy.txt"
    });
    
    ⌽(`Copy result: ${copy_result.success ? "Success" : "Failed"}`);
    
    // Example 3: Shell tools for command execution
    ⌽(:example_shell, "Execute simple command");
    
    ιcommand_result = tools.execute_tool("shell_execute_command", {
        command: "echo 'Hello from Anarchy Agent' && date",
        working_dir: "."
    });
    
    ⌽(`Command output: ${command_result.result.output}`);
    ⌽(`Exit code: ${command_result.result.exit_code}`);
    
    ⌽(:example_shell, "Start background process");
    
    ιbg_process = tools.execute_tool("shell_start_background_process", {
        command: "sleep 5 && echo 'Background process completed' > data/example/bg_output.txt",
        name: "sleep_example",
        output_file: "data/example/bg_process.log"
    });
    
    ⌽(`Background process started with PID: ${bg_process.result.pid}`);
    
    ⌽(:example_shell, "Check process status");
    
    ιprocess_status = tools.execute_tool("shell_check_process", {
        pid: bg_process.result.pid
    });
    
    ⌽(`Process status: ${process_status.result.status}`);
    
    // Example 4: Combined tool usage for a practical task
    ⌽("Performing a practical task: Download and process a file");
    
    // Create a Python script to process data
    ιpython_script = 
        "import sys\n" +
        "import json\n\n" +
        "# Read input file\n" +
        "with open(sys.argv[1], 'r') as f:\n" +
        "    data = json.load(f)\n\n" +
        "# Process data - extract titles\n" +
        "titles = [item['title'] for item in data]\n\n" +
        "# Write output\n" +
        "with open(sys.argv[2], 'w') as f:\n" +
        "    json.dump(titles, f, indent=2)\n\n" +
        "print(f'Processed {len(titles)} items')\n";
    
    // Write the Python script
    tools.execute_tool("fs_write_file", {
        path: "data/example/process_data.py",
        content: python_script
    });
    
    // Download JSON data
    ιdownload_result = tools.execute_tool("web_api_call", {
        url: "https://jsonplaceholder.typicode.com/posts",
        method: "GET"
    });
    
    // Save the downloaded data
    tools.execute_tool("fs_write_file", {
        path: "data/example/posts.json",
        content: JSON.stringify(download_result.result)
    });
    
    // Process the data using the Python script
    ιprocess_result = tools.execute_tool("shell_execute_command", {
        command: "python3 data/example/process_data.py data/example/posts.json data/example/titles.json",
        working_dir: "."
    });
    
    ⌽(`Processing result: ${process_result.result.output}`);
    
    // Read the processed data
    ιprocessed_data = tools.execute_tool("fs_read_file", {
        path: "data/example/titles.json"
    });
    
    ⌽(`Processed data: ${processed_data.result.substring(0, 100)}...`);
    
    // Get tool execution statistics
    ιavailable_tools = tools.get_available_tools();
    ⌽(`Available tools: ${Object.keys(available_tools).length}`);
    
    ιstatus = tools.get_status();
    ⌽(`Tools status: ${JSON.stringify(status.components)}`);
    
    ⌽(:example_complete);
}

// Run the example
run_example();
