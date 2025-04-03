// Load the shared string dictionary
🔠("string_dictionary.json");

ƒmain() {
    ⌽(:fs_start);
    
    // Create a directory
    ⌽(:creating_dir);
    !("mkdir -p test_dir");
    
    // Create some test files
    ⌽(:creating_files);
    ✍("test_dir/file1.txt", :file1_content);
    ✍("test_dir/file2.txt", :file2_content);
    ✍("test_dir/file3.txt", :file3_content);
    
    // List directory contents
    ⌽(:listing_dir);
    ιfiles = 📂("test_dir");
    ∀(files, λfile {
        ⌽(file);
    });
    
    // Read file contents
    ⌽(:reading_files);
    ιcontent1 = 📖("test_dir/file1.txt");
    ⌽(`${:file_content}${content1}`);
    
    // Append to a file
    ⌽(:appending_file);
    ιcontent2 = 📖("test_dir/file2.txt");
    ✍("test_dir/file2.txt", content2 + :append_line);
    
    // Read the modified file
    ιupdated_content = 📖("test_dir/file2.txt");
    ⌽(`${:updated_content}${updated_content}`);
    
    // Copy a file
    ⌽(:copying_file);
    ⧉("test_dir/file3.txt", "test_dir/file3_copy.txt");
    
    // Move/rename a file
    ⌽(:moving_file);
    ↷("test_dir/file1.txt", "test_dir/file1_renamed.txt");
    
    // Check if file exists
    ⌽(:checking_exists);
    ιexists1 = ?("test_dir/file1.txt");
    ιexists2 = ?("test_dir/file1_renamed.txt");
    ⌽(`${:original_exists}${exists1}`);
    ⌽(`${:renamed_exists}${exists2}`);
    
    // List directory contents again
    ⌽(:listing_after);
    ιupdated_files = 📂("test_dir");
    ∀(updated_files, λfile {
        ⌽(file);
    });
    
    // Remove a file
    ⌽(:removing_file);
    ✂("test_dir/file3_copy.txt");
    
    // Clean up (remove directory)
    ⌽(:cleaning_up);
    ✂("test_dir");
    
    ⟼(:fs_completed);
}

main();
