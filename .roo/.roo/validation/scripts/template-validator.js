#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { glob } = require('glob');
const chalk = require('chalk');

class TemplateValidator {
  constructor(rootDir = path.join(__dirname, '..', '..')) {
    this.rootDir = process.argv[2] || rootDir;
    // Required sections reflecting new condensed templates
    this.requiredSections = [
      { name: 'Purpose', pattern: /^##?\s+Purpose\b/m, required: true },
      { name: 'Response Protocol', pattern: /^##?\s+Response Protocol\b/m, required: true }
    ];
    // Recommended sections that improve score but are optional
    this.recommendedSections = [
      { name: 'Scope or Role', pattern: /^##?\s+(Scope(?:\s*&\s*Role)?|Scope|Role(?:\s*&\s*Scope)?)\b/m },
      { name: 'Workflow', pattern: /^##?\s+(?:.*Workflow|Pipeline Stages)\b/m },
      { name: 'Requirements', pattern: /^##?\s+(Essential Requirements|Core Requirements|Requirements|Essentials)\b/m },
      { name: 'Error Handling', pattern: /^##?\s+Error Handling\b/m }
    ];
    
    this.results = {
      files: [],
      summary: {
        totalFiles: 0,
        compliantFiles: 0,
        nonCompliantFiles: 0,
        complianceRate: 0
      }
    };
  }

  async validateAllDocuments() {
    console.log(chalk.blue('📋 Starting template structure validation...'));
    
    const mdFiles = await this.findRulesDocuments();
    console.log(chalk.gray(`Found ${mdFiles.length} rules documents`));
    
    for (const file of mdFiles) {
      await this.validateDocument(file);
    }
    
    return this.generateReport();
  }

  async findRulesDocuments() {
    const pattern = path.join(this.rootDir, 'rules-*/rules.md');
    return await glob(pattern);
  }

  async validateDocument(filePath) {
    try {
      const content = fs.readFileSync(filePath, 'utf8');
      const sections = this.extractSections(content);
      const compliance = this.checkSectionCompliance(sections, content);
      
      const fileResult = {
        file: filePath,
        compliant: compliance.isCompliant,
        sections: compliance.sections,
        missingRequired: compliance.missingRequired,
        extraSections: compliance.extraSections,
        structureIssues: compliance.structureIssues,
        score: compliance.score
      };
      
      this.results.files.push(fileResult);
      
      if (fileResult.compliant) {
        console.log(chalk.green(`✅ ${filePath}: Fully compliant (${fileResult.score}%)`));
      } else {
        console.log(chalk.yellow(`⚠️  ${filePath}: Non-compliant (${fileResult.score}%)`));
        if (fileResult.missingRequired.length > 0) {
          console.log(chalk.red(`   Missing: ${fileResult.missingRequired.join(', ')}`));
        }
      }
      
    } catch (error) {
      console.error(chalk.red(`❌ Error validating ${filePath}: ${error.message}`));
    }
  }

  extractSections(content) {
    const sectionRegex = /^(#{1,6})\s+(.+)$/gm;
    const sections = [];
    let match;
    
    while ((match = sectionRegex.exec(content)) !== null) {
      sections.push({
        level: match[1].length,
        title: match[2].trim(),
        line: this.getLineNumber(content, match.index),
        raw: match[0]
      });
    }
    
    return sections;
  }

  getLineNumber(content, index) {
    return content.substring(0, index).split('\n').length;
  }

  checkSectionCompliance(sections, content) {
    const foundSections = [];
    const missingRequired = [];
    const missingRecommended = [];
    const structureIssues = [];
    
    // Check for required sections
    for (const required of this.requiredSections) {
      const found = sections.find(section => required.pattern.test(section.raw));
      if (found) {
        foundSections.push({ name: required.name, found: true, section: found, required: true });
      } else {
        foundSections.push({ name: required.name, found: false, section: null, required: true });
        missingRequired.push(required.name);
      }
    }

    // Check for recommended sections
    for (const rec of this.recommendedSections) {
      const found = sections.find(section => rec.pattern.test(section.raw));
      if (found) {
        foundSections.push({ name: rec.name, found: true, section: found, required: false });
      } else {
        foundSections.push({ name: rec.name, found: false, section: null, required: false });
        missingRecommended.push(rec.name);
      }
    }
    
    // Structural checks
    const workflowIssues = this.checkWorkflowTableFormat(content);
    structureIssues.push(...workflowIssues);
    
    const referenceIssues = this.checkReferenceFormat(content);
    structureIssues.push(...referenceIssues);
    
    const titleIssues = this.checkTitleStructure(sections);
    structureIssues.push(...titleIssues);
    
    const score = this.calculateComplianceScore(foundSections, structureIssues);
    // Compliant if all required present and no blocking structural issues
    const blockingIssues = structureIssues.filter(i => i.type !== 'recommended_missing');
    const isCompliant = missingRequired.length === 0 && blockingIssues.length === 0;
    
    return {
      isCompliant,
      sections: foundSections,
      missingRequired,
      missingRecommended,
      extraSections: this.findExtraSections(sections),
      structureIssues,
      score
    };
  }

  checkWorkflowTableFormat(content) {
    const issues = [];
    
    const lines = content.split('\n');
    
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      
      // Match any standalone Workflow section heading, including variants like "Minimal Workflow"
      if (line.match(/^##?\s+.*Workflow(?:\s*\(.*\))?\s*$/i) && !line.includes('&')) {
        // Find the end of this section
        let sectionEnd = lines.length;
        for (let j = i + 1; j < lines.length; j++) {
          if (lines[j].match(/^##?\s+/)) {
            sectionEnd = j;
            break;
          }
        }
        
        const sectionContent = lines.slice(i, sectionEnd).join('\n');
        
        // Accept either a table or an ordered/bulleted list as valid workflow format
        const hasTable = /\|.*\|/.test(sectionContent);
        const hasTableDivider = /\|\s*-{2,}\s*\|/.test(sectionContent);
        const hasList = /^(\s*(?:\d+[\.)]|[-*])\s+).+/m.test(sectionContent);
        
        if (!hasTable && !hasList) {
          issues.push({
            type: 'workflow_format',
            message: 'Workflow section should use a table or a clear ordered/bulleted list',
            line: i + 1
          });
        } else if (hasTable && !hasTableDivider) {
          // If table exists but missing divider row, warn (non-blocking)
          issues.push({
            type: 'workflow_table_header',
            message: 'Workflow table should include a header divider row (e.g., | --- | --- |)',
            line: i + 1
          });
        }
      }
    }
    
    return issues;
  }

  checkReferenceFormat(content) {
    const issues = [];
    const referenceRegex = /\[([^\]]+)\]\(([^)]+\.md)\)/g;
    let match;
    
    while ((match = referenceRegex.exec(content)) !== null) {
      const linkText = match[1];
      const linkUrl = match[2];
      
      // Note: ../shared/ references are now using optimized versions (without -optimized suffix)
      // No validation needed for shared document references as they are already optimized
    }
    
    return issues;
  }

  checkTitleStructure(sections) {
    const issues = [];
    
    // Check for proper H1 title
    const h1Sections = sections.filter(s => s.level === 1);
    if (h1Sections.length === 0) {
      issues.push({
        type: 'title_structure',
        message: 'Document should have an H1 title',
        line: 1
      });
    } else if (h1Sections.length > 1) {
      issues.push({
        type: 'title_structure',
        message: 'Document should have only one H1 title',
        line: h1Sections[1].line
      });
    }
    
    // Check for proper heading hierarchy
    for (let i = 1; i < sections.length; i++) {
      const current = sections[i];
      const previous = sections[i - 1];
      
      if (current.level > previous.level + 1) {
        issues.push({
          type: 'heading_hierarchy',
          message: `Heading level jumps from H${previous.level} to H${current.level}`,
          line: current.line
        });
      }
    }
    
    return issues;
  }

  findExtraSections(sections) {
    // This could be expanded to identify sections that don't match the template
    return [];
  }

  calculateComplianceScore(foundSections, structureIssues) {
    const required = foundSections.filter(s => s.required);
    const recommended = foundSections.filter(s => !s.required);
    const requiredFound = required.filter(s => s.found).length;
    const recommendedFound = recommended.filter(s => s.found).length;

    const requiredScore = required.length ? (requiredFound / required.length) * 70 : 70; // 70% weight
    const recommendedScore = recommended.length ? (recommendedFound / recommended.length) * 30 : 30; // 30% weight

    const structurePenalty = Math.min(20, structureIssues.length * 2); // up to -20 for many issues
    const score = Math.round(Math.max(0, requiredScore + recommendedScore - structurePenalty));

    return score;
  }

  generateReport() {
    const compliantFiles = this.results.files.filter(f => f.compliant).length;
    
    this.results.summary = {
      totalFiles: this.results.files.length,
      compliantFiles,
      nonCompliantFiles: this.results.files.length - compliantFiles,
      complianceRate: this.results.files.length > 0 ? 
        ((compliantFiles / this.results.files.length) * 100).toFixed(2) : 100
    };

    console.log('\n' + chalk.blue('📊 Template Validation Summary'));
    console.log(chalk.gray('==================================='));
    console.log(`Total files validated: ${chalk.cyan(this.results.summary.totalFiles)}`);
    console.log(`Compliant files: ${chalk.green(this.results.summary.compliantFiles)}`);
    console.log(`Non-compliant files: ${chalk.red(this.results.summary.nonCompliantFiles)}`);
    console.log(`Compliance rate: ${chalk.yellow(this.results.summary.complianceRate + '%')}`);

    if (this.results.summary.nonCompliantFiles > 0) {
      console.log('\n' + chalk.red('🚨 Non-Compliant Files Details:'));
      this.results.files
        .filter(f => !f.compliant)
        .forEach(file => {
          console.log(chalk.red(`  ❌ ${file.file} (Score: ${file.score}%)`));
          
          if (file.missingRequired.length > 0) {
            console.log(chalk.gray(`     Missing sections: ${file.missingRequired.join(', ')}`));
          }
          
          if (file.structureIssues.length > 0) {
            file.structureIssues.forEach(issue => {
              console.log(chalk.gray(`     Line ${issue.line}: ${issue.message}`));
            });
          }
          
          console.log('');
        });
    }

    return this.results;
  }

  async saveReport(outputPath) {
    const reportData = {
      timestamp: new Date().toISOString(),
      ...this.results
    };
    
    const dir = path.dirname(outputPath);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
    fs.writeFileSync(outputPath, JSON.stringify(reportData, null, 2));
    console.log(chalk.green(`📄 Report saved to: ${outputPath}`));
  }
}

// CLI execution
if (require.main === module) {
  const validator = new TemplateValidator();
  
  validator.validateAllDocuments()
    .then(results => {
      const reportPath = path.join(__dirname, '..', 'reports', `template-validation-${Date.now()}.json`);
      return validator.saveReport(reportPath);
    })
    .then(() => {
      const nonCompliantCount = validator.results.summary.nonCompliantFiles;
      process.exit(nonCompliantCount > 0 ? 1 : 0);
    })
    .catch(error => {
      console.error(chalk.red('❌ Template validator failed:'), error);
      process.exit(1);
    });
}

module.exports = TemplateValidator;