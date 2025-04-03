// Load the shared string dictionary
🔠("string_dictionary.json");

ƒmain() {
    ⌽(:workflow_start);
    
    // 1. Gather information from the web
    ⌽(:step1);
    ιbrowser = 🌐("https://en.wikipedia.org/wiki/Rust_(programming_language)");
    
    // Extract the introduction paragraph
    ιintro = 👁(browser, "p");
    ⌽(:intro_paragraph);
    ⌽(intro);
    
    // Save the introduction to memory
    📝("rust_intro", intro);
    
    // Close the browser
    ❌(browser);
    
    // 2. Process the information
    ⌽(:step2);
    ιstored_intro = 📖("rust_intro");
    
    // Count words
    ιwords = stored_intro.split(/\s+/);
    ιword_count = words.length;
    ⌽(`${:word_count}${word_count}${:words}`);
    
    // Extract key terms (simplified example)
    ιkey_terms = [];
    ∀(["Rust", "programming language", "Mozilla", "performance", "safety"], λterm {
        if (stored_intro.includes(term)) {
            ＋(key_terms, term);
        }
    });
    
    ⌽(:key_terms);
    ∀(key_terms, λterm {
        ⌽(`${:term_prefix}${term}`);
    });
    
    // 3. Save results to file system
    ⌽(:step3);
    
    // Create a directory for results
    !("mkdir -p results");
    
    // Save the introduction
    ✍("results/rust_intro.txt", stored_intro);
    
    // Save the analysis
    ιanalysis = {
        source: "Wikipedia",
        topic: "Rust Programming Language",
        word_count: word_count,
        key_terms: key_terms,
        timestamp: Date.now()
    };
    
    ✍("results/analysis.json", ⎋(analysis));
    
    // 4. Generate a report
    ⌽(:step4);
    
    ιreport = `
${:report_title}
${:report_generated_on}${new Date().toISOString()}

${:report_intro_section}
${stored_intro}

${:report_analysis_section}
${:report_word_count}${word_count}
${:report_key_terms}${key_terms.join(", ")}

${:report_conclusion}
${:report_footer}
`;
    
    ✍("results/report.md", report);
    ⌽(:report_generated);
    
    // List all generated files
    ⌽(:generated_files);
    ιfiles = 📂("results");
    ∀(files, λfile {
        ⌽(`${:file_prefix}${file}`);
    });
    
    ⟼(:workflow_completed);
}

main();
