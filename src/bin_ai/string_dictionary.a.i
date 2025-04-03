// String dictionary for Anarchy Agent
// This file contains common strings used throughout the application

// System messages
📝("agent_title", "Anarchy Agent - A fully local, cross-platform AI assistant");
📝("usage_header", "Usage:");
📝("usage_syntax", "  anarchy-agent [OPTIONS] [FILE]");
📝("options_header", "Options:");
📝("help_option", "  --help, -h             Display this help message");
📝("example_option", "  --example <name>       Run an example (e.g., example_task, browser_automation)");
📝("repl_option", "  --repl                 Start an interactive REPL session");
📝("model_option", "  --model <path>         Specify path to a local LLM model");
📝("verbose_option", "  --verbose              Enable verbose logging");
📝("examples_header", "Examples:");
📝("example_script", "  anarchy-agent script.a.i");
📝("example_example", "  anarchy-agent --example example_task");
📝("example_repl", "  anarchy-agent --repl");

// Error messages
📝("execution_error", "Error during agent execution: ");
📝("missing_example_name", "Missing example name");
📝("missing_model_path", "Missing model path");
📝("file_not_found", "File not found: ");
📝("unknown_option", "Unknown option: ");
📝("example_not_found", "Example not found: ");
📝("no_input_file", "No input file specified");

// Success messages
📝("execution_complete", "Agent execution completed successfully.");
📝("initializing_core", "Initializing core module...");
📝("core_initialized", "Core module initialized successfully.");
📝("version_prefix", "Anarchy Agent version: ");

// REPL messages
📝("repl_start", "Starting Anarchy Agent REPL...");
📝("repl_exit_instructions", "Type 'exit' or 'quit' to exit.");
📝("repl_ended", "REPL session ended.");

// Runtime messages
📝("running_file", "Running file: ");
📝("execution_result", "Execution result: ");

// Error prefixes
📝("error_prefix", "Error: ");
📝("config_error_prefix", "Configuration error: ");
📝("planner_error_prefix", "Planner error: ");
📝("executor_error_prefix", "Executor error: ");
📝("memory_error_prefix", "Memory error: ");
📝("browser_error_prefix", "Browser error: ");
📝("filesystem_error_prefix", "File system error: ");
📝("shell_error_prefix", "Shell error: ");
📝("io_error_prefix", "I/O error: ");
📝("parse_error_prefix", "Parse error: ");
📝("runtime_error_prefix", "Runtime error: ");
📝("llm_error_prefix", "LLM error: ");
📝("unknown_error_prefix", "Unknown error: ");

// Save the dictionary to a file
💾("main", "string_dictionary.json");
