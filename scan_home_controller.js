const fs = require('fs');
const path = require('path');

const controllerPath = path.join(__dirname, 'Admin-Super-Admin', 'src', 'main', 'java', 'org', 'jackfruit', 'keliri', 'controller', 'homeController.java');

try {
  const content = fs.readFileSync(controllerPath, 'utf8');
  console.log('Read homeController.java successfully. Length:', content.length);
  
  // Find all @PostMapping, @GetMapping, @RequestMapping annotations and the method signature following them
  const regex = /@(PostMapping|GetMapping|RequestMapping|PutMapping|DeleteMapping)\([^)]*\)[\s\S]*?(public|private|protected)[^({]*\(/gi;
  let match;
  const mappings = [];
  while ((match = regex.exec(content)) !== null) {
    mappings.push(match[0].replace(/\s+/g, ' '));
  }
  
  console.log(`Found ${mappings.length} endpoint mappings:`);
  mappings.forEach((m, idx) => {
    if (m.includes('company') || m.includes('publisher') || idx < 10) {
      console.log(`${idx + 1}: ${m}`);
    }
  });

  // Let's also search for any reference to companyrepo
  const repoMatches = [];
  const lines = content.split('\n');
  lines.forEach((line, index) => {
    if (line.toLowerCase().includes('companyrepo')) {
      repoMatches.push({ lineNum: index + 1, content: line.trim() });
    }
  });
  console.log('\n--- companyrepo references ---');
  console.log(repoMatches);

} catch (error) {
  console.error('Error scanning file:', error);
}
