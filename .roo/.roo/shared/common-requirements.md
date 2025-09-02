# Common Requirements

Universal quality requirements and security standards that all RooCode modes must follow.

## Code Quality Requirements

### File Structure

- Single file ≤500 lines
- Single function ≤50 lines
- Classes ≤300 lines
- Single responsibility per module

### Coding Standards

- Follow language best practices
- Use consistent naming conventions
- Add necessary comments
- Maintain code readability

### Completion Standards

- Must call `attempt_completion`
- Provide complete implementation
- Include error handling
- Pass basic tests

## Security Requirements

### Sensitive Information Protection

- Prohibit hardcoded keys/passwords
- Use environment variables for secrets
- Implement access controls
- Encrypt sensitive data

### Input Validation

- Validate all user inputs
- Prevent injection attacks
- Limit input length
- Filter dangerous characters

### Permission Management

- Principle of least privilege
- Regular permission reviews
- Secure default configurations
- Audit log recording

## Documentation Requirements

### Required Documentation

- API interface documentation
- Installation and deployment guides
- Configuration instructions
- Troubleshooting guides

### Documentation Quality

- Accurate and complete information
- Runnable example code
- Timely updates and maintenance
- Clear and understandable structure

## Performance Requirements

### Response Times

- API response ≤2 seconds
- Page loading ≤3 seconds
- Database queries ≤1 second
- File operations ≤5 seconds

### Resource Usage

- Reasonable memory usage
- Controllable CPU utilization
- Optimized network bandwidth
- Efficient storage space

## Testing Requirements

### Test Coverage

- Unit tests ≥80%
- Integration tests cover critical paths
- End-to-end tests validate main functions
- Performance tests ensure metrics compliance

### Test Quality

- Independent test cases
- Clear and specific assertions
- Isolated test data
- Automated execution

## Deployment Requirements

### Environment Configuration

- Separate development/testing/production environments
- Externalized configuration
- Version control
- Rollback mechanisms

### Monitoring and Alerting

- Application performance monitoring
- Error log collection
- Critical metric alerts
- Health check endpoints

## Compliance Requirements

### Data Protection

- Comply with GDPR/CCPA regulations
- Data minimization principle
- User consent mechanisms
- Right to data deletion

### Audit Requirements

- Operation log recording
- Access audit tracking
- Change management processes
- Regular security assessments
