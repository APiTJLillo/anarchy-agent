// shell_tools.a.i - Shell command execution tools for Anarchy Agent
// Implements tools for executing shell commands and managing processes

// Define string dictionary entries for shell tools
📝("shell_init", "Initializing shell tools...");
📝("shell_exec", "Executing command: {}");
📝("shell_bg", "Starting background process: {}");
📝("shell_kill", "Killing process: {}");
📝("shell_error", "Shell tool error: {}");
📝("shell_success", "Shell tool success: {}");

// Shell Tools Module Definition
λShellTools {
    // Initialize shell tools
    ƒinitialize(αoptions) {
        ⌽(:shell_init);
        
        // Set default options
        ιthis.options = options || {};
        ιthis.options.tool_interface = this.options.tool_interface || null;
        ιthis.options.working_directory = this.options.working_directory || ".";
        ιthis.options.timeout = this.options.timeout || 60000;
        ιthis.options.max_output_size = this.options.max_output_size || 1048576; // 1MB
        
        // Initialize process tracking
        ιthis.processes = {};
        ιthis.command_history = [];
        
        // Register tools if tool interface is available
        if (this.options.tool_interface) {
            this._register_tools();
        }
        
        ⟼(⊤);
    }
    
    // Execute shell command
    ƒexecute_command(σcommand, αoptions) {
        ⌽(:shell_exec, command);
        
        ÷{
            // Set execution options
            ιexec_options = options || {};
            ιworking_dir = exec_options.working_dir || this.options.working_directory;
            ιtimeout = exec_options.timeout || this.options.timeout;
            ιcapture_stderr = exec_options.capture_stderr !== undefined ? 
                             exec_options.capture_stderr : ⊤;
            
            // Execute command
            ιoutput = null;
            ιexit_code = null;
            
            if (capture_stderr) {
                // Capture both stdout and stderr
                ιresult = !(`cd "${working_dir}" && { ${command}; } 2>&1; echo "EXIT_CODE=$?"`);
                
                // Extract exit code
                ιexit_code_match = result.match(/EXIT_CODE=(\d+)$/);
                if (exit_code_match) {
                    exit_code = parseInt(exit_code_match[1], 10);
                    output = result.substring(0, result.length - exit_code_match[0].length);
                } else {
                    output = result;
                    exit_code = 0;
                }
            } else {
                // Capture only stdout
                ιresult = !(`cd "${working_dir}" && { ${command}; } > /tmp/cmd_output; echo "EXIT_CODE=$?"`);
                
                // Extract exit code
                ιexit_code_match = result.match(/EXIT_CODE=(\d+)$/);
                if (exit_code_match) {
                    exit_code = parseInt(exit_code_match[1], 10);
                }
                
                // Read output from file
                output = 📖("/tmp/cmd_output");
            }
            
            // Truncate output if too large
            if (output && output.length > this.options.max_output_size) {
                output = output.substring(0, this.options.max_output_size) + 
                        "\n... [output truncated, exceeded maximum size] ...";
            }
            
            // Record command in history
            this._record_command(command, working_dir, output, exit_code, ⊤);
            
            ⌽(:shell_success, `Command executed with exit code: ${exit_code}`);
            ⟼({
                output: output,
                exit_code: exit_code,
                success: exit_code === 0
            });
        }{
            ⌽(:shell_error, `Failed to execute command: ${command}`);
            this._record_command(command, options?.working_dir || this.options.working_directory, null, null, ⊥);
            ⟼({
                output: null,
                exit_code: -1,
                success: ⊥,
                error: "Command execution failed"
            });
        }
    }
    
    // Start background process
    ƒstart_background_process(σcommand, αoptions) {
        ⌽(:shell_bg, command);
        
        ÷{
            // Set process options
            ιprocess_options = options || {};
            ιworking_dir = process_options.working_dir || this.options.working_directory;
            ιoutput_file = process_options.output_file || "/dev/null";
            ιname = process_options.name || `process_${Date.now()}`;
            
            // Start background process
            ιpid_output = !(`cd "${working_dir}" && { ${command}; } > "${output_file}" 2>&1 & echo $!`);
            ιpid = parseInt(pid_output.trim(), 10);
            
            if (isNaN(pid)) {
                ⌽(:shell_error, `Failed to start background process: ${command}`);
                ⟼(null);
            }
            
            // Record process
            ιprocess = {
                pid: pid,
                name: name,
                command: command,
                working_dir: working_dir,
                output_file: output_file,
                start_time: Date.now(),
                status: "running"
            };
            
            this.processes[pid] = process;
            
            // Record command in history
            this._record_command(command, working_dir, `Started background process with PID: ${pid}`, 0, ⊤);
            
            ⌽(:shell_success, `Started background process with PID: ${pid}`);
            ⟼(process);
        }{
            ⌽(:shell_error, `Failed to start background process: ${command}`);
            this._record_command(command, options?.working_dir || this.options.working_directory, null, null, ⊥);
            ⟼(null);
        }
    }
    
    // Check process status
    ƒcheck_process(ιpid) {
        ÷{
            // Check if process is in our tracking
            if (!this.processes[pid]) {
                ⌽(:shell_error, `Process not found: ${pid}`);
                ⟼(null);
            }
            
            ιprocess = this.processes[pid];
            
            // Check if process is still running
            ιstatus_output = !(`ps -p ${pid} -o state= || echo "X"`);
            ιis_running = status_output.trim() !== "X";
            
            // Update process status
            if (is_running) {
                process.status = "running";
            } else {
                process.status = "terminated";
                process.end_time = Date.now();
            }
            
            // Get process output if available
            if (process.output_file && process.output_file !== "/dev/null") {
                ÷{
                    process.output = 📖(process.output_file);
                    
                    // Truncate output if too large
                    if (process.output && process.output.length > this.options.max_output_size) {
                        process.output = process.output.substring(0, this.options.max_output_size) + 
                                        "\n... [output truncated, exceeded maximum size] ...";
                    }
                }{
                    process.output = "Failed to read output file";
                }
            }
            
            ⟼(process);
        }{
            ⌽(:shell_error, `Failed to check process: ${pid}`);
            ⟼(null);
        }
    }
    
    // Kill process
    ƒkill_process(ιpid, αoptions) {
        ⌽(:shell_kill, pid);
        
        ÷{
            // Set kill options
            ιkill_options = options || {};
            ιforce = kill_options.force || ⊥;
            ιsignal = kill_options.signal || (force ? "SIGKILL" : "SIGTERM");
            
            // Check if process exists
            ιprocess = this.check_process(pid);
            
            if (!process) {
                ⌽(:shell_error, `Process not found: ${pid}`);
                ⟼(⊥);
            }
            
            // If process is already terminated, return success
            if (process.status === "terminated") {
                ⌽(:shell_success, `Process ${pid} is already terminated`);
                ⟼(⊤);
            }
            
            // Kill process
            !(`kill -${signal} ${pid}`);
            
            // Update process status
            process.status = "terminated";
            process.end_time = Date.now();
            process.killed_by = signal;
            
            ⌽(:shell_success, `Killed process ${pid} with signal ${signal}`);
            ⟼(⊤);
        }{
            ⌽(:shell_error, `Failed to kill process: ${pid}`);
            ⟼(⊥);
        }
    }
    
    // List all tracked processes
    ƒlist_processes() {
        ÷{
            // Update status of all processes
            ∀(Object.keys(this.processes), λpid {
                this.check_process(parseInt(pid, 10));
            });
            
            ⟼(this.processes);
        }{
            ⌽(:shell_error, "Failed to list processes");
            ⟼({});
        }
    }
    
    // Get command history
    ƒget_command_history(ιlimit) {
        ιmax_entries = limit || this.command_history.length;
        ⟼(this.command_history.slice(-max_entries));
    }
    
    // Private: Register tools with tool interface
    ƒ_register_tools() {
        ιtool_interface = this.options.tool_interface;
        
        // Register execute command tool
        tool_interface.register_tool("shell_execute_command", {
            description: "Execute a shell command",
            execute: (params) => this.execute_command(params.command, params),
            parameters: [
                { name: "command", type: "string", description: "Shell command to execute" },
                { name: "working_dir", type: "string", description: "Working directory for command execution" },
                { name: "timeout", type: "number", description: "Command timeout in milliseconds" },
                { name: "capture_stderr", type: "boolean", description: "Whether to capture stderr output" }
            ],
            required_parameters: ["command"],
            returns: { type: "object", description: "Command execution result with output and exit code" },
            category: "shell"
        });
        
        // Register background process tool
        tool_interface.register_tool("shell_start_background_process", {
            description: "Start a background process",
            execute: (params) => this.start_background_process(params.command, params),
            parameters: [
                { name: "command", type: "string", description: "Shell command to execute in background" },
                { name: "working_dir", type: "string", description: "Working directory for process execution" },
                { name: "output_file", type: "string", description: "File to capture process output" },
                { name: "name", type: "string", description: "Name for the process" }
            ],
            required_parameters: ["command"],
            returns: { type: "object", description: "Process information object" },
            category: "shell"
        });
        
        // Register check process tool
        tool_interface.register_tool("shell_check_process", {
            description: "Check status of a background process",
            execute: (params) => this.check_process(params.pid),
            parameters: [
                { name: "pid", type: "number", description: "Process ID to check" }
            ],
            required_parameters: ["pid"],
            returns: { type: "object", description: "Process status information" },
            category: "shell"
        });
        
        // Register kill process tool
        tool_interface.register_tool("shell_kill_process", {
            description: "Kill a background process",
            execute: (params) => this.kill_process(params.pid, params),
            parameters: [
                { name: "pid", type: "number", description: "Process ID to kill" },
                { name: "force", type: "boolean", description: "Whether to force kill the process" },
                { name: "signal", type: "string", description: "Signal to send (default: SIGTERM or SIGKILL if force=true)" }
            ],
            required_parameters: ["pid"],
            returns: { type: "boolean", description: "Success status" },
            category: "shell"
        });
        
        // Register list processes tool
        tool_interface.register_tool("shell_list_processes", {
            description: "List all tracked background processes",
            execute: () => this.list_processes(),
            parameters: [],
            required_parameters: [],
            returns: { type: "object", description: "Object mapping PIDs to process information" },
            category: "shell"
        });
    }
    
    // Private: Record command in history
    ƒ_record_command(σcommand, σworking_dir, αoutput, ιexit_code, βsuccess) {
        ＋(this.command_history, {
            command: command,
            working_dir: working_dir,
            output: output,
            exit_code: exit_code,
            success: success,
            timestamp: Date.now()
        });
        
        // Limit history size
        if (this.command_history.length > 100) {
            this.command_history.shift();
        }
    }
}

// Export the ShellTools module
⟼(ShellTools);
