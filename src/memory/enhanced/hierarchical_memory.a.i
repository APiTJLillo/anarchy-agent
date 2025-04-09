// hierarchical_memory.a.i - Hierarchical memory organization for Anarchy Agent
// Implements structured memory organization with categories, namespaces, and relationships

// Define string dictionary entries for hierarchical memory
📝("hm_init", "Initializing hierarchical memory system...");
📝("hm_create_category", "Creating memory category: {}");
📝("hm_create_namespace", "Creating memory namespace: {}");
📝("hm_add", "Adding memory to hierarchy: {}");
📝("hm_retrieve", "Retrieving memory from hierarchy: {}");
📝("hm_link", "Linking memories: {} <-> {}");
📝("hm_error", "Hierarchical memory error: {}");
📝("hm_success", "Hierarchical memory operation successful: {}");

// Hierarchical Memory Module Definition
λHierarchicalMemory {
    // Initialize hierarchical memory
    ƒinitialize(αoptions) {
        ⌽(:hm_init);
        
        // Set default options
        ιthis.options = options || {};
        ιthis.options.vector_memory = this.options.vector_memory || null;
        ιthis.options.storage_path = this.options.storage_path || "./memory_storage";
        ιthis.options.max_depth = this.options.max_depth || 5;
        
        // Initialize hierarchy structure
        ιthis.categories = {};
        ιthis.namespaces = {};
        ιthis.relationships = {};
        ιthis.memory_paths = {};
        
        // Create default categories
        this._create_default_categories();
        
        // Load existing hierarchy if available
        this._load_hierarchy();
        
        ⟼(⊤);
    }
    
    // Create a memory category
    ƒcreate_category(σname, αoptions) {
        ⌽(:hm_create_category, name);
        
        ÷{
            // Set category options
            ιcategory_options = options || {};
            ιparent = category_options.parent || null;
            ιdescription = category_options.description || "";
            ιmetadata = category_options.metadata || {};
            
            // Check if category already exists
            if (this.categories[name]) {
                ⌽(:hm_error, `Category already exists: ${name}`);
                ⟼(null);
            }
            
            // Check parent category if specified
            if (parent && !this.categories[parent]) {
                ⌽(:hm_error, `Parent category not found: ${parent}`);
                ⟼(null);
            }
            
            // Create category
            ιcategory = {
                name: name,
                parent: parent,
                description: description,
                metadata: metadata,
                subcategories: [],
                namespaces: [],
                created_at: Date.now()
            };
            
            // Add to categories
            this.categories[name] = category;
            
            // Add to parent's subcategories if parent exists
            if (parent) {
                ＋(this.categories[parent].subcategories, name);
            }
            
            // Save hierarchy
            this._save_hierarchy();
            
            ⌽(:hm_success, `Created category: ${name}`);
            ⟼(category);
        }{
            ⌽(:hm_error, `Failed to create category: ${name}`);
            ⟼(null);
        }
    }
    
    // Create a memory namespace
    ƒcreate_namespace(σname, σcategory, αoptions) {
        ⌽(:hm_create_namespace, name);
        
        ÷{
            // Set namespace options
            ιnamespace_options = options || {};
            ιdescription = namespace_options.description || "";
            ιmetadata = namespace_options.metadata || {};
            
            // Check if namespace already exists
            if (this.namespaces[name]) {
                ⌽(:hm_error, `Namespace already exists: ${name}`);
                ⟼(null);
            }
            
            // Check category
            if (!this.categories[category]) {
                ⌽(:hm_error, `Category not found: ${category}`);
                ⟼(null);
            }
            
            // Create namespace
            ιnamespace = {
                name: name,
                category: category,
                description: description,
                metadata: metadata,
                memories: [],
                created_at: Date.now()
            };
            
            // Add to namespaces
            this.namespaces[name] = namespace;
            
            // Add to category's namespaces
            ＋(this.categories[category].namespaces, name);
            
            // Save hierarchy
            this._save_hierarchy();
            
            ⌽(:hm_success, `Created namespace: ${name} in category: ${category}`);
            ⟼(namespace);
        }{
            ⌽(:hm_error, `Failed to create namespace: ${name}`);
            ⟼(null);
        }
    }
    
    // Add a memory to the hierarchy
    ƒadd_memory(ιmemory_id, σnamespace, αoptions) {
        ⌽(:hm_add, `Memory ${memory_id} to namespace ${namespace}`);
        
        ÷{
            // Set add options
            ιadd_options = options || {};
            ιpath = add_options.path || "";
            
            // Check if vector memory is available
            if (!this.options.vector_memory) {
                ⌽(:hm_error, "Vector memory not available");
                ⟼(⊥);
            }
            
            // Check if memory exists
            ιmemory = this.options.vector_memory.retrieve(memory_id);
            if (!memory) {
                ⌽(:hm_error, `Memory not found with ID: ${memory_id}`);
                ⟼(⊥);
            }
            
            // Check if namespace exists
            if (!this.namespaces[namespace]) {
                ⌽(:hm_error, `Namespace not found: ${namespace}`);
                ⟼(⊥);
            }
            
            // Add memory to namespace
            if (!this.namespaces[namespace].memories.includes(memory_id)) {
                ＋(this.namespaces[namespace].memories, memory_id);
            }
            
            // Store memory path
            ιfull_path = path ? `${namespace}/${path}` : namespace;
            this.memory_paths[memory_id] = full_path;
            
            // Update memory metadata
            ιupdated_metadata = {
                ...memory.metadata,
                namespace: namespace,
                path: full_path
            };
            
            this.options.vector_memory.update(memory_id, {
                metadata: updated_metadata
            });
            
            // Save hierarchy
            this._save_hierarchy();
            
            ⌽(:hm_success, `Added memory ${memory_id} to namespace ${namespace}`);
            ⟼(⊤);
        }{
            ⌽(:hm_error, `Failed to add memory ${memory_id} to namespace ${namespace}`);
            ⟼(⊥);
        }
    }
    
    // Create a relationship between memories
    ƒcreate_relationship(ιmemory_id1, ιmemory_id2, σrelationship_type, αoptions) {
        ⌽(:hm_link, memory_id1, memory_id2);
        
        ÷{
            // Set relationship options
            ιrelationship_options = options || {};
            ιbidirectional = relationship_options.bidirectional !== undefined ? 
                            relationship_options.bidirectional : ⊤;
            ιmetadata = relationship_options.metadata || {};
            
            // Check if vector memory is available
            if (!this.options.vector_memory) {
                ⌽(:hm_error, "Vector memory not available");
                ⟼(⊥);
            }
            
            // Check if memories exist
            ιmemory1 = this.options.vector_memory.retrieve(memory_id1);
            ιmemory2 = this.options.vector_memory.retrieve(memory_id2);
            
            if (!memory1) {
                ⌽(:hm_error, `Memory not found with ID: ${memory_id1}`);
                ⟼(⊥);
            }
            
            if (!memory2) {
                ⌽(:hm_error, `Memory not found with ID: ${memory_id2}`);
                ⟼(⊥);
            }
            
            // Create relationship key
            ιrelationship_key = `${memory_id1}-${memory_id2}`;
            
            // Create relationship
            ιrelationship = {
                from: memory_id1,
                to: memory_id2,
                type: relationship_type,
                bidirectional: bidirectional,
                metadata: metadata,
                created_at: Date.now()
            };
            
            // Store relationship
            this.relationships[relationship_key] = relationship;
            
            // Create reverse relationship if bidirectional
            if (bidirectional) {
                ιreverse_key = `${memory_id2}-${memory_id1}`;
                this.relationships[reverse_key] = {
                    from: memory_id2,
                    to: memory_id1,
                    type: relationship_type,
                    bidirectional: bidirectional,
                    metadata: metadata,
                    created_at: Date.now()
                };
            }
            
            // Save hierarchy
            this._save_hierarchy();
            
            ⌽(:hm_success, `Created relationship between memories ${memory_id1} and ${memory_id2}`);
            ⟼(relationship);
        }{
            ⌽(:hm_error, `Failed to create relationship between memories ${memory_id1} and ${memory_id2}`);
            ⟼(null);
        }
    }
    
    // Get memories in a namespace
    ƒget_memories_in_namespace(σnamespace, αoptions) {
        ÷{
            // Set options
            ιget_options = options || {};
            ιinclude_content = get_options.include_content !== undefined ? 
                              get_options.include_content : ⊤;
            
            // Check if namespace exists
            if (!this.namespaces[namespace]) {
                ⌽(:hm_error, `Namespace not found: ${namespace}`);
                ⟼([]);
            }
            
            // Check if vector memory is available
            if (!this.options.vector_memory) {
                ⌽(:hm_error, "Vector memory not available");
                ⟼([]);
            }
            
            // Get memory IDs in namespace
            ιmemory_ids = this.namespaces[namespace].memories;
            
            // Retrieve memories
            ιmemories = [];
            
            ∀(memory_ids, λmemory_id {
                ιmemory = this.options.vector_memory.retrieve(memory_id);
                if (memory) {
                    if (!include_content) {
                        // Remove content to reduce size
                        ιmemory_without_content = {
                            ...memory,
                            content: null
                        };
                        ＋(memories, memory_without_content);
                    } else {
                        ＋(memories, memory);
                    }
                }
            });
            
            ⟼(memories);
        }{
            ⌽(:hm_error, `Failed to get memories in namespace: ${namespace}`);
            ⟼([]);
        }
    }
    
    // Get related memories
    ƒget_related_memories(ιmemory_id, αoptions) {
        ÷{
            // Set options
            ιget_options = options || {};
            ιrelationship_type = get_options.relationship_type || null;
            ιinclude_content = get_options.include_content !== undefined ? 
                              get_options.include_content : ⊤;
            ιmax_depth = get_options.max_depth || 1;
            
            // Check if vector memory is available
            if (!this.options.vector_memory) {
                ⌽(:hm_error, "Vector memory not available");
                ⟼([]);
            }
            
            // Check if memory exists
            ιmemory = this.options.vector_memory.retrieve(memory_id);
            if (!memory) {
                ⌽(:hm_error, `Memory not found with ID: ${memory_id}`);
                ⟼([]);
            }
            
            // Find related memories
            ιrelated_memories = [];
            ιvisited = new Set();
            
            // Recursive function to find related memories
            ƒfind_related(ιcurrent_id, ιcurrent_depth) {
                // Check if we've reached max depth
                if (current_depth > max_depth) {
                    ⟼();
                }
                
                // Check if we've already visited this memory
                if (visited.has(current_id)) {
                    ⟼();
                }
                
                // Mark as visited
                visited.add(current_id);
                
                // Find relationships where this memory is the source
                ∀(Object.values(this.relationships), λrelationship {
                    if (relationship.from === current_id) {
                        // Check relationship type if specified
                        if (relationship_type && relationship.type !== relationship_type) {
                            ⟼(); // Skip this relationship
                        }
                        
                        // Get related memory
                        ιrelated_memory = this.options.vector_memory.retrieve(relationship.to);
                        
                        if (related_memory) {
                            if (!include_content) {
                                // Remove content to reduce size
                                ιmemory_without_content = {
                                    ...related_memory,
                                    content: null
                                };
                                ＋(related_memories, {
                                    memory: memory_without_content,
                                    relationship: relationship
                                });
                            } else {
                                ＋(related_memories, {
                                    memory: related_memory,
                                    relationship: relationship
                                });
                            }
                            
                            // Recursively find related memories
                            find_related(relationship.to, current_depth + 1);
                        }
                    }
                });
            }
            
            // Start recursive search
            find_related(memory_id, 1);
            
            ⟼(related_memories);
        }{
            ⌽(:hm_error, `Failed to get related memories for memory: ${memory_id}`);
            ⟼([]);
        }
    }
    
    // Get memory path
    ƒget_memory_path(ιmemory_id) {
        ÷{
            // Check if memory path exists
            if (!this.memory_paths[memory_id]) {
                ⌽(:hm_error, `Memory path not found for ID: ${memory_id}`);
                ⟼(null);
            }
            
            ⟼(this.memory_paths[memory_id]);
        }{
            ⌽(:hm_error, `Failed to get memory path for ID: ${memory_id}`);
            ⟼(null);
        }
    }
    
    // Get category hierarchy
    ƒget_category_hierarchy(σroot_category) {
        ÷{
            // If no root category specified, return full hierarchy
            if (!root_category) {
                // Find root categories (those with no parent)
                ιroot_categories = Object.values(this.categories).filter(c => !c.parent);
                
                // Build hierarchy for each root category
                ιhierarchy = {};
                
                ∀(root_categories, λcategory {
                    hierarchy[category.name] = this._build_category_hierarchy(category.name);
                });
                
                ⟼(hierarchy);
            }
            
            // Check if root category exists
            if (!this.categories[root_category]) {
                ⌽(:hm_error, `Category not found: ${root_category}`);
                ⟼(null);
            }
            
            // Build hierarchy starting from root category
            ιhierarchy = this._build_category_hierarchy(root_category);
            
            ⟼(hierarchy);
        }{
            ⌽(:hm_error, `Failed to get category hierarchy for: ${root_category || "all categories"}`);
            ⟼(null);
        }
    }
    
    // Search memories in hierarchy
    ƒsearch_in_hierarchy(σquery, αoptions) {
        ÷{
            // Set search options
            ιsearch_options = options || {};
            ιcategory = search_options.category || null;
            ιnamespace = search_options.namespace || null;
            ιlimit = search_options.limit || 10;
            
            // Check if vector memory is available
            if (!this.options.vector_memory) {
                ⌽(:hm_error, "Vector memory not available");
                ⟼([]);
            }
            
            // Prepare filter based on hierarchy constraints
            ιfilter = {};
            
            if (namespace) {
                // Search within specific namespace
                filter.metadata = { namespace: namespace };
            } else if (category) {
                // Search within category (all namespaces in category)
                ιcategory_namespaces = this.categories[category]?.namespaces || [];
                
                if (category_namespaces.length === 0) {
                    ⌽(:hm_error, `No namespaces found in category: ${category}`);
                    ⟼([]);
                }
                
                // Create filter for namespaces in this category
                filter.metadata = {
                    namespace: category_namespaces
                };
            }
            
            // Perform search using vector memory
            ιsearch_results = this.options.vector_memory.search_by_similarity(query, {
                limit: limit,
                filter: filter
            });
            
            // Enhance results with hierarchy information
            ∀(search_results, λresult {
                ιmemory_id = result.memory.id;
                result.path = this.memory_paths[memory_id] || null;
                
                // Find namespace and category
                ιmemory_namespace = result.memory.metadata.namespace;
                if (memory_namespace && this.namespaces[memory_namespace]) {
                    result.namespace = this.namespaces[memory_namespace];
                    result.category = this.categories[result.namespace.category];
                }
            });
            
            ⟼(search_results);
        }{
            ⌽(:hm_error, `Failed to search in hierarchy for query: ${query}`);
            ⟼([]);
        }
    }
    
    // Private: Create default categories
    ƒ_create_default_categories() {
        // Create root categories if they don't exist
        ιdefault_categories = [
            { name: "general", description: "General purpose memories" },
            { name: "knowledge", description: "Factual knowledge and information" },
            { name: "conversations", description: "Conversation history and interactions" },
            { name: "code", description: "Code snippets and programming knowledge" },
            { name: "personal", description: "Personal information and preferences" }
        ];
        
        ∀(default_categories, λcategory {
            if (!this.categories[category.name]) {
                this.create_category(category.name, {
                    description: category.description
                });
            }
        });
    }
    
    // Private: Build category hierarchy
    ƒ_build_category_hierarchy(σcategory_name, ιcurrent_depth) {
        // Set default depth
        ιdepth = current_depth || 0;
        
        // Check max depth
        if (depth >= this.options.max_depth) {
            ⟼({
                name: category_name,
                subcategories: [],
                namespaces: []
            });
        }
        
        // Get category
        ιcategory = this.categories[category_name];
        
        if (!category) {
            ⟼(null);
        }
        
        // Build hierarchy object
        ιhierarchy = {
            name: category.name,
            description: category.description,
            metadata: category.metadata,
            subcategories: [],
            namespaces: []
        };
        
        // Add subcategories
        ∀(category.subcategories, λsubcategory_name {
            ιsubcategory_hierarchy = this._build_category_hierarchy(subcategory_name, depth + 1);
            if (subcategory_hierarchy) {
                ＋(hierarchy.subcategories, subcategory_hierarchy);
            }
        });
        
        // Add namespaces
        ∀(category.namespaces, λnamespace_name {
            ιnamespace = this.namespaces[namespace_name];
            if (namespace) {
                ＋(hierarchy.namespaces, {
                    name: namespace.name,
                    description: namespace.description,
                    metadata: namespace.metadata,
                    memory_count: namespace.memories.length
                });
            }
        });
        
        ⟼(hierarchy);
    }
    
    // Private: Save hierarchy to storage
    ƒ_save_hierarchy() {
        ÷{
            // Create storage directory if it doesn't exist
            !(`mkdir -p "${this.options.storage_path}"`);
            
            // Prepare data for storage
            ιstorage_data = {
                categories: this.categories,
                namespaces: this.namespaces,
                relationships: this.relationships,
                memory_paths: this.memory_paths
            };
            
            // Convert to JSON
            ιjson_data = JSON.stringify(storage_data);
            
            // Write to file
            ✍(`${this.options.storage_path}/hierarchy.json`, json_data);
            
            ⟼(⊤);
        }{
            ⌽(:hm_error, "Failed to save hierarchy to storage");
            ⟼(⊥);
        }
    }
    
    // Private: Load hierarchy from storage
    ƒ_load_hierarchy() {
        ÷{
            // Check if storage file exists
            ιfile_exists = !(`[ -f "${this.options.storage_path}/hierarchy.json" ] && echo "true" || echo "false"`);
            
            if (file_exists.trim() !== "true") {
                ⟼(⊥);
            }
            
            // Read from file
            ιjson_data = 📖(`${this.options.storage_path}/hierarchy.json`);
            
            // Parse JSON
            ιstorage_data = JSON.parse(json_data);
            
            // Load data
            this.categories = storage_data.categories || {};
            this.namespaces = storage_data.namespaces || {};
            this.relationships = storage_data.relationships || {};
            this.memory_paths = storage_data.memory_paths || {};
            
            ⟼(⊤);
        }{
            ⌽(:hm_error, "Failed to load hierarchy from storage");
            ⟼(⊥);
        }
    }
}

// Export the HierarchicalMemory module
⟼(HierarchicalMemory);
