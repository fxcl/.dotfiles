#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { glob } = require('glob');
const chalk = require('chalk');

class FormatChecker {
  constructor(rootDir = '../../.roo') {
    this.rootDir = process.argv[2] || rootDir;
    this.results = {
      files: [],
      summary: {
        totalFiles: 0,
        passedFiles: 0,
        failedFiles: 0,
        totalIssues: 0,
        issueTypes: {}
      }
    };
  }

  async checkAllDocuments() {
    console.log(chalk.blue('🔍 Starting content format validation...'));
    
    const mdFiles = await this.findRulesDocuments();
    console.log(chalk.gray(`Found ${mdFiles.length} rules documents`));
    
    for (const file of mdFiles) {
      await this.checkDocument(file);
    }
    
    return this.generateReport();
  }

  async findRulesDocuments() {
    const pattern = path.join(this.rootDir, 'rules-*/rules.md');
    return await glob(pattern);
  }

  async checkDocument(filePath) {
    try {
      const content = fs.readFileSync(filePath, 'utf8');
      const issues = [];
      
      // Check workflow table format
      issues.push(...this.checkWorkflowTables(content, filePath));
      
      // Check reference format consistency
      issues.push(...this.checkReferenceFormat(content, filePath));
      
      // Check markdown formatting
      issues.push(...this.checkMarkdownFormatting(content, filePath));
      
      // Check heading consistency
      issues.push(...this.checkHeadingConsistency(content, filePath));
      
      // Check list formatting
      issues.push(...this.checkListFormatting(content, filePath));
      
      const fileResult = {
        file: filePath,
        passed: issues.length === 0,
        issues: issues,
        issueCount: issues.length
      };
      
      this.results.files.push(fileResult);
      
      if (fileResult.passed) {
        console.log(chalk.green(`✅ ${filePath}: All format checks passed`));
      } else {
        console.log(chalk.yellow(`⚠️  ${filePath}: ${issues.length} format issues found`));
        issues.slice(0, 3).forEach(issue => {
          console.log(chalk.gray(`   Line ${issue.line}: ${issue.message}`));
        });
        if (issues.length > 3) {
          console.log(chalk.gray(`   ... and ${issues.length - 3} more issues`));
        }
      }
      
    } catch (error) {
      console.error(chalk.red(`❌ Error checking ${filePath}: ${error.message}`));
    }
  }

  checkWorkflowTables(content, filePath) {
    const issues = [];
    const lines = content.split('\n');
    
    // Find workflow sections
    const workflowSections = this.findWorkflowSections(content);
    
    workflowSections.forEach(section => {
      const sectionLines = section.lines;
      
      // Check if workflow has table format
      const tableLines = sectionLines.filter(line => line.trim().includes('|'));
      
      if (tableLines.length === 0) {
        issues.push({
          type: 'workflow_table_missing',
          message: 'Workflow section should contain a table format',
          line: section.lineNumber,
          severity: 'error'
        });
        return;
      }
      
      // Filter out separator lines (lines with only |, -, and spaces)
      const contentTableLines = tableLines.filter(line => {
        const trimmed = line.trim();
        // Skip lines that are only separators (like |------|--------|
        return !(/^\|[\s\-:|]+\|$/.test(trimmed));
      });
      
      // Need at least 2 content lines (header + data)
      if (contentTableLines.length < 2) {
        issues.push({
          type: 'workflow_table_missing',
          message: 'Workflow section should contain a table format',
          line: section.lineNumber,
          severity: 'error'
        });
        return;
      }
      
      // Validate table structure
      const tableStartLine = section.startLine + sectionLines.indexOf(tableLines[0]);
      const tableIssues = this.validateTableStructure(tableLines, tableStartLine + 1);
      issues.push(...tableIssues);
      
      // Check for proper table headers - just verify it has a header row
      const hasHeaderRow = contentTableLines.length > 0 && 
        contentTableLines[0].includes('|') && 
        contentTableLines[0].split('|').filter(col => col.trim() !== '').length >= 2;
      
      if (!hasHeaderRow) {
        issues.push({
          type: 'workflow_table_headers',
          message: 'Workflow table should have proper header row with at least 2 columns',
          line: section.lineNumber + 1,
          severity: 'warning'
        });
      }
    });
    
    return issues;
  }

  findWorkflowSections(content) {
    const sections = [];
    const lines = content.split('\n');
    
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      // Only match workflow sections that are likely to contain actual workflow content
      // Exclude sections that are just references to other documents
      if (/^##?\s+.*[Ww]orkflow/.test(line)) {
        // Find the end of this section
        let endLine = lines.length;
        for (let j = i + 1; j < lines.length; j++) {
          if (/^##?\s+/.test(lines[j])) {
            endLine = j;
            break;
          }
        }
        
        const sectionContent = lines.slice(i, endLine).join('\n');
        
        // Skip sections that are primarily references to other documents
        const contentLines = lines.slice(i + 1, endLine).filter(line => line.trim() && !line.startsWith('#'));
        const referenceLines = contentLines.filter(line => line.includes('Refer to') && line.includes('.md'));
        
        // Special handling for "Workflow & Error Handling" sections
        if (line.includes('Workflow & Error Handling')) {
          // Skip if it's primarily a reference or contains error handling lists (not workflow steps)
          const nonReferenceLines = contentLines.filter(line => !line.includes('Refer to') && !line.includes('.md') && line.trim() !== '');
          const hasErrorHandlingList = contentLines.some(line => 
            (line.includes('**') && line.includes(':')) || 
            line.includes('- **') || 
            line.includes('Handle') || 
            line.includes('Address') || 
            line.includes('Manage') ||
            line.includes('If ') ||
            line.includes('When ')
          );
          
          // Always skip "Workflow & Error Handling" sections as they are meant for error handling, not workflow tables
          continue;
        } else {
          // For other workflow sections, skip if primarily references
          if (referenceLines.length > 0 && 
              referenceLines.length >= contentLines.length * 0.5 && 
              !sectionContent.includes('|') &&
              contentLines.length <= 5) {
            continue;
          }
        }
        
        sections.push({
          lineNumber: i + 1,
          startLine: i,
          endLine: endLine,
          lines: lines.slice(i, endLine)
        });
      }
    }
    
    return sections;
  }

  validateTableStructure(tableLines, startLine) {
    const issues = [];
    
    tableLines.forEach((line, index) => {
      const lineNumber = startLine + index;
      
      // Check for proper table formatting
      if (!line.trim().startsWith('|') || !line.trim().endsWith('|')) {
        issues.push({
          type: 'table_format',
          message: 'Table rows should start and end with |',
          line: lineNumber,
          severity: 'warning'
        });
      }
      
      // Check for consistent column count
      const columns = line.split('|').filter(col => col.trim() !== '');
      if (index === 0) {
        this.expectedColumns = columns.length;
      } else if (columns.length !== this.expectedColumns && !line.includes('---')) {
        issues.push({
          type: 'table_columns',
          message: `Inconsistent column count: expected ${this.expectedColumns}, got ${columns.length}`,
          line: lineNumber,
          severity: 'error'
        });
      }
    });
    
    return issues;
  }

  checkReferenceFormat(content, filePath) {
    const issues = [];
    const lines = content.split('\n');
    
    lines.forEach((line, index) => {
      const lineNumber = index + 1;
      
      // Check for markdown links
      const linkRegex = /\[([^\]]+)\]\(([^)]+)\)/g;
      let match;
      
      while ((match = linkRegex.exec(line)) !== null) {
        const linkText = match[1];
        const linkUrl = match[2];
        
        // Note: Optimized versions no longer use -optimized suffix
        // References to ../shared/ .md files are now correct
        
        // Check for consistent link text formatting
        if (linkText.includes('_') && !linkText.match(/^[A-Z][a-z\s]+$/)) {
          issues.push({
            type: 'link_text_format',
            message: 'Link text should use consistent formatting',
            line: lineNumber,
            severity: 'info'
          });
        }
        
        // Check for relative path consistency
        if (linkUrl.startsWith('./') || linkUrl.startsWith('../')) {
          if (!linkUrl.endsWith('.md')) {
            issues.push({
              type: 'link_extension',
              message: 'Relative links should point to .md files',
              line: lineNumber,
              severity: 'warning'
            });
          }
        }
      }
    });
    
    return issues;
  }

  checkMarkdownFormatting(content, filePath) {
    const issues = [];
    const lines = content.split('\n');
    
    lines.forEach((line, index) => {
      const lineNumber = index + 1;
      
      // Check for trailing whitespace
      if (line.endsWith(' ') || line.endsWith('\t')) {
        issues.push({
          type: 'trailing_whitespace',
          message: 'Line has trailing whitespace',
          line: lineNumber,
          severity: 'info'
        });
      }
      
      // Check for inconsistent emphasis formatting
      const boldRegex = /\*\*([^*]+)\*\*/g;
      const italicRegex = /\*([^*]+)\*/g;
      
      // Check for mixed emphasis styles
      if (line.includes('__') && line.includes('**')) {
        issues.push({
          type: 'mixed_emphasis',
          message: 'Mixed bold formatting styles (** and __)',
          line: lineNumber,
          severity: 'warning'
        });
      }
      
      // Check for proper code formatting
      const inlineCodeRegex = /`([^`]+)`/g;
      let codeMatch;
      while ((codeMatch = inlineCodeRegex.exec(line)) !== null) {
        const codeContent = codeMatch[1];
        // Skip test anchors like "// TEST: [behavior description]"
        const isTestAnchor = codeContent.trim().startsWith('// TEST:');
        if (codeContent.includes(' ') && codeContent.length > 20 && !isTestAnchor) {
          issues.push({
            type: 'long_inline_code',
            message: 'Long code snippets should use code blocks instead of inline code',
            line: lineNumber,
            severity: 'info'
          });
        }
      }
    });
    
    return issues;
  }

  checkHeadingConsistency(content, filePath) {
    const issues = [];
    const lines = content.split('\n');
    
    lines.forEach((line, index) => {
      const lineNumber = index + 1;
      
      // Check heading format
      const headingMatch = line.match(/^(#{1,6})\s*(.+)$/);
      if (headingMatch) {
        const level = headingMatch[1].length;
        const title = headingMatch[2];
        
        // Check for space after #
        if (!line.match(/^#{1,6}\s+/)) {
          issues.push({
            type: 'heading_spacing',
            message: 'Headings should have a space after #',
            line: lineNumber,
            severity: 'warning'
          });
        }
        
        // Check for title case consistency (for H2 and above)
        if (level <= 2 && !this.isTitleCase(title)) {
          issues.push({
            type: 'heading_case',
            message: 'Main headings should use title case',
            line: lineNumber,
            severity: 'info'
          });
        }
      }
    });
    
    return issues;
  }

  checkListFormatting(content, filePath) {
    const issues = [];
    const lines = content.split('\n');
    
    lines.forEach((line, index) => {
      const lineNumber = index + 1;
      
      // Check unordered list formatting
      if (line.match(/^\s*[-*+]\s/)) {
        // Check for consistent bullet style within the document
        const bullet = line.match(/^\s*([-*+])/)[1];
        if (!this.documentBulletStyle) {
          this.documentBulletStyle = bullet;
        } else if (this.documentBulletStyle !== bullet) {
          issues.push({
            type: 'inconsistent_bullets',
            message: `Inconsistent bullet style: using '${bullet}' but document uses '${this.documentBulletStyle}'`,
            line: lineNumber,
            severity: 'warning'
          });
        }
        
        // Check for proper spacing
        if (!line.match(/^\s*[-*+]\s+/)) {
          issues.push({
            type: 'list_spacing',
            message: 'List items should have a space after the bullet',
            line: lineNumber,
            severity: 'warning'
          });
        }
      }
      
      // Check ordered list formatting
      if (line.match(/^\s*\d+\.\s/)) {
        if (!line.match(/^\s*\d+\.\s+/)) {
          issues.push({
            type: 'ordered_list_spacing',
            message: 'Ordered list items should have a space after the number',
            line: lineNumber,
            severity: 'warning'
          });
        }
      }
    });
    
    return issues;
  }

  isTitleCase(text) {
    const words = text.split(' ');
    const minorWords = ['a', 'an', 'and', 'as', 'at', 'but', 'by', 'for', 'if', 'in', 'nor', 'of', 'on', 'or', 'so', 'the', 'to', 'up', 'yet'];
    
    return words.every((word, index) => {
      if (index === 0 || !minorWords.includes(word.toLowerCase())) {
        return word.charAt(0) === word.charAt(0).toUpperCase();
      }
      return true;
    });
  }

  generateReport() {
    const passedFiles = this.results.files.filter(f => f.passed).length;
    const totalIssues = this.results.files.reduce((sum, f) => sum + f.issueCount, 0);
    
    // Count issue types
    const issueTypes = {};
    this.results.files.forEach(file => {
      file.issues.forEach(issue => {
        issueTypes[issue.type] = (issueTypes[issue.type] || 0) + 1;
      });
    });
    
    this.results.summary = {
      totalFiles: this.results.files.length,
      passedFiles,
      failedFiles: this.results.files.length - passedFiles,
      totalIssues,
      issueTypes
    };

    console.log('\n' + chalk.blue('📊 Format Check Summary'));
    console.log(chalk.gray('========================'));
    console.log(`Total files checked: ${chalk.cyan(this.results.summary.totalFiles)}`);
    console.log(`Files passed: ${chalk.green(this.results.summary.passedFiles)}`);
    console.log(`Files with issues: ${chalk.red(this.results.summary.failedFiles)}`);
    console.log(`Total issues found: ${chalk.yellow(this.results.summary.totalIssues)}`);

    if (Object.keys(issueTypes).length > 0) {
      console.log('\n' + chalk.blue('📋 Issue Types:'));
      Object.entries(issueTypes)
        .sort(([,a], [,b]) => b - a)
        .forEach(([type, count]) => {
          console.log(`  ${chalk.yellow(type)}: ${count}`);
        });
    }

    if (this.results.summary.failedFiles > 0) {
      console.log('\n' + chalk.red('🚨 Files with Issues:'));
      this.results.files
        .filter(f => !f.passed)
        .forEach(file => {
          console.log(chalk.red(`  ❌ ${file.file} (${file.issueCount} issues)`));
        });
    }

    return this.results;
  }

  async saveReport(outputPath) {
    const reportData = {
      timestamp: new Date().toISOString(),
      ...this.results
    };
    
    fs.writeFileSync(outputPath, JSON.stringify(reportData, null, 2));
    console.log(chalk.green(`📄 Report saved to: ${outputPath}`));
  }
}

// CLI execution
if (require.main === module) {
  const checker = new FormatChecker();
  
  checker.checkAllDocuments()
    .then(results => {
      const reportPath = path.join('.roo', 'validation', 'reports', `format-check-${Date.now()}.json`);
      return checker.saveReport(reportPath);
    })
    .then(() => {
      const failedCount = checker.results.summary.failedFiles;
      process.exit(failedCount > 0 ? 1 : 0);
    })
    .catch(error => {
      console.error(chalk.red('❌ Format checker failed:'), error);
      process.exit(1);
    });
}

module.exports = FormatChecker;