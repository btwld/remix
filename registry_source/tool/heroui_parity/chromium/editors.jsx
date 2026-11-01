import React, {useState} from 'react';
import {createRoot} from 'react-dom/client';
import {InputGroup, TextArea, SearchField, Label, Description, FieldError} from '@heroui/react';
import './editors.css';

const tid = id => ({'data-testid': id});
const states = ['rest', 'disabled', 'readonly', 'invalid'];

function SearchParts({id}) {
  return (
    <>
      <Label>Search</Label>
      <SearchField.Group {...tid(`${id}-group`)}>
        <SearchField.SearchIcon {...tid(`${id}-icon`)}/>
        <SearchField.Input {...tid(`${id}-input`)}/>
        <SearchField.ClearButton {...tid(`${id}-clear`)}/>
      </SearchField.Group>
      <Description {...tid(`${id}-description`)}>Search help</Description>
      <FieldError {...tid(`${id}-error`)}>Error</FieldError>
    </>
  );
}

function App() {
  const [value, setValue] = useState('Find');
  const [submitted, setSubmitted] = useState('');
  const [clears, setClears] = useState(0);
  return (
    <main>
      <h1>Actual HeroUI 3.2.6 editors</h1>

      <section className="matrix">
        {['primary', 'secondary'].flatMap(variant => [false, true].flatMap(fullWidth => states.map(state => {
          const id = `textarea-${variant}-${fullWidth ? 'full' : 'intrinsic'}-${state}`;
          return (
            <div className="bounded" key={id}>
              <TextArea
                {...tid(id)}
                {...{variant, fullWidth}}
                disabled={state === 'disabled'}
                readOnly={state === 'readonly'}
                aria-invalid={state === 'invalid'}
                aria-label="Notes"
                defaultValue="First line"
              />
            </div>
          );
        })))}
      </section>

      <section className="matrix">
        {['primary', 'secondary'].flatMap(variant => [false, true].flatMap(fullWidth => (
          ['input', 'textarea'].map(type => {
            const id = `input-group-${variant}-${fullWidth ? 'full' : 'intrinsic'}-${type}`;
            const Editor = type === 'input' ? InputGroup.Input : InputGroup.TextArea;
            return (
              <div className="bounded" key={id}>
                <InputGroup {...tid(id)} {...{variant, fullWidth}}>
                  <InputGroup.Prefix {...tid(`${id}-prefix`)}>$</InputGroup.Prefix>
                  <Editor {...tid(`${id}-input`)} aria-label="Amount" defaultValue="123"/>
                  <InputGroup.Suffix {...tid(`${id}-suffix`)}>USD</InputGroup.Suffix>
                </InputGroup>
              </div>
            );
          })
        )))}
      </section>

      <section className="matrix">
        {['primary', 'secondary'].flatMap(variant => [false, true].flatMap(fullWidth => states.map(state => {
          const id = `search-${variant}-${fullWidth ? 'full' : 'intrinsic'}-${state}`;
          return (
            <div className="bounded" key={id}>
              <SearchField
                {...tid(id)}
                {...{variant, fullWidth}}
                isDisabled={state === 'disabled'}
                isReadOnly={state === 'readonly'}
                isInvalid={state === 'invalid'}
                defaultValue="Find"
              >
                <SearchParts id={id}/>
              </SearchField>
            </div>
          );
        })))}
      </section>

      <SearchField
        {...tid('interactive-search')}
        value={value}
        onChange={setValue}
        onSubmit={setSubmitted}
        onClear={() => setClears(c => c + 1)}
      >
        <SearchParts id="interactive-search"/>
      </SearchField>
      <output {...tid('state')}>{JSON.stringify({value, submitted, clears})}</output>
    </main>
  );
}

createRoot(document.getElementById('root')).render(<App/>);
