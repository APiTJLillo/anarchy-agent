// Load the string dictionary
🔠("string_dictionary.json");

// Core module for the Anarchy Agent
// This is the main entry point for the core functionality

// Import submodules
ι agent = ⟰("./agent");
ι config = ⟰("./config");
ι error = ⟰("./error");

// Export the main functions and objects
ƒcreate_agent(config_obj, planner, executor, memory, browser, file_system, shell) {
    ↩ agent.new(config_obj, planner, executor, memory, browser, file_system, shell);
}

ƒrun_agent(agent_obj) {
    ↩ agent.run(agent_obj);
}

ƒcreate_config() {
    ↩ config.create_config();
}

ƒdefault_config() {
    ↩ config.default_config();
}

// Error creation helpers
ƒconfig_error(message) {
    ↩ error.config_error(message);
}

ƒplanner_error(message) {
    ↩ error.planner_error(message);
}

ƒexecutor_error(message) {
    ↩ error.executor_error(message);
}

// Version information
ι VERSION = "1.0.0";

// Print version information
ƒprint_version() {
    ⌽(:version_prefix + VERSION);
}

// Initialize the core module
ƒinitialize() {
    ⌽(:initializing_core);
    // Perform any necessary initialization
    ↩ {
        success: true,
        message: :core_initialized
    };
}
