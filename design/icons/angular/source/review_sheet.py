"""Render actual SVGs for local optical review, not illustrative artwork."""
import json,sys,io
from pathlib import Path
from PIL import Image, ImageDraw,ImageFont
import cairosvg
ROOT=Path(__file__).resolve().parents[1]
CAT=json.loads((ROOT/'catalog/icons.json').read_text())
FONT='/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'

def sheet(names,out,dark=False):
    W=1280;H=100+len(names)*116
    bg='#101112' if dark else '#f9f7f2'; ink='#f9f7f2' if dark else '#080808'
    im=Image.new('RGB',(W,H),bg);d=ImageDraw.Draw(im)
    d.text((24,20),'ANGULAR / NATIVE OPTICAL DRAWINGS',font=ImageFont.truetype(FONT,20),fill=ink)
    for col,n in enumerate([12,16,24]):d.text((240+col*300,58),f'{n} px / outline + filled / enlarged 4×',font=ImageFont.truetype(FONT,13),fill=ink)
    for row,name in enumerate(names):
        y=98+row*116
        d.line((24,y,W-24,y),fill='#75776e',width=1)
        d.text((24,y+34),name,font=ImageFont.truetype(FONT,17),fill=ink)
        for col,n in enumerate([12,16,24]):
            for j,a in enumerate(['outline','filled']):
                txt=(ROOT/f'generated/angular/{a}/{n}/{name}.svg').read_text().replace('currentColor',ink)
                b=cairosvg.svg2png(bytestring=txt.encode(),output_width=n*4,output_height=n*4)
                pic=Image.open(io.BytesIO(b)); x=240+col*300+j*130
                im.paste(pic,(x,y+(116-n*4)//2),pic)
                b=cairosvg.svg2png(bytestring=txt.encode(),output_width=n,output_height=n)
                pic=Image.open(io.BytesIO(b));im.paste(pic,(x+100,y+52),pic)
    im.save(out)

if __name__=='__main__':
    nd=[i['id'] for i in CAT['icons'] if i['stage']=='pilot-addition']
    for j in range(0,len(nd),8):sheet(nd[j:j+8],ROOT/f'review/new-icons-{j//8+1}.png')
    for j in range(0,48,12):sheet([i['id'] for i in CAT['icons'][j:j+12]],ROOT/f'review/all-icons-{j//12+1}.png')
    sheet(['sliders','gear','filter','info','help','warning','save','bookmark','edit'],ROOT/'review/dense-icons-dark.png',True)
