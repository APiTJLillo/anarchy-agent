// string_dictionary.a.i - String dictionary for Anarchy Agent
// Implements centralized string storage to minimize token usage

// String Dictionary Module Definition
λStringDictionary {
    // Initialize string dictionary
    ƒinitialize(αoptions) {
        ⌽("Initializing string dictionary...");
        
        // Set default options
        ιthis.options = options || {};
        ιthis.options.default_dict = this.options.default_dict || "default";
        ιthis.options.dict_dir = this.options.dict_dir || "./dictionaries";
        
        // Initialize dictionaries
        ιthis.dictionaries = {};
        ιthis.active_dict = this.options.default_dict;
        
        // Create dictionary directory if it doesn't exist
        ÷{
            ιexists = ?(this.options.dict_dir);
            if (!exists) {
                !(`mkdir -p ${this.options.dict_dir}`);
            }
        }{
            ⌽("Failed to create dictionary directory");
        }
        
        // Create default dictionary
        this.dictionaries[this.active_dict] = {};
        
        // Load dictionaries from files if they exist
        this._load_dictionaries();
        
        ⟼(⊤);
    }
    
    // Set string in dictionary
    ƒset(σkey, σvalue, σdict_name) {
        ιdict = dict_name || this.active_dict;
        
        // Create dictionary if it doesn't exist
        if (!this.dictionaries[dict]) {
            this.dictionaries[dict] = {};
        }
        
        // Set string in dictionary
        this.dictionaries[dict][key] = value;
        
        // Persist dictionary to disk
        this._persist_dictionary(dict);
        
        ⟼(⊤);
    }
    
    // Get string from dictionary
    ƒget(σkey, σdict_name) {
        ιdict = dict_name || this.active_dict;
        
        // Check if dictionary exists
        if (!this.dictionaries[dict]) {
            ⌽(`Dictionary not found: ${dict}`);
            ⟼(null);
        }
        
        // Get string from dictionary
        ιvalue = this.dictionaries[dict][key];
        
        // Return value or null if not found
        ⟼(value !== undefined ? value : null);
    }
    
    // Format string with placeholders
    ƒformat(σkey, ...αargs) {
        ιvalue = this.get(key);
        
        if (!value) {
            ⟼(null);
        }
        
        // Replace {} placeholders with arguments
        ιformatted = value;
        ∀(args, λarg {
            formatted = formatted.replace("{}", arg);
        });
        
        ⟼(formatted);
    }
    
    // Switch active dictionary
    ƒswitch_dictionary(σdict_name) {
        // Check if dictionary exists
        if (!this.dictionaries[dict_name]) {
            // Create new dictionary
            this.dictionaries[dict_name] = {};
        }
        
        // Switch active dictionary
        this.active_dict = dict_name;
        
        ⟼(⊤);
    }
    
    // Load dictionary from file
    ƒload_from_file(σfilename, σdict_name) {
        ιdict = dict_name || this.active_dict;
        
        ÷{
            // Get full path
            ιfull_path = `${this.options.dict_dir}/${filename}`;
            
            // Check if file exists
            ιexists = ?(full_path);
            if (!exists) {
                ⌽(`Dictionary file not found: ${filename}`);
                ⟼(⊥);
            }
            
            // Read file content
            ιcontent = 📖(full_path);
            
            // Parse JSON content
            ιparsed = ⎋(content);
            
            // Create dictionary if it doesn't exist
            if (!this.dictionaries[dict]) {
                this.dictionaries[dict] = {};
            }
            
            // Merge parsed content with existing dictionary
            ∀(Object.keys(parsed), λkey {
                this.dictionaries[dict][key] = parsed[key];
            });
            
            ⟼(⊤);
        }{
            ⌽(`Failed to load dictionary from file: ${filename}`);
            ⟼(⊥);
        }
    }
    
    // Save dictionary to file
    ƒsave_to_file(σfilename, σdict_name) {
        ιdict = dict_name || this.active_dict;
        
        ÷{
            // Check if dictionary exists
            if (!this.dictionaries[dict]) {
                ⌽(`Dictionary not found: ${dict}`);
                ⟼(⊥);
            }
            
            // Get full path
            ιfull_path = `${this.options.dict_dir}/${filename}`;
            
            // Create directory if it doesn't exist
            ιdir_path = full_path.substring(0, full_path.lastIndexOf("/"));
            ιdir_exists = ?(dir_path);
            if (!dir_exists) {
                !(`mkdir -p ${dir_path}`);
            }
            
            // Convert dictionary to JSON
            ιcontent = ⎋(this.dictionaries[dict]);
            
            // Write content to file
            ✍(full_path, content);
            
            ⟼(⊤);
        }{
            ⌽(`Failed to save dictionary to file: ${filename}`);
            ⟼(⊥);
        }
    }
    
    // Get all keys in a dictionary
    ƒget_keys(σdict_name) {
        ιdict = dict_name || this.active_dict;
        
        // Check if dictionary exists
        if (!this.dictionaries[dict]) {
            ⌽(`Dictionary not found: ${dict}`);
            ⟼([]);
        }
        
        // Return array of keys
        ⟼(Object.keys(this.dictionaries[dict]));
    }
    
    // Get all dictionaries
    ƒget_dictionaries() {
        ⟼(Object.keys(this.dictionaries));
    }
    
    // Delete a key from dictionary
    ƒdelete_key(σkey, σdict_name) {
        ιdict = dict_name || this.active_dict;
        
        // Check if dictionary exists
        if (!this.dictionaries[dict]) {
            ⌽(`Dictionary not found: ${dict}`);
            ⟼(⊥);
        }
        
        // Delete key from dictionary
        delete this.dictionaries[dict][key];
        
        // Persist dictionary to disk
        this._persist_dictionary(dict);
        
        ⟼(⊤);
    }
    
    // Delete a dictionary
    ƒdelete_dictionary(σdict_name) {
        // Check if dictionary exists
        if (!this.dictionaries[dict_name]) {
            ⌽(`Dictionary not found: ${dict_name}`);
            ⟼(⊥);
        }
        
        // Cannot delete active dictionary
        if (dict_name === this.active_dict) {
            ⌽("Cannot delete active dictionary");
            ⟼(⊥);
        }
        
        // Delete dictionary
        delete this.dictionaries[dict_name];
        
        // Delete dictionary file if it exists
        ÷{
            ιfull_path = `${this.options.dict_dir}/${dict_name}.json`;
            ιexists = ?(full_path);
            if (exists) {
                ✂(full_path);
            }
        }{
            ⌽(`Failed to delete dictionary file: ${dict_name}.json`);
        }
        
        ⟼(⊤);
    }
    
    // Private: Load dictionaries from files
    ƒ_load_dictionaries() {
        ÷{
            // Check if dictionary directory exists
            ιexists = ?(this.options.dict_dir);
            if (!exists) {
                ⟼(⊥);
            }
            
            // List files in dictionary directory
            ιfiles = 📂(this.options.dict_dir);
            
            // Load each dictionary file
            ∀(files, λfile {
                if (file.endsWith(".json")) {
                    ιdict_name = file.substring(0, file.length - 5);
                    this.load_from_file(file, dict_name);
                }
            });
            
            ⟼(⊤);
        }{
            ⌽("Failed to load dictionaries from files");
            ⟼(⊥);
        }
    }
    
    // Private: Persist dictionary to disk
    ƒ_persist_dictionary(σdict_name) {
        ÷{
            // Save dictionary to file
            this.save_to_file(`${dict_name}.json`, dict_name);
            ⟼(⊤);
        }{
            ⌽(`Failed to persist dictionary: ${dict_name}`);
            ⟼(⊥);
        }
    }
    
    // Emoji operators for direct use
    // These match the README.md documentation
    
    // 📝 (set_string) - Set string in dictionary
    ƒ📝(σkey, σvalue, σdict_name) {
        ⟼(this.set(key, value, dict_name));
    }
    
    // 📖 (get_string) - Get string from dictionary
    ƒ📖(σkey, σdict_name) {
        ⟼(this.get(key, dict_name));
    }
    
    // 🔠 (load_dictionary) - Load dictionary from file
    ƒ🔠(σfilename, σdict_name) {
        ⟼(this.load_from_file(filename, dict_name));
    }
    
    // 💾 (save_dictionary) - Save dictionary to file
    ƒ💾(σfilename, σdict_name) {
        ⟼(this.save_to_file(filename, dict_name));
    }
    
    // 🔄 (switch_dictionary) - Switch active dictionary
    ƒ🔄(σdict_name) {
        ⟼(this.switch_dictionary(dict_name));
    }
}

// Create and initialize the agent string dictionary
ιagent_dictionary = StringDictionary();
agent_dictionary.initialize();

// Add common strings for the agent
agent_dictionary.📝("agent_name", "Anarchy Agent");
agent_dictionary.📝("agent_version", "1.0.0");
agent_dictionary.📝("agent_description", "A fully local, cross-platform AI assistant using Anarchy-Inference language");

// System messages
agent_dictionary.📝("system_init", "Initializing Anarchy Agent...");
agent_dictionary.📝("system_ready", "Anarchy Agent is ready");
agent_dictionary.📝("system_shutdown", "Shutting down Anarchy Agent...");
agent_dictionary.📝("system_error", "System error: {}");
agent_dictionary.📝("system_warning", "Warning: {}");
agent_dictionary.📝("system_info", "Info: {}");

// Task messages
agent_dictionary.📝("task_start", "Starting task: {}");
agent_dictionary.📝("task_complete", "Task completed: {}");
agent_dictionary.📝("task_failed", "Task failed: {}");
agent_dictionary.📝("task_progress", "Task progress: {}%");
agent_dictionary.📝("task_cancelled", "Task cancelled: {}");

// User interaction
agent_dictionary.📝("user_prompt", "Please enter your request:");
agent_dictionary.📝("user_input", "User input: {}");
agent_dictionary.📝("user_response", "Response to user: {}");
agent_dictionary.📝("user_confirmation", "Please confirm (yes/no):");
agent_dictionary.📝("user_options", "Please select an option (1-{}):");

// Error messages
agent_dictionary.📝("error_invalid_input", "Invalid input: {}");
agent_dictionary.📝("error_permission_denied", "Permission denied: {}");
agent_dictionary.📝("error_not_found", "Not found: {}");
agent_dictionary.📝("error_timeout", "Operation timed out: {}");
agent_dictionary.📝("error_network", "Network error: {}");
agent_dictionary.📝("error_file_system", "File system error: {}");
agent_dictionary.📝("error_browser", "Browser error: {}");
agent_dictionary.📝("error_memory", "Memory error: {}");

// Success messages
agent_dictionary.📝("success_file_operation", "File operation successful: {}");
agent_dictionary.📝("success_network_operation", "Network operation successful: {}");
agent_dictionary.📝("success_browser_operation", "Browser operation successful: {}");
agent_dictionary.📝("success_memory_operation", "Memory operation successful: {}");

// Help messages
agent_dictionary.📝("help_general", "Anarchy Agent Help\n\nAvailable commands:\n- task: Execute a task\n- file: File operations\n- web: Web operations\n- memory: Memory operations\n- exit: Exit the agent");
agent_dictionary.📝("help_task", "Task Help\n\nUsage: task <description>\n\nExecutes a task based on the provided description.");
agent_dictionary.📝("help_file", "File Help\n\nUsage: file <operation> <arguments>\n\nOperations:\n- list: List directory contents\n- read: Read file content\n- write: Write content to file\n- delete: Delete file or directory\n- copy: Copy file\n- move: Move file");
agent_dictionary.📝("help_web", "Web Help\n\nUsage: web <operation> <arguments>\n\nOperations:\n- open: Open a web page\n- search: Search the web\n- download: Download a file");
agent_dictionary.📝("help_memory", "Memory Help\n\nUsage: memory <operation> <arguments>\n\nOperations:\n- store: Store a value\n- retrieve: Retrieve a value\n- delete: Delete a value\n- list: List all keys");

// Save the dictionary to file
agent_dictionary.💾("agent_dictionary.json");

// Export the StringDictionary module and initialized dictionary
⟼({
    StringDictionary: StringDictionary,
    agent_dictionary: agent_dictionary
});
