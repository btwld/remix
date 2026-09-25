import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import {execFileSync} from 'node:child_process';
import {fileURLToPath, pathToFileURL} from 'node:url';
import path from 'node:path';
import {iconSvg, iconNames, masterForSize, getIconUsage} from '../../packages/web/index.mjs';
const root=fileURLToPath(new URL('../../',import.meta.url));
const reportPath=path.join(root,'reports/web-adapter.json');
fs.writeFileSync(reportPath,JSON.stringify({status:'running'})+'\n');
const work=fs.mkdtempSync(path.join(os.tmpdir(),'icon-evidence-'));
const startPath=path.join(work,'start.json');
process.on('exit',()=>fs.rmSync(work,{recursive:true,force:true}));
execFileSync(process.env.PYTHON || 'python',['tools/evidence.py','capture','--output',startPath],{cwd:root});
const registry=JSON.parse(fs.readFileSync(path.join(root,'generated/registry.json'))).paths;
let drawings=0, isolated=0;
assert.equal(iconNames.length,48);
for (const name of iconNames) {
  const single=await import(pathToFileURL(path.join(root,'packages/web/icons',name+'.mjs')));
  for (const appearance of ['outline','filled']) for (const master of [12,16,24]) {
    const output=iconSvg(name,{appearance,master,size:master});
    assert.ok(output.includes(`d="${registry[name][appearance][master]}"`));
    assert.ok(output.includes('aria-hidden="true"'));
    assert.ok(output.includes(`viewBox="0 0 ${master} ${master}"`));
    assert.equal(single.default({appearance,master,size:master}),output);
    drawings++;
  }
  // The isolated entry references only the shared renderer, not the full-catalog data module.
  const code=fs.readFileSync(path.join(root,'packages/web/icons',name+'.mjs'),'utf8');
  assert.ok(!code.includes('data.mjs'));isolated++;
}
for(const [size,master] of [[12,12],[14,16],[16,16],[20,24],[24,24],[32,24]])assert.equal(masterForSize(size),master);
for (const size of [0,-1,NaN,Infinity,'16',2048]) assert.throws(()=>iconSvg('home',{size}));
assert.throws(()=>iconSvg('home',{pack:'rounded'}),/Unavailable pack/);
assert.throws(()=>iconSvg('home',{appearance:'duotone'}),/Unavailable appearance/);
assert.throws(()=>iconSvg('home',{master:20}),/Unavailable optical master/);
assert.throws(()=>iconSvg('settings'),/Unknown canonical/);
assert.throws(()=>iconSvg('__proto__'),/Unknown canonical/);
assert.throws(()=>iconSvg('home',{title:''}),/title must/);
const informative=iconSvg('info',{title:'About <this> & "that"'});
assert.ok(informative.includes('role="img"'));
assert.ok(informative.includes('About &lt;this&gt; &amp; &quot;that&quot;'));
assert.ok(!informative.includes('aria-hidden'));
for(const appearance of ['outline','filled']) for(const master of [12,16,24]) {
  const usage=getIconUsage('warning',{appearance,master});
  assert.equal(usage.visibleLabelRequired,true);
  assert.equal(usage.master,master);
  assert.ok(usage.geometrySha256.length===64);
}
assert.equal(getIconUsage('warning',{appearance:'filled',size:20}).master,24);
assert.equal(getIconUsage('warning',{appearance:'outline',size:32}).visibleLabelRequired,true);
assert.equal(getIconUsage('sliders').visibleLabelRequired,false);
assert.throws(()=>getIconUsage('settings'),/Unknown canonical/);
assert.throws(()=>getIconUsage('warning',{appearance:'bad'}));
assert.throws(()=>getIconUsage('warning',{master:20}));
assert.throws(()=>getIconUsage('warning',{pack:'rounded'}));
const report={status:'passed',node:process.version,drawingsCompared:drawings,isolatedImports:isolated,sizeMappings:6,checks:['canonical identity','no silent pack/appearance/master fallback','per-icon imports','decorative SVG semantics','named standalone SVG semantics','escaped title','native master selection'],scope:'Node module and source-string checks; not browser module loading or screen-reader testing'};
fs.writeFileSync(path.join(root,'reports/web-adapter.json'),JSON.stringify(report,null,2)+'\n');
execFileSync(process.env.PYTHON || 'python',['tools/evidence.py','stamp','--start-file',startPath,'--report',reportPath],{cwd:root});
console.log(JSON.stringify(report,null,2));
