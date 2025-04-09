// tool_interface.a.i - Base tool interface for Anarchy Agent
// Implements the foundation for external tool interfaces

// Define string dictionary entries for tool interface
📝("tool_init", "Initializing tool interface...");
📝("tool_register", "Registering tool: {}");
📝("tool_execute", "Executing tool: {} with params: {}");
📝("tool_result", "Tool execution result: {}");
📝("tool_error", "Tool error: {}");

// Tool Interface Module Definition
λToolInterface {
    // Initialize tool interface
    ƒinitialize(αoptions) {
        ⌽(:tool_init);
        
        // Set default options
        ιthis.options = options || {};
        ιthis.options.max_retries = this.options.max_retries || 3;
        ιthis.options.timeout = this.options.timeout || 30000;
        
        // Initialize tool registry
        ιthis.tools = {};
        ιthis.execution_history = [];
        
        ⟼(⊤);
    }
    
    // Register a tool
    ƒregister_tool(σtool_name, αtool_config) {
        ⌽(:tool_register, tool_name);
        
        // Create tool entry
        ιtool = {
            name: tool_name,
            description: tool_config.description || "",
            execute: tool_config.execute || null,
            parameters: tool_config.parameters || [],
            required_parameters: tool_config.required_parameters || [],
            returns: tool_config.returns || {},
            category: tool_config.category || "general",
            permissions: tool_config.permissions || [],
            enabled: tool_config.enabled !== undefined ? tool_config.enabled : ⊤
        };
        
        // Add to registry
        this.tools[tool_name] = tool;
        
        ⟼(⊤);
    }
    
    // Execute a tool
    ƒexecute_tool(σtool_name, αparameters, αoptions) {
        ÷{
            // Check if tool exists
            if (!this.tools[tool_name]) {
                ⌽(:tool_error, `Tool not found: ${tool_name}`);
                ⟼({
                    success: ⊥,
                    error: `Tool not found: ${tool_name}`
                });
            }
            
            ιtool = this.tools[tool_name];
            
            // Check if tool is enabled
            if (!tool.enabled) {
                ⌽(:tool_error, `Tool is disabled: ${tool_name}`);
                ⟼({
                    success: ⊥,
                    error: `Tool is disabled: ${tool_name}`
                });
            }
            
            // Set execution options
            ιexecution_options = options || {};
            ιretries = execution_options.retries || this.options.max_retries;
            ιtimeout = execution_options.timeout || this.options.timeout;
            
            // Validate parameters
            ιvalidation_result = this._validate_parameters(tool, parameters);
            if (!validation_result.valid) {
                ⌽(:tool_error, validation_result.error);
                ⟼({
                    success: ⊥,
                    error: validation_result.error
                });
            }
            
            ⌽(:tool_execute, tool_name, JSON.stringify(parameters));
            
            // Execute tool with retries
            ιresult = null;
            ιerror = null;
            ιattempt = 0;
            
            while (attempt < retries) {
                attempt++;
                
                ÷{
                    // Execute tool function
                    if (tool.execute) {
                        result = tool.execute(parameters);
                    } else {
                        ⌽(:tool_error, `Tool has no execute function: ${tool_name}`);
                        error = `Tool has no execute function: ${tool_name}`;
                        break;
                    }
                    
                    // Success
                    break;
                }{
                    // Catch error
                    error = `Execution failed on attempt ${attempt}: ${error || "Unknown error"}`;
                    
                    // Continue to next retry
                    if (attempt < retries) {
                        ⌽(`Retrying tool execution (${attempt}/${retries})...`);
                    }
                }
            }
            
            // Record execution in history
            ιexecution_record = {
                tool: tool_name,
                parameters: parameters,
                result: result,
                error: error,
                success: result !== null && error === null,
                timestamp: Date.now(),
                attempts: attempt
            };
            
            ＋(this.execution_history, execution_record);
            
            // Return result
            if (result !== null) {
                ⌽(:tool_result, JSON.stringify(result).substring(0, 100) + "...");
                ⟼({
                    success: ⊤,
                    result: result
                });
            } else {
                ⌽(:tool_error, error);
                ⟼({
                    success: ⊥,
                    error: error
                });
            }
        }{
            ⌽(:tool_error, `Unexpected error executing tool: ${tool_name}`);
            ⟼({
                success: ⊥,
                error: `Unexpected error executing tool: ${tool_name}`
            });
        }
    }
    
    // Get tool information
    ƒget_tool_info(σtool_name) {
        ⟼(this.tools[tool_name] || null);
    }
    
    // Get all available tools
    ƒget_available_tools(σcategory) {
        if (category) {
            // Filter by category
            ιfiltered_tools = {};
            ∀(Object.keys(this.tools), λtool_name {
                if (this.tools[tool_name].category === category && this.tools[tool_name].enabled) {
                    filtered_tools[tool_name] = this.tools[tool_name];
                }
            });
            ⟼(filtered_tools);
        } else {
            // Return all enabled tools
            ιenabled_tools = {};
            ∀(Object.keys(this.tools), λtool_name {
                if (this.tools[tool_name].enabled) {
                    enabled_tools[tool_name] = this.tools[tool_name];
                }
            });
            ⟼(enabled_tools);
        }
    }
    
    // Enable a tool
    ƒenable_tool(σtool_name) {
        if (this.tools[tool_name]) {
            this.tools[tool_name].enabled = ⊤;
            ⟼(⊤);
        }
        ⟼(⊥);
    }
    
    // Disable a tool
    ƒdisable_tool(σtool_name) {
        if (this.tools[tool_name]) {
            this.tools[tool_name].enabled = ⊥;
            ⟼(⊤);
        }
        ⟼(⊥);
    }
    
    // Get execution history
    ƒget_execution_history(ιlimit) {
        ιmax_entries = limit || this.execution_history.length;
        ⟼(this.execution_history.slice(-max_entries));
    }
    
    // Private: Validate parameters against tool definition
    ƒ_validate_parameters(αtool, αparameters) {
        // Check required parameters
        ∀(tool.required_parameters, λrequired_param {
            if (parameters[required_param] === undefined) {
                ⟼({
                    valid: ⊥,
                    error: `Missing required parameter: ${required_param}`
                });
            }
        });
        
        // Check parameter types if defined
        ∀(tool.parameters, λparam_def {
            if (parameters[param_def.name] !== undefined) {
                // Check type if specified
                if (param_def.type) {
                    ιparam_value = parameters[param_def.name];
                    ιparam_type = typeof param_value;
                    
                    if (param_def.type === "string" && param_type !== "string") {
                        ⟼({
                            valid: ⊥,
                            error: `Parameter ${param_def.name} should be a string`
                        });
                    } else if (param_def.type === "number" && param_type !== "number") {
                        ⟼({
                            valid: ⊥,
                            error: `Parameter ${param_def.name} should be a number`
                        });
                    } else if (param_def.type === "boolean" && param_type !== "boolean") {
                        ⟼({
                            valid: ⊥,
                            error: `Parameter ${param_def.name} should be a boolean`
                        });
                    } else if (param_def.type === "array" && !Array.isArray(param_value)) {
                        ⟼({
                            valid: ⊥,
                            error: `Parameter ${param_def.name} should be an array`
                        });
                    } else if (param_def.type === "object" && (param_type !== "object" || Array.isArray(param_value))) {
                        ⟼({
                            valid: ⊥,
                            error: `Parameter ${param_def.name} should be an object`
                        });
                    }
                }
            }
        });
        
        // All validations passed
        ⟼({
            valid: ⊤
        });
    }
}

// Export the ToolInterface module
⟼(ToolInterface);
