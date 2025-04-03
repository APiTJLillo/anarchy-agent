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

### Prerequisites

- Rust toolchain
- Node.js and npm (for UI development)
- A compatible quantized LLM model (e.g., Mistral 7B)

### Installation

```bash
# Clone the repository
git clone https://github.com/APiTJLillo/anarchy-agent.git
cd anarchy-agent

# Build the project
cargo build --release
```

### Running the Agent

```bash
# Start the agent with default settings
cargo run --release

# Or use the built binary
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

## Contributing

Contributions are welcome! Here's how you can help:

1. **Extend Core Functionality**: Add new capabilities to the agent modules
2. **Improve LLM Integration**: Enhance the interaction with local LLMs
3. **Create Examples**: Develop example tasks and workflows
4. **Documentation**: Improve guides and references

Please see our [Contributing Guide](CONTRIBUTING.md) for more details.

## License

MIT
