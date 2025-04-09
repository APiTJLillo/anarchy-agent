// web_tools.a.i - Web-based tool interfaces for Anarchy Agent
// Implements tools for web browsing, searching, and API interactions

// Define string dictionary entries for web tools
📝("web_init", "Initializing web tools...");
📝("web_browse", "Browsing URL: {}");
📝("web_search", "Searching for: {}");
📝("web_api", "Calling API: {}");
📝("web_error", "Web tool error: {}");
📝("web_success", "Web tool success: {}");

// Web Tools Module Definition
λWebTools {
    // Initialize web tools
    ƒinitialize(αoptions) {
        ⌽(:web_init);
        
        // Set default options
        ιthis.options = options || {};
        ιthis.options.tool_interface = this.options.tool_interface || null;
        ιthis.options.user_agent = this.options.user_agent || "Anarchy Agent/1.0";
        ιthis.options.timeout = this.options.timeout || 30000;
        
        // Initialize state
        ιthis.current_page = null;
        ιthis.browser_history = [];
        ιthis.search_history = [];
        
        // Register tools if tool interface is available
        if (this.options.tool_interface) {
            this._register_tools();
        }
        
        ⟼(⊤);
    }
    
    // Browse to a URL
    ƒbrowse(σurl, αoptions) {
        ⌽(:web_browse, url);
        
        ÷{
            // Set browsing options
            ιbrowse_options = options || {};
            ιheaders = browse_options.headers || {};
            ιtimeout = browse_options.timeout || this.options.timeout;
            ιfollow_redirects = browse_options.follow_redirects !== undefined ? 
                               browse_options.follow_redirects : ⊤;
            
            // Add default user agent if not specified
            if (!headers["User-Agent"]) {
                headers["User-Agent"] = this.options.user_agent;
            }
            
            // Make HTTP request
            ιresponse = !(`curl -s -L -A "${headers['User-Agent']}" -m ${timeout / 1000} "${url}"`);
            
            // Update current page and history
            ιpage = {
                url: url,
                content: response,
                timestamp: Date.now()
            };
            
            this.current_page = page;
            ＋(this.browser_history, page);
            
            ⌽(:web_success, `Browsed to ${url}`);
            ⟼(page);
        }{
            ⌽(:web_error, `Failed to browse to ${url}`);
            ⟼(null);
        }
    }
    
    // Search the web
    ƒsearch(σquery, αoptions) {
        ⌽(:web_search, query);
        
        ÷{
            // Set search options
            ιsearch_options = options || {};
            ιengine = search_options.engine || "duckduckgo";
            ιnum_results = search_options.num_results || 5;
            
            // Encode query
            ιencoded_query = encodeURIComponent(query);
            
            // Determine search URL based on engine
            ιsearch_url = "";
            if (engine === "duckduckgo") {
                search_url = `https://lite.duckduckgo.com/lite/?q=${encoded_query}`;
            } else if (engine === "google") {
                search_url = `https://www.google.com/search?q=${encoded_query}&num=${num_results}`;
            } else {
                search_url = `https://lite.duckduckgo.com/lite/?q=${encoded_query}`;
            }
            
            // Browse to search URL
            ιpage = this.browse(search_url);
            
            if (!page) {
                ⌽(:web_error, `Search failed for query: ${query}`);
                ⟼(null);
            }
            
            // Extract search results
            ιresults = this._extract_search_results(page.content, engine);
            
            // Add to search history
            ＋(this.search_history, {
                query: query,
                engine: engine,
                results: results,
                timestamp: Date.now()
            });
            
            ⌽(:web_success, `Found ${results.length} results for "${query}"`);
            ⟼(results);
        }{
            ⌽(:web_error, `Search failed for query: ${query}`);
            ⟼(null);
        }
    }
    
    // Call a REST API
    ƒcall_api(σurl, αoptions) {
        ⌽(:web_api, url);
        
        ÷{
            // Set API options
            ιapi_options = options || {};
            ιmethod = api_options.method || "GET";
            ιheaders = api_options.headers || {};
            ιdata = api_options.data || null;
            ιtimeout = api_options.timeout || this.options.timeout;
            
            // Add default headers
            if (!headers["User-Agent"]) {
                headers["User-Agent"] = this.options.user_agent;
            }
            
            if (!headers["Content-Type"] && data) {
                headers["Content-Type"] = "application/json";
            }
            
            // Build curl command
            ιcurl_cmd = `curl -s -X ${method} -m ${timeout / 1000}`;
            
            // Add headers
            ∀(Object.keys(headers), λheader {
                curl_cmd += ` -H "${header}: ${headers[header]}"`;
            });
            
            // Add data if present
            if (data) {
                ιdata_str = typeof data === "string" ? data : JSON.stringify(data);
                curl_cmd += ` -d '${data_str}'`;
            }
            
            // Add URL
            curl_cmd += ` "${url}"`;
            
            // Execute curl command
            ιresponse = !(`${curl_cmd}`);
            
            // Parse JSON response if possible
            ιparsed_response = null;
            ÷{
                parsed_response = JSON.parse(response);
            }{
                parsed_response = response;
            }
            
            ⌽(:web_success, `API call to ${url} successful`);
            ⟼(parsed_response);
        }{
            ⌽(:web_error, `API call to ${url} failed`);
            ⟼(null);
        }
    }
    
    // Get current page
    ƒget_current_page() {
        ⟼(this.current_page);
    }
    
    // Get browser history
    ƒget_browser_history(ιlimit) {
        ιmax_entries = limit || this.browser_history.length;
        ⟼(this.browser_history.slice(-max_entries));
    }
    
    // Get search history
    ƒget_search_history(ιlimit) {
        ιmax_entries = limit || this.search_history.length;
        ⟼(this.search_history.slice(-max_entries));
    }
    
    // Private: Register tools with tool interface
    ƒ_register_tools() {
        ιtool_interface = this.options.tool_interface;
        
        // Register browse tool
        tool_interface.register_tool("web_browse", {
            description: "Browse to a URL and retrieve the page content",
            execute: (params) => this.browse(params.url, params),
            parameters: [
                { name: "url", type: "string", description: "URL to browse to" },
                { name: "headers", type: "object", description: "Optional HTTP headers" },
                { name: "timeout", type: "number", description: "Request timeout in milliseconds" },
                { name: "follow_redirects", type: "boolean", description: "Whether to follow redirects" }
            ],
            required_parameters: ["url"],
            returns: { type: "object", description: "Page object with URL, content, and timestamp" },
            category: "web"
        });
        
        // Register search tool
        tool_interface.register_tool("web_search", {
            description: "Search the web using a search engine",
            execute: (params) => this.search(params.query, params),
            parameters: [
                { name: "query", type: "string", description: "Search query" },
                { name: "engine", type: "string", description: "Search engine to use (duckduckgo, google)" },
                { name: "num_results", type: "number", description: "Number of results to return" }
            ],
            required_parameters: ["query"],
            returns: { type: "array", description: "Array of search result objects" },
            category: "web"
        });
        
        // Register API call tool
        tool_interface.register_tool("web_api_call", {
            description: "Call a REST API",
            execute: (params) => this.call_api(params.url, params),
            parameters: [
                { name: "url", type: "string", description: "API endpoint URL" },
                { name: "method", type: "string", description: "HTTP method (GET, POST, PUT, DELETE, etc.)" },
                { name: "headers", type: "object", description: "HTTP headers" },
                { name: "data", type: "object", description: "Request data (for POST, PUT, etc.)" },
                { name: "timeout", type: "number", description: "Request timeout in milliseconds" }
            ],
            required_parameters: ["url"],
            returns: { type: "object", description: "API response (parsed JSON if possible)" },
            category: "web"
        });
    }
    
    // Private: Extract search results from page content
    ƒ_extract_search_results(σcontent, σengine) {
        ιresults = [];
        
        if (engine === "duckduckgo") {
            // Simple regex-based extraction for DuckDuckGo Lite
            ιlink_regex = /<a rel="nofollow" href="([^"]+)".*?>([^<]+)<\/a>/g;
            ιmatches = content.matchAll(link_regex);
            
            for (ιmatch of matches) {
                if (match[1] && match[2] && !match[1].includes("duckduckgo.com")) {
                    ＋(results, {
                        title: match[2].trim(),
                        url: match[1],
                        snippet: ""
                    });
                }
            }
        } else if (engine === "google") {
            // Simple regex-based extraction for Google
            ιlink_regex = /<a href="([^"]+)".*?>(.*?)<\/a>/g;
            ιmatches = content.matchAll(link_regex);
            
            for (ιmatch of matches) {
                if (match[1] && match[1].startsWith("/url?q=")) {
                    ιurl = decodeURIComponent(match[1].substring(7).split("&")[0]);
                    if (!url.includes("google.com")) {
                        ＋(results, {
                            title: match[2].replace(/<.*?>/g, "").trim(),
                            url: url,
                            snippet: ""
                        });
                    }
                }
            }
        }
        
        // Limit to unique results
        ιunique_results = [];
        ιseen_urls = {};
        
        ∀(results, λresult {
            if (!seen_urls[result.url]) {
                seen_urls[result.url] = ⊤;
                ＋(unique_results, result);
            }
        });
        
        ⟼(unique_results);
    }
}

// Export the WebTools module
⟼(WebTools);
