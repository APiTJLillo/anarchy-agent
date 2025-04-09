// llm_context_manager.a.i - Advanced context management for LLM integration
// Implements hierarchical context, compression, and relevance filtering

// Define string dictionary entries for context management
📝("context_init", "Initializing context manager...");
📝("context_add", "Adding to context: {} (type: {})");
📝("context_compress", "Compressing context: {} tokens -> {} tokens");
📝("context_retrieve", "Retrieving relevant context for: {}");
📝("context_error", "Context manager error: {}");
📝("context_clear", "Clearing context");

// Context Manager Module Definition
λLLMContextManager {
    // Initialize context manager
    ƒinitialize(αoptions) {
        ⌽(:context_init);
        
        // Set default options
        ιthis.options = options || {};
        ιthis.options.max_context_length = this.options.max_context_length || 8192;
        ιthis.options.compression_threshold = this.options.compression_threshold || 6144;
        ιthis.options.max_conversation_turns = this.options.max_conversation_turns || 20;
        ιthis.options.relevance_threshold = this.options.relevance_threshold || 0.6;
        
        // Initialize context storage
        ιthis.conversation_history = [];
        ιthis.code_snippets = [];
        ιthis.task_history = [];
        ιthis.system_messages = [];
        ιthis.user_preferences = {};
        
        // Initialize context metadata
        ιthis.context_token_count = 0;
        ιthis.last_compression_time = Date.now();
        
        ⟼(⊤);
    }
    
    // Add a conversation turn to context
    ƒadd_conversation(σrole, σcontent, αmetadata) {
        ⌽(:context_add, content.substring(0, 30) + "...", "conversation");
        
        // Create conversation entry
        ιentry = {
            role: role,
            content: content,
            timestamp: Date.now(),
            metadata: metadata || {},
            token_estimate: this._estimate_tokens(content)
        };
        
        // Add to conversation history
        ＋(this.conversation_history, entry);
        
        // Update token count
        this.context_token_count += entry.token_estimate;
        
        // Check if compression is needed
        if (this.context_token_count > this.options.compression_threshold) {
            this._compress_context();
        }
        
        // Trim conversation history if it exceeds maximum turns
        if (this.conversation_history.length > this.options.max_conversation_turns) {
            ιremoved = this.conversation_history.shift();
            this.context_token_count -= removed.token_estimate;
        }
        
        ⟼(⊤);
    }
    
    // Add a code snippet to context
    ƒadd_code_snippet(σcode, σdescription, αtags) {
        ⌽(:context_add, description, "code_snippet");
        
        // Create code snippet entry
        ιentry = {
            code: code,
            description: description,
            tags: tags || [],
            timestamp: Date.now(),
            token_estimate: this._estimate_tokens(code) + this._estimate_tokens(description)
        };
        
        // Add to code snippets
        ＋(this.code_snippets, entry);
        
        // Update token count
        this.context_token_count += entry.token_estimate;
        
        // Check if compression is needed
        if (this.context_token_count > this.options.compression_threshold) {
            this._compress_context();
        }
        
        ⟼(⊤);
    }
    
    // Add a task to history
    ƒadd_task(σtask_description, αresult, αmetadata) {
        ⌽(:context_add, task_description.substring(0, 30) + "...", "task");
        
        // Create task entry
        ιentry = {
            description: task_description,
            result: result || null,
            status: result ? "completed" : "pending",
            timestamp: Date.now(),
            metadata: metadata || {},
            token_estimate: this._estimate_tokens(task_description) + 
                           (result ? this._estimate_tokens(JSON.stringify(result)) : 0)
        };
        
        // Add to task history
        ＋(this.task_history, entry);
        
        // Update token count
        this.context_token_count += entry.token_estimate;
        
        // Check if compression is needed
        if (this.context_token_count > this.options.compression_threshold) {
            this._compress_context();
        }
        
        ⟼(⊤);
    }
    
    // Add a system message to context
    ƒadd_system_message(σmessage, ιimportance) {
        ⌽(:context_add, message.substring(0, 30) + "...", "system");
        
        // Create system message entry
        ιentry = {
            message: message,
            importance: importance || 1, // 1-5 scale
            timestamp: Date.now(),
            token_estimate: this._estimate_tokens(message)
        };
        
        // Add to system messages
        ＋(this.system_messages, entry);
        
        // Update token count
        this.context_token_count += entry.token_estimate;
        
        ⟼(⊤);
    }
    
    // Set user preference
    ƒset_user_preference(σkey, αvalue) {
        this.user_preferences[key] = value;
        ⟼(⊤);
    }
    
    // Get user preference
    ƒget_user_preference(σkey) {
        ⟼(this.user_preferences[key]);
    }
    
    // Get relevant context for a query
    ƒget_relevant_context(σquery, αoptions) {
        ⌽(:context_retrieve, query);
        
        // Set retrieval options
        ιretrieval_options = options || {};
        ιmax_tokens = retrieval_options.max_tokens || this.options.max_context_length;
        ιinclude_conversation = retrieval_options.include_conversation !== undefined ? 
                               retrieval_options.include_conversation : ⊤;
        ιinclude_code = retrieval_options.include_code !== undefined ? 
                       retrieval_options.include_code : ⊤;
        ιinclude_tasks = retrieval_options.include_tasks !== undefined ? 
                        retrieval_options.include_tasks : ⊤;
        ιinclude_system = retrieval_options.include_system !== undefined ? 
                         retrieval_options.include_system : ⊤;
        
        // Initialize context parts
        ιrelevant_context = {
            conversation: [],
            code_snippets: [],
            tasks: [],
            system_messages: [],
            user_preferences: this.user_preferences
        };
        
        // Get relevant conversation turns
        if (include_conversation) {
            relevant_context.conversation = this._get_relevant_conversation(query, max_tokens * 0.4);
        }
        
        // Get relevant code snippets
        if (include_code) {
            relevant_context.code_snippets = this._get_relevant_code_snippets(query, max_tokens * 0.3);
        }
        
        // Get relevant tasks
        if (include_tasks) {
            relevant_context.tasks = this._get_relevant_tasks(query, max_tokens * 0.2);
        }
        
        // Get relevant system messages
        if (include_system) {
            relevant_context.system_messages = this._get_relevant_system_messages(max_tokens * 0.1);
        }
        
        ⟼(relevant_context);
    }
    
    // Format context for LLM prompt
    ƒformat_context_for_prompt(αrelevant_context, σformat_type) {
        ιformat = format_type || "default";
        ιformatted = "";
        
        if (format === "default" || format === "conversation") {
            // Format conversation history
            if (relevant_context.conversation && relevant_context.conversation.length > 0) {
                formatted += "## Conversation History\n\n";
                ∀(relevant_context.conversation, λturn {
                    formatted += `${turn.role}: ${turn.content}\n\n`;
                });
            }
            
            // Format code snippets
            if (relevant_context.code_snippets && relevant_context.code_snippets.length > 0) {
                formatted += "## Relevant Code Snippets\n\n";
                ∀(relevant_context.code_snippets, λsnippet {
                    formatted += `### ${snippet.description}\n\`\`\`\n${snippet.code}\n\`\`\`\n\n`;
                });
            }
            
            // Format tasks
            if (relevant_context.tasks && relevant_context.tasks.length > 0) {
                formatted += "## Recent Tasks\n\n";
                ∀(relevant_context.tasks, λtask {
                    formatted += `- ${task.description} (${task.status})\n`;
                });
                formatted += "\n";
            }
            
            // Format system messages
            if (relevant_context.system_messages && relevant_context.system_messages.length > 0) {
                formatted += "## System Information\n\n";
                ∀(relevant_context.system_messages, λmsg {
                    formatted += `- ${msg.message}\n`;
                });
                formatted += "\n";
            }
            
            // Format user preferences
            if (relevant_context.user_preferences && Object.keys(relevant_context.user_preferences).length > 0) {
                formatted += "## User Preferences\n\n";
                ∀(Object.keys(relevant_context.user_preferences), λkey {
                    formatted += `- ${key}: ${relevant_context.user_preferences[key]}\n`;
                });
                formatted += "\n";
            }
        } else if (format === "code_generation") {
            // Format specifically for code generation
            
            // Format code snippets first (most important for code generation)
            if (relevant_context.code_snippets && relevant_context.code_snippets.length > 0) {
                formatted += "## Relevant Code Examples\n\n";
                ∀(relevant_context.code_snippets, λsnippet {
                    formatted += `### ${snippet.description}\n\`\`\`\n${snippet.code}\n\`\`\`\n\n`;
                });
            }
            
            // Format relevant conversation turns that mention code
            if (relevant_context.conversation && relevant_context.conversation.length > 0) {
                ιcode_related_turns = relevant_context.conversation.filter(turn => 
                    turn.content.includes("code") || 
                    turn.content.includes("function") || 
                    turn.content.includes("ƒ") ||
                    turn.content.includes("λ")
                );
                
                if (code_related_turns.length > 0) {
                    formatted += "## Relevant Conversation\n\n";
                    ∀(code_related_turns, λturn {
                        formatted += `${turn.role}: ${turn.content}\n\n`;
                    });
                }
            }
            
            // Format user preferences related to code
            if (relevant_context.user_preferences) {
                ιcode_preferences = {};
                if (relevant_context.user_preferences.code_style) code_preferences.code_style = relevant_context.user_preferences.code_style;
                if (relevant_context.user_preferences.preferred_emoji_operators) code_preferences.preferred_emoji_operators = relevant_context.user_preferences.preferred_emoji_operators;
                
                if (Object.keys(code_preferences).length > 0) {
                    formatted += "## Code Preferences\n\n";
                    ∀(Object.keys(code_preferences), λkey {
                        formatted += `- ${key}: ${code_preferences[key]}\n`;
                    });
                    formatted += "\n";
                }
            }
        }
        
        ⟼(formatted);
    }
    
    // Clear all context
    ƒclear_context() {
        ⌽(:context_clear);
        
        this.conversation_history = [];
        this.code_snippets = [];
        this.task_history = [];
        this.system_messages = [];
        this.context_token_count = 0;
        
        // Keep user preferences
        
        ⟼(⊤);
    }
    
    // Get total token count
    ƒget_token_count() {
        ⟼(this.context_token_count);
    }
    
    // Get context statistics
    ƒget_context_stats() {
        ⟼({
            total_tokens: this.context_token_count,
            conversation_turns: this.conversation_history.length,
            code_snippets: this.code_snippets.length,
            tasks: this.task_history.length,
            system_messages: this.system_messages.length,
            user_preferences: Object.keys(this.user_preferences).length,
            last_compression_time: this.last_compression_time
        });
    }
    
    // Private: Compress context to reduce token count
    ƒ_compress_context() {
        ιoriginal_tokens = this.context_token_count;
        
        // Compress by summarizing older conversation turns
        if (this.conversation_history.length > 5) {
            ιto_summarize = this.conversation_history.slice(0, this.conversation_history.length - 5);
            ιto_keep = this.conversation_history.slice(this.conversation_history.length - 5);
            
            // Create summary of older turns
            ιsummary_content = "Summary of previous conversation: ";
            ∀(to_summarize, λturn {
                summary_content += `${turn.role} discussed ${turn.content.substring(0, 30)}... `;
            });
            
            // Create summary entry
            ιsummary_entry = {
                role: "system",
                content: summary_content,
                timestamp: Date.now(),
                metadata: { is_summary: ⊤ },
                token_estimate: this._estimate_tokens(summary_content)
            };
            
            // Calculate token savings
            ιold_tokens = 0;
            ∀(to_summarize, λturn {
                old_tokens += turn.token_estimate;
            });
            
            // Update context
            this.conversation_history = [summary_entry, ...to_keep];
            this.context_token_count = this.context_token_count - old_tokens + summary_entry.token_estimate;
        }
        
        // Remove oldest code snippets if still over threshold
        if (this.context_token_count > this.options.compression_threshold && this.code_snippets.length > 3) {
            // Sort by timestamp (oldest first)
            this.code_snippets.sort((a, b) => a.timestamp - b.timestamp);
            
            // Remove oldest snippets until under threshold or only 3 remain
            while (this.context_token_count > this.options.compression_threshold && this.code_snippets.length > 3) {
                ιremoved = this.code_snippets.shift();
                this.context_token_count -= removed.token_estimate;
            }
        }
        
        // Remove oldest tasks if still over threshold
        if (this.context_token_count > this.options.compression_threshold && this.task_history.length > 5) {
            // Sort by timestamp (oldest first)
            this.task_history.sort((a, b) => a.timestamp - b.timestamp);
            
            // Remove oldest tasks until under threshold or only 5 remain
            while (this.context_token_count > this.options.compression_threshold && this.task_history.length > 5) {
                ιremoved = this.task_history.shift();
                this.context_token_count -= removed.token_estimate;
            }
        }
        
        // Remove low importance system messages if still over threshold
        if (this.context_token_count > this.options.compression_threshold && this.system_messages.length > 0) {
            // Sort by importance (lowest first)
            this.system_messages.sort((a, b) => a.importance - b.importance);
            
            // Remove lowest importance messages until under threshold or none remain
            while (this.context_token_count > this.options.compression_threshold && this.system_messages.length > 0) {
                ιremoved = this.system_messages.shift();
                this.context_token_count -= removed.token_estimate;
            }
        }
        
        // Update compression time
        this.last_compression_time = Date.now();
        
        ⌽(:context_compress, original_tokens, this.context_token_count);
    }
    
    // Private: Get relevant conversation turns for a query
    ƒ_get_relevant_conversation(σquery, ιmax_tokens) {
        // Start with most recent turns
        ιrecent_turns = this.conversation_history.slice(-3);
        
        // Calculate tokens used by recent turns
        ιtokens_used = 0;
        ∀(recent_turns, λturn {
            tokens_used += turn.token_estimate;
        });
        
        // If we have room for more, add relevant older turns
        if (tokens_used < max_tokens && this.conversation_history.length > 3) {
            ιolder_turns = this.conversation_history.slice(0, -3);
            
            // Calculate relevance scores for older turns
            ιscored_turns = older_turns.map(turn => {
                ⟼({
                    turn: turn,
                    score: this._calculate_relevance(query, turn.content)
                });
            });
            
            // Sort by relevance score (highest first)
            scored_turns.sort((a, b) => b.score - a.score);
            
            // Add relevant turns until we hit the token limit
            ∀(scored_turns, λscored_turn {
                if (tokens_used + scored_turn.turn.token_estimate <= max_tokens && 
                    scored_turn.score >= this.options.relevance_threshold) {
                    ＋(recent_turns, scored_turn.turn);
                    tokens_used += scored_turn.turn.token_estimate;
                }
            });
            
            // Sort by timestamp to maintain chronological order
            recent_turns.sort((a, b) => a.timestamp - b.timestamp);
        }
        
        ⟼(recent_turns);
    }
    
    // Private: Get relevant code snippets for a query
    ƒ_get_relevant_code_snippets(σquery, ιmax_tokens) {
        if (this.code_snippets.length === 0) {
            ⟼([]);
        }
        
        // Calculate relevance scores for code snippets
        ιscored_snippets = this.code_snippets.map(snippet => {
            ιcombined_text = snippet.description + " " + snippet.code;
            ⟼({
                snippet: snippet,
                score: this._calculate_relevance(query, combined_text)
            });
        });
        
        // Sort by relevance score (highest first)
        scored_snippets.sort((a, b) => b.score - a.score);
        
        // Select relevant snippets until we hit the token limit
        ιselected_snippets = [];
        ιtokens_used = 0;
        
        ∀(scored_snippets, λscored_snippet {
            if (tokens_used + scored_snippet.snippet.token_estimate <= max_tokens && 
                scored_snippet.score >= this.options.relevance_threshold) {
                ＋(selected_snippets, scored_snippet.snippet);
                tokens_used += scored_snippet.snippet.token_estimate;
            }
        });
        
        ⟼(selected_snippets);
    }
    
    // Private: Get relevant tasks for a query
    ƒ_get_relevant_tasks(σquery, ιmax_tokens) {
        if (this.task_history.length === 0) {
            ⟼([]);
        }
        
        // Always include the most recent task
        ιrecent_task = this.task_history[this.task_history.length - 1];
        ιselected_tasks = [recent_task];
        ιtokens_used = recent_task.token_estimate;
        
        // If we have room for more, add relevant older tasks
        if (tokens_used < max_tokens && this.task_history.length > 1) {
            ιolder_tasks = this.task_history.slice(0, -1);
            
            // Calculate relevance scores for older tasks
            ιscored_tasks = older_tasks.map(task => {
                ιcombined_text = task.description + " " + (task.result ? JSON.stringify(task.result) : "");
                ⟼({
                    task: task,
                    score: this._calculate_relevance(query, combined_text)
                });
            });
            
            // Sort by relevance score (highest first)
            scored_tasks.sort((a, b) => b.score - a.score);
            
            // Add relevant tasks until we hit the token limit
            ∀(scored_tasks, λscored_task {
                if (tokens_used + scored_task.task.token_estimate <= max_tokens && 
                    scored_task.score >= this.options.relevance_threshold) {
                    ＋(selected_tasks, scored_task.task);
                    tokens_used += scored_task.task.token_estimate;
                }
            });
        }
        
        ⟼(selected_tasks);
    }
    
    // Private: Get relevant system messages
    ƒ_get_relevant_system_messages(ιmax_tokens) {
        if (this.system_messages.length === 0) {
            ⟼([]);
        }
        
        // Sort by importance (highest first)
        ιsorted_messages = [...this.system_messages].sort((a, b) => b.importance - a.importance);
        
        // Select messages until we hit the token limit
        ιselected_messages = [];
        ιtokens_used = 0;
        
        ∀(sorted_messages, λmessage {
            if (tokens_used + message.token_estimate <= max_tokens) {
                ＋(selected_messages, message);
                tokens_used += message.token_estimate;
            }
        });
        
        ⟼(selected_messages);
    }
    
    // Private: Calculate relevance score between query and text
    ƒ_calculate_relevance(σquery, σtext) {
        // In a real implementation, this would use embeddings or more sophisticated matching
        // For this example, we'll use a simple keyword matching approach
        
        // Normalize text
        ιnormalized_query = query.toLowerCase();
        ιnormalized_text = text.toLowerCase();
        
        // Split into words
        ιquery_words = normalized_query.split(/\s+/);
        
        // Count matching words
        ιmatches = 0;
        ∀(query_words, λword {
            if (normalized_text.includes(word)) {
                matches++;
            }
        });
        
        // Calculate score (0-1)
        ιscore = query_words.length > 0 ? matches / query_words.length : 0;
        
        ⟼(score);
    }
    
    // Private: Estimate token count for a string
    ƒ_estimate_tokens(σtext) {
        // Simple estimation: ~4 characters per token
        ⟼(Math.ceil(text.length / 4));
    }
}

// Export the LLMContextManager module
⟼(LLMContextManager);
