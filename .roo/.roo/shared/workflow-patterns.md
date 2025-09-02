# Workflow Patterns

Core SPARC methodology and workflow patterns for efficient, consistent task execution across all RooCode modes.

## SPARC Methodology Framework

### SPARC Phase Breakdown

| Phase | Core Activities | Success Metrics | Time Allocation |
|-------|-----------------|-----------------|------------------|
| **S - Specification** | Requirements analysis, scope definition | 100% requirement coverage | 15-20% |
| **P - Planning** | Task breakdown, approach design | Detailed task list, timeline accuracy | 20-25% |
| **A - Architecture** | System design, interface planning | Architecture approval, integration readiness | 15-20% |
| **R - Refinement** | Implementation, testing, optimization | Feature completion, quality standards met | 30-40% |
| **C - Completion** | Validation, documentation, handover | User acceptance, deployment readiness | 10-15% |

### Enhanced SPARC Implementation

#### S - Specification (Requirements & Scope)

- Requirements are SMART (Specific, Measurable, Achievable, Relevant, Time-bound)
- All stakeholders have reviewed and approved
- Dependencies are identified and documented
- Success criteria are clearly defined

#### P - Planning (Strategy & Design)

- Task breakdown using Work Breakdown Structure (WBS)
- Approach selection via decision matrix analysis
- Resource planning with capacity analysis
- Risk planning with mitigation strategies

#### A - Architecture (Structure & Integration)

- **Modularity**: Components are loosely coupled, highly cohesive
- **Scalability**: Design supports growth and expansion
- **Maintainability**: Code is readable, documented, and testable
- **Security**: Security considerations integrated from design phase

#### R - Refinement (Implementation & Optimization)

- Implementation with code coverage and complexity metrics
- Testing via unit, integration, and system testing
- Optimization through performance tuning and refactoring
- Review via code review and design validation

#### C - Completion (Validation & Delivery)

- All acceptance criteria met
- Quality standards validated
- Documentation complete
- User training provided
- Handover completed

## Mode-Specific SPARC Implementation

| Mode | Specification Focus | Planning Emphasis | Architecture Approach | Refinement Strategy | Completion Criteria |
|------|-------------------|------------------|---------------------|-------------------|---------------------|
| **Code** | Feature requirements | Code structure | Class/module design | TDD, code review | Functional validation |
| **TDD** | Test scenarios | Test-first approach | Emergent design | Red-Green-Refactor | All tests passing |
| **Debug** | Problem identification | Root cause analysis | N/A | Systematic debugging | Issue resolution |
| **Architect** | System requirements | High-level design | Detailed architecture | Design validation | Architecture approval |
| **Docs** | Content requirements | Document structure | Information architecture | Writing, review | Accuracy validation |

### Task Classification Framework

| Complexity Level | Characteristics | SPARC Adaptation | Resource Allocation |
|------------------|-----------------|------------------|---------------------|
| **Simple** (< 30 min) | Single component, clear requirements | Lightweight SPARC | 1 developer, basic tools |
| **Medium** (30 min - 2 hrs) | Multiple components, moderate complexity | Standard SPARC | 1-2 developers, standard tools |
| **Complex** (> 2 hrs) | System-wide impact, high complexity | Extended SPARC | Team effort, advanced tools |
| **Enterprise** (> 1 week) | Multi-system, strategic impact | Full SPARC with governance | Multiple teams, enterprise tools |

## Advanced Workflow Patterns

### Collaborative Workflow Orchestration

#### Sequential Workflow Pattern

```
Mode A → Handover → Mode B → Handover → Mode C
```
**Best Practices**: Clear handover documentation, validation checkpoints, consistent quality standards

#### Parallel Workflow Pattern

```
        ┌─ Mode A ─┐
Input ──┼─ Mode B ─┼── Integration → Output
        └─ Mode C ─┘
```
**Coordination Requirements**: Shared specifications, regular sync points, conflict resolution

#### Iterative Workflow Pattern

```
Iteration 1: SPARC → Review → Feedback
     ↓
Iteration 2: SPARC → Review → Feedback
     ↓
Iteration N: SPARC → Final Delivery
```

**Iteration Management**: Fixed duration, clear goals, regular retrospectives

### Quality Gate Framework

| Gate Level | Scope | Criteria | Automation Level |
|------------|-------|----------|------------------|
| **Component** | Individual components | Unit tests, code quality | Fully automated |
| **Integration** | Component interactions | Integration tests, API contracts | Mostly automated |
| **System** | End-to-end functionality | System tests, performance | Semi-automated |
| **Acceptance** | User requirements | User acceptance tests | Manual validation |

## Risk Management & Recovery

### Risk Assessment Matrix

| Risk Category | Probability | Impact | Mitigation Strategy |
|---------------|-------------|--------|---------------------|
| **Technical** | Medium | High | Proof of concept, expert consultation |
| **Resource** | Low | Medium | Resource planning, cross-training |
| **Timeline** | High | Medium | Buffer time, parallel work |
| **Quality** | Medium | High | Quality gates, continuous testing |

### Recovery Procedures

#### Rollback Strategy

1. Detect Issue → 2. Assess Impact → 3. Decision Point → 4. Execute Recovery → 5. Validate

## Integration & Handover Protocols

### Handover Documentation Template

```
# Handover Document

## Context
- Project/Task: [Name and description]
- Previous Mode: [Mode and deliverables]
- Next Mode: [Mode and expectations]

## Deliverables
- [List of completed items]
- [Quality validation results]
- [Known issues or limitations]

## Next Steps
- [Immediate actions required]
- [Dependencies to resolve]
- [Success criteria]
```

### Integration Validation Checklist

- [ ] All deliverables meet specified requirements
- [ ] Quality gates have been passed
- [ ] Documentation is complete and accurate
- [ ] Dependencies are resolved or documented
- [ ] Next mode has confirmed readiness

## Best Practices Summary

### Workflow Excellence Principles

1. **Clarity First**: Clear requirements and expectations
2. **Quality Built-In**: Quality considerations at every step
3. **Continuous Feedback**: Regular validation and adjustment
4. **Collaborative Approach**: Effective communication and coordination
5. **Adaptive Execution**: Flexibility based on context and complexity
6. **Learning Culture**: Continuous improvement and knowledge sharing

### Success Factors

| Factor | Description | Implementation |
|--------|-------------|----------------|
| **Standardization** | Consistent processes and tools | Templates, checklists, guidelines |
| **Automation** | Automated quality gates and testing | CI/CD, automated testing, monitoring |
| **Collaboration** | Effective team communication | Regular meetings, shared tools, documentation |
| **Measurement** | Data-driven decision making | Metrics, dashboards, regular reviews |
| **Improvement** | Continuous process enhancement | Retrospectives, feedback loops, experimentation |

## References

- [Core Principles](./core-principles.md)
- [Tool Guidelines](./tool-guidelines.md)
- [Response Protocol](./response-protocol.md)
- [Common Requirements](./common-requirements.md)
