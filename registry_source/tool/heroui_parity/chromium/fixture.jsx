import React, {useState} from 'react';
import {createRoot} from 'react-dom/client';
import {Button, Chip, Card, TextField, Input, Label, Description, FieldError, Popover} from '@heroui/react';
import './fixture.css';

const variants = ['primary', 'secondary', 'tertiary', 'outline', 'ghost', 'danger', 'danger-soft'];
const sizes = ['sm', 'md', 'lg'];
const chipVariants = ['primary', 'secondary', 'soft', 'tertiary'];
const colors = ['default', 'accent', 'success', 'warning', 'danger'];

function Icon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" aria-hidden="true">
      <path d="m5 12 4 4L19 6" strokeWidth="2"/>
    </svg>
  );
}

function Fixture() {
  const [presses, setPresses] = useState(0);
  const press = () => setPresses(n => n + 1);
  return (
    <main>
      <h1>HeroUI 3.2.6 · upstream web reference</h1>

      <section>
        <h2>Buttons</h2>
        <div className="reference-grid">
          {variants.flatMap(variant => sizes.map(size => (
            <Button key={`${variant}-${size}`} data-testid={`button-${variant}-${size}`} variant={variant} size={size}>
              Continue
            </Button>
          )))}
          <Button data-testid="button-icon" isIconOnly aria-label="Confirm"><Icon/></Button>
          <Button data-testid="button-leading">
            <Icon/>
            Continue
          </Button>
          <Button data-testid="button-disabled" isDisabled>Disabled</Button>
          <Button data-testid="button-pending" isPending onPress={press}>Pending</Button>
          <Button data-testid="button-counter" onPress={press}>Count {presses}</Button>
        </div>
      </section>

      <section>
        <h2>Chips</h2>
        <div className="reference-grid">
          {chipVariants.flatMap(variant => colors.flatMap(color => sizes.map(size => (
            <Chip
              key={`${variant}-${color}-${size}`}
              data-testid={`chip-${variant}-${color}-${size}`}
              variant={variant}
              color={color}
              size={size}
            >
              <Chip.Label>Active</Chip.Label>
            </Chip>
          ))))}
        </div>
      </section>

      <section>
        <h2>Cards</h2>
        <div className="reference-grid">
          {['default', 'secondary', 'tertiary', 'transparent'].map(variant => (
            <Card key={variant} data-testid={`card-${variant}`} variant={variant} className="probe-card">
              <Card.Header>
                <Card.Title>Project details</Card.Title>
                <Card.Description>Source-pinned design system</Card.Description>
              </Card.Header>
              <Card.Content>Application-owned components.</Card.Content>
              <Card.Footer>Updated today</Card.Footer>
            </Card>
          ))}
        </div>
      </section>

      <section>
        <h2>Fields</h2>
        <div className="reference-grid">
          {['primary', 'secondary'].flatMap(variant => ['rest', 'disabled', 'invalid', 'readonly'].map(state => (
            <TextField
              key={`${variant}-${state}`}
              data-testid={`textfield-${variant}-${state}`}
              className="probe-field"
              isDisabled={state === 'disabled'}
              isInvalid={state === 'invalid'}
              isReadOnly={state === 'readonly'}
            >
              <Label>Email</Label>
              <Input data-testid={`input-${variant}-${state}`} variant={variant} placeholder="you@example.com"/>
              <Description>We will not share your email.</Description>
              <FieldError>Enter a valid email.</FieldError>
            </TextField>
          )))}
        </div>
      </section>

      <section>
        <h2>Popover</h2>
        <Popover>
          <Button data-testid="popover-trigger">Open details</Button>
          <Popover.Content data-testid="popover-content" placement="bottom">
            <Popover.Dialog>
              <Popover.Heading>Details</Popover.Heading>
              <p>Theme is preserved in the overlay.</p>
              <Button data-testid="popover-action">Action</Button>
            </Popover.Dialog>
          </Popover.Content>
        </Popover>
      </section>
    </main>
  );
}

createRoot(document.getElementById('root')).render(<Fixture/>);
