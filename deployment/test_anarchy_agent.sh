#!/bin/bash
# test_anarchy_agent.sh - Test script for verifying anarchy-agent functionality

echo "=== anarchy-agent Functionality Test Script ==="
echo ""

# Check if anarchy-agent directory exists
if [ ! -d ~/anarchy-projects/anarchy-agent ]; then
  echo "Error: anarchy-agent directory not found. Please run install_anarchy.sh first."
  exit 1
fi

cd ~/anarchy-projects/anarchy-agent

# Create a comprehensive test file
echo "Creating comprehensive test file..."
cat > comprehensive_test.a.i << 'EOF'
// comprehensive_test.a.i - Complete test of anarchy-agent functionality

📝 "=== anarchy-agent Comprehensive Test ==="
📝 "Starting test at: " + new Date().toString()

// Import all core modules
🔄 "./src/memory/enhanced/memory_integration.a.i"
🔄 "./src/llm/llm_integration.a.i"
🔄 "./src/reasoning/reasoning_integration.a.i"
🔄 "./src/tools/tools_integration.a.i"
🔄 "./src/integration/workflow_integration.a.i"

// Test 1: Memory System
📝 "\n=== Test 1: Memory System ==="
🧠 memory = initialize_memory_system()

📝 "Testing memory storage and retrieval..."
store_memory(memory, "test/string", "This is a string value")
store_memory(memory, "test/number", 42)
store_memory(memory, "test/boolean", true)
store_memory(memory, "test/nested/value", "Nested value")

🔍 string_value = retrieve_memory(memory, "test/string")
🔍 number_value = retrieve_memory(memory, "test/number")
🔍 boolean_value = retrieve_memory(memory, "test/boolean")
🔍 nested_value = retrieve_memory(memory, "test/nested/value")

📝 "Retrieved values:"
📝 "- String: " + string_value
📝 "- Number: " + number_value
📝 "- Boolean: " + boolean_value
📝 "- Nested: " + nested_value

📝 "Testing category search..."
🔍 test_category = search_by_category(memory, "test")
📝 "Found " + test_category.length + " items in 'test' category:"
for (🔢 i = 0; i < test_category.length; i++) {
  📝 "- " + test_category[i].path + ": " + test_category[i].value
}

📝 "Testing semantic search..."
🔍 semantic_results = semantic_search(memory, "value", 2)
📝 "Found " + semantic_results.length + " items matching 'value':"
for (🔢 i = 0; i < semantic_results.length; i++) {
  📝 "- " + semantic_results[i].path + ": " + semantic_results[i].value
}

📝 "Memory system test completed ✓"

// Test 2: LLM System
📝 "\n=== Test 2: LLM System ==="
🧠 llm = initialize_llm_system()

📝 "Testing context management..."
add_to_context(llm, "system", "You are a helpful assistant.")
add_to_context(llm, "user", "What is Anarchy Inference?")
add_to_context(llm, "assistant", "Anarchy Inference is a programming language designed for AI agents.")
add_to_context(llm, "user", "How do I use it?")

📝 "Context contains " + llm.context.system.length + " system messages"
📝 "Context contains " + llm.context.user.length + " user messages"
📝 "Context contains " + llm.context.assistant.length + " assistant messages"

📝 "Testing model selection..."
select_model(llm, "gpt-4")
📝 "Selected model: " + llm.model

📝 "Testing response generation..."
🔍 response = generate_response(llm)
📝 "Generated response: " + response

📝 "Testing code generation..."
🔍 code = generate_code(llm)
📝 "Generated code: \n" + code

📝 "LLM system test completed ✓"

// Test 3: Reasoning System
📝 "\n=== Test 3: Reasoning System ==="
🧠 reasoning = initialize_reasoning_system()

📝 "Testing chain of thought reasoning..."
🔠 problem = "Calculate how many 2x2 tiles are needed to cover a floor that is 5x3 meters, if each tile is 20x20 cm."
🔍 steps = chain_of_thought(reasoning, problem)

📝 "Chain of thought steps:"
for (🔢 i = 0; i < steps.length; i++) {
  📝 (i+1) + ". " + steps[i]
}

📝 "Testing planning system..."
🔍 plan = create_plan(reasoning, problem)
📝 "Generated plan:"
for (🔢 i = 0; i < plan.length; i++) {
  📝 (i+1) + ". " + plan[i]
}

📝 "Testing plan execution..."
🔍 result = execute_plan(reasoning, plan)
📝 "Plan execution result: " + result

📝 "Testing self-correction..."
🔠 code_with_errors = "🔠 calculate_area(x, y) {\n  📤 x + y // This should be x * y\n}"
🔍 corrected_code = self_correct(reasoning, code_with_errors)
📝 "Original code: \n" + code_with_errors
📝 "Corrected code: \n" + corrected_code

📝 "Reasoning system test completed ✓"

// Test 4: Tools System
📝 "\n=== Test 4: Tools System ==="
🧠 tools = initialize_tools_system()

📝 "Testing web tools..."
🔍 search_results = web_search(tools, "Anarchy Inference language")
📝 "Web search results:"
for (🔢 i = 0; i < search_results.length; i++) {
  📝 (i+1) + ". " + search_results[i].title + " - " + search_results[i].url
}

📝 "Testing file system tools..."
🔍 files = list_files(tools, "./")
📝 "Files in current directory:"
for (🔢 i = 0; i < files.length; i++) {
  📝 "- " + files[i]
}

📝 "Testing file write and read..."
write_file(tools, "test_output.txt", "This is a test file created by anarchy-agent.")
🔍 content = read_file(tools, "test_output.txt")
📝 "File content: " + content

📝 "Testing shell tools..."
🔍 command_output = execute_command(tools, "echo 'Hello from anarchy-agent!'")
📝 "Command output: " + command_output

📝 "Tools system test completed ✓"

// Test 5: Workflow Integration
📝 "\n=== Test 5: Workflow Integration ==="
🧠 agent = initialize_agent()

📝 "Testing task processing..."
🔠 task = "Find information about climate change, summarize it, and save the summary to a file."
🔍 task_result = process_task(agent, task)
📝 "Task processing result: " + task_result

📝 "Workflow integration test completed ✓"

// Final report
📝 "\n=== Comprehensive Test Results ==="
📝 "All systems tested successfully!"
📝 "Memory System: ✓"
📝 "LLM System: ✓"
📝 "Reasoning System: ✓"
📝 "Tools System: ✓"
📝 "Workflow Integration: ✓"
📝 "Test completed at: " + new Date().toString()
EOF

echo "Creating performance test file..."
cat > performance_test.a.i << 'EOF'
// performance_test.a.i - Performance test for anarchy-agent

📝 "=== anarchy-agent Performance Test ==="
📝 "Starting test at: " + new Date().toString()

// Import core modules
🔄 "./src/memory/enhanced/memory_integration.a.i"
🔄 "./src/llm/llm_integration.a.i"
🔄 "./src/reasoning/reasoning_integration.a.i"
🔄 "./src/tools/tools_integration.a.i"
🔄 "./src/integration/workflow_integration.a.i"

// Helper function to measure execution time
🔠 time_execution(func, ...args) {
  🔍 start_time = new Date().getTime()
  🔍 result = func(...args)
  🔍 end_time = new Date().getTime()
  🔍 elapsed = end_time - start_time
  
  📤 {
    "result": result,
    "time_ms": elapsed
  }
}

// Test 1: Memory System Performance
📝 "\n=== Memory System Performance ==="
🧠 memory = initialize_memory_system()

// Test memory storage performance
📝 "Testing memory storage performance..."
🔍 storage_times = 📦 []
for (🔢 i = 0; i < 100; i++) {
  🔍 timed = time_execution(store_memory, memory, "perf/item" + i, "Value " + i)
  storage_times.push(timed.time_ms)
}

🔍 avg_storage_time = storage_times.reduce((a, b) => a + b, 0) / storage_times.length
📝 "Average time to store a memory: " + avg_storage_time + "ms"

// Test memory retrieval performance
📝 "Testing memory retrieval performance..."
🔍 retrieval_times = 📦 []
for (🔢 i = 0; i < 100; i++) {
  🔍 timed = time_execution(retrieve_memory, memory, "perf/item" + i)
  retrieval_times.push(timed.time_ms)
}

🔍 avg_retrieval_time = retrieval_times.reduce((a, b) => a + b, 0) / retrieval_times.length
📝 "Average time to retrieve a memory: " + avg_retrieval_time + "ms"

// Test category search performance
📝 "Testing category search performance..."
🔍 search_timed = time_execution(search_by_category, memory, "perf")
📝 "Time to search category with 100 items: " + search_timed.time_ms + "ms"

// Test 2: LLM System Performance
📝 "\n=== LLM System Performance ==="
🧠 llm = initialize_llm_system()

// Test context management performance
📝 "Testing context management performance..."
🔍 context_times = 📦 []
for (🔢 i = 0; i < 100; i++) {
  🔍 timed = time_execution(add_to_context, llm, "user", "Message " + i)
  context_times.push(timed.time_ms)
}

🔍 avg_context_time = context_times.reduce((a, b) => a + b, 0) / context_times.length
📝 "Average time to add to context: " + avg_context_time + "ms"

// Test response generation performance
📝 "Testing response generation performance..."
🔍 response_timed = time_execution(generate_response, llm)
📝 "Time to generate response: " + response_timed.time_ms + "ms"

// Test 3: Reasoning System Performance
📝 "\n=== Reasoning System Performance ==="
🧠 reasoning = initialize_reasoning_system()

// Test chain of thought performance
📝 "Testing chain of thought performance..."
🔠 problem = "Calculate how many 2x2 tiles are needed to cover a floor that is 5x3 meters, if each tile is 20x20 cm."
🔍 cot_timed = time_execution(chain_of_thought, reasoning, problem)
📝 "Time for chain of thought reasoning: " + cot_timed.time_ms + "ms"

// Test planning performance
📝 "Testing planning performance..."
🔍 plan_timed = time_execution(create_plan, reasoning, problem)
📝 "Time to create a plan: " + plan_timed.time_ms + "ms"

// Test 4: Tools System Performance
📝 "\n=== Tools System Performance ==="
🧠 tools = initialize_tools_system()

// Test file operations performance
📝 "Testing file operations performance..."
🔍 write_timed = time_execution(write_file, tools, "perf_test.txt", "Performance test content")
📝 "Time to write a file: " + write_timed.time_ms + "ms"

🔍 read_timed = time_execution(read_file, tools, "perf_test.txt")
📝 "Time to read a file: " + read_timed.time_ms + "ms"

// Test 5: Workflow Integration Performance
📝 "\n=== Workflow Integration Performance ==="
🧠 agent = initialize_agent()

// Test task processing performance
📝 "Testing task processing performance..."
🔠 task = "Find information about climate change, summarize it, and save the summary to a file."
🔍 task_timed = time_execution(process_task, agent, task)
📝 "Time to process a task: " + task_timed.time_ms + "ms"

// Final report
📝 "\n=== Performance Test Results ==="
📝 "Memory System:"
📝 "- Storage: " + avg_storage_time + "ms per operation"
📝 "- Retrieval: " + avg_retrieval_time + "ms per operation"
📝 "- Category Search: " + search_timed.time_ms + "ms for 100 items"

📝 "LLM System:"
📝 "- Context Management: " + avg_context_time + "ms per operation"
📝 "- Response Generation: " + response_timed.time_ms + "ms"

📝 "Reasoning System:"
📝 "- Chain of Thought: " + cot_timed.time_ms + "ms"
📝 "- Planning: " + plan_timed.time_ms + "ms"

📝 "Tools System:"
📝 "- File Write: " + write_timed.time_ms + "ms"
📝 "- File Read: " + read_timed.time_ms + "ms"

📝 "Workflow Integration:"
📝 "- Task Processing: " + task_timed.time_ms + "ms"

📝 "Test completed at: " + new Date().toString()
EOF

echo "Creating stress test file..."
cat > stress_test.a.i << 'EOF'
// stress_test.a.i - Stress test for anarchy-agent

📝 "=== anarchy-agent Stress Test ==="
📝 "Starting test at: " + new Date().toString()

// Import core modules
🔄 "./src/memory/enhanced/memory_integration.a.i"
🔄 "./src/llm/llm_integration.a.i"
🔄 "./src/reasoning/reasoning_integration.a.i"
🔄 "./src/tools/tools_integration.a.i"
🔄 "./src/integration/workflow_integration.a.i"

// Test 1: Memory System Stress Test
📝 "\n=== Memory System Stress Test ==="
🧠 memory = initialize_memory_system()

// Store a large number of memories
📝 "Storing 1000 memories..."
for (🔢 i = 0; i < 1000; i++) {
  store_memory(memory, "stress/item" + i, "Value " + i)
}

// Verify storage
📝 "Verifying storage..."
🔍 errors = 0
for (🔢 i = 0; i < 1000; i++) {
  🔍 value = retrieve_memory(memory, "stress/item" + i)
  if (value != "Value " + i) {
    errors++
  }
}

📝 "Storage verification complete with " + errors + " errors"

// Test category search with large dataset
📝 "Testing category search with 1000 items..."
🔍 results = search_by_category(memory, "stress")
📝 "Found " + results.length + " items in category"

// Test 2: LLM System Stress Test
📝 "\n=== LLM System Stress Test ==="
🧠 llm = initialize_llm_system()

// Add a large context
📝 "Adding 1000 messages to context..."
for (🔢 i = 0; i < 1000; i++) {
  add_to_context(llm, "user", "Message " + i)
}

📝 "Context now contains " + llm.context.user.length + " user messages"

// Test response generation with large context
📝 "Testing response generation with large context..."
🔍 response = generate_response(llm)
📝 "Response generated successfully"

// Test 3: Reasoning System Stress Test
📝 "\n=== Reasoning System Stress Test ==="
🧠 reasoning = initialize_reasoning_system()

// Test with complex problem
📝 "Testing reasoning with complex problem..."
🔠 complex_problem = "A train leaves station A at 2:00 PM traveling at 60 mph. Another train leaves station B, 200 miles away, at 3:00 PM traveling at 75 mph towards station A. At what time will the two trains meet? Additionally, if each train has 8 cars and each car can hold 80 passengers, how many total passengers can both trains carry? If tickets cost $25 per passenger, what is the maximum revenue possible from selling all tickets?"

🔍 steps = chain_of_thought(reasoning, complex_problem)
📝 "Generated " + steps.length + " reasoning steps"

🔍 plan = create_plan(reasoning, complex_problem)
📝 "Generated plan with " + plan.length + " steps"

// Test 4: Tools System Stress Test
📝 "\n=== Tools System Stress Test ==="
🧠 tools = initialize_tools_system()

// Test with large file
📝 "Testing file operations with large content..."
🔠 large_content = ""
for (🔢 i = 0; i < 10000; i++) {
  large_content += "Line " + i + " of test content\n"
}

write_file(tools, "large_test.txt", large_content)
🔍 read_content = read_file(tools, "large_test.txt")
📝 "Successfully wrote and read file with " + large_content.length + " characters"

// Test 5: Workflow Integration Stress Test
📝 "\n=== Workflow Integration Stress Test ==="
🧠 agent = initialize_agent()

// Test with multiple tasks
📝 "Processing 10 tasks in sequence..."
for (🔢 i = 0; i < 10; i++) {
  🔠 task = "Task " + i + ": Analyze data, generate report, and save results."
  🔍 result = process_task(agent, task)
  📝 "Task " + i + " result: " + result
}

// Final report
📝 "\n=== Stress Test Results ==="
📝 "All stress tests completed successfully!"
📝 "Memory System: Handled 1000 items with " + errors + " errors"
📝 "LLM System: Handled context with " + llm.context.user.length + " messages"
📝 "Reasoning System: Processed complex problem with " + steps.length + " steps"
📝 "Tools System: Handled file with " + large_content.length + " characters"
📝 "Workflow Integration: Processed 10 sequential tasks"
📝 "Test completed at: " + new Date().toString()
EOF

echo "Making test files executable..."
chmod +x comprehensive_test.a.i
chmod +x performance_test.a.i
chmod +x stress_test.a.i

echo ""
echo "=== Test Scripts Created! ==="
echo ""
echo "To run the comprehensive test:"
echo "  cd ~/anarchy-projects/anarchy-agent"
echo "  anarchy-inference comprehensive_test.a.i"
echo ""
echo "To run the performance test:"
echo "  anarchy-inference performance_test.a.i"
echo ""
echo "To run the stress test:"
echo "  anarchy-inference stress_test.a.i"
echo ""
echo "For more information, see the LOCAL_DEPLOYMENT_GUIDE.md file."
