# Anarchy Agent Core Features Documentation

This document provides detailed information about the core features of the anarchy-agent project and how to use them effectively with the Anarchy Inference language.

## Table of Contents

1. [Enhanced Memory System](#enhanced-memory-system)
2. [LLM Integration](#llm-integration)
3. [Reasoning Capabilities](#reasoning-capabilities)
4. [External Tool Interfaces](#external-tool-interfaces)
5. [Workflow Integration](#workflow-integration)
6. [Emoji Operators Reference](#emoji-operators-reference)

## Enhanced Memory System

The enhanced memory system provides sophisticated memory management capabilities for the anarchy-agent, including vector-based semantic search, hierarchical organization, and relationship tracking.

### Key Components

- **Vector Memory**: Enables semantic search based on meaning rather than exact matches
- **Hierarchical Memory**: Organizes memories in a tree-like structure with categories and namespaces
- **Memory Integration**: Combines vector and hierarchical approaches for powerful memory management

### Basic Usage

```
// Import memory modules
🔄 "./src/memory/enhanced/memory_integration.a.i"

// Initialize memory system
🧠 memory = initialize_memory_system()

// Store memories with path-based addressing
store_memory(memory, "personal/name", "John Doe")
store_memory(memory, "personal/age", 30)
store_memory(memory, "work/company", "Anarchy AI")

// Retrieve memories by path
🔍 name = retrieve_memory(memory, "personal/name")
📝 "Name: " + name

// Search by category
🔍 personal_info = search_by_category(memory, "personal")
for (🔢 i = 0; i < personal_info.length; i++) {
  📝 personal_info[i].path + ": " + personal_info[i].value
}

// Semantic search
🔍 results = semantic_search(memory, "company information", 3)
for (🔢 i = 0; i < results.length; i++) {
  📝 results[i].path + ": " + results[i].value
}
```

### Advanced Features

#### Importance Scoring

```
// Store memory with importance score
store_memory_with_metadata(memory, "critical/password", "secure123", { "importance": 0.9 })

// Retrieve memories by importance
🔍 important_memories = search_by_importance(memory, 0.8)
```

#### Access Tracking

```
// Get recently accessed memories
🔍 recent = get_recently_accessed(memory, 5)

// Get access statistics
🔍 stats = get_memory_access_stats(memory, "personal/name")
📝 "Access count: " + stats.access_count
```

## LLM Integration

The LLM integration system provides advanced capabilities for working with large language models, including context management, model selection, and specialized code generation.

### Key Components

- **Enhanced LLM Engine**: Optimized prompt templates for Anarchy Inference code generation
- **Context Manager**: Hierarchical organization of conversation history
- **Model Selector**: Intelligent model selection based on task complexity
- **LLM Integration**: Unified system connecting all LLM components

### Basic Usage

```
// Import LLM modules
🔄 "./src/llm/llm_integration.a.i"

// Initialize LLM system
🧠 llm = initialize_llm_system()

// Add context
add_to_context(llm, "system", "You are a helpful AI assistant.")
add_to_context(llm, "user", "How do I use Anarchy Inference?")

// Select appropriate model
select_model(llm, "gpt-4")

// Generate response
🔍 response = generate_response(llm)
📝 response

// Generate code
add_to_context(llm, "user", "Write a function to calculate factorial in Anarchy Inference.")
🔍 code = generate_code(llm)
📝 code
```

### Advanced Features

#### Context Compression

```
// Compress context to stay within token limits
compress_context(llm, 2000)

// Get token count estimate
🔍 tokens = estimate_token_count(llm)
📝 "Current context uses approximately " + tokens + " tokens"
```

#### Specialized Code Generation

```
// Generate code with specific requirements
🔍 code = generate_specialized_code(llm, {
  "task": "Create a web scraper",
  "language": "anarchy-inference",
  "libraries": ["web_tools", "file_system_tools"],
  "output_format": "function"
})
```

## Reasoning Capabilities

The reasoning capabilities system provides sophisticated reasoning processes for complex problem-solving, including chain-of-thought reasoning, planning, and self-correction.

### Key Components

- **Chain of Thought**: Step-by-step reasoning for complex tasks
- **Planning System**: Hierarchical planning with dependency management
- **Self-Correction**: Error detection and automatic correction
- **Reasoning Integration**: Unified system connecting all reasoning components

### Basic Usage

```
// Import reasoning modules
🔄 "./src/reasoning/reasoning_integration.a.i"

// Initialize reasoning system
🧠 reasoning = initialize_reasoning_system()

// Use chain of thought reasoning
🔠 problem = "Calculate the area of a circle with radius 5cm."
🔍 steps = chain_of_thought(reasoning, problem)

// Display reasoning steps
for (🔢 i = 0; i < steps.length; i++) {
  📝 (i+1) + ". " + steps[i]
}

// Create a plan
🔍 plan = create_plan(reasoning, problem)

// Execute the plan
🔍 result = execute_plan(reasoning, plan)
📝 "Result: " + result

// Self-correct code
🔠 code_with_errors = "🔠 factorial(n) {\n  if (n <= 1) 📤 1\n  else 📤 n * factorial(n+1) // Should be n-1\n}"
🔍 corrected_code = self_correct(reasoning, code_with_errors)
```

### Advanced Features

#### Task Decomposition

```
// Break down a complex task into subtasks
🔠 complex_task = "Build a web application that scrapes data and visualizes it"
🔍 subtasks = decompose_task(reasoning, complex_task)

// Process each subtask
for (🔢 i = 0; i < subtasks.length; i++) {
  📝 "Processing subtask: " + subtasks[i]
  🔍 subtask_plan = create_plan(reasoning, subtasks[i])
  // ...
}
```

#### Plan Visualization

```
// Visualize a plan as a tree structure
🔍 plan = create_hierarchical_plan(reasoning, complex_task)
visualize_plan(plan)
```

## External Tool Interfaces

The external tool interfaces system provides capabilities for interacting with various external systems and APIs, including web browsing, file system operations, and shell commands.

### Key Components

- **Tool Interface**: Foundation for registering, executing, and managing external tools
- **Web Tools**: Web browsing, search, and API client functionality
- **File System Tools**: File and directory operations
- **Shell Tools**: Command execution and process management
- **Tools Integration**: Unified system connecting all tool interfaces

### Basic Usage

```
// Import tools modules
🔄 "./src/tools/tools_integration.a.i"

// Initialize tools system
🧠 tools = initialize_tools_system()

// Web search
🔍 results = web_search(tools, "Anarchy Inference language")
for (🔢 i = 0; i < results.length; i++) {
  📝 results[i].title + " - " + results[i].url
}

// File operations
🔍 files = list_files(tools, "./")
write_file(tools, "output.txt", "Hello, world!")
🔍 content = read_file(tools, "output.txt")

// Shell commands
🔍 output = execute_command(tools, "echo 'Hello from anarchy-agent!'")
📝 output
```

### Advanced Features

#### Web Browsing

```
// Navigate to a URL
navigate_to(tools, "https://example.com")

// Extract content from page
🔍 page_content = extract_page_content(tools)

// Click on elements
click_element(tools, "button#submit")

// Fill form fields
fill_form_field(tools, "input#username", "user123")
```

#### Advanced File Operations

```
// Copy and move files
copy_file(tools, "source.txt", "destination.txt")
move_file(tools, "old_location.txt", "new_location.txt")

// Create and remove directories
create_directory(tools, "new_folder")
remove_directory(tools, "old_folder", true) // true for recursive

// Get file information
🔍 info = get_file_info(tools, "document.txt")
📝 "Size: " + info.size + " bytes, Modified: " + info.modified
```

## Workflow Integration

The workflow integration system ties together all components of the anarchy-agent to provide a unified workflow for processing tasks.

### Key Components

- **Agent Initialization**: Sets up all required components
- **Task Processing**: Analyzes tasks and creates execution plans
- **Component Coordination**: Manages interaction between different components
- **Result Handling**: Processes and formats results

### Basic Usage

```
// Import workflow integration
🔄 "./src/integration/workflow_integration.a.i"

// Initialize the agent
🧠 agent = initialize_agent()

// Process a task
🔠 task = "Find information about climate change, summarize it, and save the summary to a file."
🔍 result = process_task(agent, task)
📝 result
```

### Advanced Features

#### Custom Workflows

```
// Create a custom workflow
🔠 custom_workflow(agent, input_data) {
  // Step 1: Analyze input
  🔍 analysis = analyze_with_reasoning(agent, input_data)
  
  // Step 2: Search for information
  🔍 search_results = search_with_tools(agent, analysis.search_terms)
  
  // Step 3: Process information
  🔍 processed_data = process_with_llm(agent, search_results)
  
  // Step 4: Store results
  store_in_memory(agent, "results/" + input_data.id, processed_data)
  
  📤 processed_data
}

// Use the custom workflow
🔍 result = custom_workflow(agent, { "id": "task123", "query": "renewable energy" })
```

#### Workflow Monitoring

```
// Get workflow status
🔍 status = get_workflow_status(agent, "task123")
📝 "Status: " + status.state + ", Progress: " + status.progress + "%"

// Get execution metrics
🔍 metrics = get_workflow_metrics(agent, "task123")
📝 "Execution time: " + metrics.execution_time + "ms"
📝 "Memory usage: " + metrics.memory_usage + " items"
```

## Emoji Operators Reference

Anarchy Inference uses emoji operators for various operations. Here's a reference of the most commonly used operators:

| Emoji | Name | Description | Example |
|-------|------|-------------|---------|
| 🔄 | Import | Import a module | `🔄 "./module.a.i"` |
| 🧠 | Variable | Declare a variable | `🧠 x = 10` |
| 📦 | Object | Create an object | `📦 { "key": "value" }` |
| 🔠 | Function | Define a function | `🔠 add(a, b) { 📤 a + b }` |
| 📤 | Return | Return a value | `📤 result` |
| 📝 | Print | Output to console | `📝 "Hello, world!"` |
| 🔍 | Search/Find | Find or search operation | `🔍 result = search(data)` |
| 🔢 | Number | Numeric operation | `🔢 i = 0` |
| 🌐 | Web | Web-related operation | `🌐 page = fetch(url)` |
| 📂 | File | File operation | `📂 file = open("data.txt")` |
| 📖 | Read | Read operation | `📖 content = read(file)` |
| ✍ | Write | Write operation | `✍ write(file, content)` |
| 🧮 | Calculate | Calculation operation | `🧮 result = calculate(input)` |

For a complete reference of all emoji operators and their usage, please refer to the Anarchy Inference language documentation.

## Conclusion

This documentation covers the core features of the anarchy-agent project and how to use them with the Anarchy Inference language. By combining these components, you can create powerful AI agents capable of complex reasoning, memory management, and interaction with external systems.

For more detailed information and examples, please refer to the example files in the `examples_ai/enhanced` directory and the test files in the `tests/enhanced` directory.
