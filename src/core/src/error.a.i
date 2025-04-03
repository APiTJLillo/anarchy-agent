// Load the string dictionary
🔠("string_dictionary.json");

// Error handling module for the Anarchy Agent
// This module defines error types and handling functions

// Create a new error object
ƒnew_error(type, message) {
    ↩ {
        type: type,
        message: message
    };
}

// Error type constants
ι ERROR_CONFIG = "config";
ι ERROR_PLANNER = "planner";
ι ERROR_EXECUTOR = "executor";
ι ERROR_MEMORY = "memory";
ι ERROR_BROWSER = "browser";
ι ERROR_FILESYSTEM = "filesystem";
ι ERROR_SHELL = "shell";
ι ERROR_IO = "io";
ι ERROR_PARSE = "parse";
ι ERROR_RUNTIME = "runtime";
ι ERROR_LLM = "llm";

// Create specific error types
ƒconfig_error(message) {
    ↩ new_error(ERROR_CONFIG, message);
}

ƒplanner_error(message) {
    ↩ new_error(ERROR_PLANNER, message);
}

ƒexecutor_error(message) {
    ↩ new_error(ERROR_EXECUTOR, message);
}

ƒmemory_error(message) {
    ↩ new_error(ERROR_MEMORY, message);
}

ƒbrowser_error(message) {
    ↩ new_error(ERROR_BROWSER, message);
}

ƒfilesystem_error(message) {
    ↩ new_error(ERROR_FILESYSTEM, message);
}

ƒshell_error(message) {
    ↩ new_error(ERROR_SHELL, message);
}

ƒio_error(message) {
    ↩ new_error(ERROR_IO, message);
}

ƒparse_error(message) {
    ↩ new_error(ERROR_PARSE, message);
}

ƒruntime_error(message) {
    ↩ new_error(ERROR_RUNTIME, message);
}

ƒllm_error(message) {
    ↩ new_error(ERROR_LLM, message);
}

// Format error for display
ƒformat_error(error) {
    ↪(error.type == ERROR_CONFIG) {
        ↩ :config_error_prefix + error.message;
    } ↪(error.type == ERROR_PLANNER) {
        ↩ :planner_error_prefix + error.message;
    } ↪(error.type == ERROR_EXECUTOR) {
        ↩ :executor_error_prefix + error.message;
    } ↪(error.type == ERROR_MEMORY) {
        ↩ :memory_error_prefix + error.message;
    } ↪(error.type == ERROR_BROWSER) {
        ↩ :browser_error_prefix + error.message;
    } ↪(error.type == ERROR_FILESYSTEM) {
        ↩ :filesystem_error_prefix + error.message;
    } ↪(error.type == ERROR_SHELL) {
        ↩ :shell_error_prefix + error.message;
    } ↪(error.type == ERROR_IO) {
        ↩ :io_error_prefix + error.message;
    } ↪(error.type == ERROR_PARSE) {
        ↩ :parse_error_prefix + error.message;
    } ↪(error.type == ERROR_RUNTIME) {
        ↩ :runtime_error_prefix + error.message;
    } ↪(error.type == ERROR_LLM) {
        ↩ :llm_error_prefix + error.message;
    } ↛ {
        ↩ :unknown_error_prefix + error.message;
    }
}

// Convert from other error types
ƒconvert_error(error, target_type) {
    ↩ new_error(target_type, error.message);
}
