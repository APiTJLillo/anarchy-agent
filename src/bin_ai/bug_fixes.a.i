// Bug fixes for Anarchy Agent components
// This file addresses issues identified during testing

// 1. Fix in main_updated.a.i - Ensure proper error handling for file paths
ƒvalidate_file_path(path) {
    // Check if file exists
    ι file_exists = !("test -f " + path + " && echo 'true' || echo 'false'").o.trim();
    
    ↪(file_exists !== "true") {
        ⌽(:file_not_found + path);
        ↩ false;
    }
    
    // Check if file has .a.i extension
    ↪(!path.endsWith(".a.i")) {
        ⌽("Warning: File does not have .a.i extension: " + path);
    }
    
    ↩ true;
}

// 2. Fix in executor.a.i - Add proper error handling for execute_code
ƒsafe_execute_code(code) {
    try {
        // 1. Parse the code
        ι parsed = parser.parse(code);
        
        // 2. Execute in sandbox
        ι result = sandbox.execute(parsed);
        
        ↩ { success: true, result: result };
    } catch (e) {
        ↩ { success: false, error: e.message };
    }
}

// 3. Fix in browser.a.i - Add timeout handling for browser operations
ƒbrowser_operation_with_timeout(operation, timeout = 5000) {
    ι start_time = Date.now();
    
    // Try the operation with timeout
    try {
        ι promise = new Promise((resolve, reject) => {
            // Set timeout
            setTimeout(() => {
                reject(new Error("Browser operation timed out"));
            }, timeout);
            
            // Try operation
            try {
                ι result = operation();
                resolve(result);
            } catch (e) {
                reject(e);
            }
        });
        
        ↩ { success: true, result: promise };
    } catch (e) {
        ↩ { success: false, error: e.message };
    }
}

// 4. Fix in memory.a.i - Add fallback for missing keys
ƒsafe_get_memory(key, default_value = "") {
    try {
        ι value = db.get_key_value(key);
        
        ↪(value === undefined || value === null) {
            ↩ default_value;
        }
        
        ↩ value;
    } catch (e) {
        ⌽("Warning: Error retrieving key " + key + ": " + e.message);
        ↩ default_value;
    }
}

// 5. Fix in system.a.i - Add proper path validation
ƒvalidate_path(path) {
    // Check for path traversal attempts
    ↪(path.includes("..")) {
        ⌽("Warning: Path contains potential directory traversal: " + path);
        ↩ false;
    }
    
    // Check for absolute paths
    ↪(path.startsWith("/")) {
        ⌽("Warning: Absolute paths are not allowed: " + path);
        ↩ false;
    }
    
    ↩ true;
}

// 6. Fix in planner.a.i - Add context length limit
ƒlimit_context_length(context, max_length = 1000) {
    ↪(context.length <= max_length) {
        ↩ context;
    }
    
    // Truncate context and add indicator
    ι truncated = context.substring(0, max_length);
    ↩ truncated + "... [truncated]";
}

// Export all fixes
⟼({
    validate_file_path,
    safe_execute_code,
    browser_operation_with_timeout,
    safe_get_memory,
    validate_path,
    limit_context_length
});
