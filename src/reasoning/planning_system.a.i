// planning_system.a.i - Task planning system for Anarchy Agent
// Implements hierarchical planning for complex tasks

// Define string dictionary entries for planning system
📝("plan_init", "Initializing planning system...");
📝("plan_create", "Creating plan for task: {}");
📝("plan_execute", "Executing plan for task: {}");
📝("plan_step", "Executing plan step {}: {}");
📝("plan_update", "Updating plan: {}");
📝("plan_complete", "Plan completed: {}");
📝("plan_error", "Planning error: {}");

// Planning System Module Definition
λPlanningSystem {
    // Initialize planning system
    ƒinitialize(αoptions) {
        ⌽(:plan_init);
        
        // Set default options
        ιthis.options = options || {};
        ιthis.options.max_steps = this.options.max_steps || 20;
        ιthis.options.max_depth = this.options.max_depth || 3;
        ιthis.options.llm_integration = this.options.llm_integration || null;
        ιthis.options.chain_of_thought = this.options.chain_of_thought || null;
        
        // Initialize planning state
        ιthis.current_plan = null;
        ιthis.plan_history = [];
        ιthis.status = "idle";
        
        ⟼(⊤);
    }
    
    // Create a plan for a task
    ƒcreate_plan(σtask, αoptions) {
        ⌽(:plan_create, task);
        
        ÷{
            // Set planning options
            ιplanning_options = options || {};
            ιmax_steps = planning_options.max_steps || this.options.max_steps;
            ιdetailed = planning_options.detailed || ⊤;
            ιuse_reasoning = planning_options.use_reasoning !== undefined ? 
                            planning_options.use_reasoning : ⊤;
            
            // Check if LLM integration is available
            if (!this.options.llm_integration) {
                ⌽(:plan_error, "LLM integration not available");
                ⟼(null);
            }
            
            // Use chain of thought reasoning if available and requested
            ιreasoning = null;
            if (use_reasoning && this.options.chain_of_thought) {
                reasoning = this.options.chain_of_thought.reason(task, {
                    detailed: ⊥ // Just get the conclusion
                });
            }
            
            // Create plan structure
            ιplan = {
                task: task,
                created_at: Date.now(),
                steps: [],
                dependencies: {},
                status: "created",
                reasoning: reasoning,
                metadata: planning_options.metadata || {}
            };
            
            // Generate plan steps
            ιsteps = this._generate_plan_steps(task, reasoning, max_steps);
            plan.steps = steps;
            
            // Generate dependencies between steps
            plan.dependencies = this._generate_dependencies(steps);
            
            // Store as current plan
            this.current_plan = plan;
            
            // Add to plan history
            ＋(this.plan_history, plan);
            
            // Return the plan
            ⟼(plan);
        }{
            ⌽(:plan_error, "Failed to create plan");
            ⟼(null);
        }
    }
    
    // Execute the current plan
    ƒexecute_plan(αexecution_context, αoptions) {
        ÷{
            // Check if there is a current plan
            if (!this.current_plan) {
                ⌽(:plan_error, "No current plan to execute");
                ⟼(null);
            }
            
            ⌽(:plan_execute, this.current_plan.task);
            
            // Set execution options
            ιexecution_options = options || {};
            ιstop_on_error = execution_options.stop_on_error !== undefined ? 
                            execution_options.stop_on_error : ⊤;
            ιexecute_function = execution_options.execute_function || null;
            
            // Update plan status
            this.current_plan.status = "executing";
            this.current_plan.started_at = Date.now();
            
            // Initialize results
            ιresults = [];
            
            // Get execution order based on dependencies
            ιexecution_order = this._get_execution_order(this.current_plan.steps, this.current_plan.dependencies);
            
            // Execute each step in order
            for (ιi = 0; i < execution_order.length; i++) {
                ιstep_index = execution_order[i];
                ιstep = this.current_plan.steps[step_index];
                
                ⌽(:plan_step, step_index + 1, step.description);
                
                // Mark step as executing
                step.status = "executing";
                step.started_at = Date.now();
                
                // Execute step
                ιstep_result = null;
                if (execute_function) {
                    // Use provided execution function
                    step_result = execute_function(step, execution_context, this.current_plan);
                } else {
                    // Default execution (just mark as completed)
                    step_result = { success: ⊤, output: `Executed step: ${step.description}` };
                }
                
                // Update step status
                step.completed_at = Date.now();
                step.result = step_result;
                
                if (step_result && step_result.success) {
                    step.status = "completed";
                } else {
                    step.status = "failed";
                    if (stop_on_error) {
                        this.current_plan.status = "failed";
                        ⟼({
                            success: ⊥,
                            plan: this.current_plan,
                            results: results,
                            error: `Failed at step ${step_index + 1}: ${step.description}`
                        });
                    }
                }
                
                // Add to results
                ＋(results, {
                    step_index: step_index,
                    step: step,
                    result: step_result
                });
            }
            
            // Update plan status
            this.current_plan.status = "completed";
            this.current_plan.completed_at = Date.now();
            
            ⌽(:plan_complete, this.current_plan.task);
            
            // Return results
            ⟼({
                success: ⊤,
                plan: this.current_plan,
                results: results
            });
        }{
            ⌽(:plan_error, "Failed to execute plan");
            if (this.current_plan) {
                this.current_plan.status = "failed";
            }
            ⟼({
                success: ⊥,
                plan: this.current_plan,
                error: "Plan execution failed"
            });
        }
    }
    
    // Update the current plan
    ƒupdate_plan(σtask, αoptions) {
        ⌽(:plan_update, task);
        
        ÷{
            // Check if there is a current plan
            if (!this.current_plan) {
                ⟼(this.create_plan(task, options));
            }
            
            // Set update options
            ιupdate_options = options || {};
            ιpreserve_completed = update_options.preserve_completed !== undefined ? 
                                update_options.preserve_completed : ⊤;
            
            // Create a new plan
            ιnew_plan = this.create_plan(task, options);
            
            if (!new_plan) {
                ⌽(:plan_error, "Failed to create updated plan");
                ⟼(null);
            }
            
            // If preserving completed steps, copy status from old plan
            if (preserve_completed) {
                ∀(this.current_plan.steps, λold_step, ιold_index {
                    if (old_step.status === "completed") {
                        // Find matching step in new plan
                        ∀(new_plan.steps, λnew_step, ιnew_index {
                            if (new_step.description === old_step.description) {
                                new_step.status = "completed";
                                new_step.started_at = old_step.started_at;
                                new_step.completed_at = old_step.completed_at;
                                new_step.result = old_step.result;
                            }
                        });
                    }
                });
            }
            
            // Store as current plan
            this.current_plan = new_plan;
            
            // Return the updated plan
            ⟼(new_plan);
        }{
            ⌽(:plan_error, "Failed to update plan");
            ⟼(null);
        }
    }
    
    // Get the current plan
    ƒget_current_plan() {
        ⟼(this.current_plan);
    }
    
    // Get plan history
    ƒget_plan_history() {
        ⟼(this.plan_history);
    }
    
    // Get formatted plan
    ƒget_formatted_plan(αplan) {
        ιtarget_plan = plan || this.current_plan;
        
        if (!target_plan) {
            ⟼("No plan available");
        }
        
        ⟼(this._format_plan(target_plan));
    }
    
    // Private: Generate plan steps
    ƒ_generate_plan_steps(σtask, σreasoning, ιmax_steps) {
        // Use LLM to generate plan steps
        ιprompt = `You are creating a detailed plan for an AI assistant that uses the Anarchy Inference language.

Task: ${task}
${reasoning ? `\nReasoning: ${reasoning}` : ""}

Create a step-by-step plan to accomplish this task. For each step, provide:
1. A clear, specific description of what needs to be done
2. The expected output or result of the step
3. Any tools or functions that might be needed
4. Estimated complexity (1-5 scale)

Provide between 5-${max_steps} steps, depending on task complexity. Each step should be focused and achievable.
Format each step as a numbered item with the description.`;
        
        ιplan_text = this.options.llm_integration.generate_response(prompt, {
            temperature: 0.5
        });
        
        // Parse steps from the response
        ιsteps = [];
        
        if (plan_text) {
            // Simple regex to extract numbered items
            ιstep_regex = /\d+\.\s+(.*?)(?=\n\d+\.|\n\n|$)/gs;
            ιmatches = plan_text.matchAll(step_regex);
            
            for (ιmatch of matches) {
                if (match[1]) {
                    ＋(steps, {
                        description: match[1].trim(),
                        status: "pending",
                        dependencies: []
                    });
                }
            }
        }
        
        // If parsing failed, create generic steps
        if (steps.length === 0) {
            steps = [
                { description: "Analyze requirements", status: "pending", dependencies: [] },
                { description: "Design solution approach", status: "pending", dependencies: [] },
                { description: "Implement solution", status: "pending", dependencies: [] },
                { description: "Test implementation", status: "pending", dependencies: [] },
                { description: "Finalize and document", status: "pending", dependencies: [] }
            ];
        }
        
        ⟼(steps);
    }
    
    // Private: Generate dependencies between steps
    ƒ_generate_dependencies(αsteps) {
        ιdependencies = {};
        
        // By default, each step depends on the previous step
        for (ιi = 1; i < steps.length; i++) {
            dependencies[i] = [i - 1];
        }
        
        ⟼(dependencies);
    }
    
    // Private: Get execution order based on dependencies
    ƒ_get_execution_order(αsteps, αdependencies) {
        // Initialize variables
        ιexecution_order = [];
        ιvisited = new Array(steps.length).fill(⊥);
        ιtemp_visited = new Array(steps.length).fill(⊥);
        
        // Topological sort function
        ƒvisit(ιnode) {
            // If node is in temporary visited set, we have a cycle
            if (temp_visited[node]) {
                ⟼(⊥); // Cycle detected
            }
            
            // If node is not visited yet
            if (!visited[node]) {
                // Mark as temporarily visited
                temp_visited[node] = ⊤;
                
                // Visit all dependencies
                ιdeps = dependencies[node] || [];
                for (ιi = 0; i < deps.length; i++) {
                    ιdep = deps[i];
                    if (!visit(dep)) {
                        ⟼(⊥); // Cycle detected
                    }
                }
                
                // Mark as visited
                temp_visited[node] = ⊥;
                visited[node] = ⊤;
                
                // Add to execution order
                execution_order.push(node);
            }
            
            ⟼(⊤);
        }
        
        // Visit all nodes
        for (ιi = 0; i < steps.length; i++) {
            if (!visited[i]) {
                if (!visit(i)) {
                    // Cycle detected, fall back to sequential execution
                    execution_order = [];
                    for (ιj = 0; j < steps.length; j++) {
                        execution_order.push(j);
                    }
                    ⟼(execution_order);
                }
            }
        }
        
        ⟼(execution_order);
    }
    
    // Private: Format plan for output
    ƒ_format_plan(αplan) {
        ιformatted = `# Plan: ${plan.task}\n\n`;
        
        // Add metadata
        formatted += `Created: ${new Date(plan.created_at).toISOString()}\n`;
        formatted += `Status: ${plan.status}\n\n`;
        
        // Add reasoning if available
        if (plan.reasoning) {
            formatted += `## Reasoning\n${plan.reasoning}\n\n`;
        }
        
        // Add steps
        formatted += `## Steps\n\n`;
        
        ∀(plan.steps, λstep, ιindex {
            ιstatus_icon = step.status === "completed" ? "✅" : 
                          step.status === "executing" ? "⏳" : 
                          step.status === "failed" ? "❌" : "⬜";
            
            formatted += `${status_icon} **Step ${index + 1}**: ${step.description}\n`;
            
            // Add dependencies
            ιdeps = plan.dependencies[index] || [];
            if (deps.length > 0) {
                formatted += `   Dependencies: `;
                ∀(deps, λdep, ιdep_index {
                    formatted += `Step ${dep + 1}${dep_index < deps.length - 1 ? ", " : ""}`;
                });
                formatted += `\n`;
            }
            
            // Add result if available
            if (step.result) {
                formatted += `   Result: ${step.result.success ? "Success" : "Failed"}\n`;
                if (step.result.output) {
                    formatted += `   Output: ${step.result.output.substring(0, 100)}${step.result.output.length > 100 ? "..." : ""}\n`;
                }
            }
            
            formatted += `\n`;
        });
        
        ⟼(formatted);
    }
}

// Export the PlanningSystem module
⟼(PlanningSystem);
