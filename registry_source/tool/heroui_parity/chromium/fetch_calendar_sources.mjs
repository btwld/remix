// Refresh calendar evidence exclusively from integrity-verified pinned tarballs.
import {readFile,writeFile,mkdir} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {execFileSync} from 'node:child_process';
import {tmpdir} from 'node:os';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
const ref=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'../../../reference/heroui_3_2_6');
const manifest=JSON.parse(await readFile(path.join(ref,'sources.json')));
const files=JSON.parse(await readFile(path.join(ref,'source/files.json')));
const sha=bytes=>createHash('sha256').update(bytes).digest('hex');
const families=['calendar','range-calendar','date-picker','date-range-picker'];
for(const pkg of manifest.packages) {
  const response=await fetch(pkg.tarball);if(!response.ok)throw Error(response.statusText);
  const bytes=Buffer.from(await response.arrayBuffer());
  const actual='sha512-'+createHash('sha512').update(bytes).digest('base64');
  if(actual!==pkg.integrity)throw Error(`Integrity mismatch: ${pkg.name}`);
  const tar=path.join(tmpdir(),`remix-heroui-${pkg.name.split('/').pop()}-3.2.6.tgz`);
  await writeFile(tar,bytes);
  const targets=pkg.name==='@heroui/styles'
    ? [...families,'date-field'].map(f=>`dist/components/${f}.css`)
    : families.flatMap(f=>[`dist/components/${f}/${f}.js`,`dist/components/${f}/${f}.d.ts`]);
  for(const target of targets) {
    const content=execFileSync('tar',['-xOf',tar,`package/${target}`]);
    const digest=sha(content);
    pkg.inspectedFiles=pkg.inspectedFiles.filter(f=>f.path!==target);
    pkg.inspectedFiles.push({path:target,sha256:digest});
    const relative=pkg.name==='@heroui/react'?`source/react/${target}`:`source/${target}`;
    await mkdir(path.dirname(path.join(ref,relative)),{recursive:true});
    await writeFile(path.join(ref,relative),content);
    const old=files.findIndex(f=>f.path===relative);if(old>=0)files.splice(old,1);
    files.push({path:relative,sha256:digest});
  }
}
files.sort((a,b)=>a.path.localeCompare(b.path,'en'));
await writeFile(path.join(ref,'source/files.json'),JSON.stringify(files,null,1)+'\n');
await writeFile(path.join(ref,'sources.json'),JSON.stringify(manifest,null,2)+'\n');
console.log('Verified pinned SHA-512 integrity; refreshed calendar source SHA-256 hashes.');
