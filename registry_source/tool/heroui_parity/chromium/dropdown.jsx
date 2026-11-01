import React from 'react';
import {createRoot} from 'react-dom/client';
import {flushSync} from 'react-dom';
import {Dropdown, Label} from '@heroui/react';
import './dropdown.css';

const root = createRoot(document.getElementById('root'));
let props = {};
let events = [];
let epoch = 0;
const labels = {a: 'Apple', b: 'Banana', c: 'Cherry', d: 'Date'};

function render() {
  const {items = ['a', 'b', 'c', 'd'], menu = {}, itemVariant = 'default', ...triggerProps} = props;
  flushSync(() => root.render(
    <>
      <button id="before">Before</button>
      <Dropdown key={epoch} {...triggerProps} onOpenChange={value => events.push({type: 'open', value})}>
        <Dropdown.Trigger>Actions</Dropdown.Trigger>
        <Dropdown.Popover>
          <Dropdown.Menu
            aria-label="Fruit actions"
            {...menu}
            onAction={key => events.push({type: 'action', key})}
            onSelectionChange={keys => events.push({type: 'selection', keys: keys === 'all' ? 'all' : [...keys]})}
          >
            {items.map(id => (
              <Dropdown.Item key={id} id={id} textValue={labels[id]} variant={itemVariant}>
                <Label>{labels[id]}</Label>
                <Dropdown.ItemIndicator/>
              </Dropdown.Item>
            ))}
          </Dropdown.Menu>
        </Dropdown.Popover>
      </Dropdown>
      <button id="after">After</button>
    </>,
  ));
}

window.dropdownFixture = {
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
      expanded: document.querySelector('[data-slot=dropdown-trigger]')?.getAttribute('aria-expanded'),
      activeRole: document.activeElement?.getAttribute('role'),
      activeText: document.activeElement?.textContent,
      items: [...document.querySelectorAll('[role^=menuitem]')].map(el => ({
        text: el.textContent,
        role: el.getAttribute('role'),
        checked: el.getAttribute('aria-checked'),
        disabled: el.getAttribute('aria-disabled'),
        focused: el === document.activeElement,
      })),
    };
  },
};
window.dropdownFixture.mount();
