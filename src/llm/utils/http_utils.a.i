// http_utils.a.i
// HTTP request utilities for LLM API calls

🔠 create_http_utils() {
  // Create HTTP utilities for making API requests
  📤 {
    // Make an HTTP request using shell commands
    request: 🔍(method, url, headers, data) {
      // Create curl command
      🧠 cmd = "curl -s -X " + method + " \"" + url + "\""
      
      // Add headers
      for (🧠 key in headers) {
        cmd += " -H \"" + key + ": " + headers[key] + "\""
      }
      
      // Add data if present
      if (data) {
        cmd += " -d '" + JSON.stringify(data) + "'"
      }
      
      // Create a temporary file for the response
      🧠 temp_file = "/tmp/anarchy_http_response_" + Math.floor(Math.random() * 1000000) + ".json"
      cmd += " > " + temp_file
      
      // Execute command
      🧠 result = execute_shell_command(cmd)
      
      // Read response from temp file
      try {
        🧠 response_text = 📖(temp_file)
        
        // Clean up temp file
        execute_shell_command("rm " + temp_file)
        
        // Try to parse as JSON
        try {
          📤 JSON.parse(response_text)
        } catch (e) {
          // Return raw text if not valid JSON
          📤 { text: response_text }
        }
      } catch (error) {
        📤 { error: "Failed to read response" }
      }
    },
    
    // Make a GET request
    get: 🔍(url, headers) {
      📤 this.request("GET", url, headers || {})
    },
    
    // Make a POST request
    post: 🔍(url, data, headers) {
      📤 this.request("POST", url, headers || {}, data)
    },
    
    // Stream a response using a callback
    stream: 🔍(method, url, headers, data, callback) {
      // This is a simplified implementation that doesn't actually stream
      // In a real implementation, we would use a more sophisticated approach
      
      // Make the request
      🧠 response = this.request(method, url, headers, data)
      
      // Call the callback with the entire response
      if (callback && typeof callback === "function") {
        callback(response)
      }
      
      📤 true
    }
  }
}

// Helper function to execute shell commands
🔠 execute_shell_command(command) {
  // In a real implementation, this would use the shell execution capabilities
  // For now, we'll use a placeholder
  
  // Create a temporary file for the command
  🧠 cmd_file = "/tmp/anarchy_cmd_" + Math.floor(Math.random() * 1000000) + ".sh"
  ✍(cmd_file, "#!/bin/bash\n" + command)
  
  // Make it executable
  execute_shell_command("chmod +x " + cmd_file)
  
  // Execute the command
  🧠 output = execute_shell_command(cmd_file)
  
  // Clean up
  execute_shell_command("rm " + cmd_file)
  
  📤 output
}

// Export the HTTP utilities creator function
📤 {
  create_http_utils: create_http_utils
}
