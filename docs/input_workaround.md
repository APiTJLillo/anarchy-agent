# Input Function Workaround Documentation

## Overview

The Anarchy Inference language currently lacks a native input function for receiving user input during program execution. This workaround provides a file-based solution that maintains the symbolic syntax style of Anarchy Inference while enabling interactive capabilities.

## Implementation

The input workaround uses a file-based approach where:
1. The agent writes prompts to output files
2. The user responds by creating or modifying input files
3. The agent reads these input files to obtain user input

This implementation adds three new emoji operators to the Anarchy Inference language:

| Symbol | Name | Description | Parameters | Return Value |
|--------|------|-------------|------------|--------------|
| 📥 | get_input_from_file | Reads content from an input file | filename | File content as string |
| 📤 | write_output_to_file | Writes content to an output file | filename, content | "Output written" |
| 📩 | wait_for_input_file | Waits for an input file to appear | filename, timeout_ms | "true" or "false" |

## Usage

### Basic Input/Output Example

```
// Write a prompt to an output file
📤("prompt.txt", "What is your name?");

// Wait for user to create input file (with 30 second timeout)
ιinput_ready = 📩("response.txt", "30000");

if (input_ready == "true") {
    // Read the input file
    ιuser_input = 📥("response.txt");
    ⌽(`Hello, ${user_input}!`);
}
```

### Conversation Flow

1. The agent writes a prompt to a file using 📤
2. The agent waits for user input using 📩
3. The user creates or modifies the input file
4. The agent reads the input using 📥
5. The process repeats for continued conversation

## Configuration

The input workaround uses a configurable directory for input/output files:

```rust
// In config.rs
pub struct Config {
    // Other configuration options...
    
    /// Directory for input/output files (for input workaround)
    pub input_directory: String,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            // Other default values...
            input_directory: "./input_files".to_string(),
        }
    }
}
```

## Integration

The input workaround is integrated into the executor module:

1. The `InputWorkaround` struct is initialized with the configured directory
2. Input symbols (📥, 📤, 📩) are registered with the sandbox
3. These symbols can be used in Anarchy Inference code

## Error Handling

The input workaround includes comprehensive error handling:

- `InputError`: Errors related to reading input files
- `OutputError`: Errors related to writing output files
- `FileWaitError`: Errors related to waiting for input files

## Example Application

See `examples_ai/input_workaround_example.a.i` for a complete example of using the input workaround in an interactive conversation.

## Limitations

- This approach requires file system access
- There is no real-time notification when files change
- The agent must poll for file changes using the wait function
- Input is not directly integrated into the console/terminal

## Future Improvements

- Add real-time file watching using a notification system
- Implement a WebSocket-based input mechanism for web interfaces
- Create a unified input/output interface that can use different backends
- Add support for structured data input/output (JSON, etc.)
