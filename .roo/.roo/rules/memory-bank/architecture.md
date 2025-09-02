# Architecture

## System Architecture

The RooCode extension's configuration is designed around a modular architecture that separates concerns and allows for scalability. The core components are:

*   **Modes:** Each mode is a self-contained set of rules and instructions that define the AI's behavior for a specific task.
*   **Rules:** A hierarchical system of rules, from global to mode-specific, that governs the AI's operation.
*   **MCP (Model Context Protocol):** An integration layer for connecting to external services and APIs.

## Source Code Paths

The primary configuration files are located in the `.roo` directory:

*   `.roo/rules/`: Contains the core rules and guidelines for the extension.
*   `.roo/rules-*/`: Each subdirectory contains the rules for a specific mode (e.g., `.roo/rules-docs-writer/`).
*   `.roo/mcp.json`: Configuration for MCP servers.

## Key Technical Decisions

*   **Markdown for Rules:** Rules are written in Markdown for readability and ease of maintenance.
*   **JSON for Configuration:** MCP server configurations are in JSON format for structured data.
*   **Directory-based Mode Organization:** Each mode's configuration is contained within its own directory, promoting modularity.
