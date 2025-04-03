// Load the string dictionary
🔠("string_dictionary.json");

// Agent module for the Anarchy Agent
// This module coordinates all components of the agent

// Configuration structure
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

// Create a new agent with all components
ƒnew(config, planner, executor, memory, browser, file_system, shell) {
    ↩ {
        config: config,
        planner: planner,
        executor: executor,
        memory: memory,
        browser: browser,
        file_system: file_system,
        shell: shell
    };
}

// Run the agent based on the configuration
ƒrun(agent) {
    ↪(agent.config.repl_mode) {
        ↩ run_repl(agent);
    } ↪(agent.config.file_path) {
        ↩ run_file(agent, agent.config.file_path);
    } ↛ {
        ↩ {
            success: false,
            error: :no_input_file
        };
    }
}

// Run the agent in REPL mode
ƒrun_repl(agent) {
    ⌽(:repl_start);
    ⌽(:repl_exit_instructions);
    
    ↻(true) {
        ⌽("> ");
        ι input = !("read line").o.trim();
        
        ↪(input == "exit" || input == "quit") {
            ↵;
        }
        
        // Process the input through the planning and execution pipeline
        ι result = process_input(agent, input);
        
        ↪(result.success) {
            ⌽(result.output);
        } ↛ {
            ⌽(:error_prefix + result.error);
        }
    }
    
    ⌽(:repl_ended);
    ↩ {
        success: true,
        error: null
    };
}

// Run the agent with a file input
ƒrun_file(agent, file_path) {
    ↪(agent.config.verbose) {
        ⌽(:running_file + file_path);
    }
    
    ι file_exists = !("test -f " + file_path + " && echo 'true' || echo 'false'").o;
    ↪(file_exists != "true") {
        ↩ {
            success: false,
            error: :file_not_found + file_path
        };
    }
    
    ι content = !("cat " + file_path).o;
    
    // Process the file content through the planning and execution pipeline
    ι result = process_input(agent, content);
    
    ↪(agent.config.verbose && result.success) {
        ⌽(:execution_result + result.output);
    }
    
    ↩ result;
}

// Process input through the planning and execution pipeline
ƒprocess_input(agent, input) {
    // 1. Use the planner to generate Anarchy-Inference code
    ι plan_result = agent.planner.plan(input);
    
    ↪(!plan_result.success) {
        ↩ {
            success: false,
            error: plan_result.error
        };
    }
    
    // 2. Store the plan in memory
    ι store_result = agent.memory.store_plan(plan_result.plan);
    
    ↪(!store_result.success) {
        ↩ {
            success: false,
            error: store_result.error
        };
    }
    
    // 3. Execute the plan using the executor
    ι exec_result = agent.executor.execute(plan_result.plan);
    
    ↪(!exec_result.success) {
        ↩ {
            success: false,
            error: exec_result.error
        };
    }
    
    // 4. Store the result in memory
    ι mem_result = agent.memory.store_result(exec_result.output);
    
    ↪(!mem_result.success) {
        ↩ {
            success: false,
            error: mem_result.error
        };
    }
    
    ↩ {
        success: true,
        output: exec_result.output
    };
}
