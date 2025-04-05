ƒmain() {
    ⌽("Starting memory management system test...");
    
    // Test basic memory operations
    ⌽("Testing basic memory operations...");
    
    // Store values in memory
    ⌽("Storing values in memory...");
    📝("test_key1", "test_value1");
    📝("test_key2", "test_value2");
    
    // Retrieve values from memory
    ⌽("Retrieving values from memory...");
    ιvalue1 = 📖("test_key1");
    ιvalue2 = 📖("test_key2");
    
    ⌽(`Retrieved values: ${value1}, ${value2}`);
    
    // Test updating a value
    ⌽("Testing value update...");
    📝("test_key1", "updated_value1");
    ιupdated = 📖("test_key1");
    ⌽(`Updated value: ${updated}`);
    
    // Test deleting a value
    ⌽("Testing value deletion...");
    🗑("test_key2");
    
    // Try to retrieve the deleted value (should fail gracefully)
    ÷{
        ιdeleted = 📖("test_key2");
        ⌽(`This should not print: ${deleted}`);
    }{
        ⌽("Successfully detected deleted key");
    }
    
    // Test storing complex data
    ⌽("Testing complex data storage...");
    ιcomplex_data = {
        name: "Test User",
        age: 30,
        tags: ["test", "memory", "complex"]
    };
    
    // Convert to string for storage
    ιdata_string = ⎋(complex_data);
    📝("complex_test", data_string);
    
    // Retrieve and parse
    ιretrieved_string = 📖("complex_test");
    ιretrieved_data = ⎋(retrieved_string);
    
    ⌽(`Retrieved complex data: ${retrieved_data.name}, age ${retrieved_data.age}`);
    ⌽(`Tags: ${retrieved_data.tags.join(", ")}`);
    
    // Clean up
    ⌽("Cleaning up test data...");
    🗑("test_key1");
    🗑("complex_test");
    
    ⟼("Memory management system test completed");
}

main();
