// Core module implementation in Anarchy-Inference
// Load the string dictionary
🔠("string_dictionary.json");

// Define the Core module
ƒCore() {
    ι self = {};
    
    // Initialize the core module
    self.initialize = λ() {
        ⌽(:initializing_core);
        
        // Initialize all components
        self.memory.initialize();
        self.planner.initialize();
        self.executor.initialize();
        self.browser.initialize();
        self.system.initialize();
        
        ⌽(:core_initialized);
        ↩ true;
    };
    
    // Run a task using natural language
    self.run_task = λ(task_description) {
        // 1. Generate a plan using the planner
        ι anarchy_code = self.planner.generate_plan(task_description);
        
        // 2. Execute the plan using the executor
        ι result = self.executor.execute_code(anarchy_code);
        
        // 3. Store the result in memory
        self.memory.store_result(task_description, anarchy_code, result);
        
        ↩ result;
    };
    
    // Run Anarchy-Inference code directly
    self.run_code = λ(code) {
        ↩ self.executor.execute_code(code);
    };
    
    // Shutdown the core module
    self.shutdown = λ() {
        // Shutdown all components in reverse order
        self.system.shutdown();
        self.browser.shutdown();
        self.executor.shutdown();
        self.planner.shutdown();
        self.memory.shutdown();
        
        ↩ true;
    };
    
    ↩ self;
}

// Export the module
⟼(Core);
