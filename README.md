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

## How It's Different

Unlike other autonomous agent frameworks like Auto-GPT or Manus, Anarchy Agent:

- **Operates Entirely Offline**: No cloud APIs or internet connection required for core functionality
- **Uses a Symbolic Language**: Anarchy-Inference's token-minimal syntax makes it ideal for LLM-generated code
- **Minimalist Design**: Focused on efficiency and simplicity rather than feature bloat
- **Unified Action Language**: All agent actions are expressed in a single, consistent symbolic language

## Architecture

The system consists of several core modules:

- **Planner**: Generates high-level plans using the LLM
- **Executor**: Safely runs Anarchy-Inference code in a sandboxed environment
- **Memory**: Stores and retrieves information from previous executions
- **Browser**: Automates web browsing and interaction
- **System**: Interfaces with the operating system for file and process operations

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

The repository includes several example Anarchy-Inference scripts (`.a.i` files) in the `examples/anarchy-inference` directory:

- `example_task.a.i`: Basic file operations and web requests
- `browser_automation.a.i`: Web browser automation
- `file_system_operations.a.i`: File system operations
- `memory_operations.a.i`: Memory and state persistence
- `complete_workflow.a.i`: End-to-end workflow example

To run these examples:

```bash
# Using pre-built binary
./anarchy-agent --example example_task

# Or specify a custom script
./anarchy-agent --script path/to/your_script.a.i
```

## Contributing

Contributions are welcome! Here's how you can help:

1. **Extend Core Functionality**: Add new capabilities to the agent modules
2. **Improve LLM Integration**: Enhance the interaction with local LLMs
3. **Create Examples**: Develop example tasks and workflows
4. **Documentation**: Improve guides and references

Please see our [Contributing Guide](CONTRIBUTING.md) for more details.

## License

MIT
