import React from 'react';
import {createRoot} from 'react-dom/client';
import {flushSync} from 'react-dom';
import {Breadcrumbs} from '@heroui/react';
import './breadcrumbs.css';

const root = createRoot(document.getElementById('root'));
const items = [
  {id: 'home', label: 'Home'},
  {id: 'library', label: 'Library'},
  {id: 'book', label: 'Book'},
];

function render({direction = 'ltr', mode = 'light'}) {
  document.documentElement.className = mode === 'dark' ? 'dark' : '';
  document.documentElement.dir = direction;
  flushSync(() => root.render(
    <div id="fixture">
      <Breadcrumbs key={`${mode}-${direction}`} aria-label="Location">
        {items.map(item => (
          <Breadcrumbs.Item key={item.id} id={item.id} href={`#${item.id}`}>
            {item.label}
          </Breadcrumbs.Item>
        ))}
      </Breadcrumbs>
    </div>,
  ));
}

const rect = el => el.getBoundingClientRect().toJSON();

function snapshotItem(el) {
  const link = el.querySelector('[data-slot=link]');
  const style = getComputedStyle(link);
  const separator = el.querySelector('[data-slot=breadcrumbs-separator]');
  return {
    text: link.textContent,
    rect: rect(el),
    linkRect: rect(link),
    color: style.color,
    opacity: style.opacity,
    fontSize: style.fontSize,
    fontWeight: style.fontWeight,
    lineHeight: style.lineHeight,
    decoration: style.textDecorationLine,
    outline: style.outline,
    separator: separator
      ? {rect: rect(separator), transform: getComputedStyle(separator).transform}
      : null,
  };
}

window.breadcrumbsFixture = {
  mount(props = {}) {
    render(props);
  },
  snapshot() {
    const nav = document.querySelector('[data-slot=breadcrumbs]');
    return {
      root: {tag: nav.tagName, rect: rect(nav), gap: getComputedStyle(nav).gap},
      items: [...document.querySelectorAll('[data-slot=breadcrumbs-item]')].map(snapshotItem),
    };
  },
};
window.breadcrumbsFixture.mount();
