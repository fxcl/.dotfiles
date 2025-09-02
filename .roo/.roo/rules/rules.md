# SPARC Development Rules

## Core Principles

- **Simplicity**: Clear, maintainable solutions.
- **Iteration**: Enhance, don't rewrite.
- **Focus**: Stick to the task. No scope creep.
- **Quality**: Clean, tested, documented code.
- **Collaboration**: Efficient human-AI pairing.

## Workflow

- Phases: Specification → Pseudocode → Architecture → Optimization → Completion.
- Reflect and improve codebase continuously.
- Use memory bank for context.

## Project Understanding

- Read docs first (PRD, README, architecture).
- Adhere to existing architecture and patterns.
- Use established tech stack.

## AI Collaboration

- Instructions must be clear: state outcomes, constraints, context.
- Prefix outputs: "Suggestion:" or "Apply Fix:".
- Break down complex tasks.
- Confirm understanding: "Confirm: Reviewed context, goal is objective, executing steps".

## Code Quality

- **TypeScript**: Strict typing, JSDoc.
- **Maintainability**: Modular, extensible, clear.
- **Concise**: Files < 300 lines. Refactor proactively.
- **DRY**: Eliminate redundancy.
- **Standards**: Follow ESLint/Prettier.
- **Naming**: Descriptive and standard file names.

## Refactoring

- **Objective**: Improve readability, reduce redundancy, align with architecture.
- **Holistic**: Merge similar components.
- **Directness**: Modify existing code directly.
- **Validation**: Verify integrations after changes.

## Testing & Validation

- **TDD**: Tests before features.
- **Coverage**: Critical paths and edge cases.
- **Pass Mandatory**: Fix failing tests immediately.
- **Manual Checks**: Supplement automated tests.

## Debugging

- **Root Cause**: Find the fundamental problem.
- **Logging**: Use precise logging.
- **Research**: Use agent tools for complex issues.

## Security

- **Authority**: Sensitive logic is server-side only.
- **Sanitization**: Strict server-side input validation.
- **Credentials**: Use environment variables. No hardcoding.

## Version Control

- **Git**: Frequent, descriptive commits.
- **Branching**: Follow defined strategy.
- **Environments**: Ensure code consistency.
- **Servers**: Restart after updates.

## Documentation Maintenance

- **Reflective**: Maintain complete, accurate, structured docs.
- **Continuous**: Update guidelines regularly.
- **Review**: Ensure file accuracy and relevance.
- **Comments**: Clarify complex logic.

## Tool Usage (Simplified)

### File Operations

- `read_file(path)`
- `write_to_file(path, content, line_count)`
- `list_files(directory, recursive)`

### Code Editing

- `apply_diff(path, diff)`
- `insert_content(path, operations)`
- `search_and_replace(path, operations)`

### Project Management

- `execute_command(command)`
- `attempt_completion(result, optional_cli_command)`
- `ask_followup_question(question)`

### MCP Integration

- `use_mcp_tool(server_name, tool_name, arguments)`
- `access_mcp_resource(server_name, uri)`