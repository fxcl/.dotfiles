#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { glob } = require('glob');
const chalk = require('chalk');

class CrossReferenceValidator {
  constructor(rootDir = '../../.roo') {
    this.rootDir = process.argv[2] || rootDir;
    this.documentMap = new Map();
    this.referenceGraph = new Map();
    this.results = {
      files: [],
      references: [],
      issues: [],
      summary: {
        totalFiles: 0,
        totalReferences: 0,
        validReferences: 0,
        brokenReferences: 0,
        circularDependencies: [],
        orphanedDocuments: [],
        missingDependencies: []
      }
    };
  }

  async validateCrossReferences() {
    console.log(chalk.blue('🔗 Starting cross-reference validation...'));
    
    // Step 1: Discover all documents
    await this.discoverDocuments();
    
    // Step 2: Extract all references
    await this.extractReferences();
    
    // Step 3: Validate reference integrity
    await this.validateReferences();
    
    // Step 4: Analyze dependency graph
    await this.analyzeDependencyGraph();
    
    // Step 5: Check for circular dependencies
    await this.detectCircularDependencies();
    
    // Step 6: Find orphaned documents
    await this.findOrphanedDocuments();
    
    return this.generateReport();
  }

  async discoverDocuments() {
    console.log(chalk.gray('📁 Discovering documents...'));
    
    // Find all markdown files in rules directories
    const rulesPattern = path.join(this.rootDir, 'rules-*/rules.md');
    const rulesFiles = await glob(rulesPattern);
    
    // Find all shared documents
    const sharedPattern = path.join(this.rootDir, 'shared/**/*.md');
    const sharedFiles = await glob(sharedPattern);
    
    const allFiles = [...rulesFiles, ...sharedFiles];
    
    for (const file of allFiles) {
      const relativePath = path.relative(process.cwd(), file);
      const content = fs.readFileSync(file, 'utf8');
      
      this.documentMap.set(relativePath, {
        path: relativePath,
        absolutePath: file,
        content: content,
        type: file.includes('/shared/') ? 'shared' : 'rules',
        references: [],
        referencedBy: []
      });
    }
    
    console.log(chalk.gray(`Found ${allFiles.length} documents (${rulesFiles.length} rules, ${sharedFiles.length} shared)`));
  }

  async extractReferences() {
    console.log(chalk.gray('🔍 Extracting references...'));
    
    for (const [docPath, doc] of this.documentMap) {
      const references = this.findReferencesInDocument(doc.content, docPath);
      doc.references = references;
      
      // Build reference graph
      this.referenceGraph.set(docPath, references.map(ref => ref.targetPath));
    }
  }

  findReferencesInDocument(content, sourcePath) {
    const references = [];
    const lines = content.split('\n');
    
    lines.forEach((line, index) => {
      const lineNumber = index + 1;
      
      // Find markdown links
      const linkRegex = /\[([^\]]+)\]\(([^)]+\.md)\)/g;
      let match;
      
      while ((match = linkRegex.exec(line)) !== null) {
        const linkText = match[1];
        const linkUrl = match[2];
        
        // Resolve relative path
        const targetPath = this.resolveRelativePath(sourcePath, linkUrl);
        
        references.push({
          sourcePath: sourcePath,
          targetPath: targetPath,
          linkText: linkText,
          linkUrl: linkUrl,
          line: lineNumber,
          type: 'markdown_link'
        });
      }
      
      // Find include statements or other reference patterns
      const includeRegex = /<!--\s*include\s+([^\s]+\.md)\s*-->/g;
      while ((match = includeRegex.exec(line)) !== null) {
        const includePath = match[1];
        const targetPath = this.resolveRelativePath(sourcePath, includePath);
        
        references.push({
          sourcePath: sourcePath,
          targetPath: targetPath,
          linkText: 'include',
          linkUrl: includePath,
          line: lineNumber,
          type: 'include'
        });
      }
    });
    
    return references;
  }

  resolveRelativePath(sourcePath, relativePath) {
    const sourceDir = path.dirname(sourcePath);
    const resolved = path.resolve(sourceDir, relativePath);
    return path.relative(process.cwd(), resolved);
  }

  async validateReferences() {
    console.log(chalk.gray('✅ Validating reference integrity...'));
    
    for (const [docPath, doc] of this.documentMap) {
      for (const ref of doc.references) {
        const issue = this.validateSingleReference(ref);
        if (issue) {
          this.results.issues.push(issue);
        } else {
          // Mark target as referenced by this document
          const targetDoc = this.documentMap.get(ref.targetPath);
          if (targetDoc) {
            targetDoc.referencedBy.push(ref.sourcePath);
          }
        }
        
        this.results.references.push({
          ...ref,
          valid: !issue,
          issue: issue?.message || null
        });
      }
    }
  }

  validateSingleReference(reference) {
    const { sourcePath, targetPath, linkUrl, line, type } = reference;
    
    // Check if target file exists
    if (!this.documentMap.has(targetPath)) {
      return {
        type: 'broken_reference',
        severity: 'error',
        message: `Referenced file does not exist: ${targetPath}`,
        sourcePath: sourcePath,
        targetPath: targetPath,
        line: line
      };
    }
    
    // Check for self-references
    if (sourcePath === targetPath) {
      return {
        type: 'self_reference',
        severity: 'warning',
        message: 'Document references itself',
        sourcePath: sourcePath,
        targetPath: targetPath,
        line: line
      };
    }
    
    // Check for proper relative path format
    if (!linkUrl.startsWith('./') && !linkUrl.startsWith('../')) {
      return {
        type: 'absolute_path',
        severity: 'warning',
        message: 'Should use relative path for internal references',
        sourcePath: sourcePath,
        targetPath: targetPath,
        line: line
      };
    }
    
    // Note: Optimized versions no longer use -optimized suffix
    // References to ../shared/ .md files are now correct
    
    return null; // No issues
  }

  async analyzeDependencyGraph() {
    console.log(chalk.gray('📊 Analyzing dependency graph...'));
    
    // Calculate dependency metrics
    for (const [docPath, doc] of this.documentMap) {
      const outgoingRefs = doc.references.length;
      const incomingRefs = doc.referencedBy.length;
      
      doc.metrics = {
        outgoingReferences: outgoingRefs,
        incomingReferences: incomingRefs,
        dependencyRatio: outgoingRefs > 0 ? incomingRefs / outgoingRefs : 0
      };
    }
  }

  async detectCircularDependencies() {
    console.log(chalk.gray('🔄 Detecting circular dependencies...'));
    
    const visited = new Set();
    const recursionStack = new Set();
    const cycles = [];
    
    for (const [docPath] of this.documentMap) {
      if (!visited.has(docPath)) {
        const cycle = this.dfsDetectCycle(docPath, visited, recursionStack, []);
        if (cycle) {
          cycles.push(cycle);
        }
      }
    }
    
    this.results.summary.circularDependencies = cycles;
    
    if (cycles.length > 0) {
      console.log(chalk.yellow(`⚠️  Found ${cycles.length} circular dependencies`));
    }
  }

  dfsDetectCycle(node, visited, recursionStack, path) {
    visited.add(node);
    recursionStack.add(node);
    path.push(node);
    
    const references = this.referenceGraph.get(node) || [];
    
    for (const neighbor of references) {
      if (!this.documentMap.has(neighbor)) continue;
      
      if (!visited.has(neighbor)) {
        const cycle = this.dfsDetectCycle(neighbor, visited, recursionStack, [...path]);
        if (cycle) return cycle;
      } else if (recursionStack.has(neighbor)) {
        // Found a cycle
        const cycleStart = path.indexOf(neighbor);
        return path.slice(cycleStart).concat([neighbor]);
      }
    }
    
    recursionStack.delete(node);
    return null;
  }

  async findOrphanedDocuments() {
    console.log(chalk.gray('🏝️  Finding orphaned documents...'));
    
    const orphaned = [];
    
    for (const [docPath, doc] of this.documentMap) {
      // Skip main entry points (rules.md files)
      if (docPath.endsWith('/rules.md')) continue;
      
      // Check if document is referenced by any other document
      if (doc.referencedBy.length === 0) {
        orphaned.push({
          path: docPath,
          type: doc.type,
          outgoingReferences: doc.references.length
        });
      }
    }
    
    this.results.summary.orphanedDocuments = orphaned;
    
    if (orphaned.length > 0) {
      console.log(chalk.yellow(`🏝️  Found ${orphaned.length} orphaned documents`));
    }
  }

  generateReport() {
    const validRefs = this.results.references.filter(ref => ref.valid).length;
    const brokenRefs = this.results.references.filter(ref => !ref.valid).length;
    
    this.results.summary = {
      ...this.results.summary,
      totalFiles: this.documentMap.size,
      totalReferences: this.results.references.length,
      validReferences: validRefs,
      brokenReferences: brokenRefs
    };

    console.log('\n' + chalk.blue('📊 Cross-Reference Validation Summary'));
    console.log(chalk.gray('======================================'));
    console.log(`Total documents: ${chalk.cyan(this.results.summary.totalFiles)}`);
    console.log(`Total references: ${chalk.cyan(this.results.summary.totalReferences)}`);
    console.log(`Valid references: ${chalk.green(this.results.summary.validReferences)}`);
    console.log(`Broken references: ${chalk.red(this.results.summary.brokenReferences)}`);
    console.log(`Circular dependencies: ${chalk.yellow(this.results.summary.circularDependencies.length)}`);
    console.log(`Orphaned documents: ${chalk.yellow(this.results.summary.orphanedDocuments.length)}`);

    // Show reference integrity rate
    const integrityRate = this.results.summary.totalReferences > 0 ? 
      ((this.results.summary.validReferences / this.results.summary.totalReferences) * 100).toFixed(2) : 100;
    console.log(`Reference integrity: ${chalk.cyan(integrityRate + '%')}`);

    // Show issues by type
    if (this.results.issues.length > 0) {
      console.log('\n' + chalk.red('🚨 Reference Issues:'));
      
      const issuesByType = {};
      this.results.issues.forEach(issue => {
        issuesByType[issue.type] = (issuesByType[issue.type] || 0) + 1;
      });
      
      Object.entries(issuesByType)
        .sort(([,a], [,b]) => b - a)
        .forEach(([type, count]) => {
          console.log(`  ${chalk.yellow(type)}: ${count}`);
        });
      
      // Show top broken references
      const brokenRefs = this.results.issues
        .filter(issue => issue.type === 'broken_reference')
        .slice(0, 5);
      
      if (brokenRefs.length > 0) {
        console.log('\n' + chalk.red('💔 Top Broken References:'));
        brokenRefs.forEach(issue => {
          console.log(chalk.red(`  ❌ ${issue.sourcePath}:${issue.line} → ${issue.targetPath}`));
        });
      }
    }

    // Show circular dependencies
    if (this.results.summary.circularDependencies.length > 0) {
      console.log('\n' + chalk.yellow('🔄 Circular Dependencies:'));
      this.results.summary.circularDependencies.forEach((cycle, index) => {
        console.log(chalk.yellow(`  ${index + 1}. ${cycle.join(' → ')}`));
      });
    }

    // Show orphaned documents
    if (this.results.summary.orphanedDocuments.length > 0) {
      console.log('\n' + chalk.yellow('🏝️  Orphaned Documents:'));
      this.results.summary.orphanedDocuments.slice(0, 5).forEach(doc => {
        console.log(chalk.yellow(`  📄 ${doc.path} (${doc.type})`));
      });
      
      if (this.results.summary.orphanedDocuments.length > 5) {
        const remaining = this.results.summary.orphanedDocuments.length - 5;
        console.log(chalk.gray(`  ... and ${remaining} more`));
      }
    }

    // Show dependency metrics for top documents
    console.log('\n' + chalk.blue('📈 Top Referenced Documents:'));
    const topReferenced = Array.from(this.documentMap.values())
      .sort((a, b) => b.metrics.incomingReferences - a.metrics.incomingReferences)
      .slice(0, 5);
    
    topReferenced.forEach(doc => {
      console.log(chalk.cyan(`  📄 ${doc.path}: ${doc.metrics.incomingReferences} incoming refs`));
    });

    return this.results;
  }

  async saveReport(outputPath) {
    const reportData = {
      timestamp: new Date().toISOString(),
      ...this.results,
      documentMap: Array.from(this.documentMap.entries()).map(([path, doc]) => ({
        path,
        type: doc.type,
        metrics: doc.metrics,
        referencesCount: doc.references.length,
        referencedByCount: doc.referencedBy.length
      }))
    };
    
    fs.writeFileSync(outputPath, JSON.stringify(reportData, null, 2));
    console.log(chalk.green(`📄 Report saved to: ${outputPath}`));
  }
}

// CLI execution
if (require.main === module) {
  const validator = new CrossReferenceValidator();
  
  validator.validateCrossReferences()
    .then(results => {
      const reportPath = path.join('.roo', 'validation', 'reports', `cross-reference-${Date.now()}.json`);
      return validator.saveReport(reportPath);
    })
    .then(() => {
      const brokenCount = validator.results.summary.brokenReferences;
      const circularCount = validator.results.summary.circularDependencies.length;
      process.exit((brokenCount > 0 || circularCount > 0) ? 1 : 0);
    })
    .catch(error => {
      console.error(chalk.red('❌ Cross-reference validator failed:'), error);
      process.exit(1);
    });
}

module.exports = CrossReferenceValidator;