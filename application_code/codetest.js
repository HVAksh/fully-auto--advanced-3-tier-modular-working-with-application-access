const fs = require('fs');
const path = require('path');

describe('application_code structure', () => {
  const baseDir = path.join(__dirname, 'application_code');

  it('should contain "web_files" and "app_files" directories', () => {
    const dirs = fs.readdirSync(baseDir, { withFileTypes: true })
                   .filter(entry => entry.isDirectory())
                   .map(entry => entry.name);

    expect(dirs).toContain('web_files');
    expect(dirs).toContain('app_files');
  });
});