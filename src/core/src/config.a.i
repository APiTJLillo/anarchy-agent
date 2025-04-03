// Load the string dictionary
🔠("string_dictionary.json");

// Configuration module for the Anarchy Agent
// This module defines configuration options and handling functions

// Create a new configuration object
ƒcreate_config() {
    ↩ {
        file_path: null,
        example_name: null,
        repl_mode: false,
        model_path: null,
        verbose: false,
        sandbox_enabled: true,
        memory_path: "./memory"
    };
}

// Default configuration
ƒdefault_config() {
    ↩ create_config();
}

// Configuration builder functions
ƒwith_file_path(config, path) {
    ι new_config = clone_config(config);
    new_config.file_path = path;
    ↩ new_config;
}

ƒwith_example_name(config, name) {
    ι new_config = clone_config(config);
    new_config.example_name = name;
    ↩ new_config;
}

ƒwith_repl_mode(config, enabled) {
    ι new_config = clone_config(config);
    new_config.repl_mode = enabled;
    ↩ new_config;
}

ƒwith_model_path(config, path) {
    ι new_config = clone_config(config);
    new_config.model_path = path;
    ↩ new_config;
}

ƒwith_verbose(config, verbose) {
    ι new_config = clone_config(config);
    new_config.verbose = verbose;
    ↩ new_config;
}

ƒwith_sandbox_enabled(config, enabled) {
    ι new_config = clone_config(config);
    new_config.sandbox_enabled = enabled;
    ↩ new_config;
}

ƒwith_memory_path(config, path) {
    ι new_config = clone_config(config);
    new_config.memory_path = path;
    ↩ new_config;
}

// Helper function to clone a configuration
ƒclone_config(config) {
    ↩ {
        file_path: config.file_path,
        example_name: config.example_name,
        repl_mode: config.repl_mode,
        model_path: config.model_path,
        verbose: config.verbose,
        sandbox_enabled: config.sandbox_enabled,
        memory_path: config.memory_path
    };
}

// Get file path as a proper path object
ƒget_file_path(config) {
    ↪(config.file_path) {
        ↩ config.file_path;
    } ↛ {
        ↩ null;
    }
}

// Get memory path as a proper path object
ƒget_memory_path(config) {
    ↪(config.memory_path) {
        ↩ config.memory_path;
    } ↛ {
        ↩ null;
    }
}

// Get model path as a proper path object
ƒget_model_path(config) {
    ↪(config.model_path) {
        ↩ config.model_path;
    } ↛ {
        ↩ null;
    }
}
