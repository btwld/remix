import React from 'react';
import {createRoot} from 'react-dom/client';
import {flushSync} from 'react-dom';
import {Menu, Label} from '@heroui/react';
import './menu.css';

const root = createRoot(document.getElementById('root'));
let props = {};
let events = [];
let epoch = 0;
const labels = {a: 'Apple', b: 'Banana', c: 'Cherry', d: 'Date'};

function render() {
  const {items = ['a', 'b', 'c', 'd'], itemVariant = 'default', ...menuProps} = props;
  flushSync(() => root.render(
    <>
      <button id="before">Before</button>
      <Menu
        key={epoch}
        aria-label="Fruit actions"
        {...menuProps}
        onAction={key => events.push({type: 'action', key})}
        onClose={() => events.push({type: 'close'})}
        onSelectionChange={keys => events.push({type: 'selection', keys: keys === 'all' ? 'all' : [...keys]})}
      >
        {items.map(id => (
          <Menu.Item key={id} id={id} textValue={labels[id]} variant={itemVariant}>
            <Label>{labels[id]}</Label>
            <Menu.ItemIndicator/>
          </Menu.Item>
        ))}
      </Menu>
      <button id="after">After</button>
    </>,
  ));
}

window.menuFixture = {
  mount(next = {}) {
    props = next;
    events = [];
    epoch++;
    render();
  },
  update(next) {
    props = {...props, ...next};
    render();
  },
  snapshot() {
    return {
      events: [...events],
      activeRole: document.activeElement?.getAttribute('role'),
      activeText: document.activeElement?.textContent,
      items: [...document.querySelectorAll('[role^=menuitem]')].map(el => ({
        text: el.textContent,
        role: el.getAttribute('role'),
        checked: el.getAttribute('aria-checked'),
        disabled: el.getAttribute('aria-disabled'),
        tabIndex: el.tabIndex,
        focused: el === document.activeElement,
      })),
    };
  },
};
window.menuFixture.mount();
