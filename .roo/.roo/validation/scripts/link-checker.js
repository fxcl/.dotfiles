#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { glob } = require('glob');
const chalk = require('chalk');

class LinkChecker {
  constructor(rootDir = '../../.roo') {
    this.rootDir = process.argv[2] || rootDir;
    this.brokenLinks = [];
    this.validLinks = [];
    this.totalLinks = 0;
    this.results = {
      files: [],
      summary: {
        totalFiles: 0,
        totalLinks: 0,
        brokenLinks: 0,
        validLinks: 0,
        successRate: 0
      }
    };
  }

  async checkAllLinks() {
    console.log(chalk.blue('🔍 Starting link validation...'));
    
    const mdFiles = await this.findMarkdownFiles();
    console.log(chalk.gray(`Found ${mdFiles.length} markdown files`));
    
    for (const file of mdFiles) {
      await this.checkFileLinks(file);
    }
    
    return this.generateReport();
  }

  async findMarkdownFiles() {
    const pattern = path.join(this.rootDir, '**/*.md');
    return await glob(pattern, { ignore: ['**/node_modules/**', '../docs/**'] });
  }

  async checkFileLinks(filePath) {
    try {
      const content = fs.readFileSync(filePath, 'utf8');
      const links = this.extractLinks(content);
      
      const fileResult = {
        file: filePath,
        links: [],
        brokenCount: 0,
        validCount: 0
      };

      for (const link of links) {
        const linkResult = await this.validateLink(link, filePath);
        fileResult.links.push(linkResult);
        
        if (linkResult.valid) {
          fileResult.validCount++;
          this.validLinks.push(linkResult);
        } else {
          fileResult.brokenCount++;
          this.brokenLinks.push(linkResult);
        }
        
        this.totalLinks++;
      }
      
      this.results.files.push(fileResult);
      
      if (fileResult.brokenCount > 0) {
        console.log(chalk.yellow(`⚠️  ${filePath}: ${fileResult.brokenCount} broken links`));
      } else if (fileResult.validCount > 0) {
        console.log(chalk.green(`✅ ${filePath}: ${fileResult.validCount} valid links`));
      }
      
    } catch (error) {
      console.error(chalk.red(`❌ Error reading ${filePath}: ${error.message}`));
    }
  }

  extractLinks(content) {
    const linkRegex = /\[([^\]]+)\]\(([^)]+)\)/g;
    const links = [];
    let match;
    
    while ((match = linkRegex.exec(content)) !== null) {
      links.push({
        text: match[1],
        url: match[2],
        line: this.getLineNumber(content, match.index)
      });
    }
    
    return links;
  }

  getLineNumber(content, index) {
    return content.substring(0, index).split('\n').length;
  }

  async validateLink(link, sourceFile) {
    const result = {
      text: link.text,
      url: link.url,
      line: link.line,
      sourceFile: sourceFile,
      valid: false,
      error: null,
      type: this.getLinkType(link.url)
    };

    try {
      if (result.type === 'relative') {
        result.valid = await this.validateRelativeLink(link.url, sourceFile);
        if (!result.valid) {
          result.error = 'File not found';
        }
      } else if (result.type === 'anchor') {
        result.valid = await this.validateAnchorLink(link.url, sourceFile);
        if (!result.valid) {
          result.error = 'Anchor not found';
        }
      } else if (result.type === 'absolute') {
        // For absolute paths, check if file exists
        result.valid = fs.existsSync(link.url);
        if (!result.valid) {
          result.error = 'Absolute path not found';
        }
      } else {
        // External URLs - assume valid for now
        result.valid = true;
      }
    } catch (error) {
      result.valid = false;
      result.error = error.message;
    }

    return result;
  }

  getLinkType(url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return 'external';
    } else if (url.startsWith('/')) {
      return 'absolute';
    } else if (url.includes('#')) {
      return 'anchor';
    } else {
      return 'relative';
    }
  }

  async validateRelativeLink(url, sourceFile) {
    const sourceDir = path.dirname(sourceFile);
    const targetPath = path.resolve(sourceDir, url);
    return fs.existsSync(targetPath);
  }

  async validateAnchorLink(url, sourceFile) {
    const [filePart, anchor] = url.split('#');
    
    let targetFile;
    if (filePart) {
      const sourceDir = path.dirname(sourceFile);
      targetFile = path.resolve(sourceDir, filePart);
    } else {
      targetFile = sourceFile;
    }
    
    if (!fs.existsSync(targetFile)) {
      return false;
    }
    
    // Check if anchor exists in target file
    const content = fs.readFileSync(targetFile, 'utf8');
    const anchorRegex = new RegExp(`#{1,6}\\s+.*${anchor.replace(/[.*+?^${}()|[\\]\\\\]/g, '\\\\$&')}`, 'i');
    return anchorRegex.test(content);
  }

  generateReport() {
    this.results.summary = {
      totalFiles: this.results.files.length,
      totalLinks: this.totalLinks,
      brokenLinks: this.brokenLinks.length,
      validLinks: this.validLinks.length,
      successRate: this.totalLinks > 0 ? ((this.validLinks.length / this.totalLinks) * 100).toFixed(2) : 100
    };

    console.log('\n' + chalk.blue('📊 Link Validation Summary'));
    console.log(chalk.gray('================================'));
    console.log(`Total files scanned: ${chalk.cyan(this.results.summary.totalFiles)}`);
    console.log(`Total links found: ${chalk.cyan(this.results.summary.totalLinks)}`);
    console.log(`Valid links: ${chalk.green(this.results.summary.validLinks)}`);
    console.log(`Broken links: ${chalk.red(this.results.summary.brokenLinks)}`);
    console.log(`Success rate: ${chalk.yellow(this.results.summary.successRate + '%')}`);

    if (this.brokenLinks.length > 0) {
      console.log('\n' + chalk.red('🚨 Broken Links Details:'));
      this.brokenLinks.forEach(link => {
        console.log(chalk.red(`  ❌ ${link.sourceFile}:${link.line}`));
        console.log(chalk.gray(`     Text: "${link.text}"`));
        console.log(chalk.gray(`     URL: ${link.url}`));
        console.log(chalk.gray(`     Error: ${link.error}`));
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
    
    fs.writeFileSync(outputPath, JSON.stringify(reportData, null, 2));
    console.log(chalk.green(`📄 Report saved to: ${outputPath}`));
  }
}

// CLI execution
if (require.main === module) {
  const checker = new LinkChecker();
  
  checker.checkAllLinks()
    .then(results => {
      const reportPath = path.join('.roo', 'validation', 'reports', `link-check-${Date.now()}.json`);
      return checker.saveReport(reportPath);
    })
    .then(() => {
      process.exit(checker.brokenLinks.length > 0 ? 1 : 0);
    })
    .catch(error => {
      console.error(chalk.red('❌ Link checker failed:'), error);
      process.exit(1);
    });
}

module.exports = LinkChecker;