use anyhow::Result;

/// Main entry point for running examples
fn main() -> Result<()> {
    println!("Anarchy Agent Examples");
    println!("=====================");
    println!();
    
    println!("Available examples:");
    println!("1. Basic task (file operations and web requests)");
    println!("2. Browser automation");
    println!("3. File system operations");
    println!("4. Memory operations");
    println!("5. Complete workflow");
    println!();
    
    println!("To run an example, use:");
    println!("cargo run --example <example_name>");
    println!();
    println!("Example: cargo run --example example_task");
    
    Ok(())
}
