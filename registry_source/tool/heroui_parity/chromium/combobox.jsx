import React from 'react';
import {createRoot} from 'react-dom/client';
import {flushSync} from 'react-dom';
import {ComboBox, Input, Label, ListBox} from '@heroui/react';
import './combobox.css';

const root = createRoot(document.getElementById('root'));
let epoch = 0;
window.comboboxFixture = {
  mount(props = {}) {
    flushSync(() => root.render(
      <ComboBox key={++epoch} allowsCustomValue {...props}>
        <Label>Destination</Label>
        <ComboBox.InputGroup>
          <Input placeholder="Search cities"/>
          <ComboBox.Trigger/>
        </ComboBox.InputGroup>
        <ComboBox.Popover>
          <ListBox>
            {['Apple', 'Apricot', 'Avocado', 'Banana'].map(label => (
              <ListBox.Item key={label} id={label} textValue={label}>{label}</ListBox.Item>
            ))}
          </ListBox>
        </ComboBox.Popover>
      </ComboBox>
    ));
  },
};
window.comboboxFixture.mount();
