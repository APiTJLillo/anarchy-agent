# Anarchy Agent Local Deployment Guide

This guide provides comprehensive instructions for setting up and running the anarchy-agent project on your local machine.

## Prerequisites

- Linux, macOS, or Windows with WSL
- Basic familiarity with command line operations
- Git installed
- Internet connection for downloading dependencies

## Installation Steps

### 1. Install Anarchy Inference Interpreter

The anarchy-agent project requires the Anarchy Inference interpreter to run. You can install it using our provided script or manually.

#### Automated Installation

```bash
# Make the script executable
chmod +x install_anarchy.sh

# Run the installation script
./install_anarchy.sh
```

#### Manual Installation

If you prefer to install manually:

1. Download the Anarchy Inference v0.3.1 release:
   ```bash
   wget https://github.com/APiTJLillo/Anarchy-Inference/releases/download/v0.3.1/anarchy-inference-v0.3.1-linux-x86_64.tar.gz
   ```

2. Extract the binary:
   ```bash
   mkdir -p ~/anarchy-tools/bin
   tar -xzf anarchy-inference-v0.3.1-linux-x86_64.tar.gz -C ~/anarchy-tools/bin
   chmod +x ~/anarchy-tools/bin/anarchy-inference
   ```

3. Add to your PATH:
   ```bash
   echo 'export PATH="$HOME/anarchy-tools/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

4. Verify installation:
   ```bash
   anarchy-inference --version
   ```

### 2. Set Up anarchy-agent Project

#### Automated Setup

```bash
# Make the script executable
chmod +x setup_anarchy_agent.sh

# Run the setup script
./setup_anarchy_agent.sh
```

#### Manual Setup

If you prefer to set up manually:

1. Clone the repository:
   ```bash
   mkdir -p ~/anarchy-projects
   cd ~/anarchy-projects
   git clone https://github.com/APiTJLillo/anarchy-agent.git
   cd anarchy-agent
   ```

2. Create the required directories:
   ```bash
   mkdir -p src/memory/enhanced
   mkdir -p src/llm
   mkdir -p src/reasoning
   mkdir -p src/tools
   mkdir -p src/integration
   mkdir -p examples_ai/enhanced
   mkdir -p tests/enhanced
   ```

3. Create the component files as described in the CORE_FEATURES_DOCUMENTATION.md file.

## Verification and Testing

### Automated Testing

```bash
# Make the script executable
chmod +x test_anarchy_agent.sh

# Run the test script
./test_anarchy_agent.sh
```

### Manual Testing

1. Run the verification script:
   ```bash
   cd ~/anarchy-projects/anarchy-agent
   anarchy-inference verify_setup.a.i
   ```

2. Run individual component tests:
   ```bash
   anarchy-inference examples_ai/enhanced/memory_example.a.i
   anarchy-inference examples_ai/enhanced/llm_example.a.i
   anarchy-inference examples_ai/enhanced/reasoning_example.a.i
   anarchy-inference examples_ai/enhanced/tools_example.a.i
   anarchy-inference examples_ai/enhanced/integration_example.a.i
   ```

## Project Structure

After setup, your project structure should look like this:

```
~/anarchy-projects/anarchy-agent/
├── src/
│   ├── memory/
│   │   └── enhanced/
│   │       ├── vector_memory.a.i
│   │       ├── hierarchical_memory.a.i
│   │       └── memory_integration.a.i
│   ├── llm/
│   │   ├── enhanced_llm.a.i
│   │   ├── llm_context_manager.a.i
│   │   ├── model_selector.a.i
│   │   └── llm_integration.a.i
│   ├── reasoning/
│   │   ├── chain_of_thought.a.i
│   │   ├── planning_system.a.i
│   │   ├── self_correction.a.i
│   │   └── reasoning_integration.a.i
│   ├── tools/
│   │   ├── tool_interface.a.i
│   │   ├── web_tools.a.i
│   │   ├── file_system_tools.a.i
│   │   ├── shell_tools.a.i
│   │   └── tools_integration.a.i
│   └── integration/
│       └── workflow_integration.a.i
├── examples_ai/
│   ├── enhanced/
│   │   ├── memory_example.a.i
│   │   ├── llm_example.a.i
│   │   ├── reasoning_example.a.i
│   │   ├── tools_example.a.i
│   │   └── integration_example.a.i
│   ├── corrected_syntax_example.a.i
│   ├── input_workaround_example.a.i
│   ├── memory_operations.a.i
│   ├── browser_automation.a.i
│   └── complete_workflow.a.i
└── tests/
    ├── enhanced/
    │   ├── memory_system_test.a.i
    │   ├── llm_integration_test.a.i
    │   ├── reasoning_capabilities_test.a.i
    │   └── external_tools_test.a.i
    └── integration_test.a.i
```

## Troubleshooting

### Common Issues

1. **Anarchy Inference not found**
   - Ensure the binary is in your PATH
   - Check that the binary has execute permissions

2. **Import errors in .a.i files**
   - Verify file paths in import statements
   - Check that all required files exist

3. **Syntax errors**
   - Ensure you're using the correct emoji operators
   - Check for missing brackets or parentheses

### Getting Help

If you encounter issues not covered here, please:
1. Check the CORE_FEATURES_DOCUMENTATION.md file for detailed usage information
2. Open an issue on the GitHub repository: https://github.com/APiTJLillo/anarchy-agent/issues

## Next Steps

After successfully setting up the anarchy-agent project, you can:

1. Explore the example files to understand how each component works
2. Read the CORE_FEATURES_DOCUMENTATION.md file for detailed usage information
3. Start building your own agent by modifying the existing components
4. Contribute to the project by adding new features or fixing bugs

## Conclusion

You now have a working setup of the anarchy-agent project using the Anarchy Inference language. This provides a solid foundation for developing AI agents with advanced capabilities such as memory management, reasoning, and external tool integration.

For more detailed information about the core features and how to use them, please refer to the CORE_FEATURES_DOCUMENTATION.md file.
