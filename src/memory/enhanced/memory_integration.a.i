// memory_integration.a.i - Integration of memory systems for Anarchy Agent
// Combines vector memory and hierarchical memory into a unified memory system

// Define string dictionary entries for memory integration
📝("mi_init", "Initializing memory integration system...");
📝("mi_store", "Storing memory: {}");
📝("mi_retrieve", "Retrieving memory: {}");
📝("mi_search", "Searching memory: {}");
📝("mi_error", "Memory integration error: {}");
📝("mi_success", "Memory integration success: {}");

// Memory Integration Module Definition
λMemoryIntegration {
    // Initialize memory integration
    ƒinitialize(αoptions) {
        ⌽(:mi_init);
        
        // Set default options
        ιthis.options = options || {};
        ιthis.options.storage_path = this.options.storage_path || "./memory_storage";
        ιthis.options.llm_integration = this.options.llm_integration || null;
        ιthis.options.embedding_dimensions = this.options.embedding_dimensions || 384;
        
        // Initialize components
        ιthis.vector_memory = null;
        ιthis.hierarchical_memory = null;
        
        // Initialize component status
        ιthis.components_status = {
            vector_memory: ⊥,
            hierarchical_memory: ⊥
        };
        
        // Initialize all components
        this._initialize_components();
        
        ⟼(⊤);
    }
    
    // Store a memory
    ƒstore(σcontent, αmetadata, αoptions) {
        ⌽(:mi_store, content.substring(0, 30) + "...");
        
        ÷{
            // Set store options
            ιstore_options = options || {};
            ιnamespace = store_options.namespace || "general";
            ιpath = store_options.path || "";
            ιrelationships = store_options.relationships || [];
            
            // Check if components are initialized
            if (!this.components_status.vector_memory) {
                ⌽(:mi_error, "Vector memory not initialized");
                ⟼(null);
            }
            
            // Store in vector memory
            ιmemory = this.vector_memory.store(content, metadata);
            
            if (!memory) {
                ⌽(:mi_error, "Failed to store in vector memory");
                ⟼(null);
            }
            
            // Store in hierarchical memory if available
            if (this.components_status.hierarchical_memory) {
                // Ensure namespace exists
                ιnamespace_parts = namespace.split('/');
                ιbase_namespace = namespace_parts[0];
                ιcategory = "general";
                
                // Determine category based on metadata or namespace
                if (metadata && metadata.type) {
                    if (this.hierarchical_memory.categories[metadata.type]) {
                        category = metadata.type;
                    }
                }
                
                // Create namespace if it doesn't exist
                if (!this.hierarchical_memory.namespaces[base_namespace]) {
                    this.hierarchical_memory.create_namespace(base_namespace, category, {
                        description: `Namespace for ${base_namespace} memories`
                    });
                }
                
                // Add to hierarchical memory
                this.hierarchical_memory.add_memory(memory.id, base_namespace, {
                    path: path
                });
                
                // Create relationships if specified
                ∀(relationships, λrelationship {
                    if (relationship.target_id && relationship.type) {
                        this.hierarchical_memory.create_relationship(
                            memory.id,
                            relationship.target_id,
                            relationship.type,
                            {
                                bidirectional: relationship.bidirectional,
                                metadata: relationship.metadata
                            }
                        );
                    }
                });
            }
            
            ⌽(:mi_success, `Stored memory with ID: ${memory.id}`);
            ⟼(memory);
        }{
            ⌽(:mi_error, "Failed to store memory");
            ⟼(null);
        }
    }
    
    // Retrieve a memory by ID
    ƒretrieve(ιid, αoptions) {
        ⌽(:mi_retrieve, id);
        
        ÷{
            // Set retrieve options
            ιretrieve_options = options || {};
            ιinclude_related = retrieve_options.include_related !== undefined ? 
                              retrieve_options.include_related : ⊥;
            ιinclude_path = retrieve_options.include_path !== undefined ? 
                           retrieve_options.include_path : ⊤;
            
            // Check if vector memory is initialized
            if (!this.components_status.vector_memory) {
                ⌽(:mi_error, "Vector memory not initialized");
                ⟼(null);
            }
            
            // Retrieve from vector memory
            ιmemory = this.vector_memory.retrieve(id);
            
            if (!memory) {
                ⌽(:mi_error, `Memory not found with ID: ${id}`);
                ⟼(null);
            }
            
            // Add hierarchical information if available
            if (this.components_status.hierarchical_memory && include_path) {
                ιpath = this.hierarchical_memory.get_memory_path(id);
                if (path) {
                    memory.path = path;
                }
            }
            
            // Add related memories if requested
            if (this.components_status.hierarchical_memory && include_related) {
                ιrelated = this.hierarchical_memory.get_related_memories(id, {
                    include_content: ⊥ // Don't include content to reduce size
                });
                
                if (related) {
                    memory.related = related;
                }
            }
            
            ⌽(:mi_success, `Retrieved memory with ID: ${id}`);
            ⟼(memory);
        }{
            ⌽(:mi_error, `Failed to retrieve memory with ID: ${id}`);
            ⟼(null);
        }
    }
    
    // Search memories
    ƒsearch(σquery, αoptions) {
        ⌽(:mi_search, query);
        
        ÷{
            // Set search options
            ιsearch_options = options || {};
            ιsearch_type = search_options.search_type || "semantic";
            ιlimit = search_options.limit || 5;
            ιnamespace = search_options.namespace || null;
            ιcategory = search_options.category || null;
            ιmetadata = search_options.metadata || null;
            
            // Check if vector memory is initialized
            if (!this.components_status.vector_memory) {
                ⌽(:mi_error, "Vector memory not initialized");
                ⟼([]);
            }
            
            // Perform search based on type
            ιresults = null;
            
            if (search_type === "semantic") {
                // Semantic search
                if (this.components_status.hierarchical_memory && (namespace || category)) {
                    // Search within hierarchy
                    results = this.hierarchical_memory.search_in_hierarchy(query, {
                        namespace: namespace,
                        category: category,
                        limit: limit
                    });
                } else {
                    // Direct vector search
                    results = this.vector_memory.search_by_similarity(query, {
                        limit: limit,
                        filter: metadata ? { metadata: metadata } : null
                    });
                }
            } else if (search_type === "metadata") {
                // Metadata search
                if (!metadata) {
                    ⌽(:mi_error, "Metadata required for metadata search");
                    ⟼([]);
                }
                
                results = this.vector_memory.search_by_metadata(metadata, {
                    limit: limit
                });
                
                // Add path information if hierarchical memory is available
                if (this.components_status.hierarchical_memory) {
                    ∀(results, λmemory {
                        ιpath = this.hierarchical_memory.get_memory_path(memory.id);
                        if (path) {
                            memory.path = path;
                        }
                    });
                }
            } else {
                ⌽(:mi_error, `Unknown search type: ${search_type}`);
                ⟼([]);
            }
            
            ⌽(:mi_success, `Found ${results.length} memories matching query`);
            ⟼(results);
        }{
            ⌽(:mi_error, "Failed to search memories");
            ⟼([]);
        }
    }
    
    // Create a memory category
    ƒcreate_category(σname, αoptions) {
        ÷{
            // Check if hierarchical memory is initialized
            if (!this.components_status.hierarchical_memory) {
                ⌽(:mi_error, "Hierarchical memory not initialized");
                ⟼(null);
            }
            
            // Create category
            ιcategory = this.hierarchical_memory.create_category(name, options);
            
            ⟼(category);
        }{
            ⌽(:mi_error, `Failed to create category: ${name}`);
            ⟼(null);
        }
    }
    
    // Create a memory namespace
    ƒcreate_namespace(σname, σcategory, αoptions) {
        ÷{
            // Check if hierarchical memory is initialized
            if (!this.components_status.hierarchical_memory) {
                ⌽(:mi_error, "Hierarchical memory not initialized");
                ⟼(null);
            }
            
            // Create namespace
            ιnamespace = this.hierarchical_memory.create_namespace(name, category, options);
            
            ⟼(namespace);
        }{
            ⌽(:mi_error, `Failed to create namespace: ${name}`);
            ⟼(null);
        }
    }
    
    // Create a relationship between memories
    ƒcreate_relationship(ιmemory_id1, ιmemory_id2, σrelationship_type, αoptions) {
        ÷{
            // Check if hierarchical memory is initialized
            if (!this.components_status.hierarchical_memory) {
                ⌽(:mi_error, "Hierarchical memory not initialized");
                ⟼(null);
            }
            
            // Create relationship
            ιrelationship = this.hierarchical_memory.create_relationship(
                memory_id1,
                memory_id2,
                relationship_type,
                options
            );
            
            ⟼(relationship);
        }{
            ⌽(:mi_error, `Failed to create relationship between memories ${memory_id1} and ${memory_id2}`);
            ⟼(null);
        }
    }
    
    // Get memory statistics
    ƒget_stats() {
        ÷{
            ιstats = {
                vector_memory: this.components_status.vector_memory ? 
                             this.vector_memory.get_stats() : null,
                hierarchical_memory: this.components_status.hierarchical_memory ? {
                    categories: Object.keys(this.hierarchical_memory.categories).length,
                    namespaces: Object.keys(this.hierarchical_memory.namespaces).length,
                    relationships: Object.keys(this.hierarchical_memory.relationships).length
                } : null
            };
            
            ⟼(stats);
        }{
            ⌽(:mi_error, "Failed to get memory statistics");
            ⟼(null);
        }
    }
    
    // Get category hierarchy
    ƒget_category_hierarchy(σroot_category) {
        ÷{
            // Check if hierarchical memory is initialized
            if (!this.components_status.hierarchical_memory) {
                ⌽(:mi_error, "Hierarchical memory not initialized");
                ⟼(null);
            }
            
            // Get hierarchy
            ιhierarchy = this.hierarchical_memory.get_category_hierarchy(root_category);
            
            ⟼(hierarchy);
        }{
            ⌽(:mi_error, `Failed to get category hierarchy for: ${root_category || "all categories"}`);
            ⟼(null);
        }
    }
    
    // Private: Initialize all components
    ƒ_initialize_components() {
        // Initialize vector memory
        ÷{
            ιVectorMemory = require("./vector_memory");
            this.vector_memory = VectorMemory();
            this.vector_memory.initialize({
                embedding_dimensions: this.options.embedding_dimensions,
                llm_integration: this.options.llm_integration,
                storage_path: `${this.options.storage_path}/vector`
            });
            this.components_status.vector_memory = ⊤;
        }{
            ⌽(:mi_error, "Failed to initialize vector memory");
        }
        
        // Initialize hierarchical memory
        ÷{
            ιHierarchicalMemory = require("./hierarchical_memory");
            this.hierarchical_memory = HierarchicalMemory();
            this.hierarchical_memory.initialize({
                vector_memory: this.vector_memory,
                storage_path: `${this.options.storage_path}/hierarchy`
            });
            this.components_status.hierarchical_memory = ⊤;
        }{
            ⌽(:mi_error, "Failed to initialize hierarchical memory");
        }
    }
}

// Export the MemoryIntegration module
⟼(MemoryIntegration);
