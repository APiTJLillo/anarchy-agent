// Load the shared string dictionary
🔠("string_dictionary.json");

ƒmain() {
    ⌽(:start_example);
    
    // List files in current directory
    ⌽(:listing_files);
    ιfiles = 📂(".");
    ∀(files, λfile {
        ⌽(file);
    });
    
    // Fetch a webpage
    ⌽(:fetching_webpage);
    ιresponse = ↗("https://example.com");
    ⌽(`${:status_code}${response.s}`);
    
    // Extract and display content
    ιcontent = response.b;
    ιtitle_match = content.match(/<title>(.+?)<\/title>/);
    
    if (title_match) {
        ⌽(`${:page_title}${title_match[1]}`);
    }
    
    // Save content to file
    ✍("example_page.html", content);
    ⌽(:saved_content);
    
    ⟼(:task_completed);
}

main();
