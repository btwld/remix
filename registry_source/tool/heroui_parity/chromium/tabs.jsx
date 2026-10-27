import React from 'react';
import {createRoot} from 'react-dom/client';
import {flushSync} from 'react-dom';
import {Tabs} from '@heroui/react';
import './tabs.css';

const root = createRoot(document.getElementById('root'));
let props = {};
let events = [];
let epoch = 0;
const labels = {one: 'One', two: 'Two', three: 'Three'};
const panels = {one: 'First content', two: 'Second content', three: 'Third content'};

function render() {
  const {items = ['one', 'two', 'three'], ...tabsProps} = props;
  flushSync(() => root.render(
    <Tabs key={epoch} {...tabsProps} onSelectionChange={key => events.push(key)}>
      <Tabs.ListContainer>
        <Tabs.List aria-label="Settings">
          {items.map(id => (
            <Tabs.Tab key={id} id={id} isDisabled={id === 'two'}>
              {labels[id]}
              <Tabs.Indicator/>
            </Tabs.Tab>
          ))}
        </Tabs.List>
      </Tabs.ListContainer>
      {items.map(id => <Tabs.Panel key={id} id={id}>{panels[id]}</Tabs.Panel>)}
    </Tabs>,
  ));
}

window.tabsFixture = {
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
      tabs: [...document.querySelectorAll('[role=tab]')].map(el => ({
        id: el.textContent,
        selected: el.getAttribute('aria-selected'),
        disabled: el.getAttribute('aria-disabled'),
        tabIndex: el.tabIndex,
        focused: el === document.activeElement,
      })),
      panels: [...document.querySelectorAll('[role=tabpanel]')].map(el => ({
        text: el.textContent,
        hidden: el.hidden,
      })),
    };
  },
};
window.tabsFixture.mount();
