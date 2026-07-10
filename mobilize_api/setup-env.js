const fs = require('fs');
const path = require('path');

const envFiles = [
  { dest: '.env.dev', src: 'env.dev.template' },
  { dest: '.env.aws', src: 'env.aws.template' },
  { dest: '.env.sms', src: 'env.sms.template' },
  { dest: '.env.messages', src: 'env.messages.template' },
  { dest: '.env.collections', src: 'env.collections.template' },
  { dest: '.env.google', src: 'env.google.template' },
  { dest: '.env.email', src: 'env.email.template' }
];

const templatesDir = path.join(__dirname, 'env-templates');

if (!fs.existsSync(templatesDir)) {
  console.error(`Error: env-templates directory not found at ${templatesDir}`);
  process.exit(1);
}

envFiles.forEach(file => {
  const destPath = path.join(__dirname, file.dest);
  const srcPath = path.join(templatesDir, file.src);

  if (fs.existsSync(destPath)) {
    console.log(`[Info] ${file.dest} already exists. Skipping.`);
  } else if (!fs.existsSync(srcPath)) {
    console.warn(`[Warning] Template for ${file.src} not found in env-templates.`);
  } else {
    try {
      fs.copyFileSync(srcPath, destPath);
      console.log(`[Success] Created ${file.dest} from ${file.src}.`);
    } catch (err) {
      console.error(`[Error] Failed to copy ${file.dest}:`, err);
    }
  }
});

console.log('Environment setup complete.');
