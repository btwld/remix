(()=>{
'use strict';
document.documentElement.classList.add('js');
const DATA=JSON.parse(document.getElementById('icon-data').textContent);
const INDEX=Object.fromEntries(DATA.catalog.icons.map(x=>[x.id,x]));
const $=s=>document.querySelector(s);
const $$=s=>Array.from(document.querySelectorAll(s));
const escapeXML=value=>String(value).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&apos;'}[c]));
const masterFor=size=>size<=12?12:size<=16?16:24;
function icon(name,a,n,css=n){return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${n} ${n}" width="${css}" height="${css}" fill="currentColor" fill-rule="evenodd" aria-hidden="true" focusable="false"><path d="${DATA.paths[name][a][n]}"/></svg>`;}
function exported(name,a,n){return `<svg xmlns="http://www.w3.org/2000/svg" width="${n}" height="${n}" viewBox="0 0 ${n} ${n}" fill="currentColor" fill-rule="evenodd" role="img" focusable="false">\n  <title>${escapeXML(INDEX[name].label+' — '+a)}</title>\n  <path d="${DATA.paths[name][a][n]}"/>\n</svg>\n`;}
function pair(name,n,css,labels=true){return ['outline','filled'].map(a=>`<div class="pair-member">${icon(name,a,n,css)}${labels?`<small>${a.toUpperCase()}</small>`:''}</div>`).join('');}
function refreshCatalog(){
 const q=$('#search').value.trim().toLowerCase();const group=$('#category').value;const onlyNew=$('#new-only').getAttribute('aria-pressed')==='true';
 let visible=0;
 $$('.icon-card').forEach(card=>{const m=INDEX[card.dataset.icon];const hay=[m.id,m.label,m.meaning,...m.keywords].join(' ').toLowerCase();
   const show=(!q||hay.includes(q))&&(!group||m.category===group)&&(!onlyNew||m.stage==='pilot-addition');card.hidden=!show;if(show)visible++;});
 $$('.family').forEach(f=>{f.hidden=!Array.from(f.querySelectorAll('.icon-card')).some(c=>!c.hidden);});
 $('#count').textContent=`${visible} of ${DATA.catalog.icons.length} icons shown`;
 $('#empty').style.display=visible?'none':'block';
}
$('#search').addEventListener('input',refreshCatalog);$('#category').addEventListener('change',refreshCatalog);
$('#new-only').addEventListener('click',e=>{const b=e.currentTarget;b.setAttribute('aria-pressed',b.getAttribute('aria-pressed')!=='true');refreshCatalog();});
function reset(){ $('#search').value='';$('#category').value='';$('#new-only').setAttribute('aria-pressed','false');refreshCatalog(); }
$('#reset').addEventListener('click',reset);$('#empty-reset').addEventListener('click',reset);
$$('.chips a').forEach(a=>a.addEventListener('click',()=>reset()));
$('#display-size').addEventListener('change',()=>{const s=+$('#display-size').value,n=masterFor(s);$$('.card-live').forEach(p=>p.innerHTML=pair(p.dataset.icon,n,s));$('#size-note').textContent=`${s} px display uses the ${n} px optical master. Native strips below each card do not change.`;});
$('#theme').addEventListener('change',()=>{$('#library').dataset.theme=$('#theme').value;});
function refreshExamples(){const s=+$('#example-size').value,n=masterFor(s);$$('.sample-control').forEach(b=>b.querySelector('.example-icon').innerHTML=icon(b.dataset.icon,b.dataset.appearance,n,s));$('#examples-surface').dataset.theme=$('#example-theme').value;}
$('#example-size').addEventListener('change',refreshExamples);$('#example-theme').addEventListener('change',refreshExamples);
$$('.sample-control').forEach(b=>b.addEventListener('click',()=>{$('#example-feedback').textContent=`Preview only: ${INDEX[b.dataset.icon].example} / ${b.dataset.appearance}. No product action was performed.`;}));
$$('.demo-action').forEach(b=>b.addEventListener('click',()=>{$('#app-feedback').textContent=`Preview only: ${b.getAttribute('aria-label')||b.textContent.trim()}.`;}));
$$('.favorite-toggle').forEach(b=>b.addEventListener('click',()=>{const active=b.getAttribute('aria-pressed')!=='true';b.setAttribute('aria-pressed',active);b.innerHTML=icon('star',active?'filled':'outline',24);$('#app-feedback').textContent=active?'Favorite selected in this demo.':'Favorite cleared in this demo.';}));
// Each overlay and its artwork share exact dimensions and a single viewBox origin.
function geometryPair(name,n,z) {
 const inset={12:1,16:1.5,24:2}[n];
 const lines=Array.from({length:n+1},(_,i)=>`M${i} 0V${n}M0 ${i}H${n}`).join('');
 const overlay=`<svg class="coordinate-grid" xmlns="http://www.w3.org/2000/svg" width="${n*z}" height="${n*z}" viewBox="0 0 ${n} ${n}" aria-hidden="true" data-unit="1" data-css-step="${z}" data-keyline-inset="${inset}"><path d="${lines}" fill="none" stroke="currentColor" stroke-width="0.5" opacity="0.35" vector-effect="non-scaling-stroke"/><rect x="${inset}" y="${inset}" width="${n-2*inset}" height="${n-2*inset}" fill="none" stroke="currentColor" stroke-width="1" stroke-dasharray="3 2" vector-effect="non-scaling-stroke"/><path d="M${n/2} 0V${n}M0 ${n/2}H${n}" fill="none" stroke="currentColor" stroke-width="1" vector-effect="non-scaling-stroke"/></svg>`;
 return ['outline','filled'].map(a=>`<div class="pair-member"><div class="vector-frame" data-appearance="${a}" style="width:${n*z}px;height:${n*z}px">${icon(name,a,n,n*z)}${overlay}</div><small>${a.toUpperCase()}</small></div>`).join('');
}
function usageFor(name,n) {
 const meta=INDEX[name], ref=meta.review.usageRestriction;
 if(!ref) return meta.review.usage;
 const record=DATA.restrictions[ref];
 const required=['outline','filled'].filter(a=>record.sizes[n][a].visibleLabelRequired);
 return `Visible text label required for ${required.join(' and ')} at ${n} px, including scaled uses of this master. A tooltip or accessible name alone does not replace the visible label.`;
}
let proofGeneration=0, proofFrame=0, alignFrame=0, proofDpr=0;
function alignNativeProof() {
 if(!dialog.open) return;
 const dpr=window.devicePixelRatio||1;
 $$('#native-proof canvas').forEach(canvas=>{
   canvas.style.transform='none';
   const rect=canvas.getBoundingClientRect();
   const dx=Math.round(rect.left*dpr)/dpr-rect.left;
   const dy=Math.round(rect.top*dpr)/dpr-rect.top;
   canvas.style.transform=`translate(${dx}px,${dy}px)`;
 });
}
function scheduleAlignment() {
 cancelAnimationFrame(alignFrame);
 alignFrame=requestAnimationFrame(()=>{
   if(proofDpr!==(window.devicePixelRatio||1)) scheduleNativeProof();
   else alignNativeProof();
 });
}
function scheduleNativeProof() {
 cancelAnimationFrame(proofFrame);
 proofFrame=requestAnimationFrame(renderNativeProof);
}
async function renderNativeProof() {
 if(!dialog.open) return;
 const generation=++proofGeneration;
 const n=+$('#inspect-size').value, dpr=window.devicePixelRatio||1;
 const pixels=Math.round(n*dpr), name=selected;
 proofDpr=dpr;
 const canvases=$$('#native-proof canvas');
 $('#native-proof-note').textContent=`${n} CSS px · ${pixels} device pixels at ${dpr}× density. No inspection grid is applied to this raster.`;
 try {
   await Promise.all(canvases.map(async canvas=>{
     canvas.dataset.ready='false'; canvas.width=pixels; canvas.height=pixels;
     canvas.style.width=n+'px';canvas.style.height=n+'px';
     const appearance=canvas.dataset.appearance;
     const fg=getComputedStyle(canvas).color;
     // Rasterize the exact exported SVG path at the device resolution, not a
     // reduced image of the enlarged preview. No image smoothing at 1:1 copy.
     const text=exported(name,appearance,n).replace(`width="${n}" height="${n}"`,`width="${pixels}" height="${pixels}"`).replace('fill="currentColor"',`fill="${fg}"`);
     const url=URL.createObjectURL(new Blob([text],{type:'image/svg+xml'}));
     try {
       const image=new Image();
       await new Promise((resolve,reject)=>{image.onload=resolve;image.onerror=()=>reject(new Error('Native SVG raster could not load'));image.src=url;});
       if(generation!==proofGeneration||!canvas.isConnected) return;
       const ctx=canvas.getContext('2d'); if(!ctx) throw new Error('Canvas 2D unavailable');
       ctx.clearRect(0,0,pixels,pixels);ctx.drawImage(image,0,0,pixels,pixels);
       canvas.dataset.ready='true';canvas.dataset.icon=name;canvas.dataset.master=String(n);canvas.dataset.dpr=String(dpr);
     } finally {URL.revokeObjectURL(url);}
   }));
   alignNativeProof();
 } catch(error) {
   if(generation===proofGeneration) $('#native-proof-note').textContent='Native raster unavailable. Use the exported SVG and a native-size browser proof; no raster validation is implied.';
 }
}
window.addEventListener('resize',scheduleAlignment);
document.addEventListener('scroll',scheduleAlignment,true);
window.visualViewport?.addEventListener('resize',scheduleAlignment);
window.visualViewport?.addEventListener('scroll',scheduleAlignment);
window.matchMedia('(forced-colors: active)').addEventListener('change',scheduleNativeProof);
window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change',scheduleNativeProof);
const dialog=$('#inspector');
dialog.addEventListener('close',()=>{proofGeneration++;cancelAnimationFrame(proofFrame);});let selected='sliders';let activeAppearance='outline';
function updateInspector(){
 const n=+$('#inspect-size').value,z=+$('#inspect-zoom').value,m=INDEX[selected];
 $('#inspect-title').textContent=m.label;$('#inspect-code-name').textContent=`angular / ${selected}`;
 $('#inspect-stage').dataset.theme=$('#theme').value;
 $('#native-proof').dataset.theme=$('#theme').value;
 $('#inspect-pair').innerHTML=geometryPair(selected,n,z);
 $('#native-proof-pair').innerHTML=['outline','filled'].map(a=>`<div class="native-member"><canvas data-appearance="${a}" role="img" aria-label="${escapeXML(m.label)} ${a}, ${n} pixel native raster"></canvas><small>${a.toUpperCase()}</small></div>`).join('');
 scheduleNativeProof();
 $('#inspect-note').textContent=m.review.note;
 $('#inspect-usage').textContent=usageFor(selected,n);
 $('#inspect-meta').textContent=`${m.pairModel==='weight'?'Regular/heavier open symbol':'Matched outline/filled object'} · ${n} px native · ${z}× vector view · 1 native unit = ${z} CSS px · ${m.stage==='baseline'?'Preserved baseline':'New pilot drawing'}`;
 $('#code').value=exported(selected,activeAppearance,n);$('#copy-status').textContent='';
 $('#code-appearance').value=activeAppearance;
}
$$('.icon-card').forEach(b=>b.addEventListener('click',()=>{selected=b.dataset.icon;updateInspector();dialog.showModal();$('#inspect-close').focus();scheduleNativeProof();}));
$('#inspect-close').addEventListener('click',()=>dialog.close());
$('#inspect-size').addEventListener('change',updateInspector);$('#inspect-zoom').addEventListener('change',updateInspector);
$('#code-appearance').addEventListener('change',()=>{activeAppearance=$('#code-appearance').value;updateInspector();});
$('#inspect-grid').addEventListener('click',e=>{const b=e.currentTarget,v=b.getAttribute('aria-pressed')!=='true';b.setAttribute('aria-pressed',v);$('#inspect-stage').classList.toggle('grid-on',v);});
$$('[data-download]').forEach(b=>b.addEventListener('click',()=>{const a=b.dataset.download,n=+$('#inspect-size').value;const blob=new Blob([exported(selected,a,n)],{type:'image/svg+xml'});const url=URL.createObjectURL(blob);const link=document.createElement('a');link.href=url;link.download=`${selected}-${a}-${n}.svg`;document.body.appendChild(link);link.click();link.remove();setTimeout(()=>URL.revokeObjectURL(url),1500);}));
$('#copy-svg').addEventListener('click',async()=>{try{if(!navigator.clipboard)throw new Error('Clipboard unavailable');await navigator.clipboard.writeText($('#code').value);$('#copy-status').textContent='SVG copied.';}catch{ $('#code').focus();$('#code').select();$('#copy-status').textContent='Select the highlighted code and copy it with your system shortcut.'; }});
$('#expand-notes').addEventListener('click',e=>{const b=e.currentTarget,v=b.getAttribute('aria-expanded')!=='true';b.setAttribute('aria-expanded',v);$$('.review-notes details').forEach(d=>d.open=v);b.textContent=v?'Collapse review notes':'Expand review notes';});
window.VectorUIPilot=Object.freeze({ids:Object.keys(INDEX),masterFor,exported,usageFor});
window.__ICON_GUIDE_READY__=true;

})();
