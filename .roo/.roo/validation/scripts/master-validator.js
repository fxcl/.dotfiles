#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const chalk = require('chalk');

// Import validation modules
const LinkChecker = require('./link-checker');
const TemplateValidator = require('./template-validator');
const FormatChecker = require('./format-checker');
const CrossReferenceValidator = require('./cross-reference-validator');

class MasterValidator {
  constructor(configPath = '.roo/validation/config/validation-config.json') {
    this.config = this.loadConfig(configPath);
    this.results = {
      timestamp: new Date().toISOString(),
      overall: {
        passed: false,
        score: 0,
        issues: [],
        warnings: []
      },
      validations: {
        linkChecker: null,
        templateValidator: null,
        formatChecker: null,
        crossReferenceValidator: null
      },
      summary: {
        totalFiles: 0,
        totalIssues: 0,
        criticalIssues: 0,
        warningIssues: 0,
        infoIssues: 0
      }
    };
  }

  loadConfig(configPath) {
    try {
      const configContent = fs.readFileSync(configPath, 'utf8');
      return JSON.parse(configContent);
    } catch (error) {
      console.warn(chalk.yellow(`⚠️  Could not load config from ${configPath}, using defaults`));
      return this.getDefaultConfig();
    }
  }

  getDefaultConfig() {
    return {
      validation: {
        thresholds: {
          linkIntegrity: { minSuccessRate: 95 },
          templateCompliance: { minComplianceRate: 90 },
          formatConsistency: { maxIssuesPerFile: 5 },
          crossReferences: {
            minIntegrityRate: 95,
            maxCircularDependencies: 0,
            maxOrphanedDocuments: 3
          }
        }
      }
    };
  }

  async runAllValidations() {
    console.log(chalk.blue.bold('🚀 Starting RooCode Documentation Validation Suite'));
    console.log(chalk.gray('=' .repeat(60)));
    console.log(chalk.gray(`Started at: ${new Date().toLocaleString()}`));
    console.log('');

    const startTime = Date.now();

    try {
      // Run all validation checks
      await this.runLinkChecker();
      await this.runTemplateValidator();
      await this.runFormatChecker();
      await this.runCrossReferenceValidator();

      // Analyze results
      this.analyzeResults();

      // Generate reports
      await this.generateReports();

      const duration = ((Date.now() - startTime) / 1000).toFixed(2);
      console.log(chalk.gray(`\nCompleted in ${duration}s`));

      return this.results;

    } catch (error) {
      console.error(chalk.red('❌ Validation suite failed:'), error);
      throw error;
    }
  }

  async runLinkChecker() {
    console.log(chalk.blue('🔗 Running Link Integrity Check...'));
    try {
      const linkChecker = new LinkChecker();
      const results = await linkChecker.checkAllLinks();
      this.results.validations.linkChecker = results;
      
      // Compute success rate with compatibility across possible summary fields
      const totalLinks = results.summary.totalLinks || 0;
      const validLinks = (results.summary.validLinks != null)
        ? results.summary.validLinks
        : (results.summary.workingLinks != null)
          ? results.summary.workingLinks
          : (results.summary.brokenLinks != null && totalLinks > 0)
            ? (totalLinks - results.summary.brokenLinks)
            : 0;
      const successRate = totalLinks > 0 ? ((validLinks / totalLinks) * 100) : 100;
      
      if (successRate >= this.config.validation.thresholds.linkIntegrity.minSuccessRate) {
        console.log(chalk.green(`✅ Link check passed (${successRate.toFixed(1)}% success rate)`));
      } else {
        console.log(chalk.red(`❌ Link check failed (${successRate.toFixed(1)}% success rate)`));
        this.results.overall.issues.push({
          type: 'link_integrity',
          severity: 'error',
          message: `Link success rate ${successRate.toFixed(1)}% below threshold ${this.config.validation.thresholds.linkIntegrity.minSuccessRate}%`
        });
      }
    } catch (error) {
      console.error(chalk.red('❌ Link checker failed:'), error.message);
      this.results.overall.issues.push({
        type: 'link_checker_error',
        severity: 'error',
        message: `Link checker failed: ${error.message}`
      });
    }
  }

  async runTemplateValidator() {
    console.log(chalk.blue('📋 Running Template Structure Validation...'));
    try {
      const templateValidator = new TemplateValidator();
      const results = await templateValidator.validateAllDocuments();
      this.results.validations.templateValidator = results;
      
      const complianceRate = parseFloat(results.summary.complianceRate);
      
      if (complianceRate >= this.config.validation.thresholds.templateCompliance.minComplianceRate) {
        console.log(chalk.green(`✅ Template validation passed (${complianceRate}% compliance)`));
      } else {
        console.log(chalk.red(`❌ Template validation failed (${complianceRate}% compliance)`));
        this.results.overall.issues.push({
          type: 'template_compliance',
          severity: 'error',
          message: `Template compliance ${complianceRate}% below threshold ${this.config.validation.thresholds.templateCompliance.minComplianceRate}%`
        });
      }
    } catch (error) {
      console.error(chalk.red('❌ Template validator failed:'), error.message);
      this.results.overall.issues.push({
        type: 'template_validator_error',
        severity: 'error',
        message: `Template validator failed: ${error.message}`
      });
    }
  }

  async runFormatChecker() {
    console.log(chalk.blue('🔍 Running Format Consistency Check...'));
    try {
      const formatChecker = new FormatChecker();
      const results = await formatChecker.checkAllDocuments();
      this.results.validations.formatChecker = results;
      
      const maxIssuesPerFile = this.config.validation.thresholds.formatConsistency.maxIssuesPerFile;
      const filesWithTooManyIssues = results.files.filter(f => f.issueCount > maxIssuesPerFile);
      
      if (filesWithTooManyIssues.length === 0) {
        console.log(chalk.green(`✅ Format check passed (max ${maxIssuesPerFile} issues per file)`));
      } else {
        console.log(chalk.yellow(`⚠️  Format check has warnings (${filesWithTooManyIssues.length} files exceed threshold)`));
        this.results.overall.warnings.push({
          type: 'format_consistency',
          severity: 'warning',
          message: `${filesWithTooManyIssues.length} files have more than ${maxIssuesPerFile} format issues`
        });
      }
    } catch (error) {
      console.error(chalk.red('❌ Format checker failed:'), error.message);
      this.results.overall.issues.push({
        type: 'format_checker_error',
        severity: 'error',
        message: `Format checker failed: ${error.message}`
      });
    }
  }

  async runCrossReferenceValidator() {
    console.log(chalk.blue('🔗 Running Cross-Reference Validation...'));
    try {
      const crossRefValidator = new CrossReferenceValidator();
      const results = await crossRefValidator.validateCrossReferences();
      this.results.validations.crossReferenceValidator = results;
      
      const thresholds = this.config.validation.thresholds.crossReferences;
      const integrityRate = results.summary.totalReferences > 0 ? 
        ((results.summary.validReferences / results.summary.totalReferences) * 100) : 100;
      
      let passed = true;
      
      if (integrityRate < thresholds.minIntegrityRate) {
        passed = false;
        this.results.overall.issues.push({
          type: 'cross_reference_integrity',
          severity: 'error',
          message: `Reference integrity ${integrityRate.toFixed(1)}% below threshold ${thresholds.minIntegrityRate}%`
        });
      }
      
      if (results.summary.circularDependencies.length > thresholds.maxCircularDependencies) {
        passed = false;
        this.results.overall.issues.push({
          type: 'circular_dependencies',
          severity: 'error',
          message: `Found ${results.summary.circularDependencies.length} circular dependencies (max allowed: ${thresholds.maxCircularDependencies})`
        });
      }
      
      if (results.summary.orphanedDocuments.length > thresholds.maxOrphanedDocuments) {
        this.results.overall.warnings.push({
          type: 'orphaned_documents',
          severity: 'warning',
          message: `Found ${results.summary.orphanedDocuments.length} orphaned documents (threshold: ${thresholds.maxOrphanedDocuments})`
        });
      }
      
      if (passed) {
        console.log(chalk.green(`✅ Cross-reference validation passed (${integrityRate.toFixed(1)}% integrity)`));
      } else {
        console.log(chalk.red(`❌ Cross-reference validation failed`));
      }
    } catch (error) {
      console.error(chalk.red('❌ Cross-reference validator failed:'), error.message);
      this.results.overall.issues.push({
        type: 'cross_reference_error',
        severity: 'error',
        message: `Cross-reference validator failed: ${error.message}`
      });
    }
  }

  analyzeResults() {
    console.log('\n' + chalk.blue('📊 Analyzing Overall Results...'));
    
    // Calculate summary statistics
    let totalFiles = 0;
    let totalIssues = 0;
    let criticalIssues = 0;
    let warningIssues = 0;
    let infoIssues = 0;
    
    // Aggregate from all validators
    Object.values(this.results.validations).forEach(validation => {
      if (validation && validation.summary) {
        if (validation.summary.totalFiles) {
          totalFiles = Math.max(totalFiles, validation.summary.totalFiles);
        }
        if (validation.summary.totalIssues) {
          totalIssues += validation.summary.totalIssues;
        }
      }
      
      if (validation && validation.files) {
        validation.files.forEach(file => {
          if (file.issues) {
            file.issues.forEach(issue => {
              switch (issue.severity) {
                case 'error': criticalIssues++; break;
                case 'warning': warningIssues++; break;
                case 'info': infoIssues++; break;
              }
            });
          }
        });
      }
    });
    
    // Count overall issues and warnings
    criticalIssues += this.results.overall.issues.length;
    warningIssues += this.results.overall.warnings.length;
    
    this.results.summary = {
      totalFiles,
      totalIssues: criticalIssues + warningIssues + infoIssues,
      criticalIssues,
      warningIssues,
      infoIssues
    };
    
    // Calculate overall score (0-100)
    const maxPossibleIssues = totalFiles * 10; // Assume max 10 issues per file
    const actualIssues = criticalIssues * 3 + warningIssues * 1 + infoIssues * 0.1;
    this.results.overall.score = Math.max(0, Math.round(100 - (actualIssues / maxPossibleIssues) * 100));
    
    // Determine overall pass/fail
    this.results.overall.passed = criticalIssues === 0;
    
    // Display summary
    console.log(chalk.gray('=' .repeat(50)));
    console.log(`📁 Total files validated: ${chalk.cyan(totalFiles)}`);
    console.log(`🔍 Total issues found: ${chalk.yellow(this.results.summary.totalIssues)}`);
    console.log(`❌ Critical issues: ${chalk.red(criticalIssues)}`);
    console.log(`⚠️  Warning issues: ${chalk.yellow(warningIssues)}`);
    console.log(`ℹ️  Info issues: ${chalk.blue(infoIssues)}`);
    console.log(`📊 Overall score: ${chalk.cyan(this.results.overall.score + '/100')}`);
    
    if (this.results.overall.passed) {
      console.log(chalk.green.bold('\n🎉 ALL VALIDATIONS PASSED!'));
    } else {
      console.log(chalk.red.bold('\n❌ VALIDATION FAILED'));
      console.log(chalk.red('Critical issues must be resolved before proceeding.'));
    }
    
    if (warningIssues > 0) {
      console.log(chalk.yellow(`\n⚠️  ${warningIssues} warnings found - consider addressing these for better quality.`));
    }
  }

  async generateReports() {
    console.log('\n' + chalk.blue('📄 Generating Reports...'));
    
    const timestamp = Date.now();
    const reportsDir = path.join(__dirname, '..', 'reports');
    
    // Ensure reports directory exists
    if (!fs.existsSync(reportsDir)) {
      fs.mkdirSync(reportsDir, { recursive: true });
    }
    
    // Generate JSON report
    const jsonReportPath = path.join(reportsDir, `validation-report-${timestamp}.json`);
    fs.writeFileSync(jsonReportPath, JSON.stringify(this.results, null, 2));
    console.log(chalk.green(`📄 JSON report: ${jsonReportPath}`));
    
    // Generate summary report
    const summaryReportPath = path.join(reportsDir, `validation-summary-${timestamp}.txt`);
    const summaryContent = this.generateSummaryReport();
    fs.writeFileSync(summaryReportPath, summaryContent);
    console.log(chalk.green(`📄 Summary report: ${summaryReportPath}`));
    
    // Generate latest symlinks
    const latestJsonPath = path.join(reportsDir, 'latest-validation.json');
    const latestSummaryPath = path.join(reportsDir, 'latest-summary.txt');
    
    try {
      if (fs.existsSync(latestJsonPath)) fs.unlinkSync(latestJsonPath);
      if (fs.existsSync(latestSummaryPath)) fs.unlinkSync(latestSummaryPath);
      
      fs.symlinkSync(path.basename(jsonReportPath), latestJsonPath);
      fs.symlinkSync(path.basename(summaryReportPath), latestSummaryPath);
    } catch (error) {
      // Symlink creation might fail on some systems, that's okay
      console.log(chalk.gray('Note: Could not create latest report symlinks'));
    }
  }

  generateSummaryReport() {
    const lines = [];
    lines.push('RooCode Documentation Validation Report');
    lines.push('=' .repeat(50));
    lines.push(`Generated: ${new Date(this.results.timestamp).toLocaleString()}`);
    lines.push('');
    
    lines.push('OVERALL RESULTS');
    lines.push('-' .repeat(20));
    lines.push(`Status: ${this.results.overall.passed ? 'PASSED' : 'FAILED'}`);
    lines.push(`Score: ${this.results.overall.score}/100`);
    lines.push(`Total Files: ${this.results.summary.totalFiles}`);
    lines.push(`Total Issues: ${this.results.summary.totalIssues}`);
    lines.push(`Critical: ${this.results.summary.criticalIssues}`);
    lines.push(`Warnings: ${this.results.summary.warningIssues}`);
    lines.push(`Info: ${this.results.summary.infoIssues}`);
    lines.push('');
    
    if (this.results.overall.issues.length > 0) {
      lines.push('CRITICAL ISSUES');
      lines.push('-' .repeat(20));
      this.results.overall.issues.forEach((issue, index) => {
        lines.push(`${index + 1}. [${issue.type}] ${issue.message}`);
      });
      lines.push('');
    }
    
    if (this.results.overall.warnings.length > 0) {
      lines.push('WARNINGS');
      lines.push('-' .repeat(20));
      this.results.overall.warnings.forEach((warning, index) => {
        lines.push(`${index + 1}. [${warning.type}] ${warning.message}`);
      });
      lines.push('');
    }
    
    // Add individual validator summaries
    Object.entries(this.results.validations).forEach(([name, results]) => {
      if (results && results.summary) {
        lines.push(`${name.toUpperCase()} SUMMARY`);
        lines.push('-' .repeat(20));
        Object.entries(results.summary).forEach(([key, value]) => {
          lines.push(`${key}: ${value}`);
        });
        lines.push('');
      }
    });
    
    return lines.join('\n');
  }
}

// CLI execution
if (require.main === module) {
  const validator = new MasterValidator();
  
  validator.runAllValidations()
    .then(results => {
      process.exit(results.overall.passed ? 0 : 1);
    })
    .catch(error => {
      console.error(chalk.red('❌ Master validator failed:'), error);
      process.exit(1);
    });
}

module.exports = MasterValidator;