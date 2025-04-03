// Load the string dictionary
🔠("string_dictionary.json");

// Import core modules
ι agent_module = ⟰("anarchy_agent_core/agent");
ι config_module = ⟰("anarchy_agent_core/config");
ι error_module = ⟰("anarchy_agent_core/error");

// Import other modules
ι planner_module = ⟰("anarchy_agent_planner/planning");
ι executor_module = ⟰("anarchy_agent_executor/sandbox");
ι memory_module = ⟰("anarchy_agent_memory/storage");
ι browser_module = ⟰("anarchy_agent_browser/driver");
ι file_module = ⟰("anarchy_agent_system/file");
ι shell_module = ⟰("anarchy_agent_system/shell");

// Main function
ƒmain() {
    // Parse command line arguments
    ι args = !("echo $@").o;
    
    // Display help if no arguments or help flag
    ↪(args == "" || args == "--help" || args == "-h") {
        print_usage();
        ↩;
    }
    
    // Parse config from arguments
    ι config = parse_config(args);
    
    // Initialize the agent with all components
    ι agent = initialize_agent(config);
    
    // Run the agent
    ι result = agent_module.run(agent);
    
    ↪(result.success) {
        ⌽(:execution_complete);
    } ↛ {
        ⌽(:execution_error + result.error);
        !(exit 1);
    }
}

// Print usage information
ƒprint_usage() {
    ⌽(:agent_title);
    ⌽(:usage_header);
    ⌽(:usage_syntax);
    ⌽("");
    ⌽(:options_header);
    ⌽(:help_option);
    ⌽(:example_option);
    ⌽(:repl_option);
    ⌽(:model_option);
    ⌽(:verbose_option);
    ⌽("");
    ⌽(:examples_header);
    ⌽(:example_script);
    ⌽(:example_example);
    ⌽(:example_repl);
}

// Parse configuration from arguments
ƒparse_config(args) {
    ι config = config_module.default();
    ι args_array = args.split(" ");
    
    ι i = 0;
    ↻(i < args_array.length) {
        ↪(args_array[i] == "--example") {
            ↪(i + 1 < args_array.length) {
                config.example_name = args_array[i + 1];
                i += 2;
            } ↛ {
                ⌽(:missing_example_name);
                !(exit 1);
            }
        } ↪(args_array[i] == "--repl") {
            config.repl_mode = true;
            i += 1;
        } ↪(args_array[i] == "--model") {
            ↪(i + 1 < args_array.length) {
                config.model_path = args_array[i + 1];
                i += 2;
            } ↛ {
                ⌽(:missing_model_path);
                !(exit 1);
            }
        } ↪(args_array[i] == "--verbose") {
            config.verbose = true;
            i += 1;
        } ↛ {
            // Assume it's a file path
            ↪(!args_array[i].startsWith("--")) {
                ι file_exists = !("test -f " + args_array[i] + " && echo 'true' || echo 'false'").o;
                ↪(file_exists == "true") {
                    config.file_path = args_array[i];
                } ↛ {
                    ⌽(:file_not_found + args_array[i]);
                    !(exit 1);
                }
            } ↛ {
                ⌽(:unknown_option + args_array[i]);
                !(exit 1);
            }
            i += 1;
        }
    }
    
    // Handle example mode
    ↪(config.example_name) {
        ι example_path = "examples/anarchy-inference/" + config.example_name + ".a.i";
        ι example_exists = !("test -f " + example_path + " && echo 'true' || echo 'false'").o;
        ↪(example_exists == "true") {
            config.file_path = example_path;
        } ↛ {
            ⌽(:example_not_found + config.example_name);
            !(exit 1);
        }
    }
    
    // Validate config
    ↪(!config.repl_mode && !config.file_path) {
        ⌽(:no_input_file);
        !(exit 1);
    }
    
    ↩ config;
}

// Initialize agent with all components
ƒinitialize_agent(config) {
    // Initialize all components
    ι planner = planner_module.new(config);
    ι executor = executor_module.new(config);
    ι memory = memory_module.new(config);
    ι browser = browser_module.new(config);
    ι file_system = file_module.new(config);
    ι shell = shell_module.new(config);
    
    // Create and return the agent with all components
    ι agent = agent_module.new(
        config,
        planner,
        executor,
        memory,
        browser,
        file_system,
        shell
    );
    
    ↩ agent;
}

// Call the main function
main();
