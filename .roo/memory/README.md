# Memory System

This directory contains the Memory Mode's storage system, which serves as the institutional memory for the multi-agent framework. It provides persistent storage, retrieval, and pattern recognition capabilities across projects and sessions.

## Directory Structure

```
/.roo/memory/
├── projects/                      # Project-specific memory
│   ├── [project_id]/              # Individual project folders
│   │   ├── artifacts/             # Key project outputs
│   │   ├── decisions/             # Important decisions and rationales
│   │   ├── learnings/             # Extracted insights and lessons
│   │   └── timeline/              # Chronological project history
├── knowledge/                     # Cross-project knowledge
│   ├── patterns/                  # Recurring patterns and solutions
│   ├── references/                # External information sources
│   ├── templates/                 # Reusable structures and formats
│   └── best-practices/            # Established effective approaches
├── context/                       # Session and environmental context
│   ├── sessions/                  # Individual interaction sessions
│   ├── environments/              # Development environment details
│   └── users/                     # User preferences and history
└── index/                         # Retrieval indexes and metadata
    ├── artifacts-index.json       # Index of all stored artifacts
    ├── timeline-index.json        # Chronological index of events
    ├── topic-index.json           # Topic-based information index
    └── relationship-graph.json    # Connections between information
```

## Usage

The Memory System is primarily accessed through the Memory Agent, which provides structured interfaces for storing and retrieving information. Direct manipulation of the files is not recommended, as it may break the indexing and relationship tracking.

### Storage

Information is stored in standardized formats:
- Markdown files (.md) for human-readable content
- JSON files (.json) for structured data and metadata

### Retrieval

Information can be retrieved through several mechanisms:
- By project
- By topic
- By timeline
- By relationships
- By full-text search

### Indexes

The index files maintain metadata about all stored information:
- `artifacts-index.json`: Tracks all project outputs
- `timeline-index.json`: Maintains chronological event history
- `topic-index.json`: Organizes information by subject matter
- `relationship-graph.json`: Maps connections between items

## Integration with SQL Memory MCP

This file-based storage system serves as an interim solution until the SQL Memory MCP is implemented. The storage abstraction layer will allow for a seamless transition between storage backends while maintaining the same interface for other agents.

## Maintenance

The Memory System is automatically maintained by the Memory Agent, which:
- Updates indexes when new information is added
- Maintains relationships between items
- Performs regular integrity checks
- Identifies patterns and insights
- Archives less frequently accessed information

For more information on the Memory Mode, see the [Memory Agent documentation](../../agents/memory/memory-agent.md).