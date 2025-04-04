use anyhow::Result;
use std::path::PathBuf;
use std::env;
use tokio;

use anarchy_agent::core::Agent;
use anarchy_agent::core::Config as CoreConfig;

#[tokio::main]
async fn main() -> Result<()> {
    // Initialize logging
    env_logger::init();

    // Parse command line arguments
    let args: Vec<String> = env::args().collect();
    let config = parse_args(&args)?;

    // Create and initialize the agent
    // Clone the config before passing it to Agent::with_config()
    let agent = Agent::with_config(config.clone()).await?;
    agent.initialize().await?;

    // Handle different execution modes
    if let Some(file_path) = &config.file_path {
        // Run a specific Anarchy-Inference file
        let file_content = std::fs::read_to_string(file_path)?;
        let result = agent.run_code(&file_content).await?;
        println!("Execution result: {}", result);
    } else if let Some(example_name) = &config.example_name {
        // Run an example
        let example_path = format!("examples/anarchy-inference/{}.a.i", example_name);
        let file_content = std::fs::read_to_string(&example_path)?;
        let result = agent.run_code(&file_content).await?;
        println!("Example execution result: {}", result);
    } else if config.repl_mode {
        // Run in REPL mode
        run_repl(&agent).await?;
    } else {
        // Run in interactive mode with natural language input
        println!("Anarchy Agent - A fully local, cross-platform AI assistant");
        println!("Enter a task description (or 'exit' to quit):");
        
        let mut input = String::new();
        std::io::stdin().read_line(&mut input)?;
        
        while input.trim() != "exit" && input.trim() != "quit" {
            let result = agent.run_task(&input).await?;
            println!("Task result: {}", result);
            
            input.clear();
            println!("Enter another task (or 'exit' to quit):");
            std::io::stdin().read_line(&mut input)?;
        }
    }

    // Shutdown the agent
    agent.shutdown().await?;
    
    Ok(())
}

// Parse command line arguments into a configuration
fn parse_args(args: &[String]) -> Result<CoreConfig> {
    let mut config = CoreConfig::default();
    let mut i = 1; // Skip the program name
    
    while i < args.len() {
        match args[i].as_str() {
            "--help" | "-h" => {
                print_usage();
                std::process::exit(0);
            },
            "--example" => {
                if i + 1 < args.len() {
                    config.example_name = Some(args[i + 1].clone());
                    i += 2;
                } else {
                    eprintln!("Missing example name");
                    std::process::exit(1);
                }
            },
            "--repl" => {
                config.repl_mode = true;
                i += 1;
            },
            "--model" => {
                if i + 1 < args.len() {
                    config.llm_model_path = PathBuf::from(&args[i + 1]);
                    i += 2;
                } else {
                    eprintln!("Missing model path");
                    std::process::exit(1);
                }
            },
            "--verbose" => {
                config.verbose = true;
                i += 1;
            },
            _ => {
                // Assume it's a file path if it doesn't start with --
                if !args[i].starts_with("--") {
                    let path = PathBuf::from(&args[i]);
                    if path.exists() {
                        config.file_path = Some(path);
                    } else {
                        eprintln!("File not found: {}", args[i]);
                        std::process::exit(1);
                    }
                } else {
                    eprintln!("Unknown option: {}", args[i]);
                    std::process::exit(1);
                }
                i += 1;
            }
        }
    }
    
    Ok(config)
}

// Print usage information
fn print_usage() {
    println!("Anarchy Agent - A fully local, cross-platform AI assistant");
    println!("Usage:");
    println!("  anarchy-agent [OPTIONS] [FILE]");
    println!("");
    println!("Options:");
    println!("  --help, -h             Display this help message");
    println!("  --example <n>       Run an example (e.g., example_task, browser_automation)");
    println!("  --repl                 Start an interactive REPL session");
    println!("  --model <path>         Specify path to a local LLM model");
    println!("  --verbose              Enable verbose logging");
    println!("");
    println!("Examples:");
    println!("  anarchy-agent script.a.i");
    println!("  anarchy-agent --example example_task");
    println!("  anarchy-agent --repl");
}

// Run the REPL (Read-Eval-Print Loop)
async fn run_repl(agent: &Agent) -> Result<()> {
    println!("Starting Anarchy Agent REPL...");
    println!("Type 'exit' or 'quit' to exit.");
    
    let mut input = String::new();
    print!("> ");
    std::io::Write::flush(&mut std::io::stdout())?;
    std::io::stdin().read_line(&mut input)?;
    
    while input.trim() != "exit" && input.trim() != "quit" {
        if !input.trim().is_empty() {
            match agent.run_code(&input).await {
                Ok(result) => println!("{}", result),
                Err(e) => eprintln!("Error: {}", e),
            }
        }
        
        input.clear();
        print!("> ");
        std::io::Write::flush(&mut std::io::stdout())?;
        std::io::stdin().read_line(&mut input)?;
    }
    
    println!("REPL session ended.");
    Ok(())
}
