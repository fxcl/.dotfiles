# File Operations Guidelines

## read_file

```xml
<read_file>
  <path>File path here</path>
</read_file>
```

### Required Parameters

- `path`: The file path to read

### Common Errors to Avoid

- Attempting to read non-existent files
- Using incorrect or relative paths
- Missing the `path` parameter

### Best Practices

- Always check if a file exists before attempting to modify it.
- Use `read_file` before `apply_diff` or `search_and_replace` to verify content.
- For large files, consider using `start_line` and `end_line` parameters to read specific sections.

## write_to_file

```xml
<write_to_file>
  <path>File path here</path>
  <content>Your file content here</content>
  <line_count>Total number of lines</line_count>
</write_to_file>
```

### Required Parameters

- `path`: The file path to write to
- `content`: The content to write to the file
- `line_count`: The total number of lines in the content

### Common Errors to Avoid

- Missing any of the required parameters
- Incorrect line count
- Attempting to write to protected directories
- Using incorrect or relative paths

### Best Practices

- Always include the correct line count.
- Check if the file already exists before creating it.
- Use proper file extensions for the content type.
- Ensure proper permissions for file creation.

## list_files

```xml
<list_files>
  <path>Directory path here</path>
  <recursive>true/false</recursive>
</list_files>
```

### Required Parameters

- `path`: The directory path to list
- `recursive`: Whether to list files recursively (true/false)

### Common Errors to Avoid

- Attempting to list non-existent directories
- Using incorrect or relative paths
- Missing the `path` parameter
- Using incorrect values for `recursive` (must be true or false)

### Best Practices

- Use recursive listing only when necessary.
- Filter results based on specific criteria when needed.
- Use the results to verify file existence before operations.
