const fs = require('fs');

// Test the modified regex
const content = fs.readFileSync('/Users/kelvin/workspace/js/rooles/.roo/rules-memory/rules.md', 'utf8');

console.log('=== Testing different regex patterns ===');

// Pattern 1: Original pattern
const pattern1 = /^##?\s+.*Workflow[\s\S]*?(?=^##?\s+|$)/gm;
console.log('\n--- Pattern 1 (Original) ---');
let match1;
while ((match1 = pattern1.exec(content)) !== null) {
  const sectionTitle = match1[0].split('\n')[0];
  console.log(`Found: ${sectionTitle}`);
  console.log(`Content length: ${match1[0].length}`);
  console.log(`Has table: ${/\|.*\|/.test(match1[0])}`);
  console.log(`First 200 chars: ${match1[0].substring(0, 200)}...`);
}

// Pattern 2: Modified pattern
const pattern2 = /^##?\s+(?!.*&.*Error.*Handling).*Workflow(?!.*&.*Error.*Handling)[\s\S]*?(?=^##?\s+|$)/gm;
console.log('\n--- Pattern 2 (Modified) ---');
let match2;
while ((match2 = pattern2.exec(content)) !== null) {
  const sectionTitle = match2[0].split('\n')[0];
  console.log(`Found: ${sectionTitle}`);
  console.log(`Content length: ${match2[0].length}`);
  console.log(`Has table: ${/\|.*\|/.test(match2[0])}`);
  console.log(`First 200 chars: ${match2[0].substring(0, 200)}...`);
}

// Let's also check what comes after the Workflow section
console.log('\n--- Manual section extraction ---');
const lines = content.split('\n');
let workflowStart = -1;
let workflowEnd = -1;

for (let i = 0; i < lines.length; i++) {
  if (lines[i].match(/^##\s+Workflow$/)) {
    workflowStart = i;
  } else if (workflowStart !== -1 && lines[i].match(/^##\s+/)) {
    workflowEnd = i;
    break;
  }
}

if (workflowStart !== -1) {
  const workflowSection = lines.slice(workflowStart, workflowEnd !== -1 ? workflowEnd : lines.length).join('\n');
  console.log(`Workflow section (lines ${workflowStart}-${workflowEnd || lines.length}):`);
  console.log(workflowSection);
  console.log(`\nHas table: ${/\|.*\|/.test(workflowSection)}`);
}