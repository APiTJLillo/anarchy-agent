// System module implementation in Anarchy-Inference
// Load the string dictionary
🔠("string_dictionary.json");

// Define the System module
ƒSystem() {
    ι self = {};
    
    // Initialize the system module
    self.initialize = λ() {
        // Initialize the sandbox
        self.sandbox.initialize();
        
        ↩ true;
    };
    
    // List directory contents (for Anarchy-Inference 📂 symbol)
    self.list_directory = λ(path) {
        ι files = self.file.list_directory(path);
        ↩ files;
    };
    
    // Read file contents (for Anarchy-Inference 📖 symbol)
    self.read_file = λ(path) {
        ι content = self.file.read_file(path);
        ↩ content;
    };
    
    // Write to a file (for Anarchy-Inference ✍ symbol)
    self.write_file = λ(path, contents) {
        self.file.write_file(path, contents);
        ↩ true;
    };
    
    // Remove a file or directory (for Anarchy-Inference ✂ symbol)
    self.remove_path = λ(path) {
        self.file.remove_path(path);
        ↩ true;
    };
    
    // Copy a file (for Anarchy-Inference ⧉ symbol)
    self.copy_file = λ(src, dst) {
        self.file.copy_file(src, dst);
        ↩ true;
    };
    
    // Move a file (for Anarchy-Inference ↷ symbol)
    self.move_file = λ(src, dst) {
        self.file.move_file(src, dst);
        ↩ true;
    };
    
    // Check if a file exists (for Anarchy-Inference ? symbol)
    self.file_exists = λ(path) {
        ι exists = self.file.file_exists(path);
        ↩ exists;
    };
    
    // Execute a shell command (for Anarchy-Inference ! symbol)
    self.execute_shell = λ(command) {
        ι result = self.shell.execute(command);
        ↩ result;
    };
    
    // Get current OS information (for Anarchy-Inference 🖥 symbol)
    self.get_os_info = λ() {
        ι info = self.shell.get_os_info();
        ↩ info;
    };
    
    // Get environment variable (for Anarchy-Inference 🌐 symbol)
    self.get_env_var = λ(name) {
        ι value = self.shell.get_env_var(name);
        ↩ value;
    };
    
    // Shutdown the system module
    self.shutdown = λ() {
        // Shutdown the sandbox
        self.sandbox.shutdown();
        
        ↩ true;
    };
    
    ↩ self;
}

// Export the module
⟼(System);
