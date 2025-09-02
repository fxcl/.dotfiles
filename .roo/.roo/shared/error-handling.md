# Error Handling Framework

Core error management strategies for robust, reliable operation across all RooCode modes.

## Core Principles

- **Prevention First**: Proactive error prevention over reactive handling
- **Graceful Degradation**: System continues functioning despite errors
- **Fast Recovery**: Minimize downtime and user impact
- **User-Centric**: Clear communication and minimal disruption

## Error Classification

| Category | Examples | Severity | Response |
|----------|----------|----------|----------|
| **System** | Memory, disk, network | Critical/High | Immediate action, fallback |
| **Tool** | Invalid parameters, execution failure | Medium | Retry, alternative approach |
| **Code** | Syntax, logic errors | Low/Medium | Fix and validate |
| **Design** | UX, accessibility issues | Medium | Planned improvement |

## Prevention Strategies

### Input Validation

- Type checking and range validation
- Format validation with regex/patterns
- Business logic validation

### Defensive Programming

```javascript
function processData(input) {
  // Validate input
  if (!input || typeof input !== 'object') {
    throw new ValidationError('Invalid input: expected object');
  }

  // Apply defaults and error boundaries
  const safeInput = { ...defaultValues, ...input };

  try {
    return performOperation(safeInput);
  } catch (error) {
    logger.error('Operation failed', { input, error });
    return fallbackResult(safeInput);
  }
}
```

## Detection & Recovery

### Detection Methods

- **Automated Monitoring**: Real-time system monitoring
- **User Reports**: Manual issue reporting
- **Code Analysis**: Pre-deployment detection
- **Testing**: Automated test suites

### Recovery Strategies

| Error Type | Primary Recovery | Fallback |
|------------|------------------|----------|
| **File Operations** | Retry with validation | Manual intervention |
| **Network Issues** | Exponential backoff | Cached/offline mode |
| **Code Errors** | Automatic fix | Rollback to previous version |
| **System Resources** | Resource optimization | Graceful degradation |

## Error Communication

### User Messages Template

```
[Status Icon] [Clear Description]

What happened: [Simple explanation]
What you can do: [Actionable steps]
```

### Internal Error Reporting

- Unique error ID and timestamp
- Severity and category classification
- Context and technical details
- Resolution status and actions taken

## Quality Assurance

- **Unit Testing**: 100% error path coverage
- **Integration Testing**: All integration points
- **Chaos Engineering**: Critical failure scenarios
- **User Acceptance**: Key user journey validation

## Continuous Improvement

### Key Metrics

- **Mean Time to Detection (MTTD)**
- **Mean Time to Resolution (MTTR)**
- **Error Rate**
- **Recovery Success Rate**

### Learning Loop

```
Continuous Improvement Cycle:
1. Error Occurrence
   ↓
2. Data Collection
   ↓
3. Pattern Analysis
   ↓
4. Root Cause Identification
   ↓
5. Prevention Strategy Update
   ↓
6. Implementation & Validation
   ↓
7. Monitoring & Measurement
   ↓
[Back to 1]
```

## Integration Guidelines

### Cross-Mode Error Handling

| Scenario | Coordination Method | Responsibility | Escalation Path |
|----------|-------------------|----------------|------------------|
| **Mode Handover** | Structured handover document | Sending mode | Receiving mode lead |
| **Shared Resources** | Resource locking, conflict resolution | Resource owner | System administrator |
| **Cross-Mode Errors** | Unified error reporting | Detecting mode | Mode coordinator |

### Tool Integration

```
Tool Chain Error Flow:
Tool A → [Error] → Recovery → Tool B → [Success] → Continue
   ↓                   ↓
Error Log         Fallback Path
```

## References

- [Core Principles](./core-principles.md)
- [Response Protocol](./response-protocol.md)
- [Workflow Patterns](./workflow-patterns.md)
- [Standard Responses](./standard-responses.md)
