# Anarchy Agent Documentation

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Architecture](#architecture)
4. [Usage Guide](#usage-guide)
5. [API Reference](#api-reference)
6. [Examples](#examples)
7. [Contributing](#contributing)
8. [Troubleshooting](#troubleshooting)

## Introduction

Anarchy Agent is a fully local, cross-platform AI assistant that automates computer tasks, codes, browses, and interacts with the OS using the [Anarchy-Inference](https://github.com/APiTJLillo/Anarchy-Inference) language.

The agent operates entirely offline, using a quantized open-source LLM to generate and execute Anarchy-Inference code. This makes it different from other autonomous agent frameworks like Auto-GPT or Manus, which typically rely on cloud APIs and use natural language for actions.

### Key Features

- **Fully Local Operation**: Runs completely offline using quantized open-source LLMs
- **Symbolic Action Language**: Uses Anarchy-Inference's single-character function syntax for all operations
- **Modular Architecture**: Composed of planner, executor, memory, browser automation, and system tools
- **Secure Execution**: Sandboxed execution of generated Anarchy-Inference code
- **Cross-Platform**: Built with Rust backend and Tauri/web frontend

## Installation

### Prerequisites

- Rust toolchain (1.70.0 or later)
- Node.js and npm (for UI development)
- A compatible quantized LLM model (e.g., Mistral 7B)

### Building from Source

```bash
# Clone the repository
git clone https://github.com/APiTJLillo/anarchy-agent.git
cd anarchy-agent

# Build the project
cargo build --release

# Run the agent
cargo run --release
```

### Installing the LLM Model

The agent requires a local LLM model to function. By default, it looks for the model at `./models/mistral-7b-instruct-v0.2.Q4_0.gguf`.

```bash
# Create the models directory
mkdir -p models

# Download a compatible model (example using Mistral 7B)
curl -L https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF/resolve/main/mistral-7b-instruct-v0.2.Q4_0.gguf -o models/mistral-7b-instruct-v0.2.Q4_0.gguf
```

## Architecture

Anarchy Agent is designed as a modular system with several key components that work together to create an autonomous agent capable of planning and executing tasks using the Anarchy-Inference language.

### Core Components

1. **Core Module**: The central coordinator for the entire system, managing the flow of information between components and orchestrating the agent's operation.

2. **LLM Engine**: Integrates with a quantized open-source language model to provide the intelligence for the agent.

3. **Planner**: Responsible for breaking down user tasks into actionable steps using the Anarchy-Inference language.

4. **Executor**: Safely runs Anarchy-Inference code in a sandboxed environment.

5. **Memory**: Stores and retrieves information from previous executions and interactions.

6. **Browser**: Enables web automation and interaction.

7. **System**: Interfaces with the operating system for file and process operations.

8. **UI**: Provides the user interface for interacting with the agent.

For more detailed information about the architecture, see [ARCHITECTURE.md](ARCHITECTURE.md).

## Usage Guide

### Basic Usage

1. Start the agent:

```bash
cargo run --release
```

2. Enter a task description in the UI:

```
List all files in the current directory, download the Wikipedia homepage, and extract the first paragraph.
```

3. The agent will:
   - Generate Anarchy-Inference code to accomplish the task
   - Execute the code in a sandboxed environment
   - Display the results in the UI

### Configuration

The agent can be configured by editing the `config.toml` file in the root directory:

```toml
[core]
llm_model_path = "./models/mistral-7b-instruct-v0.2.Q4_0.gguf"
memory_path = "./data/memory.db"

[browser]
headless = true

[system]
working_directory = "./workspace"
sandbox_enabled = true
```

### Command Line Options

```
USAGE:
    anarchy-agent [OPTIONS]

OPTIONS:
    -c, --config <FILE>    Sets a custom config file
    -m, --model <FILE>     Sets a custom model file
    -w, --workspace <DIR>  Sets a custom workspace directory
    -h, --help             Prints help information
    -V, --version          Prints version information
```

## API Reference

### Core Module

The Core module serves as the central coordinator for the entire system.

```rust
// Create a new agent with default configuration
let agent = Agent::new().await?;

// Initialize the agent
agent.initialize().await?;

// Run a task
let result = agent.run_task("List all files in the current directory").await?;

// Shutdown the agent
agent.shutdown().await?;
```

### Planner Module

The Planner module is responsible for generating Anarchy-Inference code from task descriptions.

```rust
// Create a new planner
let planner = Planner::new(&model_path, memory)?;

// Generate a plan
let anarchy_code = planner.generate_plan("Download a webpage").await?;
```

### Executor Module

The Executor module safely runs Anarchy-Inference code in a sandboxed environment.

```rust
// Create a new executor
let executor = Executor::new(memory, browser, system)?;

// Execute code
let result = executor.execute_code("ƒmain() { ⌽(\"Hello, World!\"); }").await?;
```

### Memory Module

The Memory module stores and retrieves information from previous executions.

```rust
// Create a new memory instance
let memory = Memory::new(&db_path)?;

// Store a result
memory.store_result("task", "code", "result").await?;

// Retrieve context
let context = memory.retrieve_context("similar task").await?;
```

### Browser Module

The Browser module enables web automation and interaction.

```rust
// Create a new browser instance
let browser = Browser::new(true)?;

// Open a page
browser.open_page("https://example.com").await?;

// Get text from an element
let text = browser.get_text("#main").await?;
```

### System Module

The System module interfaces with the operating system for file and process operations.

```rust
// Create a new system instance
let system = System::new(&working_dir, true)?;

// List directory contents
let files = system.list_directory(".").await?;

// Execute a shell command
let result = system.execute_shell("ls -la").await?;
```

## Examples

### Example 1: List Files and Download a Webpage

```
Task: List all files in the current directory, download the Wikipedia homepage, and extract the first paragraph.

Generated Anarchy-Inference code:
```

```
ƒmain() {
    ⌽("Executing task...");
    
    // List files in current directory
    ιfiles = 📂(".");
    ⌽("Files in current directory:");
    ∀(files, λfile {
        ⌽(file);
    });
    
    // Download Wikipedia homepage
    ιresponse = ↗("https://en.wikipedia.org/wiki/Main_Page");
    ⌽("Downloaded Wikipedia homepage");
    
    // Extract first paragraph using regex
    ιcontent = response.b;
    ιmatch = content.match(/<p>(.+?)<\/p>/);
    ιfirst_paragraph = match[1];
    
    // Save to file
    ✍("wikipedia_first_paragraph.txt", first_paragraph);
    ⌽("Saved first paragraph to file");
    
    ⟼("Task completed successfully");
}

main();
```

### Example 2: Browser Automation

```
Task: Search for "Rust programming language" on Google and save the first 3 results.

Generated Anarchy-Inference code:
```

```
ƒmain() {
    // Open browser and navigate to Google
    ιbrowser = 🌐("https://www.google.com");
    ⌽("Opened Google");
    
    // Input search query
    ⌨(browser, "input[name='q']", "Rust programming language");
    ⌽("Entered search query");
    
    // Click search button
    🖱(browser, "input[name='btnK']");
    ⌽("Clicked search button");
    
    // Wait for results to load
    ⏰(2000);
    
    // Extract first 3 results
    ιresults = [];
    ∀([0, 1, 2], λi {
        ιtext = 👁(browser, `#rso div.g:nth-child(${i+1}) h3`);
        ιlink = 🧠(browser, `return document.querySelector('#rso div.g:nth-child(${i+1}) a').href`);
        ＋(results, {title: text, url: link});
    });
    
    // Save results to file
    ✍("google_results.json", ⎋(results));
    ⌽("Saved results to file");
    
    // Close browser
    ❌(browser);
    
    ⟼("Search completed successfully");
}

main();
```

### Example 3: File Processing

```
Task: Read a CSV file, calculate the average of a numeric column, and save the result.

Generated Anarchy-Inference code:
```

```
ƒmain() {
    // Read CSV file
    ιcontent = 📖("data.csv");
    ⌽("Read CSV file");
    
    // Parse CSV
    ιlines = content.split("\n");
    ιheaders = lines[0].split(",");
    
    // Find index of numeric column
    ιcolumn_index = -1;
    ∀(headers, λheader, i {
        if (header == "Value") {
            column_index = i;
        }
    });
    
    if (column_index == -1) {
        ⟼("Column 'Value' not found");
    }
    
    // Calculate average
    ιsum = 0;
    ιcount = 0;
    
    ∀(lines.slice(1), λline {
        if (line.trim() == "") {
            ⟼();
        }
        
        ιvalues = line.split(",");
        ιvalue = 🔢(values[column_index]);
        sum = sum + value;
        count = count + 1;
    });
    
    ιaverage = sum / count;
    ⌽(`Average value: ${average}`);
    
    // Save result
    ✍("average.txt", `Average of 'Value' column: ${average}`);
    
    ⟼("Calculation completed successfully");
}

main();
```

## Contributing

Contributions to Anarchy Agent are welcome! Here's how you can help:

1. **Extend Core Functionality**: Add new capabilities to the agent modules
2. **Improve LLM Integration**: Enhance the interaction with local LLMs
3. **Create Examples**: Develop example tasks and workflows
4. **Documentation**: Improve guides and references

Please see our [Contributing Guide](CONTRIBUTING.md) for more details.

## Troubleshooting

### Common Issues

#### LLM Model Not Found

```
Error: ModelLoadingError("Model file not found at: ./models/mistral-7b-instruct-v0.2.Q4_0.gguf")
```

Solution: Download the model file to the correct location or specify a different model path using the `--model` option.

#### Permission Denied for File Operations

```
Error: PermissionDenied("Path /etc/passwd is not within any allowed paths")
```

Solution: The agent's sandbox restricts file operations to the working directory. Use relative paths within the working directory or configure additional allowed paths in the config file.

#### Browser Automation Fails

```
Error: BrowserInitializationError("WebDriver not initialized")
```

Solution: Ensure you have a compatible WebDriver installed for your browser. The agent uses headless Chrome by default.

### Getting Help

If you encounter issues not covered here, please:

1. Check the [GitHub Issues](https://github.com/APiTJLillo/anarchy-agent/issues) for similar problems
2. Create a new issue with detailed information about your problem
3. Include logs and error messages to help diagnose the issue
