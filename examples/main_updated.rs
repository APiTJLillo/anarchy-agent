// Updated examples/main.rs file that uses string dictionary references
use anyhow::Result;

/// Main entry point for running examples
fn main() -> Result<()> {
    // Load string dictionary
    let dict = load_string_dictionary()?;
    
    println!("{}", dict.get("examples_title").unwrap_or("Anarchy Agent Examples"));
    println!("{}", dict.get("examples_separator").unwrap_or("====================="));
    println!("");
    
    println!("{}", dict.get("available_examples").unwrap_or("Available examples:"));
    println!("{}", dict.get("example_1").unwrap_or("1. Basic task (file operations and web requests)"));
    println!("{}", dict.get("example_2").unwrap_or("2. Browser automation"));
    println!("{}", dict.get("example_3").unwrap_or("3. File system operations"));
    println!("{}", dict.get("example_4").unwrap_or("4. Memory operations"));
    println!("{}", dict.get("example_5").unwrap_or("5. Complete workflow"));
    println!("");
    
    println!("{}", dict.get("example_run_instructions").unwrap_or("To run an example, use:"));
    println!("{}", dict.get("example_run_command").unwrap_or("cargo run --example <example_name>"));
    println!("");
    println!("{}", dict.get("example_run_example").unwrap_or("Example: cargo run --example example_task"));
    
    Ok(())
}

/// Load the string dictionary from file
fn load_string_dictionary() -> Result<std::collections::HashMap<String, String>> {
    let dict_path = "string_dictionary.json";
    
    // Try to load the dictionary file
    match std::fs::read_to_string(dict_path) {
        Ok(content) => {
            // Parse JSON
            match serde_json::from_str(&content) {
                Ok(dict) => Ok(dict),
                Err(_) => {
                    // Return empty dictionary if parsing fails
                    Ok(std::collections::HashMap::new())
                }
            }
        },
        Err(_) => {
            // Return empty dictionary if file doesn't exist
            Ok(std::collections::HashMap::new())
        }
    }
}
