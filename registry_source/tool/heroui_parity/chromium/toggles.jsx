import React, {useState} from 'react';
import {createRoot} from 'react-dom/client';
import {ToggleButton, ToggleButtonGroup} from '@heroui/react';
import {I18nProvider} from 'react-aria-components';
import './toggles.css';

const tid = id => ({'data-testid': id});

function App() {
  const [multiple, setMultiple] = useState(new Set(['a']));
  return (
    <main>
      <h1>Actual HeroUI 3.2.6 toggles</h1>

      <section className="matrix">
        {['default', 'ghost'].flatMap(variant => ['sm', 'md', 'lg'].flatMap(size => (
          [false, true].flatMap(isIconOnly => (
            ['rest', 'selected', 'disabled', 'disabled-selected'].map(state => {
              const id = `toggle-${variant}-${size}-${isIconOnly ? 'icon' : 'label'}-${state}`;
              return (
                <ToggleButton
                  key={id}
                  {...tid(id)}
                  {...{variant, size, isIconOnly}}
                  aria-label={id}
                  defaultSelected={state.includes('selected')}
                  isDisabled={state.startsWith('disabled')}
                >
                  {isIconOnly ? '+' : 'Toggle'}
                </ToggleButton>
              );
            })
          ))
        )))}
      </section>

      <section className="matrix">
        {['horizontal', 'vertical'].flatMap(orientation => [false, true].flatMap(isDetached => (
          [false, true].flatMap(fullWidth => ['sm', 'md', 'lg'].map(size => {
            const joint = isDetached ? 'detached' : 'joined';
            const width = fullWidth ? 'full' : 'auto';
            const id = `group-${orientation}-${joint}-${width}-${size}`;
            return (
              <div key={id} className="bounded">
                <ToggleButtonGroup
                  {...tid(id)}
                  {...{orientation, isDetached, fullWidth, size}}
                  defaultSelectedKeys={['a']}
                  selectionMode="multiple"
                  aria-label={id}
                >
                  <ToggleButton id="a" {...tid(`${id}-a`)}>First</ToggleButton>
                  <ToggleButton id="b" {...tid(`${id}-b`)}>
                    <ToggleButtonGroup.Separator {...tid(`${id}-separator`)}/>
                    Last
                  </ToggleButton>
                </ToggleButtonGroup>
              </div>
            );
          }))
        )))}
      </section>

      <ToggleButtonGroup
        {...tid('interactive-group')}
        selectedKeys={multiple}
        onSelectionChange={setMultiple}
        selectionMode="multiple"
        aria-label="Multiple"
      >
        <ToggleButton id="a" {...tid('interactive-a')}>A</ToggleButton>
        <ToggleButton id="b" {...tid('interactive-b')}>B</ToggleButton>
        <ToggleButton id="c" isDisabled {...tid('interactive-c')}>C</ToggleButton>
        <ToggleButton id="d" {...tid('interactive-d')}>D</ToggleButton>
      </ToggleButtonGroup>

      <ToggleButtonGroup
        {...tid('required-group')}
        selectionMode="single"
        disallowEmptySelection
        defaultSelectedKeys={['a']}
        aria-label="Required"
      >
        <ToggleButton id="a" {...tid('required-a')}>Required A</ToggleButton>
        <ToggleButton id="b" {...tid('required-b')}>Required B</ToggleButton>
      </ToggleButtonGroup>

      <ToggleButtonGroup size="sm" isDisabled {...tid('nested-group')} aria-label="Nested">
        <span>
          <ToggleButton id="n" isDisabled={false} {...tid('nested-child')}>Nested</ToggleButton>
        </span>
      </ToggleButtonGroup>

      <output {...tid('state')}>{JSON.stringify([...multiple])}</output>
    </main>
  );
}

// ?rtl switches the react-aria locale to Arabic so group arrow keys reverse.
const locale = new URLSearchParams(location.search).has('rtl') ? 'ar' : 'en-US';
createRoot(document.getElementById('root')).render(
  <I18nProvider locale={locale}>
    <App/>
  </I18nProvider>,
);
