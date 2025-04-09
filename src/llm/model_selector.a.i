// model_selector.a.i - Intelligent model selection for LLM integration
// Implements automatic model selection based on task complexity and requirements

// Define string dictionary entries for model selection
📝("model_init", "Initializing model selector...");
📝("model_analyze", "Analyzing task: {}");
📝("model_select", "Selected model: {} for task: {}");
📝("model_error", "Model selection error: {}");
📝("model_register", "Registered model: {}");

// Model Selector Module Definition
λModelSelector {
    // Initialize model selector
    ƒinitialize(αoptions) {
        ⌽(:model_init);
        
        // Set default options
        ιthis.options = options || {};
        ιthis.options.default_model = this.options.default_model || "default";
        ιthis.options.models_dir = this.options.models_dir || "./models";
        
        // Initialize model registry
        ιthis.models = {};
        ιthis.task_history = [];
        ιthis.performance_metrics = {};
        
        // Load available models
        this._discover_models();
        
        ⟼(⊤);
    }
    
    // Register a model with capabilities
    ƒregister_model(σmodel_name, αcapabilities) {
        ⌽(:model_register, model_name);
        
        // Create model entry
        ιmodel = {
            name: model_name,
            path: `${this.options.models_dir}/${model_name}`,
            capabilities: capabilities || {},
            performance: {
                success_rate: 0,
                average_latency: 0,
                calls: 0
            }
        };
        
        // Set default capabilities if not provided
        if (!model.capabilities.parameters) {
            model.capabilities.parameters = model_name.includes("7b") ? 7 : 
                                           model_name.includes("13b") ? 13 : 
                                           model_name.includes("70b") ? 70 : 
                                           model_name.includes("40b") ? 40 : 1;
        }
        
        if (!model.capabilities.context_length) {
            model.capabilities.context_length = 4096;
        }
        
        if (!model.capabilities.strengths) {
            model.capabilities.strengths = [];
        }
        
        if (!model.capabilities.weaknesses) {
            model.capabilities.weaknesses = [];
        }
        
        if (!model.capabilities.quantization) {
            model.capabilities.quantization = model_name.includes("q4_0") ? "Q4_0" : 
                                             model_name.includes("q5_k") ? "Q5_K" : 
                                             model_name.includes("q8_0") ? "Q8_0" : "Unknown";
        }
        
        // Add to registry
        this.models[model_name] = model;
        
        ⟼(⊤);
    }
    
    // Select best model for a task
    ƒselect_model(σtask_description, αrequirements) {
        ⌽(:model_analyze, task_description);
        
        ÷{
            // Set default requirements
            ιtask_requirements = requirements || {};
            ιcomplexity = task_requirements.complexity || this._analyze_task_complexity(task_description);
            ιcontext_length = task_requirements.context_length || this._estimate_context_length(task_description);
            ιspeed_priority = task_requirements.speed_priority || ⊥;
            ιaccuracy_priority = task_requirements.accuracy_priority || ⊥;
            ιcode_generation = task_requirements.code_generation || task_description.includes("code") || task_description.includes("function");
            
            // If no models available, return default
            if (Object.keys(this.models).length === 0) {
                ⟼(this.options.default_model);
            }
            
            // Score each model based on requirements
            ιscored_models = [];
            
            ∀(Object.keys(this.models), λmodel_name {
                ιmodel = this.models[model_name];
                ιscore = 0;
                
                // Score based on parameter count vs. complexity
                if (complexity <= 2 && model.capabilities.parameters <= 7) {
                    score += 3;
                } else if (complexity <= 3 && model.capabilities.parameters <= 13) {
                    score += 4;
                } else if (complexity <= 4 && model.capabilities.parameters <= 40) {
                    score += 5;
                } else if (complexity >= 5 && model.capabilities.parameters >= 40) {
                    score += 6;
                } else {
                    score += 2;
                }
                
                // Score based on context length
                if (model.capabilities.context_length >= context_length) {
                    score += 3;
                } else {
                    score -= 2;
                }
                
                // Score based on speed priority
                if (speed_priority && model.capabilities.parameters <= 13) {
                    score += 3;
                }
                
                // Score based on accuracy priority
                if (accuracy_priority && model.capabilities.parameters >= 40) {
                    score += 3;
                }
                
                // Score based on code generation
                if (code_generation && model.capabilities.strengths.includes("code")) {
                    score += 4;
                }
                
                // Score based on past performance
                if (model.performance.calls > 0) {
                    score += model.performance.success_rate * 2;
                }
                
                ＋(scored_models, {
                    name: model_name,
                    score: score
                });
            });
            
            // Sort by score (highest first)
            scored_models.sort((a, b) => b.score - a.score);
            
            // Select highest scoring model
            ιselected_model = scored_models.length > 0 ? scored_models[0].name : this.options.default_model;
            
            // Record task for history
            this._record_task(task_description, selected_model, complexity);
            
            ⌽(:model_select, selected_model, task_description.substring(0, 30) + "...");
            ⟼(selected_model);
        }{
            ⌽(:model_error, "Failed to select model");
            ⟼(this.options.default_model);
        }
    }
    
    // Update model performance metrics
    ƒupdate_performance(σmodel_name, βsuccess, ιlatency) {
        if (!this.models[model_name]) {
            ⟼(⊥);
        }
        
        ιmodel = this.models[model_name];
        ιcurrent_calls = model.performance.calls;
        ιcurrent_success_rate = model.performance.success_rate;
        ιcurrent_latency = model.performance.average_latency;
        
        // Update metrics
        model.performance.calls += 1;
        model.performance.success_rate = (current_success_rate * current_calls + (success ? 1 : 0)) / model.performance.calls;
        model.performance.average_latency = (current_latency * current_calls + latency) / model.performance.calls;
        
        ⟼(⊤);
    }
    
    // Get model information
    ƒget_model_info(σmodel_name) {
        ⟼(this.models[model_name] || null);
    }
    
    // Get all available models
    ƒget_available_models() {
        ⟼(Object.keys(this.models));
    }
    
    // Get task history
    ƒget_task_history() {
        ⟼(this.task_history);
    }
    
    // Private: Discover available models
    ƒ_discover_models() {
        ÷{
            // Check if models directory exists
            ιexists = ?(this.options.models_dir);
            if (!exists) {
                !(`mkdir -p ${this.options.models_dir}`);
                ⟼(⊥);
            }
            
            // List files in models directory
            ιfiles = 📂(this.options.models_dir);
            
            // Register each model file
            ∀(files, λfile {
                if (file.endsWith(".gguf") || file.endsWith(".bin")) {
                    ιmodel_name = file.substring(0, file.lastIndexOf("."));
                    
                    // Infer capabilities from filename
                    ιcapabilities = {
                        parameters: model_name.includes("7b") ? 7 : 
                                   model_name.includes("13b") ? 13 : 
                                   model_name.includes("70b") ? 70 : 
                                   model_name.includes("40b") ? 40 : 1,
                        context_length: model_name.includes("32k") ? 32768 : 
                                       model_name.includes("16k") ? 16384 : 
                                       model_name.includes("8k") ? 8192 : 4096,
                        strengths: model_name.includes("code") ? ["code"] : [],
                        weaknesses: [],
                        quantization: model_name.includes("q4_0") ? "Q4_0" : 
                                     model_name.includes("q5_k") ? "Q5_K" : 
                                     model_name.includes("q8_0") ? "Q8_0" : "Unknown"
                    };
                    
                    this.register_model(model_name, capabilities);
                }
            });
            
            ⟼(⊤);
        }{
            ⌽(:model_error, "Failed to discover models");
            ⟼(⊥);
        }
    }
    
    // Private: Analyze task complexity
    ƒ_analyze_task_complexity(σtask_description) {
        // Simple heuristic based on task description length and keywords
        ιcomplexity = 1;
        
        // Length-based complexity
        if (task_description.length > 100) complexity += 1;
        if (task_description.length > 200) complexity += 1;
        
        // Keyword-based complexity
        ιcomplex_keywords = ["complex", "advanced", "difficult", "sophisticated", "intricate", "comprehensive"];
        ∀(complex_keywords, λkeyword {
            if (task_description.toLowerCase().includes(keyword)) {
                complexity += 1;
                ⟼(); // Break after first match
            }
        });
        
        // Feature-based complexity
        if (task_description.includes("browser") && task_description.includes("memory")) complexity += 1;
        if (task_description.includes("file") && task_description.includes("network")) complexity += 1;
        if (task_description.includes("code") && task_description.includes("generate")) complexity += 1;
        
        // Cap at 5
        ⟼(Math.min(complexity, 5));
    }
    
    // Private: Estimate required context length
    ƒ_estimate_context_length(σtask_description) {
        // Simple estimation based on task description
        ιbase_length = 2048; // Base context length
        
        // Adjust based on task description
        if (task_description.includes("history") || task_description.includes("previous")) {
            base_length += 2048;
        }
        
        if (task_description.includes("analyze") || task_description.includes("summarize")) {
            base_length += 4096;
        }
        
        if (task_description.includes("code") || task_description.includes("generate")) {
            base_length += 2048;
        }
        
        ⟼(base_length);
    }
    
    // Private: Record task for history
    ƒ_record_task(σtask_description, σselected_model, ιcomplexity) {
        ＋(this.task_history, {
            task: task_description,
            model: selected_model,
            complexity: complexity,
            timestamp: Date.now()
        });
        
        // Keep history limited to last 100 tasks
        if (this.task_history.length > 100) {
            this.task_history.shift();
        }
    }
}

// Export the ModelSelector module
⟼(ModelSelector);
