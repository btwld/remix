import React, {useState} from 'react';
import {createRoot} from 'react-dom/client';
import {
  Avatar, AvatarGroup, Badge, Separator, Surface, Typography, Heading, Paragraph, Code, Prose,
  Kbd, Skeleton, Spinner, Link, CloseButton, Button, ButtonGroup,
} from '@heroui/react';
import './foundation.css';

const colors = ['default', 'accent', 'success', 'warning', 'danger'];
const sizes = ['sm', 'md', 'lg'];
const variants = ['primary', 'secondary', 'tertiary', 'outline', 'ghost', 'danger', 'danger-soft'];
const keys = [
  'command', 'shift', 'ctrl', 'option', 'enter', 'delete', 'escape', 'tab', 'capslock', 'up', 'right',
  'down', 'left', 'pageup', 'pagedown', 'home', 'end', 'help', 'space', 'fn', 'win', 'alt',
];
const sampleImage = 'data:image/svg+xml,' + encodeURIComponent(
  '<svg xmlns="http://www.w3.org/2000/svg" width="80" height="40">' +
  '<rect width="80" height="40" fill="#126bdf"/><circle cx="40" cy="20" r="16" fill="white"/></svg>');

const tid = value => ({'data-testid': value});

function Section({name, children}) {
  return (
    <section className="reference-section">
      <h2>{name}</h2>
      <div className="reference-grid">{children}</div>
    </section>
  );
}

function App() {
  const [count, setCount] = useState(0);
  const increment = () => setCount(x => x + 1);
  return (
    <main>
      <h1>HeroUI 3.2.6 foundations — actual upstream components</h1>

      <Section name="Avatar">
        {['default', 'soft'].flatMap(variant => colors.flatMap(color => sizes.map(size => (
          <Avatar
            key={`${variant}-${color}-${size}`}
            {...tid(`avatar-${variant}-${color}-${size}`)}
            {...{variant, color, size}}
          >
            <Avatar.Fallback {...tid(`avatar-fallback-${variant}-${color}-${size}`)}>AB</Avatar.Fallback>
          </Avatar>
        ))))}
        <Avatar {...tid('avatar-image')}>
          <Avatar.Image {...tid('avatar-image-content')} src={sampleImage} alt="Example user"/>
          <Avatar.Fallback>Fallback</Avatar.Fallback>
        </Avatar>
        <Avatar {...tid('avatar-failed')}>
          <Avatar.Image src="data:image/png;base64,invalid" alt="Failed user"/>
          <Avatar.Fallback {...tid('avatar-failed-fallback')}>EF</Avatar.Fallback>
        </Avatar>
      </Section>

      <Section name="Avatar groups">
        {['clip', 'ring'].flatMap(overlap => sizes.map(size => (
          <AvatarGroup
            key={`${overlap}-${size}`}
            {...tid(`avatar-group-${overlap}-${size}`)}
            {...{overlap, size}}
            max={2}
            color="accent"
            variant="soft"
          >
            {['AB', 'CD', 'EF', 'GH'].map((label, i) => (
              <Avatar key={label} {...tid(`avatar-group-${overlap}-${size}-${i}`)}>
                <Avatar.Fallback>{label}</Avatar.Fallback>
              </Avatar>
            ))}
          </AvatarGroup>
        )))}
        <AvatarGroup {...tid('avatar-group-grid')} isGrid max={2}>
          {['AB', 'CD', 'EF'].map(label => (
            <Avatar key={label}>
              <Avatar.Fallback>{label}</Avatar.Fallback>
            </Avatar>
          ))}
        </AvatarGroup>
        <AvatarGroup {...tid('avatar-group-explicit-count')} max={1}>
          <Avatar><Avatar.Fallback>AB</Avatar.Fallback></Avatar>
          <Avatar><Avatar.Fallback>CD</Avatar.Fallback></Avatar>
          <AvatarGroup.Count>More</AvatarGroup.Count>
        </AvatarGroup>
        <AvatarGroup {...tid('avatar-group-overrides')} size="lg" color="danger">
          <Avatar size="sm" color="success" {...tid('avatar-group-override-child')}>
            <Avatar.Fallback>AB</Avatar.Fallback>
          </Avatar>
          <div>
            <Avatar {...tid('avatar-group-nested-child')}>
              <Avatar.Fallback>CD</Avatar.Fallback>
            </Avatar>
          </div>
        </AvatarGroup>
      </Section>

      <Section name="Badge">
        {['primary', 'secondary', 'soft'].flatMap(variant => colors.flatMap(color => sizes.map(size => (
          <Badge
            key={`${variant}-${color}-${size}`}
            {...tid(`badge-${variant}-${color}-${size}`)}
            {...{variant, color, size}}
          >
            9
          </Badge>
        ))))}
        {['top-left', 'top-right', 'bottom-left', 'bottom-right'].map(placement => (
          <Badge.Anchor key={placement} {...tid(`badge-anchor-${placement}`)}>
            <span style={{display: 'block', width: 48, height: 48, background: 'var(--default)'}}>AB</span>
            <Badge {...tid(`badge-anchored-${placement}`)} placement={placement} color="danger">9</Badge>
          </Badge.Anchor>
        ))}
      </Section>

      <Section name="Surface and separators">
        {['default', 'secondary', 'tertiary', 'transparent'].map(variant => (
          <Surface key={variant} variant={variant} className="surface-probe" {...tid(`surface-${variant}`)}>
            <span {...tid(`surface-text-${variant}`)}>Inherited text</span>
          </Surface>
        ))}
        {['horizontal', 'vertical'].flatMap(orientation => ['default', 'secondary', 'tertiary'].map(variant => (
          <div className="separator-probe" key={`${orientation}-${variant}`}>
            <Separator {...{orientation, variant}} {...tid(`separator-${orientation}-${variant}`)}/>
          </div>
        )))}
      </Section>

      <Section name="Typography">
        {['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'body', 'body-sm', 'body-xs', 'code'].map(type => (
          <Typography key={type} type={type} {...tid(`typography-${type}`)}>Sample text</Typography>
        ))}
        {['normal', 'medium', 'semibold', 'bold'].map(weight => (
          <Typography key={weight} weight={weight} {...tid(`typography-weight-${weight}`)}>Weight</Typography>
        ))}
        {['start', 'center', 'end', 'justify'].map(align => (
          <Typography key={align} align={align} style={{width: 160}} {...tid(`typography-align-${align}`)}>
            Alignment
          </Typography>
        ))}
        <Typography color="muted" {...tid('typography-muted')}>Muted</Typography>
        <Typography truncate style={{width: 80}} {...tid('typography-truncate')}>
          A long truncated text value
        </Typography>
        <Heading level={2} {...tid('heading-2')}>Heading</Heading>
        <Paragraph size="sm" {...tid('paragraph-sm')}>Paragraph</Paragraph>
        <Code {...tid('code')}>print()</Code>
        <Prose {...tid('prose')}>
          <h1 {...tid('prose-heading')}>Heading</h1>
          <p {...tid('prose-paragraph')}>
            Paragraph <a href="#" {...tid('prose-link')}>Link</a> <code {...tid('prose-code')}>code</code>
          </p>
          <ul {...tid('prose-list')}>
            <li>One</li>
            <li>Two</li>
          </ul>
          <blockquote {...tid('prose-quote')}>Quote</blockquote>
          <hr {...tid('prose-separator')}/>
        </Prose>
      </Section>

      <Section name="Keyboard">
        {keys.map(keyValue => (
          <Kbd key={keyValue} {...tid(`kbd-${keyValue}`)}>
            <Kbd.Abbr keyValue={keyValue} {...tid(`kbd-abbr-${keyValue}`)}/>
            <Kbd.Content>K</Kbd.Content>
          </Kbd>
        ))}
        <Kbd variant="light" {...tid('kbd-light')}>
          <Kbd.Abbr keyValue="command"/>
          <Kbd.Content>K</Kbd.Content>
        </Kbd>
      </Section>

      <Section name="Loading">
        {['shimmer', 'pulse', 'none'].map(animationType => (
          <Skeleton
            key={animationType}
            animationType={animationType}
            style={{width: 120, height: 24}}
            {...tid(`skeleton-${animationType}`)}
          />
        ))}
        <Skeleton {...tid('skeleton-nested')} style={{width: 120, height: 48}}>
          <Skeleton {...tid('skeleton-nested-child')} style={{width: 80, height: 24}}/>
        </Skeleton>
        {['accent', 'current', 'danger', 'success', 'warning'].flatMap(color => ['sm', 'md', 'lg', 'xl'].map(size => (
          <Spinner key={`${color}-${size}`} {...{color, size}} {...tid(`spinner-${color}-${size}`)}/>
        )))}
      </Section>

      <Section name="Links and close buttons">
        <Link href="#target" {...tid('link')} onPress={increment}>
          Open<Link.Icon {...tid('link-icon')}/>
        </Link>
        <Link href="#target" isDisabled {...tid('link-disabled')} onPress={increment}>Disabled</Link>
        <CloseButton {...tid('close-button')} onPress={increment}/>
        <CloseButton {...tid('close-button-disabled')} isDisabled onPress={increment}/>
        <CloseButton {...tid('close-button-pending')} isPending onPress={increment}/>
        <output {...tid('activation-count')}>{count}</output>
      </Section>

      <Section name="Button groups">
        {variants.flatMap(variant => sizes.flatMap(size => ['horizontal', 'vertical'].map(orientation => {
          const id = `button-group-${variant}-${size}-${orientation}`;
          return (
            <ButtonGroup key={id} {...{variant, size, orientation}} {...tid(id)}>
              <Button {...tid(`${id}-first`)}>First</Button>
              <ButtonGroup.Separator {...tid(`${id}-separator`)}/>
              <Button {...tid(`${id}-last`)}>Last</Button>
            </ButtonGroup>
          );
        })))}
        <ButtonGroup {...tid('button-group-disabled')} isDisabled size="lg" variant="danger">
          <Button {...tid('button-group-inherited-disabled')}>Disabled</Button>
          <Button isDisabled={false} size="sm" variant="secondary" {...tid('button-group-explicit-override')}>
            Enabled
          </Button>
          <div>
            <Button {...tid('button-group-nested')}>Nested</Button>
          </div>
        </ButtonGroup>
        <ButtonGroup fullWidth {...tid('button-group-fullwidth')} style={{width: 280}}>
          <Button {...tid('button-group-fullwidth-first')}>First</Button>
          <Button {...tid('button-group-fullwidth-last')}>Last</Button>
        </ButtonGroup>
      </Section>
    </main>
  );
}

createRoot(document.getElementById('root')).render(<App/>);
