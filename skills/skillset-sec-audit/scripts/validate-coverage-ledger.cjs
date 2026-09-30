#!/usr/bin/env node
// validate-coverage-ledger.cjs — zero-dependency checker for coverage-ledger.json.
const fs = require('fs');
const path = process.argv[2] || 'coverage-ledger.json';
let data;
try {
  data = JSON.parse(fs.readFileSync(path, 'utf8'));
} catch (e) {
  console.error(`FAIL: cannot read ${path}: ${e.message}`);
  process.exit(1);
}
const errors = [];
if (!Array.isArray(data.units)) errors.push('.units must be an array');
for (const u of data.units || []) {
  for (const k of ['id', 'files', 'status']) {
    if (!u[k]) errors.push(`unit ${u.id || '?'} missing ${k}`);
  }
  if (u.status && !['pending', 'covered', 'gap'].includes(u.status)) {
    errors.push(`unit ${u.id} bad status`);
  }
}
if (errors.length) {
  console.error(errors.join('\n'));
  process.exit(1);
}
console.log('coverage-ledger.json valid');
