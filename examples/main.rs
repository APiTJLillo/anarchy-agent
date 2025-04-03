use anyhow::Result;

/// Main entry point for running examples
fn main() -> Result<()> {
    ⌽("Anarchy Agent Examples");
    ⌽("=====================");
    ⌽("");
    
    ⌽("Available examples:");
    ⌽("1. Basic task (file operations and web requests)");
    ⌽("2. Browser automation");
    ⌽("3. File system operations");
    ⌽("4. Memory operations");
    ⌽("5. Complete workflow");
    ⌽("");
    
    ⌽("To run an example, use:");
    ⌽("cargo run --example <example_name>");
    ⌽("");
    ⌽("Example: cargo run --example example_task");
    
    Ok(())
}
