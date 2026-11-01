import React from 'react';
import {createRoot} from 'react-dom/client';
import {Accordion, Alert, Button, Checkbox, Disclosure, Label, Meter, Modal,
  ProgressBar, Slider, Table, Toast, toast, Tooltip} from '@heroui/react';
import './families2.css';

const statuses = ['default', 'accent', 'success', 'warning', 'danger'];
const sizes = ['sm', 'md', 'lg'];
const bodyText = 'Modal body copy.';
const longText = Array.from({length: 48}, (_, i) => `Paragraph ${i + 1} fills the dialog so scrolling engages.`);

function Icon() {
  return <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" aria-hidden="true"><path d="m5 12 4 4L19 6" strokeWidth="2"/></svg>;
}

// ---- Tooltip -------------------------------------------------------------

const tooltipCases = [
  {id: 'default'},
  {id: 'top', placement: 'top'},
  {id: 'bottom', placement: 'bottom'},
  {id: 'left', placement: 'left'},
  {id: 'right', placement: 'right'},
  {id: 'arrow', placement: 'top', arrow: true},
  {id: 'long', placement: 'top', text: 'A long tooltip sentence that keeps going well past the three hundred twenty pixel limit so it has to wrap onto several lines.'},
];

function TooltipCase({id, placement, arrow, text = 'Tooltip text'}) {
  return <div data-case={`tooltip-${id}`}>
    <Tooltip delay={0} closeDelay={0}>
      <Button variant="secondary">Hover me</Button>
      <Tooltip.Content placement={placement} showArrow={arrow}>
        {arrow ? <Tooltip.Arrow/> : null}
        <p>{text}</p>
      </Tooltip.Content>
    </Tooltip>
  </div>;
}

// ---- Modal ---------------------------------------------------------------

const modalCases = [
  ...['xs', 'sm', 'md', 'lg', 'cover', 'full'].map(size => ({id: `${size}-auto`, size})),
  ...['center', 'top', 'bottom'].map(placement => ({id: `md-${placement}`, size: 'md', placement})),
  {id: 'md-icon', size: 'md', icon: true},
  {id: 'scroll-inside', size: 'md', scroll: 'inside', tall: true},
  {id: 'scroll-outside', size: 'md', scroll: 'outside', tall: true},
  {id: 'backdrop-blur', size: 'md', variant: 'blur'},
  {id: 'backdrop-transparent', size: 'md', variant: 'transparent'},
];

function ModalCase({id, size, placement, scroll, variant, icon, tall}) {
  return <Modal>
    <Button variant="secondary" data-modal-trigger={id}>{id}</Button>
    <Modal.Backdrop variant={variant} data-case={`modal-${id}`}>
      <Modal.Container size={size} placement={placement} scroll={scroll}>
        <Modal.Dialog>
          <Modal.CloseTrigger/>
          <Modal.Header>
            {icon ? <Modal.Icon className="bg-accent-soft text-accent-soft-foreground"><Icon/></Modal.Icon> : null}
            <Modal.Heading>Modal heading</Modal.Heading>
          </Modal.Header>
          <Modal.Body>{tall ? longText.map(line => <p key={line}>{line}</p>) : <p>{bodyText}</p>}</Modal.Body>
          <Modal.Footer>
            <Button slot="close" variant="secondary">Cancel</Button>
            <Button slot="close">Continue</Button>
          </Modal.Footer>
        </Modal.Dialog>
      </Modal.Container>
    </Modal.Backdrop>
  </Modal>;
}

// ---- Accordion and disclosure -------------------------------------------

const accordionItems = [
  ['one', 'First question', 'The first answer is expanded.'],
  ['two', 'Second question', 'The second answer.'],
  ['three', 'Third question', 'The third answer.'],
];

function AccordionCase({id, variant, disabledFirst}) {
  return <div className="case" data-case={`accordion-${id}`}>
    <Accordion variant={variant} defaultExpandedKeys={disabledFirst ? [] : ['one']}>
      {accordionItems.map(([key, title, body], index) =>
        <Accordion.Item key={key} id={key} isDisabled={disabledFirst && index === 0}>
          <Accordion.Heading>
            <Accordion.Trigger>{title}<Accordion.Indicator/></Accordion.Trigger>
          </Accordion.Heading>
          <Accordion.Panel><Accordion.Body>{body}</Accordion.Body></Accordion.Panel>
        </Accordion.Item>)}
    </Accordion>
  </div>;
}

function DisclosureCase({id, expanded, disabled, withButton}) {
  return <div className="case" data-case={`disclosure-${id}`}>
    <Disclosure defaultExpanded={expanded} isDisabled={disabled}>
      <Disclosure.Heading>
        {withButton
          ? <Button slot="trigger" variant="secondary">Details<Disclosure.Indicator/></Button>
          : <Disclosure.Trigger>Details<Disclosure.Indicator/></Disclosure.Trigger>}
      </Disclosure.Heading>
      <Disclosure.Content><Disclosure.Body>Hidden details revealed by the trigger.</Disclosure.Body></Disclosure.Content>
    </Disclosure>
  </div>;
}

// ---- Slider ----------------------------------------------------------------

function SliderCase({id, value, labelled = true, disabled}) {
  return <div className="case" data-case={`slider-${id}`}>
    <Slider defaultValue={value} isDisabled={disabled} aria-label="Volume">
      {labelled ? <Label>Volume</Label> : null}
      {labelled ? <Slider.Output/> : null}
      <Slider.Track><Slider.Fill/><Slider.Thumb/></Slider.Track>
    </Slider>
  </div>;
}

// ---- Alert -----------------------------------------------------------------

function AlertCase({status, titleOnly}) {
  return <div className="case" data-case={`alert-${status}${titleOnly ? '-short' : ''}`}>
    <Alert status={status}>
      <Alert.Indicator/>
      <Alert.Content>
        <Alert.Title>Update available</Alert.Title>
        {titleOnly ? null : <Alert.Description>A new version is ready.</Alert.Description>}
      </Alert.Content>
    </Alert>
  </div>;
}

// ---- Progress bar and meter ---------------------------------------------

function ProgressCase({color, size, indeterminate}) {
  const id = `${indeterminate ? 'indeterminate' : color}-${size}`;
  return <div className="case" data-case={`progress-${id}`}>
    <ProgressBar aria-label="Loading" value={indeterminate ? undefined : 60} isIndeterminate={indeterminate} color={color} size={size}>
      <Label>Loading</Label>
      {indeterminate ? null : <ProgressBar.Output/>}
      <ProgressBar.Track><ProgressBar.Fill/></ProgressBar.Track>
    </ProgressBar>
  </div>;
}

function MeterCase({color, size}) {
  return <div className="case" data-case={`meter-${color}-${size}`}>
    <Meter aria-label="Storage" value={60} color={color} size={size}>
      <Label>Storage</Label>
      <Meter.Output/>
      <Meter.Track><Meter.Fill/></Meter.Track>
    </Meter>
  </div>;
}

// ---- Table -------------------------------------------------------------------

const people = [
  ['1', 'Kate Moore', 'Engineer', 'Active'],
  ['2', 'Noah Reyes', 'Designer', 'Paused'],
  ['3', 'Ana Silva', 'Manager', 'Active'],
  ['4', 'Li Wei', 'Analyst', 'Invited'],
];

function TableCase({variant, select}) {
  const id = `${variant}${select ? '-select' : ''}`;
  return <div className="case-wide" data-case={`table-${id}`}>
    <Table variant={variant}>
      <Table.ScrollContainer>
        <Table.Content aria-label="Team" selectionMode={select ? 'multiple' : 'none'}
          defaultSelectedKeys={select ? ['2'] : undefined}
          sortDescriptor={{column: 'name', direction: 'ascending'}}>
          <Table.Header>
            {select ? <Table.Column>
              <Checkbox slot="selection" aria-label="Select all"><Checkbox.Control><Checkbox.Indicator/></Checkbox.Control></Checkbox>
            </Table.Column> : null}
            <Table.Column id="name" isRowHeader allowsSorting>
              {({sortDirection}) => <Table.SortableColumnHeader sortDirection={sortDirection}>Name</Table.SortableColumnHeader>}
            </Table.Column>
            <Table.Column id="role">Role</Table.Column>
            <Table.Column id="status">Status</Table.Column>
          </Table.Header>
          <Table.Body>
            {people.map(([key, name, role, status]) =>
              <Table.Row key={key} id={key}>
                {select ? <Table.Cell>
                  <Checkbox slot="selection" aria-label={`Select ${name}`}><Checkbox.Control><Checkbox.Indicator/></Checkbox.Control></Checkbox>
                </Table.Cell> : null}
                <Table.Cell>{name}</Table.Cell>
                <Table.Cell>{role}</Table.Cell>
                <Table.Cell>{status}</Table.Cell>
              </Table.Row>)}
          </Table.Body>
        </Table.Content>
      </Table.ScrollContainer>
      <Table.Footer>4 members</Table.Footer>
    </Table>
  </div>;
}

// ---- Toast -------------------------------------------------------------------

const toastOptions = {timeout: 0, description: 'Monday at 9:00 AM', actionProps: {children: 'Undo'}};
window.f2 = {
  addToast(kind) {
    if (kind === 'single') return toast('Saved', {timeout: 0});
    return toast(`Toast ${kind}`, {...toastOptions, variant: kind});
  },
  clearToasts() { toast.clear(); },
};

function Section({name, children}) {
  return <section><h2 style={{fontSize: 14, fontWeight: 600, marginBottom: 12}}>{name}</h2>{children}</section>;
}

function App() {
  return <main>
    <Section name="Tooltip"><div className="tooltip-stage">{tooltipCases.map(c => <TooltipCase key={c.id} {...c}/>)}</div></Section>
    <Section name="Modal"><div className="modal-triggers">{modalCases.map(c => <ModalCase key={c.id} {...c}/>)}</div></Section>
    <Section name="Accordion"><div className="case-list">
      <AccordionCase id="default" variant="default"/>
      <AccordionCase id="surface" variant="surface"/>
      <AccordionCase id="disabled" variant="default" disabledFirst/>
    </div></Section>
    <Section name="Disclosure"><div className="case-list">
      <DisclosureCase id="closed"/><DisclosureCase id="open" expanded/>
      <DisclosureCase id="disabled" disabled/>
      <DisclosureCase id="button-closed" withButton/><DisclosureCase id="button-open" withButton expanded/>
    </div></Section>
    <Section name="Slider"><div className="case-list">
      <SliderCase id="min" value={0}/><SliderCase id="mid" value={50}/><SliderCase id="max" value={100}/>
      <SliderCase id="bare" value={50} labelled={false}/><SliderCase id="disabled" value={50} disabled/>
    </div></Section>
    <Section name="Alert"><div className="case-list">
      {statuses.map(status => <AlertCase key={status} status={status}/>)}
      {statuses.map(status => <AlertCase key={`title-${status}`} status={status} titleOnly/>)}
    </div></Section>
    <Section name="Progress"><div className="case-list">
      {statuses.flatMap(color => sizes.map(size => <ProgressCase key={`${color}-${size}`} color={color} size={size}/>))}
      {sizes.map(size => <ProgressCase key={`indeterminate-${size}`} color="accent" size={size} indeterminate/>)}
    </div></Section>
    <Section name="Meter"><div className="case-list">
      {statuses.flatMap(color => sizes.map(size => <MeterCase key={`${color}-${size}`} color={color} size={size}/>))}
    </div></Section>
    <Section name="Table"><div className="case-list" style={{width: '100%'}}>
      <TableCase variant="primary"/><TableCase variant="secondary"/>
      <TableCase variant="primary" select/><TableCase variant="secondary" select/>
    </div></Section>
    <Toast.Provider/>
  </main>;
}

createRoot(document.getElementById('root')).render(<App/>);
