// Load the shared string dictionary
🔠("string_dictionary.json");

ƒmain() {
    ⌽(:memory_start);
    
    // Store values in memory
    ⌽(:storing_values);
    📝("user_name", "Alice");
    📝("favorite_color", "blue");
    📝("login_count", "1");
    
    // Retrieve values from memory
    ⌽(:retrieving_values);
    ιname = 📖("user_name");
    ιcolor = 📖("favorite_color");
    ιcount = 📖("login_count");
    
    ⌽(`${:user_format}${name}, ${:favorite_color}${color}, ${:login_count}${count}`);
    
    // Update a value
    ⌽(:updating_count);
    ιnew_count = 🔢(count) + 1;
    📝("login_count", 🔤(new_count));
    
    // Retrieve the updated value
    ιupdated_count = 📖("login_count");
    ⌽(`${:updated_count}${updated_count}`);
    
    // Delete a value
    ⌽(:deleting_value);
    🗑("favorite_color");
    
    // Try to retrieve the deleted value
    ÷{
        ιdeleted_color = 📖("favorite_color");
        ⌽(`${:error_message}${deleted_color}`);
    }{
        ⌽(:delete_success);
    }
    
    // Store complex data using JSON
    ⌽(:storing_complex);
    ιuser_data = {
        name: "Alice",
        age: 30,
        skills: ["programming", "design", "writing"],
        contact: {
            email: "alice@example.com",
            phone: "555-1234"
        }
    };
    
    📝("user_profile", ⎋(user_data));
    
    // Retrieve and parse complex data
    ⌽(:retrieving_complex);
    ιstored_data = 📖("user_profile");
    ιparsed_data = ⎋(stored_data);
    
    ⌽(`${:user_profile}${parsed_data.name}, ${parsed_data.age} years old`);
    ⌽(`${:skills}${parsed_data.skills.join(", ")}`);
    ⌽(`${:contact}${parsed_data.contact.email}`);
    
    ⟼(:memory_completed);
}

main();
