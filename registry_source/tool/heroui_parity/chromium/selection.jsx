import React, {useState} from 'react';
import {createRoot} from 'react-dom/client';
import {
  Checkbox, CheckboxGroup, Radio, RadioGroup, Switch, SwitchGroup, Label, Description, FieldError,
} from '@heroui/react';
import './selection.css';

const tid = id => ({'data-testid': id});
const states = [
  'rest', 'selected', 'mixed', 'disabled', 'disabled-selected', 'invalid', 'invalid-selected',
  'readonly', 'required',
];

/** Checkbox and Switch props for one of the `states`. */
function props(state) {
  return {
    defaultSelected: state.includes('selected'),
    isIndeterminate: state === 'mixed',
    isDisabled: state.startsWith('disabled'),
    isInvalid: state.startsWith('invalid'),
    isReadOnly: state === 'readonly',
    isRequired: state === 'required',
  };
}

function CheckParts({id, label = 'Checkbox'}) {
  return (
    <>
      <Checkbox.Content {...tid(`${id}-content`)}>
        <Checkbox.Control {...tid(`${id}-control`)}>
          <Checkbox.Indicator {...tid(`${id}-indicator`)}/>
        </Checkbox.Control>
        <Label {...tid(`${id}-label`)}>{label}</Label>
      </Checkbox.Content>
      <Description {...tid(`${id}-description`)}>Help text</Description>
      <FieldError {...tid(`${id}-error`)}>Invalid selection</FieldError>
    </>
  );
}

function SwitchParts({id}) {
  return (
    <>
      <Switch.Content {...tid(`${id}-content`)}>
        <Switch.Control {...tid(`${id}-control`)}>
          <Switch.Thumb {...tid(`${id}-thumb`)}>
            <Switch.Icon {...tid(`${id}-icon`)}>+</Switch.Icon>
          </Switch.Thumb>
        </Switch.Control>
        <Label {...tid(`${id}-label`)}>Switch</Label>
      </Switch.Content>
      <Description {...tid(`${id}-description`)}>Help text</Description>
      <FieldError {...tid(`${id}-error`)}>Invalid selection</FieldError>
    </>
  );
}

function RadioParts({id, label = 'Radio'}) {
  return (
    <>
      <Radio.Content {...tid(`${id}-content`)}>
        <Radio.Control {...tid(`${id}-control`)}>
          <Radio.Indicator {...tid(`${id}-indicator`)}/>
        </Radio.Control>
        <Label {...tid(`${id}-label`)}>{label}</Label>
      </Radio.Content>
      <Description {...tid(`${id}-description`)}>Help text</Description>
    </>
  );
}

function App() {
  const [check, setCheck] = useState(false);
  const [mixed, setMixed] = useState(false);
  const [toggle, setToggle] = useState(false);
  return (
    <main>
      <h1>Actual HeroUI 3.2.6 selection contracts</h1>

      <section className="matrix">
        {['primary', 'secondary'].flatMap(variant => states.map(state => {
          const id = `checkbox-${variant}-${state}`;
          return (
            <Checkbox key={id} className="field-probe" variant={variant} {...props(state)} {...tid(id)}>
              <CheckParts id={id}/>
            </Checkbox>
          );
        }))}
      </section>

      <section className="matrix">
        {['sm', 'md', 'lg'].flatMap(size => states.filter(s => s !== 'mixed').map(state => {
          const id = `switch-${size}-${state}`;
          return (
            <Switch key={id} className="field-probe" size={size} {...props(state)} {...tid(id)}>
              <SwitchParts id={id}/>
            </Switch>
          );
        }))}
      </section>

      <section className="matrix">
        {['primary', 'secondary'].flatMap(variant => ['horizontal', 'vertical'].flatMap(orientation => (
          ['rest', 'disabled', 'invalid', 'readonly', 'required'].map(state => {
            const id = `radio-${variant}-${orientation}-${state}`;
            return (
              <RadioGroup
                key={id}
                {...tid(id)}
                variant={variant}
                orientation={orientation}
                defaultValue="a"
                isDisabled={state === 'disabled'}
                isInvalid={state === 'invalid'}
                isReadOnly={state === 'readonly'}
                isRequired={state === 'required'}
              >
                <Label>Choose radio</Label>
                {['a', 'b', 'c'].map(value => (
                  <Radio key={value} value={value} {...tid(`${id}-${value}`)}>
                    <RadioParts id={`${id}-${value}`}/>
                  </Radio>
                ))}
                <Description>Group help</Description>
                <FieldError>Required</FieldError>
              </RadioGroup>
            );
          })
        )))}
      </section>

      <section>
        {['primary', 'secondary'].map(variant => (
          <CheckboxGroup key={variant} {...tid(`checkbox-group-${variant}`)} variant={variant} defaultValue={['a']}>
            <Label>Choose boxes</Label>
            {['a', 'b'].map(value => (
              <div key={value}>
                <Checkbox value={value} {...tid(`checkbox-group-${variant}-${value}`)}>
                  <CheckParts id={`checkbox-group-${variant}-${value}`}/>
                </Checkbox>
              </div>
            ))}
            <Description>Group help</Description>
          </CheckboxGroup>
        ))}
      </section>

      <section>
        {['horizontal', 'vertical'].map(orientation => (
          <SwitchGroup key={orientation} orientation={orientation} {...tid(`switch-group-${orientation}`)}>
            <Label>Switches</Label>
            {['a', 'b'].map(value => (
              <Switch key={value} {...tid(`switch-group-${orientation}-${value}`)}>
                <SwitchParts id={`switch-group-${orientation}-${value}`}/>
              </Switch>
            ))}
          </SwitchGroup>
        ))}
      </section>

      <section>
        <Checkbox {...tid('interactive-checkbox')} isSelected={check} onChange={setCheck}>
          <CheckParts id="interactive-checkbox"/>
        </Checkbox>
        <Checkbox {...tid('interactive-mixed')} isSelected={mixed} isIndeterminate onChange={setMixed}>
          <CheckParts id="interactive-mixed"/>
        </Checkbox>
        <Switch {...tid('interactive-switch')} isSelected={toggle} onChange={setToggle}>
          <SwitchParts id="interactive-switch"/>
        </Switch>
        <output {...tid('state')}>{JSON.stringify({check, mixed, toggle})}</output>
      </section>
    </main>
  );
}

createRoot(document.getElementById('root')).render(<App/>);
