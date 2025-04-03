use anyhow::Result;

/// Example task to demonstrate the agent's capabilities
pub fn example_task() -> Result<()> {
    // Create a simple example that lists files and fetches a webpage
    let example_code = r#"
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
"#;

    ⌽("Example Anarchy-Inference code:");
    ⌽("{}", example_code);
    
    // In a real implementation, this would execute the code
    // let agent = Agent::new().await?;
    // agent.initialize().await?;
    // let result = agent.run_code(example_code).await?;
    // ⌽("Execution result: {}", result);
    
    Ok(())
}
