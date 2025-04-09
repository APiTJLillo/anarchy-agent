// memory_system_test.a.i - Test suite for the enhanced memory management system
// Tests vector memory, hierarchical organization, and memory integration

// Import required modules
ιVectorMemory = require("../../src/memory/enhanced/vector_memory");
ιHierarchicalMemory = require("../../src/memory/enhanced/hierarchical_memory");
ιMemoryIntegration = require("../../src/memory/enhanced/memory_integration");

// Define string dictionary entries
📝("test_init", "Initializing memory system tests...");
📝("test_run", "Running test: {}");
📝("test_pass", "✅ Test passed: {}");
📝("test_fail", "❌ Test failed: {} - {}");
📝("test_complete", "Tests completed: {} passed, {} failed");

// Test suite for memory system
λMemorySystemTest {
    // Initialize test suite
    ƒinitialize() {
        ⌽(:test_init);
        
        // Initialize test counters
        ιthis.tests_run = 0;
        ιthis.tests_passed = 0;
        ιthis.tests_failed = 0;
        
        // Initialize test storage path
        ιthis.test_storage_path = "./test_memory_storage";
        
        // Create test storage directory
        !(`mkdir -p ${this.test_storage_path}`);
        
        // Initialize components for testing
        this._initialize_components();
        
        ⟼(⊤);
    }
    
    // Run all tests
    ƒrun_tests() {
        // Vector memory tests
        this.test_vector_memory_store();
        this.test_vector_memory_retrieve();
        this.test_vector_memory_search();
        this.test_vector_memory_delete();
        
        // Hierarchical memory tests
        this.test_hierarchical_memory_categories();
        this.test_hierarchical_memory_namespaces();
        this.test_hierarchical_memory_relationships();
        
        // Memory integration tests
        this.test_memory_integration_store();
        this.test_memory_integration_search();
        this.test_memory_integration_hierarchy();
        
        // Report results
        ⌽(:test_complete, this.tests_passed, this.tests_failed);
        
        // Clean up test storage
        !(`rm -rf ${this.test_storage_path}`);
        
        ⟼(this.tests_failed === 0);
    }
    
    // Test vector memory store functionality
    ƒtest_vector_memory_store() {
        ⌽(:test_run, "vector_memory_store");
        this.tests_run++;
        
        ÷{
            // Store a memory
            ιmemory = this.vector_memory.store(
                "This is a test memory for vector storage",
                {
                    type: "test",
                    importance: 3,
                    tags: ["test", "vector", "store"]
                }
            );
            
            // Verify memory was stored
            if (!memory || !memory.id || memory.content !== "This is a test memory for vector storage") {
                ⌽(:test_fail, "vector_memory_store", "Memory not stored correctly");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify metadata
            if (memory.metadata.type !== "test" || 
                memory.metadata.importance !== 3 || 
                !memory.metadata.tags.includes("vector")) {
                ⌽(:test_fail, "vector_memory_store", "Memory metadata not stored correctly");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify embedding
            if (!memory.embedding || memory.embedding.length === 0) {
                ⌽(:test_fail, "vector_memory_store", "Memory embedding not generated");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "vector_memory_store");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "vector_memory_store", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test vector memory retrieve functionality
    ƒtest_vector_memory_retrieve() {
        ⌽(:test_run, "vector_memory_retrieve");
        this.tests_run++;
        
        ÷{
            // Store a memory
            ιmemory = this.vector_memory.store(
                "This is a memory to test retrieval",
                { type: "test_retrieve" }
            );
            
            // Retrieve the memory
            ιretrieved = this.vector_memory.retrieve(memory.id);
            
            // Verify retrieval
            if (!retrieved || retrieved.id !== memory.id || 
                retrieved.content !== "This is a memory to test retrieval") {
                ⌽(:test_fail, "vector_memory_retrieve", "Memory not retrieved correctly");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify access count updated
            if (retrieved.access_count !== 1) {
                ⌽(:test_fail, "vector_memory_retrieve", "Access count not updated");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "vector_memory_retrieve");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "vector_memory_retrieve", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test vector memory search functionality
    ƒtest_vector_memory_search() {
        ⌽(:test_run, "vector_memory_search");
        this.tests_run++;
        
        ÷{
            // Store multiple memories
            this.vector_memory.store(
                "Artificial intelligence is transforming how we interact with computers",
                { tags: ["AI", "technology"] }
            );
            
            this.vector_memory.store(
                "Machine learning algorithms can identify patterns in data",
                { tags: ["AI", "ML", "data"] }
            );
            
            this.vector_memory.store(
                "Natural language processing helps computers understand human language",
                { tags: ["AI", "NLP"] }
            );
            
            // Search by similarity
            ιresults = this.vector_memory.search_by_similarity("AI and machine learning", {
                limit: 2,
                threshold: 0.1
            });
            
            // Verify search results
            if (!results || results.length === 0) {
                ⌽(:test_fail, "vector_memory_search", "No search results returned");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify results have similarity scores
            if (results[0].similarity === undefined || results[0].similarity <= 0) {
                ⌽(:test_fail, "vector_memory_search", "Search results missing similarity scores");
                this.tests_failed++;
                ⟼();
            }
            
            // Search by metadata
            ιmetadata_results = this.vector_memory.search_by_metadata({
                tags: ["NLP"]
            });
            
            // Verify metadata search
            if (!metadata_results || metadata_results.length === 0 || 
                !metadata_results[0].content.includes("Natural language processing")) {
                ⌽(:test_fail, "vector_memory_search", "Metadata search failed");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "vector_memory_search");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "vector_memory_search", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test vector memory delete functionality
    ƒtest_vector_memory_delete() {
        ⌽(:test_run, "vector_memory_delete");
        this.tests_run++;
        
        ÷{
            // Store a memory
            ιmemory = this.vector_memory.store(
                "This is a memory to test deletion",
                { type: "test_delete" }
            );
            
            // Delete the memory
            ιdelete_result = this.vector_memory.delete(memory.id);
            
            // Verify deletion
            if (!delete_result) {
                ⌽(:test_fail, "vector_memory_delete", "Delete operation failed");
                this.tests_failed++;
                ⟼();
            }
            
            // Try to retrieve deleted memory
            ιretrieved = this.vector_memory.retrieve(memory.id);
            
            // Verify memory is gone
            if (retrieved) {
                ⌽(:test_fail, "vector_memory_delete", "Memory still exists after deletion");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "vector_memory_delete");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "vector_memory_delete", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test hierarchical memory categories
    ƒtest_hierarchical_memory_categories() {
        ⌽(:test_run, "hierarchical_memory_categories");
        this.tests_run++;
        
        ÷{
            // Create categories
            ιparent_category = this.hierarchical_memory.create_category("test_parent", {
                description: "Parent category for testing"
            });
            
            ιchild_category = this.hierarchical_memory.create_category("test_child", {
                parent: "test_parent",
                description: "Child category for testing"
            });
            
            // Verify categories were created
            if (!parent_category || !child_category) {
                ⌽(:test_fail, "hierarchical_memory_categories", "Categories not created");
                this.tests_failed++;
                ⟼();
            }
            
            // Get category hierarchy
            ιhierarchy = this.hierarchical_memory.get_category_hierarchy("test_parent");
            
            // Verify hierarchy
            if (!hierarchy || hierarchy.name !== "test_parent" || 
                !hierarchy.subcategories || hierarchy.subcategories.length === 0 ||
                hierarchy.subcategories[0].name !== "test_child") {
                ⌽(:test_fail, "hierarchical_memory_categories", "Category hierarchy incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "hierarchical_memory_categories");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "hierarchical_memory_categories", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test hierarchical memory namespaces
    ƒtest_hierarchical_memory_namespaces() {
        ⌽(:test_run, "hierarchical_memory_namespaces");
        this.tests_run++;
        
        ÷{
            // Create namespace
            ιnamespace = this.hierarchical_memory.create_namespace("test_namespace", "test_parent", {
                description: "Namespace for testing"
            });
            
            // Verify namespace was created
            if (!namespace || namespace.name !== "test_namespace" || 
                namespace.category !== "test_parent") {
                ⌽(:test_fail, "hierarchical_memory_namespaces", "Namespace not created correctly");
                this.tests_failed++;
                ⟼();
            }
            
            // Store a memory in vector memory
            ιmemory = this.vector_memory.store(
                "This is a memory for namespace testing",
                { type: "test_namespace" }
            );
            
            // Add memory to namespace
            ιadd_result = this.hierarchical_memory.add_memory(memory.id, "test_namespace");
            
            // Verify memory was added
            if (!add_result) {
                ⌽(:test_fail, "hierarchical_memory_namespaces", "Memory not added to namespace");
                this.tests_failed++;
                ⟼();
            }
            
            // Get memories in namespace
            ιnamespace_memories = this.hierarchical_memory.get_memories_in_namespace("test_namespace");
            
            // Verify memories in namespace
            if (!namespace_memories || namespace_memories.length === 0 || 
                namespace_memories[0].id !== memory.id) {
                ⌽(:test_fail, "hierarchical_memory_namespaces", "Memories in namespace incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "hierarchical_memory_namespaces");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "hierarchical_memory_namespaces", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test hierarchical memory relationships
    ƒtest_hierarchical_memory_relationships() {
        ⌽(:test_run, "hierarchical_memory_relationships");
        this.tests_run++;
        
        ÷{
            // Store two memories
            ιmemory1 = this.vector_memory.store(
                "This is the first memory for relationship testing",
                { type: "test_relationship" }
            );
            
            ιmemory2 = this.vector_memory.store(
                "This is the second memory for relationship testing",
                { type: "test_relationship" }
            );
            
            // Create relationship
            ιrelationship = this.hierarchical_memory.create_relationship(
                memory1.id,
                memory2.id,
                "references",
                { bidirectional: true }
            );
            
            // Verify relationship was created
            if (!relationship || relationship.from !== memory1.id || 
                relationship.to !== memory2.id || relationship.type !== "references") {
                ⌽(:test_fail, "hierarchical_memory_relationships", "Relationship not created correctly");
                this.tests_failed++;
                ⟼();
            }
            
            // Get related memories
            ιrelated = this.hierarchical_memory.get_related_memories(memory1.id);
            
            // Verify related memories
            if (!related || related.length === 0 || 
                related[0].memory.id !== memory2.id || 
                related[0].relationship.type !== "references") {
                ⌽(:test_fail, "hierarchical_memory_relationships", "Related memories incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify bidirectional relationship
            ιreverse_related = this.hierarchical_memory.get_related_memories(memory2.id);
            
            if (!reverse_related || reverse_related.length === 0 || 
                reverse_related[0].memory.id !== memory1.id) {
                ⌽(:test_fail, "hierarchical_memory_relationships", "Bidirectional relationship failed");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "hierarchical_memory_relationships");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "hierarchical_memory_relationships", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test memory integration store functionality
    ƒtest_memory_integration_store() {
        ⌽(:test_run, "memory_integration_store");
        this.tests_run++;
        
        ÷{
            // Store memory through integration
            ιmemory = this.memory_integration.store(
                "This is a test memory for integration storage",
                {
                    type: "test_integration",
                    importance: 4,
                    tags: ["test", "integration"]
                },
                {
                    namespace: "test_namespace"
                }
            );
            
            // Verify memory was stored
            if (!memory || !memory.id || 
                memory.content !== "This is a test memory for integration storage") {
                ⌽(:test_fail, "memory_integration_store", "Memory not stored correctly");
                this.tests_failed++;
                ⟼();
            }
            
            // Retrieve memory
            ιretrieved = this.memory_integration.retrieve(memory.id, {
                include_path: true
            });
            
            // Verify retrieval with path
            if (!retrieved || !retrieved.path || !retrieved.path.includes("test_namespace")) {
                ⌽(:test_fail, "memory_integration_store", "Memory path not set correctly");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "memory_integration_store");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "memory_integration_store", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test memory integration search functionality
    ƒtest_memory_integration_search() {
        ⌽(:test_run, "memory_integration_search");
        this.tests_run++;
        
        ÷{
            // Store memories for searching
            this.memory_integration.store(
                "Artificial intelligence research is advancing rapidly",
                { tags: ["AI", "research"] },
                { namespace: "test_namespace" }
            );
            
            this.memory_integration.store(
                "Machine learning models require large datasets",
                { tags: ["ML", "data"] },
                { namespace: "test_namespace" }
            );
            
            // Search with integration
            ιresults = this.memory_integration.search("artificial intelligence research", {
                search_type: "semantic",
                namespace: "test_namespace",
                limit: 2
            });
            
            // Verify search results
            if (!results || results.length === 0) {
                ⌽(:test_fail, "memory_integration_search", "No search results returned");
                this.tests_failed++;
                ⟼();
            }
            
            // Verify results have path information
            if (!results[0].memory || !results[0].path || 
                !results[0].path.includes("test_namespace")) {
                ⌽(:test_fail, "memory_integration_search", "Search results missing path information");
                this.tests_failed++;
                ⟼();
            }
            
            // Search by metadata
            ιmetadata_results = this.memory_integration.search("", {
                search_type: "metadata",
                metadata: { tags: ["ML"] }
            });
            
            // Verify metadata search
            if (!metadata_results || metadata_results.length === 0 || 
                !metadata_results[0].content.includes("Machine learning")) {
                ⌽(:test_fail, "memory_integration_search", "Metadata search failed");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "memory_integration_search");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "memory_integration_search", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Test memory integration hierarchy functionality
    ƒtest_memory_integration_hierarchy() {
        ⌽(:test_run, "memory_integration_hierarchy");
        this.tests_run++;
        
        ÷{
            // Create category through integration
            ιcategory = this.memory_integration.create_category("integration_category", {
                description: "Category created through integration"
            });
            
            // Verify category was created
            if (!category || category.name !== "integration_category") {
                ⌽(:test_fail, "memory_integration_hierarchy", "Category not created correctly");
                this.tests_failed++;
                ⟼();
            }
            
            // Create namespace through integration
            ιnamespace = this.memory_integration.create_namespace(
                "integration_namespace",
                "integration_category",
                { description: "Namespace created through integration" }
            );
            
            // Verify namespace was created
            if (!namespace || namespace.name !== "integration_namespace" || 
                namespace.category !== "integration_category") {
                ⌽(:test_fail, "memory_integration_hierarchy", "Namespace not created correctly");
                this.tests_failed++;
                ⟼();
            }
            
            // Get hierarchy through integration
            ιhierarchy = this.memory_integration.get_category_hierarchy("integration_category");
            
            // Verify hierarchy
            if (!hierarchy || hierarchy.name !== "integration_category" || 
                !hierarchy.namespaces || hierarchy.namespaces.length === 0 ||
                hierarchy.namespaces[0].name !== "integration_namespace") {
                ⌽(:test_fail, "memory_integration_hierarchy", "Hierarchy incorrect");
                this.tests_failed++;
                ⟼();
            }
            
            ⌽(:test_pass, "memory_integration_hierarchy");
            this.tests_passed++;
        }{
            ⌽(:test_fail, "memory_integration_hierarchy", "Exception occurred");
            this.tests_failed++;
        }
    }
    
    // Private: Initialize components for testing
    ƒ_initialize_components() {
        // Initialize vector memory
        this.vector_memory = VectorMemory();
        this.vector_memory.initialize({
            embedding_dimensions: 384,
            storage_path: `${this.test_storage_path}/vector`
        });
        
        // Initialize hierarchical memory
        this.hierarchical_memory = HierarchicalMemory();
        this.hierarchical_memory.initialize({
            vector_memory: this.vector_memory,
            storage_path: `${this.test_storage_path}/hierarchy`
        });
        
        // Initialize memory integration
        this.memory_integration = MemoryIntegration();
        this.memory_integration.initialize({
            storage_path: this.test_storage_path,
            embedding_dimensions: 384
        });
    }
}

// Create and run test suite
ιtest_suite = MemorySystemTest();
test_suite.initialize();
test_suite.run_tests();
