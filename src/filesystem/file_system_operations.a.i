// file_system_operations.a.i - File system operations for Anarchy Agent
// Implements directory listing, file reading/writing, file/directory removal, and file copying/moving

// Define string dictionary entries for file system operations
📝("fs_init", "Initializing file system operations...");
📝("fs_list_dir", "Listing directory: {}");
📝("fs_read_file", "Reading file: {}");
📝("fs_write_file", "Writing to file: {}");
📝("fs_remove", "Removing file/directory: {}");
📝("fs_copy", "Copying file: {} to {}");
📝("fs_move", "Moving file: {} to {}");
📝("fs_exists", "Checking if file exists: {}");
📝("fs_error", "File system error: {}");
📝("fs_success", "File system operation successful: {}");

// FileSystem Module Definition
λFileSystem {
    // Initialize file system operations
    ƒinitialize(αoptions) {
        ⌽(:fs_init);
        
        // Set default options
        ιthis.options = options || {};
        ιthis.options.base_dir = this.options.base_dir || ".";
        ιthis.options.allowed_dirs = this.options.allowed_dirs || ["."];
        ιthis.options.max_file_size = this.options.max_file_size || 10485760; // 10MB
        
        ⟼(⊤);
    }
    
    // List directory contents
    ƒlist_directory(σpath) {
        ⌽(:fs_list_dir, path);
        
        ÷{
            // Validate path
            if (!this._validate_path(path)) {
                ⌽(:fs_error, `Access denied to path: ${path}`);
                ⟼(null);
            }
            
            // Get full path
            ιfull_path = this._get_full_path(path);
            
            // Check if directory exists
            ιexists = ?(full_path);
            if (!exists) {
                ⌽(:fs_error, `Directory does not exist: ${path}`);
                ⟼(null);
            }
            
            // List directory contents
            ιfiles = 📂(full_path);
            
            ⟼(files);
        }{
            ⌽(:fs_error, `Failed to list directory: ${path}`);
            ⟼(null);
        }
    }
    
    // Read file content
    ƒread_file(σpath) {
        ⌽(:fs_read_file, path);
        
        ÷{
            // Validate path
            if (!this._validate_path(path)) {
                ⌽(:fs_error, `Access denied to path: ${path}`);
                ⟼(null);
            }
            
            // Get full path
            ιfull_path = this._get_full_path(path);
            
            // Check if file exists
            ιexists = ?(full_path);
            if (!exists) {
                ⌽(:fs_error, `File does not exist: ${path}`);
                ⟼(null);
            }
            
            // Read file content
            ιcontent = 📖(full_path);
            
            ⟼(content);
        }{
            ⌽(:fs_error, `Failed to read file: ${path}`);
            ⟼(null);
        }
    }
    
    // Write content to file
    ƒwrite_file(σpath, σcontent, βappend) {
        ⌽(:fs_write_file, path);
        
        ÷{
            // Validate path
            if (!this._validate_path(path)) {
                ⌽(:fs_error, `Access denied to path: ${path}`);
                ⟼(⊥);
            }
            
            // Get full path
            ιfull_path = this._get_full_path(path);
            
            // Create directory if it doesn't exist
            ιdir_path = full_path.substring(0, full_path.lastIndexOf("/"));
            ιdir_exists = ?(dir_path);
            if (!dir_exists) {
                !(`mkdir -p ${dir_path}`);
            }
            
            // Check content size
            if (content.length > this.options.max_file_size) {
                ⌽(:fs_error, `Content exceeds maximum file size: ${this.options.max_file_size} bytes`);
                ⟼(⊥);
            }
            
            // Write content to file
            if (append) {
                // Append to file
                ιexisting_content = "";
                ιfile_exists = ?(full_path);
                if (file_exists) {
                    existing_content = 📖(full_path);
                }
                ✍(full_path, existing_content + content);
            } else {
                // Overwrite file
                ✍(full_path, content);
            }
            
            ⟼(⊤);
        }{
            ⌽(:fs_error, `Failed to write to file: ${path}`);
            ⟼(⊥);
        }
    }
    
    // Remove file or directory
    ƒremove(σpath) {
        ⌽(:fs_remove, path);
        
        ÷{
            // Validate path
            if (!this._validate_path(path)) {
                ⌽(:fs_error, `Access denied to path: ${path}`);
                ⟼(⊥);
            }
            
            // Get full path
            ιfull_path = this._get_full_path(path);
            
            // Check if file/directory exists
            ιexists = ?(full_path);
            if (!exists) {
                ⌽(:fs_error, `File/directory does not exist: ${path}`);
                ⟼(⊥);
            }
            
            // Remove file/directory
            ✂(full_path);
            
            ⟼(⊤);
        }{
            ⌽(:fs_error, `Failed to remove file/directory: ${path}`);
            ⟼(⊥);
        }
    }
    
    // Copy file
    ƒcopy_file(σsource, σdestination) {
        ⌽(:fs_copy, source, destination);
        
        ÷{
            // Validate paths
            if (!this._validate_path(source) || !this._validate_path(destination)) {
                ⌽(:fs_error, `Access denied to path: ${!this._validate_path(source) ? source : destination}`);
                ⟼(⊥);
            }
            
            // Get full paths
            ιfull_source = this._get_full_path(source);
            ιfull_destination = this._get_full_path(destination);
            
            // Check if source file exists
            ιsource_exists = ?(full_source);
            if (!source_exists) {
                ⌽(:fs_error, `Source file does not exist: ${source}`);
                ⟼(⊥);
            }
            
            // Create destination directory if it doesn't exist
            ιdest_dir = full_destination.substring(0, full_destination.lastIndexOf("/"));
            ιdir_exists = ?(dest_dir);
            if (!dir_exists) {
                !(`mkdir -p ${dest_dir}`);
            }
            
            // Copy file
            ⧉(full_source, full_destination);
            
            ⟼(⊤);
        }{
            ⌽(:fs_error, `Failed to copy file from ${source} to ${destination}`);
            ⟼(⊥);
        }
    }
    
    // Move file
    ƒmove_file(σsource, σdestination) {
        ⌽(:fs_move, source, destination);
        
        ÷{
            // Validate paths
            if (!this._validate_path(source) || !this._validate_path(destination)) {
                ⌽(:fs_error, `Access denied to path: ${!this._validate_path(source) ? source : destination}`);
                ⟼(⊥);
            }
            
            // Get full paths
            ιfull_source = this._get_full_path(source);
            ιfull_destination = this._get_full_path(destination);
            
            // Check if source file exists
            ιsource_exists = ?(full_source);
            if (!source_exists) {
                ⌽(:fs_error, `Source file does not exist: ${source}`);
                ⟼(⊥);
            }
            
            // Create destination directory if it doesn't exist
            ιdest_dir = full_destination.substring(0, full_destination.lastIndexOf("/"));
            ιdir_exists = ?(dest_dir);
            if (!dir_exists) {
                !(`mkdir -p ${dest_dir}`);
            }
            
            // Move file
            ↷(full_source, full_destination);
            
            ⟼(⊤);
        }{
            ⌽(:fs_error, `Failed to move file from ${source} to ${destination}`);
            ⟼(⊥);
        }
    }
    
    // Check if file exists
    ƒfile_exists(σpath) {
        ⌽(:fs_exists, path);
        
        ÷{
            // Validate path
            if (!this._validate_path(path)) {
                ⌽(:fs_error, `Access denied to path: ${path}`);
                ⟼(⊥);
            }
            
            // Get full path
            ιfull_path = this._get_full_path(path);
            
            // Check if file exists
            ιexists = ?(full_path);
            
            ⟼(exists);
        }{
            ⌽(:fs_error, `Failed to check if file exists: ${path}`);
            ⟼(⊥);
        }
    }
    
    // Private: Validate path against allowed directories
    ƒ_validate_path(σpath) {
        // Normalize path
        ιnormalized_path = path.replace(/\/+/g, "/").replace(/\/\.\//g, "/");
        
        // Check for path traversal attempts
        if (normalized_path.includes("..")) {
            ⟼(⊥);
        }
        
        // Check if path is within allowed directories
        ∀(this.options.allowed_dirs, λallowed_dir {
            if (normalized_path.startsWith(allowed_dir)) {
                ⟼(⊤);
            }
        });
        
        ⟼(⊥);
    }
    
    // Private: Get full path
    ƒ_get_full_path(σpath) {
        // If path is absolute, return as is
        if (path.startsWith("/")) {
            ⟼(path);
        }
        
        // Otherwise, prepend base directory
        ⟼(`${this.options.base_dir}/${path}`);
    }
    
    // Emoji operators for direct use
    // These match the IMPLEMENTATION_DETAILS.md documentation
    
    // 📂 (list_directory) - List directory contents
    ƒ📂(σpath) {
        ⟼(this.list_directory(path));
    }
    
    // 📖 (read_file) - Read file content
    ƒ📖(σpath) {
        ⟼(this.read_file(path));
    }
    
    // ✍ (write_file) - Write content to file
    ƒ✍(σpath, σcontent) {
        ⟼(this.write_file(path, content, ⊥));
    }
    
    // ✂ (remove_file_directory) - Remove file or directory
    ƒ✂(σpath) {
        ⟼(this.remove(path));
    }
    
    // ⧉ (copy_file) - Copy file
    ƒ⧉(σsource, σdestination) {
        ⟼(this.copy_file(source, destination));
    }
    
    // ↷ (move_file) - Move file
    ƒ↷(σsource, σdestination) {
        ⟼(this.move_file(source, destination));
    }
    
    // ? (file_exists) - Check if file exists
    ƒ?(σpath) {
        ⟼(this.file_exists(path));
    }
}

// Export the FileSystem module
⟼(FileSystem);
