// file_system_tools.a.i - File system tool interfaces for Anarchy Agent
// Implements tools for file and directory operations

// Define string dictionary entries for file system tools
📝("fs_init", "Initializing file system tools...");
📝("fs_read", "Reading file: {}");
📝("fs_write", "Writing to file: {}");
📝("fs_list", "Listing directory: {}");
📝("fs_delete", "Deleting file/directory: {}");
📝("fs_error", "File system tool error: {}");
📝("fs_success", "File system tool success: {}");

// File System Tools Module Definition
λFileSystemTools {
    // Initialize file system tools
    ƒinitialize(αoptions) {
        ⌽(:fs_init);
        
        // Set default options
        ιthis.options = options || {};
        ιthis.options.tool_interface = this.options.tool_interface || null;
        ιthis.options.base_directory = this.options.base_directory || ".";
        ιthis.options.allow_absolute_paths = this.options.allow_absolute_paths !== undefined ? 
                                           this.options.allow_absolute_paths : ⊥;
        
        // Initialize operation history
        ιthis.operation_history = [];
        
        // Register tools if tool interface is available
        if (this.options.tool_interface) {
            this._register_tools();
        }
        
        ⟼(⊤);
    }
    
    // Read file content
    ƒread_file(σpath, αoptions) {
        ⌽(:fs_read, path);
        
        ÷{
            // Set read options
            ιread_options = options || {};
            ιencoding = read_options.encoding || "utf8";
            ιbinary = read_options.binary || ⊥;
            
            // Resolve path
            ιresolved_path = this._resolve_path(path);
            
            // Check if file exists
            if (!this._file_exists(resolved_path)) {
                ⌽(:fs_error, `File not found: ${path}`);
                ⟼(null);
            }
            
            // Read file
            ιcontent = null;
            if (binary) {
                // Read as binary
                content = !(`cat "${resolved_path}" | base64`);
                content = { binary: ⊤, data: content };
            } else {
                // Read as text
                content = 📖(resolved_path);
            }
            
            // Record operation
            this._record_operation("read", resolved_path, null, ⊤);
            
            ⌽(:fs_success, `Read file: ${path}`);
            ⟼(content);
        }{
            ⌽(:fs_error, `Failed to read file: ${path}`);
            this._record_operation("read", path, "Failed to read file", ⊥);
            ⟼(null);
        }
    }
    
    // Write content to file
    ƒwrite_file(σpath, αcontent, αoptions) {
        ⌽(:fs_write, path);
        
        ÷{
            // Set write options
            ιwrite_options = options || {};
            ιencoding = write_options.encoding || "utf8";
            ιappend = write_options.append || ⊥;
            ιbinary = write_options.binary || ⊥;
            ιcreate_dirs = write_options.create_dirs !== undefined ? 
                          write_options.create_dirs : ⊤;
            
            // Resolve path
            ιresolved_path = this._resolve_path(path);
            
            // Create parent directories if needed
            if (create_dirs) {
                ιdir_path = resolved_path.substring(0, resolved_path.lastIndexOf("/"));
                !(`mkdir -p "${dir_path}"`);
            }
            
            // Write file
            if (binary && content.binary && content.data) {
                // Write binary data
                !(`echo "${content.data}" | base64 -d > "${resolved_path}"`);
            } else if (append) {
                // Append text
                ✍(resolved_path, content, { append: ⊤ });
            } else {
                // Write text
                ✍(resolved_path, content);
            }
            
            // Record operation
            this._record_operation("write", resolved_path, null, ⊤);
            
            ⌽(:fs_success, `Wrote to file: ${path}`);
            ⟼(⊤);
        }{
            ⌽(:fs_error, `Failed to write to file: ${path}`);
            this._record_operation("write", path, "Failed to write to file", ⊥);
            ⟼(⊥);
        }
    }
    
    // List directory contents
    ƒlist_directory(σpath, αoptions) {
        ⌽(:fs_list, path);
        
        ÷{
            // Set list options
            ιlist_options = options || {};
            ιrecursive = list_options.recursive || ⊥;
            ιinclude_hidden = list_options.include_hidden || ⊥;
            ιdetailed = list_options.detailed || ⊥;
            
            // Resolve path
            ιresolved_path = this._resolve_path(path);
            
            // Check if directory exists
            if (!this._directory_exists(resolved_path)) {
                ⌽(:fs_error, `Directory not found: ${path}`);
                ⟼(null);
            }
            
            // List directory
            ιentries = null;
            
            if (detailed) {
                // Get detailed listing
                ιls_cmd = `ls -la${recursive ? "R" : ""}${include_hidden ? "" : " | grep -v '^\\.'"}`;
                ιls_output = !(`cd "${resolved_path}" && ${ls_cmd}`);
                
                // Parse ls output
                entries = this._parse_detailed_listing(ls_output);
            } else {
                // Get simple listing
                entries = 📂(resolved_path);
                
                // Filter hidden files if needed
                if (!include_hidden) {
                    entries = entries.filter(entry => !entry.startsWith("."));
                }
            }
            
            // Record operation
            this._record_operation("list", resolved_path, null, ⊤);
            
            ⌽(:fs_success, `Listed directory: ${path}`);
            ⟼(entries);
        }{
            ⌽(:fs_error, `Failed to list directory: ${path}`);
            this._record_operation("list", path, "Failed to list directory", ⊥);
            ⟼(null);
        }
    }
    
    // Delete file or directory
    ƒdelete(σpath, αoptions) {
        ⌽(:fs_delete, path);
        
        ÷{
            // Set delete options
            ιdelete_options = options || {};
            ιrecursive = delete_options.recursive || ⊥;
            ιforce = delete_options.force || ⊥;
            
            // Resolve path
            ιresolved_path = this._resolve_path(path);
            
            // Check if path exists
            if (!this._path_exists(resolved_path)) {
                ⌽(:fs_error, `Path not found: ${path}`);
                ⟼(⊥);
            }
            
            // Delete path
            if (this._directory_exists(resolved_path)) {
                // Delete directory
                if (recursive) {
                    !(`rm -r${force ? "f" : ""} "${resolved_path}"`);
                } else {
                    !(`rmdir "${resolved_path}"`);
                }
            } else {
                // Delete file
                !(`rm ${force ? "-f " : ""}"${resolved_path}"`);
            }
            
            // Record operation
            this._record_operation("delete", resolved_path, null, ⊤);
            
            ⌽(:fs_success, `Deleted: ${path}`);
            ⟼(⊤);
        }{
            ⌽(:fs_error, `Failed to delete: ${path}`);
            this._record_operation("delete", path, "Failed to delete", ⊥);
            ⟼(⊥);
        }
    }
    
    // Copy file or directory
    ƒcopy(σsource, σdestination, αoptions) {
        ÷{
            // Set copy options
            ιcopy_options = options || {};
            ιrecursive = copy_options.recursive || ⊤;
            ιoverwrite = copy_options.overwrite || ⊥;
            
            // Resolve paths
            ιresolved_source = this._resolve_path(source);
            ιresolved_destination = this._resolve_path(destination);
            
            // Check if source exists
            if (!this._path_exists(resolved_source)) {
                ⌽(:fs_error, `Source not found: ${source}`);
                ⟼(⊥);
            }
            
            // Check if destination exists and overwrite is not allowed
            if (this._path_exists(resolved_destination) && !overwrite) {
                ⌽(:fs_error, `Destination already exists: ${destination}`);
                ⟼(⊥);
            }
            
            // Create parent directories if needed
            ιdest_dir = resolved_destination.substring(0, resolved_destination.lastIndexOf("/"));
            !(`mkdir -p "${dest_dir}"`);
            
            // Copy
            if (this._directory_exists(resolved_source)) {
                // Copy directory
                !(`cp -${recursive ? "r" : ""}${overwrite ? "f" : ""} "${resolved_source}" "${resolved_destination}"`);
            } else {
                // Copy file
                !(`cp ${overwrite ? "-f " : ""}"${resolved_source}" "${resolved_destination}"`);
            }
            
            // Record operation
            this._record_operation("copy", `${resolved_source} -> ${resolved_destination}`, null, ⊤);
            
            ⌽(:fs_success, `Copied: ${source} -> ${destination}`);
            ⟼(⊤);
        }{
            ⌽(:fs_error, `Failed to copy: ${source} -> ${destination}`);
            this._record_operation("copy", `${source} -> ${destination}`, "Failed to copy", ⊥);
            ⟼(⊥);
        }
    }
    
    // Move file or directory
    ƒmove(σsource, σdestination, αoptions) {
        ÷{
            // Set move options
            ιmove_options = options || {};
            ιoverwrite = move_options.overwrite || ⊥;
            
            // Resolve paths
            ιresolved_source = this._resolve_path(source);
            ιresolved_destination = this._resolve_path(destination);
            
            // Check if source exists
            if (!this._path_exists(resolved_source)) {
                ⌽(:fs_error, `Source not found: ${source}`);
                ⟼(⊥);
            }
            
            // Check if destination exists and overwrite is not allowed
            if (this._path_exists(resolved_destination) && !overwrite) {
                ⌽(:fs_error, `Destination already exists: ${destination}`);
                ⟼(⊥);
            }
            
            // Create parent directories if needed
            ιdest_dir = resolved_destination.substring(0, resolved_destination.lastIndexOf("/"));
            !(`mkdir -p "${dest_dir}"`);
            
            // Move
            !(`mv ${overwrite ? "-f " : ""}"${resolved_source}" "${resolved_destination}"`);
            
            // Record operation
            this._record_operation("move", `${resolved_source} -> ${resolved_destination}`, null, ⊤);
            
            ⌽(:fs_success, `Moved: ${source} -> ${destination}`);
            ⟼(⊤);
        }{
            ⌽(:fs_error, `Failed to move: ${source} -> ${destination}`);
            this._record_operation("move", `${source} -> ${destination}`, "Failed to move", ⊥);
            ⟼(⊥);
        }
    }
    
    // Get file information
    ƒget_file_info(σpath) {
        ÷{
            // Resolve path
            ιresolved_path = this._resolve_path(path);
            
            // Check if path exists
            if (!this._path_exists(resolved_path)) {
                ⌽(:fs_error, `Path not found: ${path}`);
                ⟼(null);
            }
            
            // Get file info
            ιstat_output = !(`stat -c "%F|%s|%Y|%A|%U|%G" "${resolved_path}"`);
            ιparts = stat_output.split("|");
            
            if (parts.length !== 6) {
                ⌽(:fs_error, `Failed to get file info: ${path}`);
                ⟼(null);
            }
            
            ιinfo = {
                path: path,
                type: parts[0],
                size: parseInt(parts[1], 10),
                modified: new Date(parseInt(parts[2], 10) * 1000),
                permissions: parts[3],
                owner: parts[4],
                group: parts[5]
            };
            
            // Record operation
            this._record_operation("info", resolved_path, null, ⊤);
            
            ⟼(info);
        }{
            ⌽(:fs_error, `Failed to get file info: ${path}`);
            this._record_operation("info", path, "Failed to get file info", ⊥);
            ⟼(null);
        }
    }
    
    // Get operation history
    ƒget_operation_history(ιlimit) {
        ιmax_entries = limit || this.operation_history.length;
        ⟼(this.operation_history.slice(-max_entries));
    }
    
    // Private: Register tools with tool interface
    ƒ_register_tools() {
        ιtool_interface = this.options.tool_interface;
        
        // Register read file tool
        tool_interface.register_tool("fs_read_file", {
            description: "Read content from a file",
            execute: (params) => this.read_file(params.path, params),
            parameters: [
                { name: "path", type: "string", description: "Path to the file" },
                { name: "encoding", type: "string", description: "File encoding (default: utf8)" },
                { name: "binary", type: "boolean", description: "Whether to read as binary" }
            ],
            required_parameters: ["path"],
            returns: { type: "string", description: "File content" },
            category: "filesystem"
        });
        
        // Register write file tool
        tool_interface.register_tool("fs_write_file", {
            description: "Write content to a file",
            execute: (params) => this.write_file(params.path, params.content, params),
            parameters: [
                { name: "path", type: "string", description: "Path to the file" },
                { name: "content", type: "string", description: "Content to write" },
                { name: "encoding", type: "string", description: "File encoding (default: utf8)" },
                { name: "append", type: "boolean", description: "Whether to append to existing file" },
                { name: "binary", type: "boolean", description: "Whether to write as binary" },
                { name: "create_dirs", type: "boolean", description: "Whether to create parent directories" }
            ],
            required_parameters: ["path", "content"],
            returns: { type: "boolean", description: "Success status" },
            category: "filesystem"
        });
        
        // Register list directory tool
        tool_interface.register_tool("fs_list_directory", {
            description: "List contents of a directory",
            execute: (params) => this.list_directory(params.path, params),
            parameters: [
                { name: "path", type: "string", description: "Path to the directory" },
                { name: "recursive", type: "boolean", description: "Whether to list recursively" },
                { name: "include_hidden", type: "boolean", description: "Whether to include hidden files" },
                { name: "detailed", type: "boolean", description: "Whether to include detailed information" }
            ],
            required_parameters: ["path"],
            returns: { type: "array", description: "Array of directory entries" },
            category: "filesystem"
        });
        
        // Register delete tool
        tool_interface.register_tool("fs_delete", {
            description: "Delete a file or directory",
            execute: (params) => this.delete(params.path, params),
            parameters: [
                { name: "path", type: "string", description: "Path to delete" },
                { name: "recursive", type: "boolean", description: "Whether to delete recursively" },
                { name: "force", type: "boolean", description: "Whether to force deletion" }
            ],
            required_parameters: ["path"],
            returns: { type: "boolean", description: "Success status" },
            category: "filesystem"
        });
        
        // Register copy tool
        tool_interface.register_tool("fs_copy", {
            description: "Copy a file or directory",
            execute: (params) => this.copy(params.source, params.destination, params),
            parameters: [
                { name: "source", type: "string", description: "Source path" },
                { name: "destination", type: "string", description: "Destination path" },
                { name: "recursive", type: "boolean", description: "Whether to copy recursively" },
                { name: "overwrite", type: "boolean", description: "Whether to overwrite existing files" }
            ],
            required_parameters: ["source", "destination"],
            returns: { type: "boolean", description: "Success status" },
            category: "filesystem"
        });
        
        // Register move tool
        tool_interface.register_tool("fs_move", {
            description: "Move a file or directory",
            execute: (params) => this.move(params.source, params.destination, params),
            parameters: [
                { name: "source", type: "string", description: "Source path" },
                { name: "destination", type: "string", description: "Destination path" },
                { name: "overwrite", type: "boolean", description: "Whether to overwrite existing files" }
            ],
            required_parameters: ["source", "destination"],
            returns: { type: "boolean", description: "Success status" },
            category: "filesystem"
        });
        
        // Register file info tool
        tool_interface.register_tool("fs_get_file_info", {
            description: "Get information about a file or directory",
            execute: (params) => this.get_file_info(params.path),
            parameters: [
                { name: "path", type: "string", description: "Path to get info for" }
            ],
            required_parameters: ["path"],
            returns: { type: "object", description: "File information object" },
            category: "filesystem"
        });
    }
    
    // Private: Resolve path (relative to base directory or absolute)
    ƒ_resolve_path(σpath) {
        // Check if path is absolute
        if (path.startsWith("/")) {
            if (this.options.allow_absolute_paths) {
                ⟼(path);
            } else {
                // Strip leading slash and treat as relative
                ⟼(`${this.options.base_directory}/${path.substring(1)}`);
            }
        }
        
        // Relative path
        ⟼(`${this.options.base_directory}/${path}`);
    }
    
    // Private: Check if file exists
    ƒ_file_exists(σpath) {
        ιresult = !(`[ -f "${path}" ] && echo "true" || echo "false"`);
        ⟼(result.trim() === "true");
    }
    
    // Private: Check if directory exists
    ƒ_directory_exists(σpath) {
        ιresult = !(`[ -d "${path}" ] && echo "true" || echo "false"`);
        ⟼(result.trim() === "true");
    }
    
    // Private: Check if path exists (file or directory)
    ƒ_path_exists(σpath) {
        ιresult = !(`[ -e "${path}" ] && echo "true" || echo "false"`);
        ⟼(result.trim() === "true");
    }
    
    // Private: Parse detailed directory listing
    ƒ_parse_detailed_listing(σlisting) {
        ιlines = listing.split("\n");
        ιentries = [];
        ιcurrent_dir = "";
        
        ∀(lines, λline {
            // Check if this is a directory header line
            if (line.match(/^[\/\w]+:$/)) {
                current_dir = line.substring(0, line.length - 1);
                ⟼(); // Skip to next line
            }
            
            // Parse regular entry line
            ιentry_match = line.match(/^([drwx-]+)\s+(\d+)\s+(\w+)\s+(\w+)\s+(\d+)\s+(\w+\s+\d+\s+[\d:]+)\s+(.+)$/);
            if (entry_match) {
                ιname = entry_match[7];
                
                // Skip . and .. entries
                if (name === "." || name === "..") {
                    ⟼(); // Skip to next line
                }
                
                ＋(entries, {
                    name: name,
                    path: current_dir ? `${current_dir}/${name}` : name,
                    type: entry_match[1].startsWith("d") ? "directory" : "file",
                    permissions: entry_match[1],
                    links: parseInt(entry_match[2], 10),
                    owner: entry_match[3],
                    group: entry_match[4],
                    size: parseInt(entry_match[5], 10),
                    modified: entry_match[6]
                });
            }
        });
        
        ⟼(entries);
    }
    
    // Private: Record operation in history
    ƒ_record_operation(σoperation, σpath, σerror, βsuccess) {
        ＋(this.operation_history, {
            operation: operation,
            path: path,
            error: error,
            success: success,
            timestamp: Date.now()
        });
        
        // Limit history size
        if (this.operation_history.length > 100) {
            this.operation_history.shift();
        }
    }
}

// Export the FileSystemTools module
⟼(FileSystemTools);
