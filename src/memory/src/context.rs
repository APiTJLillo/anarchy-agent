use crate::storage::MemoryEntry;

/// Format memory entries into a context string for the LLM
pub fn format_context(entries: &[MemoryEntry]) -> String {
    if entries.is_empty() {
        return "No relevant previous executions found.".to_string();
    }
    
    let mut context = String::from("Previous relevant executions:\n\n");
    
    for (i, entry) in entries.iter().enumerate() {
        context.push_str(&format!(
            "Execution {}:\n- Task: {}\n- Code:\n```\n{}\n```\n- Result: {}\n\n",
            i + 1,
            entry.task,
            entry.code,
            entry.result
        ));
    }
    
    context
}

/// Extract keywords from a task description for relevance matching
pub fn extract_keywords(task_description: &str) -> Vec<String> {
    // In a real implementation, this would use NLP techniques to extract keywords
    // For now, just split by spaces and filter out common words
    let common_words = vec![
        "a", "an", "the", "and", "or", "but", "in", "on", "at", "to", "for", "with",
        "is", "are", "was", "were", "be", "been", "being",
    ];
    
    task_description
        .split_whitespace()
        .map(|word| word.to_lowercase())
        .filter(|word| !common_words.contains(&word.as_str()))
        .collect()
}

/// Calculate relevance score between a task and a memory entry
pub fn calculate_relevance(task_description: &str, entry: &MemoryEntry) -> f32 {
    // In a real implementation, this would use more sophisticated techniques
    // For now, just count keyword matches
    let task_keywords = extract_keywords(task_description);
    let entry_keywords = extract_keywords(&entry.task);
    
    let mut matches = 0;
    for task_keyword in &task_keywords {
        if entry_keywords.contains(task_keyword) {
            matches += 1;
        }
    }
    
    if task_keywords.is_empty() {
        return 0.0;
    }
    
    matches as f32 / task_keywords.len() as f32
}
