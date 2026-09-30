#!/usr/bin/env node
// validate-findings.cjs — zero-dependency checker for findings.json.
const fs = require('fs');
const path = process.argv[2] || 'findings.json';
let data;
try {
  data = JSON.parse(fs.readFileSync(path, 'utf8'));
} catch (e) {
  console.error(`FAIL: cannot read ${path}: ${e.message}`);
  process.exit(1);
}
const errors = [];
for (const key of ['confirmed', 'needs_validation', 'rejected']) {
  if (!Array.isArray(data[key])) errors.push(`.${key} must be an array`);
}
for (const f of data.confirmed || []) {
  for (const k of ['id', 'title', 'severity', 'file', 'evidence', 'impact']) {
    if (!f[k]) errors.push(`confirmed ${f.id || '?'} missing ${k}`);
  }
  if (f.severity && !['critical', 'high', 'medium', 'low'].includes(f.severity)) {
    errors.push(`confirmed ${f.id} bad severity`);
  }
}
for (const f of data.needs_validation || []) {
  if (!f.id || !f.title || !f.unresolved) errors.push(`needs_validation ${f.id || '?'} needs unresolved fact`);
  if (f.severity) errors.push(`needs_validation ${f.id} must not set severity`);
}
if (errors.length) {
  console.error(errors.join('\n'));
  process.exit(1);
}
console.log('findings.json valid');
