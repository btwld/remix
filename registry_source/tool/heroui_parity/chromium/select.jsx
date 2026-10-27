import React from 'react';
import {createRoot} from 'react-dom/client';
import {flushSync} from 'react-dom';
import {Select, ListBox} from '@heroui/react';
import './select.css';

const root = createRoot(document.getElementById('root'));
let props = {};
let events = [];
let epoch = 0;
const labels = {a: 'Apple', b: 'Banana', c: 'Cherry', d: 'Date'};

function render() {
  const {items = ['a', 'b', 'c', 'd'], clear = false, ...selectProps} = props;
  flushSync(() => root.render(
    <>
      <button id="before">Before</button>
      <Select
        key={epoch}
        aria-label="Fruit"
        placeholder="Choose fruit"
        {...selectProps}
        onChange={value => events.push({type: 'change', value})}
        onOpenChange={value => events.push({type: 'open', value})}
        onClear={() => events.push({type: 'clear'})}
      >
        <Select.Trigger>
          <Select.Value/>
          {clear && <Select.ClearButton/>}
          <Select.Indicator/>
        </Select.Trigger>
        <Select.Popover>
          <ListBox>
            {items.map(id => (
              <ListBox.Item key={id} id={id} textValue={labels[id]}>
                {labels[id]}
                <ListBox.ItemIndicator/>
              </ListBox.Item>
            ))}
          </ListBox>
        </Select.Popover>
      </Select>
      <button id="after">After</button>
    </>,
  ));
}

window.selectFixture = {
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
    const trigger = document.querySelector('[data-slot=select-trigger]');
    return {
      events: [...events],
      activeRole: document.activeElement?.getAttribute('role'),
      activeText: document.activeElement?.textContent,
      trigger: trigger?.textContent,
      expanded: trigger?.getAttribute('aria-expanded'),
      items: [...document.querySelectorAll('[role=option]')].map(el => ({
        text: el.textContent,
        selected: el.getAttribute('aria-selected'),
        disabled: el.getAttribute('aria-disabled'),
        focused: el === document.activeElement,
      })),
    };
  },
};
window.selectFixture.mount();
