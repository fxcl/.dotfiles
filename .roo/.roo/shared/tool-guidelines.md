# Tool Guidelines

Essential guidelines for effective tool usage across all RooCode modes.

## Core Principles

- **Appropriate Selection**: Choose the right tool for each task
- **Error Resilience**: Handle failures gracefully with try-catch and fallbacks
- **Resource Efficiency**: Optimize resource usage with timeouts and cleanup
- **Security First**: Validate inputs and sanitize outputs

## Tool Categories

### File Operations

| Tool | Purpose | Best Practice | Error Handling |
|------|---------|---------------|----------------|
| `read_file` | Content inspection | Verify existence first | Handle missing files |
| `write_to_file` | File creation | Include line count | Check disk space |
| `apply_diff` | Targeted changes | Use exact content | Validate syntax |

### Network Operations

- Implement exponential backoff for retries
- Use streaming for large data transfers
- Handle authentication token refresh
- Implement timeout mechanisms

### Data Processing

- Use streaming and chunking for large datasets
- Implement schema validation for structured data
- Monitor latency and handle backpressure
- Validate data integrity

## Integration Patterns

### Mode-Specific Integration

- Development: Code editing tools with syntax validation
- Deployment: Infrastructure tools with rollback capabilities
- Monitoring: Observability tools with real-time data

### Quality Assurance

#### Pre-execution Validation

- Parameter validation
- Permission checks
- Resource availability
- Dependency verification

#### Execution Monitoring

- Response time < 5 seconds
- Error rate < 5%
- Resource usage < 80% capacity

## Troubleshooting

### Common Issues

| Issue | Symptoms | Solution |
|-------|----------|----------|
| **Permission Errors** | Access denied | Check file permissions, use appropriate user |
| **Path Issues** | File not found | Use absolute paths, validate before use |
| **Resource Limits** | Timeout, memory errors | Optimize algorithms, increase limits |
| **Network Issues** | Connection timeout | Implement retry logic, use fallback endpoints |

### Debugging Workflow

1. Enable debug logging
2. Isolate problem area
3. Test with minimal input
4. Verify environment and dependencies
5. Implement and validate fix

## Performance Optimization

| Strategy | Application | Expected Improvement |
|----------|-------------|---------------------|
| **Caching** | Repeated operations | 50-90% response time reduction |
| **Batching** | Multiple similar operations | 30-70% throughput increase |
| **Async Processing** | I/O bound operations | 2-10x concurrency improvement |
| **Resource Pooling** | Connection management | 20-50% resource efficiency |

## Security Considerations

### Input Validation

- Sanitize all user inputs
- Validate data types and ranges
- Check for injection attacks
- Implement rate limiting

### Output Sanitization

- Remove sensitive information
- Validate output format
- Implement access controls
- Log security events
