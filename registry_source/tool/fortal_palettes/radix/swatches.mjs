const escape = value => value.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

/** Documentation swatches share the exact source snapshot, not copied colors. */
export function renderSwatches({ source, pairs, scales }) {
  const svg = [
    '<svg xmlns="http://www.w3.org/2000/svg" width="1120" height="1040" viewBox="0 0 1120 1040" role="img" aria-labelledby="title desc">',
    '<title id="title">Fortal theme accent and neutral swatches</title>',
    '<desc id="desc">Seven themes, each showing its twelve-step Radix accent and paired neutral in light and dark mode.</desc>',
    `<metadata>${escape(source.licenseText)}</metadata>`,
    '<rect width="1120" height="1040" fill="#ffffff"/>',
  ];
  const text = (value, x, y, size = 17, fill = '#202020', bold = false) =>
    svg.push(`<text x="${x}" y="${y}" font-family="sans-serif" font-size="${size}" fill="${fill}" font-weight="${bold ? 700 : 400}">${escape(value)}</text>`);
  text('Light', 26, 37, 24, '#202020', true);
  text('Dark', 586, 37, 24, '#202020', true);
  Object.entries(pairs).forEach(([name, pair], index) => {
    ['light', 'dark'].forEach((mode, column) => {
      const x = 16 + column * 560, y = 55 + index * 133;
      const gray = scales[pair.neutral][mode].solid;
      const accent = scales[pair.accent][mode].solid;
      const title = name === 'ceu' ? 'Céu' : name[0].toUpperCase() + name.slice(1);
      svg.push(`<rect x="${x}" y="${y}" width="528" height="121" rx="12" fill="${gray[0]}" stroke="${gray[5]}"/>`);
      text(title, x + 16, y + 28, 22, gray[11], true);
      text(`${pair.accent} + ${pair.neutral}`, x + 178, y + 27, 16, gray[10]);
      [accent, gray].forEach((values, row) => values.forEach((color, step) =>
        svg.push(`<rect x="${x + 16 + step * 41}" y="${y + 42 + row * 33}" width="38" height="26" rx="3" fill="${color}"/>`)));
    });
  });
  text(`Raw sRGB source scales · ${source.package} ${source.version} · Functional component roles are fitted separately.`, 26, 1018, 16);
  svg.push('</svg>');
  return svg.join('\n') + '\n';
}
