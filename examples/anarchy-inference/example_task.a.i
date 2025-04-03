ƒmain() {
    ⌽("Starting example task...");
    
    // List files in current directory
    ⌽("Listing files in current directory:");
    ιfiles = 📂(".");
    ∀(files, λfile {
        ⌽(file);
    });
    
    // Fetch a webpage
    ⌽("Fetching example.com...");
    ιresponse = ↗("https://example.com");
    ⌽(`Status code: ${response.s}`);
    
    // Extract and display content
    ιcontent = response.b;
    ιtitle_match = content.match(/<title>(.+?)<\/title>/);
    
    if (title_match) {
        ⌽(`Page title: ${title_match[1]}`);
    }
    
    // Save content to file
    ✍("example_page.html", content);
    ⌽("Saved page content to example_page.html");
    
    ⟼("Example task completed successfully");
}

main();
