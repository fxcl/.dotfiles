const fs = require('fs');

// Test the updated workflow section detection with skip logic
const content = fs.readFileSync('/Users/kelvin/workspace/js/rooles/.roo/rules-accessibility-expert/rules.md', 'utf8');
const lines = content.split('\n');

console.log('Testing UPDATED workflow section detection with skip logic:');
console.log('========================================================');

for (let i = 0; i < lines.length; i++) {
  const line = lines[i];
  if (/^##?\s+.*[Ww]orkflow/.test(line)) {
    console.log(`\nLine ${i + 1}: "${line}" - MATCHED`);
    
    // Find the end of this section
    let endLine = lines.length;
    for (let j = i + 1; j < lines.length; j++) {
      if (/^##?\s+/.test(lines[j])) {
        endLine = j;
        break;
      }
    }
    
    const sectionContent = lines.slice(i, endLine).join('\n');
    const contentLines = lines.slice(i + 1, endLine).filter(line => line.trim() && !line.startsWith('#'));
    const referenceLines = contentLines.filter(line => line.includes('Refer to') && line.includes('.md'));
    
    console.log(`  Section lines: ${i + 1} to ${endLine}`);
    console.log(`  Content lines: ${contentLines.length}`);
    console.log(`  Reference lines: ${referenceLines.length}`);
    console.log(`  Has table (|): ${sectionContent.includes('|')}`);
    
    // Apply UPDATED skip logic
    let shouldSkip = false;
    
    if (line.includes('Workflow & Error Handling')) {
      const nonReferenceLines = contentLines.filter(line => !line.includes('Refer to') && !line.includes('.md') && line.trim() !== '');
      const hasErrorHandlingList = contentLines.some(line => line.includes('**') && line.includes(':') && (line.includes('Handle') || line.includes('Address') || line.includes('Manage')));
      
      console.log(`  Non-reference lines: ${nonReferenceLines.length}`);
      console.log(`  Has error handling list: ${hasErrorHandlingList}`);
      
      if ((referenceLines.length > 0 && nonReferenceLines.length <= 2) || hasErrorHandlingList) {
        shouldSkip = true;
        console.log(`  SHOULD SKIP: Workflow & Error Handling with references or error handling list`);
      }
    } else {
      if (referenceLines.length > 0 && 
          referenceLines.length >= contentLines.length * 0.5 && 
          !sectionContent.includes('|') &&
          contentLines.length <= 5) {
        shouldSkip = true;
        console.log(`  SHOULD SKIP: Other workflow section with mostly references`);
      }
    }
    
    if (!shouldSkip) {
      const tableLines = lines.slice(i, endLine).filter(line => line.trim().includes('|'));
      console.log(`  Table lines found: ${tableLines.length}`);
      if (tableLines.length === 0) {
        console.log(`  ❌ WOULD REPORT ERROR: No table found`);
      } else {
        console.log(`  ✅ WOULD PASS: Table found`);
      }
    }
  }
}