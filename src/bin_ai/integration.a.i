// Main integration file for Anarchy-Agent components
// Load the string dictionary
🔠("string_dictionary.json");

// Import all modules
ι sandbox = ⟰("./sandbox");
ι parser = ⟰("./parser");
ι file = ⟰("./file");
ι shell = ⟰("./shell");
ι network = ⟰("./network");
ι db = ⟰("./db");
ι llm = ⟰("./llm");
ι browser = ⟰("./browser");

// Define the main integration module
ƒIntegration() {
    ι self = {};
    ι components = {};
    
    // Initialize all components
    self.initialize = λ(config) {
        ⌽(:initializing_core);
        
        // Create component instances
        components.sandbox = sandbox();
        components.parser = parser();
        components.file = file();
        components.shell = shell();
        components.network = network();
        components.db = db();
        components.llm = llm();
        components.browser = browser();
        
        // Initialize each component
        components.sandbox.initialize();
        components.parser.initialize();
        components.file.initialize();
        components.shell.initialize();
        components.network.initialize();
        components.db.initialize();
        components.llm.initialize(config);
        components.browser.initialize();
        
        // Register symbol handlers in the sandbox
        self.register_symbols();
        
        ⌽(:core_initialized);
        ↩ true;
    };
    
    // Register all symbol handlers in the sandbox
    self.register_symbols = λ() {
        // Register file system symbols
        components.sandbox.register("📂", components.file.list_directory);
        components.sandbox.register("📖", components.file.read_file);
        components.sandbox.register("✍", components.file.write_file);
        components.sandbox.register("✂", components.file.remove_path);
        components.sandbox.register("⧉", components.file.copy_file);
        components.sandbox.register("↷", components.file.move_file);
        components.sandbox.register("?", components.file.file_exists);
        
        // Register shell symbols
        components.sandbox.register("!", components.shell.execute);
        components.sandbox.register("🖥", components.shell.get_os_info);
        
        // Register network symbols
        components.sandbox.register("↗", components.network.http_get);
        components.sandbox.register("↓", components.network.http_post);
        
        // Register browser symbols
        components.sandbox.register("🌐", components.browser.open_page);
        components.sandbox.register("🖱", components.browser.click_element);
        components.sandbox.register("⌨", components.browser.input_text);
        components.sandbox.register("👁", components.browser.get_text);
        components.sandbox.register("🧠", components.browser.execute_js);
        components.sandbox.register("❌", components.browser.close);
        components.sandbox.register("📸", components.browser.take_screenshot);
        
        // Register memory symbols
        components.sandbox.register("📝", components.db.set_key_value);
        components.sandbox.register("📚", components.db.get_key_value);
        components.sandbox.register("🗑", components.db.delete_key_value);
        
        ↩ true;
    };
    
    // Execute Anarchy-Inference code
    self.execute = λ(code) {
        // 1. Parse the code
        ι parsed = components.parser.parse(code);
        
        // 2. Execute in sandbox
        ι result = components.sandbox.execute(parsed);
        
        ↩ result;
    };
    
    // Generate and execute code for a task
    self.run_task = λ(task_description) {
        // 1. Retrieve relevant context from memory
        ι context = components.db.query_relevant(task_description);
        
        // 2. Generate Anarchy-Inference code using the LLM
        ι prompt = `Task: ${task_description}\n\nContext: ${JSON.stringify(context)}\n\nGenerate Anarchy-Inference code to accomplish this task:`;
        ι anarchy_code = components.llm.generate(prompt);
        
        // 3. Execute the generated code
        ι result = self.execute(anarchy_code);
        
        // 4. Store the result in memory
        components.db.store_execution(task_description, anarchy_code, result);
        
        ↩ {
            task: task_description,
            code: anarchy_code,
            result: result
        };
    };
    
    // Shutdown all components
    self.shutdown = λ() {
        // Shutdown in reverse order of initialization
        components.browser.shutdown();
        components.llm.shutdown();
        components.db.shutdown();
        components.network.shutdown();
        components.shell.shutdown();
        components.file.shutdown();
        components.parser.shutdown();
        components.sandbox.shutdown();
        
        ↩ true;
    };
    
    // Get a specific component
    self.get_component = λ(name) {
        ↩ components[name];
    };
    
    ↩ self;
}

// Export the module
⟼(Integration);
