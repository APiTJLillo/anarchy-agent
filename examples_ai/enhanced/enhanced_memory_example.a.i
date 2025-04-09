// enhanced_memory_example.a.i - Example demonstrating the enhanced memory system
// Shows how to use vector memory, hierarchical organization, and memory integration

// Import required modules
ιMemoryIntegration = require("../src/memory/enhanced/memory_integration");
ιLLMIntegration = require("../src/llm/llm_integration");

// Define string dictionary entries
📝("example_init", "Initializing enhanced memory example...");
📝("example_store", "Storing memory: {}");
📝("example_retrieve", "Retrieving memory: {}");
📝("example_search", "Searching memory: {}");
📝("example_complete", "Example completed successfully!");

// Main example function
ƒrun_example() {
    ⌽(:example_init);
    
    // Initialize LLM integration for embeddings
    ιllm = LLMIntegration();
    llm.initialize({
        model: "local/embedding-model",
        context_size: 4096
    });
    
    // Initialize memory system
    ιmemory = MemoryIntegration();
    memory.initialize({
        storage_path: "./memory_storage",
        llm_integration: llm,
        embedding_dimensions: 384
    });
    
    // Create memory categories
    memory.create_category("research", {
        description: "Research notes and findings",
        metadata: { importance: 4 }
    });
    
    memory.create_category("projects", {
        description: "Project information and tasks",
        metadata: { importance: 5 }
    });
    
    // Create namespaces
    memory.create_namespace("ai_research", "research", {
        description: "Artificial Intelligence research"
    });
    
    memory.create_namespace("anarchy_project", "projects", {
        description: "Anarchy Inference project"
    });
    
    // Store memories with different content and metadata
    ⌽(:example_store, "AI research note");
    ιmemory1 = memory.store(
        "Vector embeddings are mathematical representations of words or concepts in a high-dimensional space. " +
        "They capture semantic relationships and allow for efficient similarity calculations.",
        {
            type: "research",
            importance: 4,
            tags: ["AI", "embeddings", "vectors"]
        },
        {
            namespace: "ai_research"
        }
    );
    
    ⌽(:example_store, "Project implementation note");
    ιmemory2 = memory.store(
        "The Anarchy Inference language uses emoji operators to represent common programming operations. " +
        "For example, ⌽ is used for output, ƒ for function definitions, and λ for lambda expressions.",
        {
            type: "projects",
            importance: 5,
            tags: ["anarchy", "syntax", "emoji"]
        },
        {
            namespace: "anarchy_project"
        }
    );
    
    ⌽(:example_store, "Connection between concepts");
    ιmemory3 = memory.store(
        "Implementing vector embeddings in Anarchy Inference requires careful consideration of the emoji " +
        "operators to ensure the mathematical operations are clear and maintainable.",
        {
            type: "research",
            importance: 3,
            tags: ["AI", "anarchy", "implementation"]
        },
        {
            namespace: "ai_research",
            relationships: [
                {
                    target_id: memory1.id,
                    type: "references",
                    bidirectional: true
                },
                {
                    target_id: memory2.id,
                    type: "implements",
                    bidirectional: false
                }
            ]
        }
    );
    
    // Retrieve a memory by ID with related memories
    ⌽(:example_retrieve, `Memory ${memory3.id}`);
    ιretrieved_memory = memory.retrieve(memory3.id, {
        include_related: true
    });
    
    ⌽(`Retrieved memory: ${retrieved_memory.content.substring(0, 50)}...`);
    ⌽(`Memory path: ${retrieved_memory.path}`);
    ⌽(`Related memories: ${retrieved_memory.related.length}`);
    
    // Perform semantic search
    ⌽(:example_search, "vector embeddings in AI");
    ιsemantic_results = memory.search("vector embeddings in AI", {
        search_type: "semantic",
        limit: 2
    });
    
    ⌽(`Found ${semantic_results.length} memories related to "vector embeddings in AI"`);
    ∀(semantic_results, λresult, ιindex {
        ⌽(`Result ${index + 1}: ${result.memory.content.substring(0, 50)}...`);
        ⌽(`Similarity: ${result.similarity.toFixed(4)}`);
    });
    
    // Search by metadata
    ⌽(:example_search, "tags: anarchy");
    ιmetadata_results = memory.search("", {
        search_type: "metadata",
        metadata: {
            tags: ["anarchy"]
        },
        limit: 2
    });
    
    ⌽(`Found ${metadata_results.length} memories with tag "anarchy"`);
    ∀(metadata_results, λmemory, ιindex {
        ⌽(`Result ${index + 1}: ${memory.content.substring(0, 50)}...`);
    });
    
    // Search within a specific category
    ⌽(:example_search, "implementation in research category");
    ιcategory_results = memory.search("implementation", {
        search_type: "semantic",
        category: "research",
        limit: 2
    });
    
    ⌽(`Found ${category_results.length} memories about "implementation" in research category`);
    ∀(category_results, λresult, ιindex {
        ⌽(`Result ${index + 1}: ${result.memory.content.substring(0, 50)}...`);
    });
    
    // Get memory statistics
    ιstats = memory.get_stats();
    ⌽(`Memory statistics: ${JSON.stringify(stats, null, 2)}`);
    
    // Get category hierarchy
    ιhierarchy = memory.get_category_hierarchy();
    ⌽(`Category hierarchy: ${JSON.stringify(hierarchy, null, 2)}`);
    
    ⌽(:example_complete);
}

// Run the example
run_example();
