# Anarchy Agent

An agent implementation using the Anarchy Inference language, designed for efficient LLM-based agents with minimal token usage.

## Overview

The Anarchy Agent project provides a framework for building intelligent agents using the Anarchy Inference language. It leverages the language's string dictionary system and symbolic syntax to create agents that are both powerful and token-efficient.

## Features

- **Memory Management**: Store and retrieve information using the string dictionary system
- **Reasoning System**: Process user inputs with configurable reasoning depth
- **Symbolic Syntax**: Use emoji operators and single-character functions for minimal token usage
- **Pattern Matching**: Recognize and respond to different input patterns
- **Extensible Design**: Add new capabilities through additional functions

## Getting Started

### Prerequisites

- Anarchy Inference v0.3.1 or higher
- Rust and Cargo for running the Anarchy Inference interpreter

### Installation

1. Clone this repository:
   ```
   git clone https://github.com/APiTJLillo/anarchy-agent.git
   ```

2. Make sure you have Anarchy Inference installed:
   ```
   git clone https://github.com/APiTJLillo/Anarchy-Inference.git
   cd Anarchy-Inference
   cargo build
   ```

### Running the Agent

To run the example agent:

```
cd anarchy-agent
cargo run --bin anarchy-inference examples/example_usage.a.i
```

## Project Structure

- `src/` - Core agent implementation files
  - `agent_core.a.i` - Main agent functionality
- `examples/` - Example usage and demonstrations
  - `example_usage.a.i` - Basic usage example

## Current Limitations

- Input function (🎤) not yet implemented in Anarchy Inference
- No module system for importing code from other files
- Limited string dictionary management for complex memory operations
- Missing external integrations for web browsing, search, and file system access

## Contributing

Contributions are welcome! Please see the TODO.md file for a list of features and improvements that are needed.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- The Anarchy Inference project for providing the language foundation
- Contributors to the LLM-VM project for inspiration on agent design
