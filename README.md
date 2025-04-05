# Anarchy Agent

A fully local, cross-platform AI assistant that automates computer tasks, codes, browses, and interacts with the OS using the [Anarchy-Inference](https://github.com/APiTJLillo/Anarchy-Inference) language.

## Overview

Anarchy Agent is an autonomous agent system that uses the minimalist, token-efficient Anarchy-Inference language as its "action language" for executing tasks. The agent operates entirely offline, using a quantized open-source LLM to generate and execute Anarchy-Inference code.

### Key Features

- **Fully Local Operation**: Runs completely offline using quantized open-source LLMs
- **Symbolic Action Language**: Uses Anarchy-Inference's single-character function syntax for all operations
- **Modular Architecture**: Composed of planner, executor, memory, browser automation, and system tools
- **Secure Execution**: Sandboxed execution of generated Anarchy-Inference code
- **Cross-Platform**: Built with Rust backend and Tauri/web frontend
- **Interactive Input**: File-based input/output mechanism with emoji operators (📥, 📤, 📩)
- **Enhanced Memory**: Vector-based semantic search with tags, importance scoring, and access tracking
- **Pattern Matching**: Regex-based pattern matching with template-based code generation

## How It's Different

Unlike other autonomous agent frameworks like Auto-GPT or Manus, Anarchy Agent:

- **Operates Entirely Offline**: No cloud APIs or internet connection required for core functionality
- **Uses a Symbolic Language**: Anarchy-Inference's token-minimal syntax makes it ideal for LLM-generated code
- **Minimalist Design**: Focused on efficiency and simplicity rather than feature bloat
- **Unified Action Language**: All agent actions are expressed in a single, consistent symbolic language

## Architecture

The system consists of several core modules:

- **Planner**: Generates high-level plans using the LLM with pattern matching
- **Executor**: Safely runs Anarchy-Inference code in a sandboxed environment
- **Memory**: Stores and retrieves information with semantic search capabilities
- **Browser**: Automates web browsing and interaction
- **System**: Interfaces with the operating system for file and process operations

## New Features

### Input Function Workaround

The input function workaround provides a file-based solution for interactive capabilities:

- **📥 (get_input_from_file)**: Reads content from an input file
- **📤 (write_output_to_file)**: Writes content to an output file
- **📩 (wait_for_input_file)**: Waits for an input file to appear

Example:
```
// Write a prompt to an output file
📤("prompt.txt", "What is your name?");

// Wait for user to create input file (with 30 second timeout)
ιinput_ready = 📩("response.txt", "30000");

// Read the input file
ιuser_input = 📥("response.txt");
```

### Enhanced Memory System

The memory system now includes:

- **Vector-based semantic search** for finding relevant information
- **Tag-based searching** for categorized memory entries
- **Importance scoring** to prioritize critical information
- **Access tracking** to maintain frequently used information longer
- **Structured data support** for complex information storage

### Improved Reasoning System

The reasoning system now features:

- **Pattern matching** using regex with named capture groups
- **Template-based code generation** with variable substitution
- **Reasoning history** for tracking and explaining decisions
- **Default patterns** for common operations (file, HTTP, input, memory)

## Getting Started

### Installation

#### Pre-built Binaries (Recommended)

We provide pre-built binaries for major platforms with the Anarchy-Inference interpreter bundled in:

```bash
# Download the latest release for your platform
# Windows
curl -LO https://github.com/APiTJLillo/anarchy-agent/releases/latest/download/anarchy-agent-windows.zip
unzip anarchy-agent-windows.zip

# macOS
curl -LO https://github.com/APiTJLillo/anarchy-agent/releases/latest/download/anarchy-agent-macos.tar.gz
tar -xzf anarchy-agent-macos.tar.gz

# Linux
curl -LO https://github.com/APiTJLillo/anarchy-agent/releases/latest/download/anarchy-agent-linux.tar.gz
tar -xzf anarchy-agent-linux.tar.gz
```

#### Building from Source (For Developers)

If you prefer to build from source:

```bash
# Prerequisites:
# - Rust toolchain
# - Node.js and npm (for UI development)

# Clone the repository
git clone https://github.com/APiTJLillo/anarchy-agent.git
cd anarchy-agent

# Build the project
cargo build --release
```

### LLM Model Setup

The agent requires a local LLM model to function:

```bash
# Create the models directory
mkdir -p models

# Download a compatible model (example using Mistral 7B)
curl -L https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF/resolve/main/mistral-7b-instruct-v0.2.Q4_0.gguf -o models/mistral-7b-instruct-v0.2.Q4_0.gguf
```

### Running the Agent

```bash
# Using pre-built binary
./anarchy-agent

# Or if built from source
./target/release/anarchy-agent
```

## Example Usage

Here's a simple example of using Anarchy Agent to list files and download a webpage:

```
Task: List all files in the current directory, download the Wikipedia homepage, and extract the first paragraph.

Agent will:
1. Use ! (shell) to list files
2. Use ↗ (HTTP GET) to download the webpage
3. Use regex or parsing functions to extract text
```

## Anarchy-Inference Examples

The repository includes several example Anarchy-Inference scripts (`.a.i` files) in the `examples_ai` directory:

- `example_task.a.i`: Basic file operations and web requests
- `browser_automation.a.i`: Web browser automation
- `file_system_operations.a.i`: File system operations
- `memory_operations.a.i`: Memory and state persistence
- `complete_workflow.a.i`: End-to-end workflow example
- `input_workaround_example.a.i`: Demonstrates the input function workaround
- `corrected_syntax_example.a.i`: Shows proper Anarchy Inference syntax conventions

To run these examples:

```bash
# Using pre-built binary
./anarchy-agent --example example_task

# Or specify a custom script
./anarchy-agent --script path/to/your_script.a.i
```

## Testing

The repository includes test files for all features in the `tests` directory:

- `input_workaround_test.a.i`: Tests the input function workaround
- `memory_system_test.a.i`: Tests the enhanced memory system
- `reasoning_system_test.a.i`: Tests the improved reasoning system
- `integration_test.a.i`: Tests how all components work together

Run the tests using:

```bash
./run_tests.sh
```

## Documentation

For detailed information about the implemented features, see:

- `IMPLEMENTATION_REPORT.md`: Technical details about all implementations
- `USAGE_GUIDE.md`: Practical guide for using the new features
- `docs/input_workaround.md`: Documentation for the input function workaround

## Contributing

Contributions are welcome! Here's how you can help:

1. **Extend Core Functionality**: Add new capabilities to the agent modules
2. **Improve LLM Integration**: Enhance the interaction with local LLMs
3. **Create Examples**: Develop example tasks and workflows
4. **Documentation**: Improve guides and references

Please see our [Contributing Guide](CONTRIBUTING.md) for more details.

## License

MIT
