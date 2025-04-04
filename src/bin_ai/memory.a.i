// Memory module implementation in Anarchy-Inference
// Load the string dictionary
🔠("string_dictionary.json");

// Define the Memory module
ƒMemory() {
    ι self = {};
    
    // Initialize the memory module
    self.initialize = λ() {
        // Initialize the database
        self.db.initialize();
        
        ↩ true;
    };
    
    // Store a task result in memory
    self.store_result = λ(task, code, result) {
        self.db.store_execution(task, code, result);
        ↩ true;
    };
    
    // Retrieve context relevant to a task description
    self.retrieve_context = λ(task_description) {
        ι relevant_entries = self.db.query_relevant(task_description);
        ι context = self.format_context(relevant_entries);
        ↩ context;
    };
    
    // Format context from relevant entries
    self.format_context = λ(entries) {
        ↪(entries.length == 0) {
            ↩ "";
        }
        
        ι context = "Previous relevant executions:\n";
        ∀(entries, λentry {
            context += `Task: ${entry.task}\nCode: ${entry.code}\nResult: ${entry.result}\n\n`;
        });
        
        ↩ context;
    };
    
    // Store a key-value pair in memory (for Anarchy-Inference 📝 symbol)
    self.set_memory = λ(key, value) {
        self.db.set_key_value(key, value);
        ↩ true;
    };
    
    // Retrieve a value by key from memory (for Anarchy-Inference 📖 symbol)
    self.get_memory = λ(key) {
        ι value = self.db.get_key_value(key);
        ↩ value;
    };
    
    // Delete a key from memory (for Anarchy-Inference 🗑 symbol)
    self.forget_key = λ(key) {
        self.db.delete_key_value(key);
        ↩ true;
    };
    
    // Shutdown the memory module
    self.shutdown = λ() {
        // Close the database connection
        self.db.close();
        
        ↩ true;
    };
    
    ↩ self;
}

// Export the module
⟼(Memory);
