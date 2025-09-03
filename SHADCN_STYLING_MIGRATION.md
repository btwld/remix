# shadcn/ui Styling Migration Guide

Complete reference for migrating Remix components to shadcn/ui styling patterns.

## Table of Contents

1. [Component Mappings](#component-mappings)
2. [Design System Tokens](#design-system-tokens)
3. [Tailwind Reference Tables](#tailwind-reference-tables)
4. [Component-by-Component Analysis](#component-by-component-analysis)
5. [Migration Steps](#migration-steps)

## Component Mappings

| Remix Component | shadcn/ui Component | GitHub Path | Notes |
|----------------|-------------------|-------------|-------|
| Accordion | Accordion | [accordion.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/accordion.tsx) | Direct mapping |
| Avatar | Avatar | [avatar.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/avatar.tsx) | Direct mapping |
| Badge | Badge | [badge.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/badge.tsx) | Direct mapping |
| Button | Button | [button.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/button.tsx) | Direct mapping |
| Callout | Alert | [alert.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/alert.tsx) | Similar purpose |
| Card | Card | [card.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/card.tsx) | Direct mapping |
| Checkbox | Checkbox | [checkbox.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/checkbox.tsx) | Direct mapping |
| Chip | Badge | [badge.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/badge.tsx) | Use badge variants |
| Divider | Separator | [separator.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/separator.tsx) | Different naming |
| Label | Label | [label.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/label.tsx) | Direct mapping |
| ListItem | Custom | N/A | No direct equivalent |
| Progress | Progress | [progress.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/progress.tsx) | Direct mapping |
| Radio | RadioGroup | [radio-group.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/radio-group.tsx) | Component + group |
| Select | Select | [select.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/select.tsx) | Direct mapping |
| Slider | Slider | [slider.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/slider.tsx) | Direct mapping |
| Spinner | Skeleton | [skeleton.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/skeleton.tsx) | Use skeleton or custom |
| Switch | Switch | [switch.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/switch.tsx) | Direct mapping |
| TextField | Input | [input.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/input.tsx) | Different naming |
| Tooltip | Tooltip | [tooltip.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/tooltip.tsx) | Direct mapping |

## Design System Tokens

### Core Color Tokens (HSL Values)

#### Light Theme
```css
--background: 0 0% 100%                /* Pure white */
--foreground: 240 10% 3.9%             /* Dark gray/black */
--card: 0 0% 100%                      /* White */
--card-foreground: 240 10% 3.9%       /* Dark gray/black */
--popover: 0 0% 100%                   /* White */
--popover-foreground: 240 10% 3.9%    /* Dark gray/black */
--primary: 240 5.9% 10%                /* Very dark blue-gray */
--primary-foreground: 0 0% 98%         /* Off-white */
--secondary: 240 4.8% 95.9%            /* Light gray */
--secondary-foreground: 240 5.9% 10%   /* Dark blue-gray */
--muted: 240 4.8% 95.9%                /* Light gray */
--muted-foreground: 240 3.8% 46.1%     /* Medium gray */
--accent: 240 4.8% 95.9%               /* Light gray */
--accent-foreground: 240 5.9% 10%      /* Dark blue-gray */
--destructive: 0 72.22% 50.59%         /* Red */
--destructive-foreground: 0 0% 98%     /* Off-white */
--border: 240 5.9% 90%                 /* Light border gray */
--input: 240 5.9% 90%                  /* Input border gray */
--ring: 240 5% 64.9%                   /* Focus ring gray */
--radius: 0.5rem                       /* 8px border radius */
```

#### Dark Theme
```css
--background: 240 10% 3.9%             /* Very dark */
--foreground: 0 0% 98%                 /* Off-white */
--card: 240 10% 3.9%                   /* Very dark */
--card-foreground: 0 0% 98%            /* Off-white */
--popover: 240 10% 3.9%                /* Very dark */
--popover-foreground: 0 0% 98%         /* Off-white */
--primary: 0 0% 98%                    /* Off-white */
--primary-foreground: 240 5.9% 10%     /* Dark blue-gray */
--secondary: 240 3.7% 15.9%            /* Dark gray */
--secondary-foreground: 0 0% 98%       /* Off-white */
--muted: 240 3.7% 15.9%                /* Dark gray */
--muted-foreground: 240 5% 64.9%       /* Medium gray */
--accent: 240 3.7% 15.9%               /* Dark gray */
--accent-foreground: 0 0% 98%          /* Off-white */
--destructive: 0 62.8% 30.6%           /* Dark red */
--destructive-foreground: 0 0% 98%     /* Off-white */
--border: 240 3.7% 15.9%               /* Dark border */
--input: 240 3.7% 15.9%                /* Dark input border */
--ring: 240 4.9% 83.9%                 /* Light focus ring */
```

### Chart Colors
```css
--chart-1: 12 76% 61%      /* Orange */
--chart-2: 173 58% 39%     /* Teal */
--chart-3: 197 37% 24%     /* Dark blue */
--chart-4: 43 74% 66%      /* Yellow */
--chart-5: 27 87% 67%      /* Red-orange */
```

## Tailwind Reference Tables

### Complete Spacing Scale

| Class | REM | PX | Class | REM | PX |
|-------|-----|----|----|-----|----| 
| `p-0` | 0 | 0px | `p-12` | 3rem | 48px |
| `p-px` | 1px | 1px | `p-14` | 3.5rem | 56px |
| `p-0.5` | 0.125rem | 2px | `p-16` | 4rem | 64px |
| `p-1` | 0.25rem | 4px | `p-20` | 5rem | 80px |
| `p-1.5` | 0.375rem | 6px | `p-24` | 6rem | 96px |
| `p-2` | 0.5rem | 8px | `p-28` | 7rem | 112px |
| `p-2.5` | 0.625rem | 10px | `p-32` | 8rem | 128px |
| `p-3` | 0.75rem | 12px | `p-36` | 9rem | 144px |
| `p-3.5` | 0.875rem | 14px | `p-40` | 10rem | 160px |
| `p-4` | 1rem | 16px | `p-44` | 11rem | 176px |
| `p-5` | 1.25rem | 20px | `p-48` | 12rem | 192px |
| `p-6` | 1.5rem | 24px | `p-52` | 13rem | 208px |
| `p-7` | 1.75rem | 28px | `p-56` | 14rem | 224px |
| `p-8` | 2rem | 32px | `p-60` | 15rem | 240px |
| `p-9` | 2.25rem | 36px | `p-64` | 16rem | 256px |
| `p-10` | 2.5rem | 40px | `p-72` | 18rem | 288px |
| `p-11` | 2.75rem | 44px | `p-80` | 20rem | 320px |
|  |  |  | `p-96` | 24rem | 384px |

*Note: Apply to margin (`m-*`), width (`w-*`), height (`h-*`), gap (`gap-*`), and spacing utilities.*

### Typography Scale

| Class | Font Size | Line Height | Letter Spacing |
|-------|-----------|-------------|----------------|
| `text-xs` | 0.75rem (12px) | 1rem (16px) | 0.05em |
| `text-sm` | 0.875rem (14px) | 1.25rem (20px) | 0.025em |
| `text-base` | 1rem (16px) | 1.5rem (24px) | 0em |
| `text-lg` | 1.125rem (18px) | 1.75rem (28px) | -0.025em |
| `text-xl` | 1.25rem (20px) | 1.75rem (28px) | -0.025em |
| `text-2xl` | 1.5rem (24px) | 2rem (32px) | -0.025em |
| `text-3xl` | 1.875rem (30px) | 2.25rem (36px) | -0.025em |

### Font Weights

| Class | Font Weight | Numeric Value |
|-------|-------------|---------------|
| `font-thin` | 100 | 100 |
| `font-extralight` | 200 | 200 |
| `font-light` | 300 | 300 |
| `font-normal` | 400 | 400 |
| `font-medium` | 500 | 500 |
| `font-semibold` | 600 | 600 |
| `font-bold` | 700 | 700 |
| `font-extrabold` | 800 | 800 |
| `font-black` | 900 | 900 |

### Border Radius Scale

| Class | Border Radius | Pixels |
|-------|---------------|---------|
| `rounded-none` | 0 | 0px |
| `rounded-sm` | 0.125rem | 2px |
| `rounded` | 0.25rem | 4px |
| `rounded-md` | 0.375rem | 6px |
| `rounded-lg` | 0.5rem | 8px |
| `rounded-xl` | 0.75rem | 12px |
| `rounded-2xl` | 1rem | 16px |
| `rounded-3xl` | 1.5rem | 24px |
| `rounded-full` | 9999px | Full circle |

### Common Interactive States

#### Standard Focus Pattern
```css
focus-visible:outline-none 
focus-visible:ring-2 
focus-visible:ring-ring 
focus-visible:ring-offset-2
```

#### Standard Disabled Pattern
```css
disabled:cursor-not-allowed 
disabled:opacity-50
```

#### Standard Transition
```css
transition-colors
```
*Duration: 150ms cubic-bezier(0.4, 0, 0.2, 1)*

## Component-by-Component Analysis

### 1. Accordion → shadcn/ui Accordion

**GitHub Path**: [accordion.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/accordion.tsx)

#### Design Tokens Used
- Border: `hsl(var(--border))`
- Text: `hsl(var(--foreground))`

#### Complete Styling Breakdown

##### AccordionItem
```css
border-b: 1px solid hsl(var(--border))
```
- **Tailwind**: `border-b`
- **CSS**: `border-bottom: 1px solid`

##### AccordionTrigger
```css
/* Layout */
display: flex
flex: 1 1 0%
align-items: center
justify-content: space-between
padding: 1rem 0

/* Typography */
font-weight: 500
```
- **Layout Classes**: `flex flex-1 items-center justify-between`
- **Spacing Classes**: `py-4` (1rem top/bottom)
- **Typography Classes**: `font-medium`

##### Interactive States
```css
/* Hover */
text-decoration: underline

/* Icon Rotation */
transform: rotate(180deg) [data-state=open]

/* Transitions */
transition: all 150ms cubic-bezier(0.4, 0, 0.2, 1)
```
- **Hover**: `hover:underline`
- **State**: `[&[data-state=open]>svg]:rotate-180`
- **Transition**: `transition-all`

##### AccordionContent
```css
padding-bottom: 1rem
padding-top: 0
overflow: hidden
```
- **Spacing**: `pb-4 pt-0`
- **Animations**: 
  - `data-[state=closed]:animate-accordion-up`
  - `data-[state=open]:animate-accordion-down`

---

### 2. Avatar → shadcn/ui Avatar

**GitHub Path**: [avatar.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/avatar.tsx)

#### Design Tokens Used
- Background: `hsl(var(--muted))`

#### Complete Styling Breakdown

##### Avatar Root
```css
/* Position & Layout */
position: relative
display: flex
height: 2.5rem      /* 40px */
width: 2.5rem       /* 40px */
flex-shrink: 0
overflow: hidden
border-radius: 9999px
```
- **Layout**: `relative flex shrink-0 overflow-hidden`
- **Size**: `h-10 w-10` (2.5rem/40px)
- **Shape**: `rounded-full`

##### Avatar Image
```css
aspect-ratio: 1 / 1
height: 100%
width: 100%
```
- **Classes**: `aspect-square h-full w-full`

##### Avatar Fallback
```css
display: flex
height: 100%
width: 100%
align-items: center
justify-content: center
border-radius: 9999px
background-color: hsl(var(--muted))
```
- **Layout**: `flex h-full w-full items-center justify-center`
- **Shape**: `rounded-full`
- **Background**: `bg-muted`

---

### 3. Badge → shadcn/ui Badge

**GitHub Path**: [badge.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/badge.tsx)

#### Design Tokens Used
- Primary: `hsl(var(--primary))`, `hsl(var(--primary-foreground))`
- Secondary: `hsl(var(--secondary))`, `hsl(var(--secondary-foreground))`
- Destructive: `hsl(var(--destructive))`, `hsl(var(--destructive-foreground))`
- Ring: `hsl(var(--ring))`

#### Base Styling
```css
/* Layout */
display: inline-flex
align-items: center
border: 1px solid
border-radius: 9999px

/* Spacing */
padding: 0.125rem 0.625rem  /* 2px 10px */

/* Typography */
font-size: 0.75rem          /* 12px */
font-weight: 600
line-height: 1

/* Focus */
outline: none
```
- **Layout**: `inline-flex items-center border rounded-full`
- **Spacing**: `px-2.5 py-0.5`
- **Typography**: `text-xs font-semibold`
- **Focus**: `focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2`

#### Variants

##### Default Variant
```css
border-color: transparent
background-color: hsl(var(--primary))
color: hsl(var(--primary-foreground))
```
- **Classes**: `border-transparent bg-primary text-primary-foreground`
- **Hover**: `hover:bg-primary/80`

##### Secondary Variant
```css
border-color: transparent
background-color: hsl(var(--secondary))
color: hsl(var(--secondary-foreground))
```
- **Classes**: `border-transparent bg-secondary text-secondary-foreground`
- **Hover**: `hover:bg-secondary/80`

##### Destructive Variant
```css
border-color: transparent
background-color: hsl(var(--destructive))
color: hsl(var(--destructive-foreground))
```
- **Classes**: `border-transparent bg-destructive text-destructive-foreground`
- **Hover**: `hover:bg-destructive/80`

##### Outline Variant
```css
color: hsl(var(--foreground))
```
- **Classes**: `text-foreground`

---

### 4. Button → shadcn/ui Button

**GitHub Path**: [button.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/button.tsx)

#### Design Tokens Used
- Primary: `hsl(var(--primary))`, `hsl(var(--primary-foreground))`
- Secondary: `hsl(var(--secondary))`, `hsl(var(--secondary-foreground))`
- Destructive: `hsl(var(--destructive))`, `hsl(var(--destructive-foreground))`
- Accent: `hsl(var(--accent))`, `hsl(var(--accent-foreground))`
- Border: `hsl(var(--input))`
- Background: `hsl(var(--background))`

#### Base Styling
```css
/* Layout */
display: inline-flex
align-items: center
justify-content: center
gap: 0.5rem             /* 8px */
white-space: nowrap

/* Typography */
font-size: 0.875rem     /* 14px */
font-weight: 500
line-height: 1.25rem    /* 20px */

/* Border */
border-radius: 0.375rem /* 6px */

/* Transitions */
transition: colors 150ms cubic-bezier(0.4, 0, 0.2, 1)
```
- **Layout**: `inline-flex items-center justify-center gap-2`
- **Typography**: `whitespace-nowrap text-sm font-medium`
- **Border**: `rounded-md`
- **Focus**: `focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2`
- **Disabled**: `disabled:pointer-events-none disabled:opacity-50`

#### Size Variants

##### Default Size
```css
height: 2.5rem          /* 40px */
padding: 0.5rem 1rem    /* 8px 16px */
```
- **Classes**: `h-10 px-4 py-2`

##### Small Size
```css
height: 2.25rem         /* 36px */
padding-left: 0.75rem   /* 12px */
padding-right: 0.75rem  /* 12px */
border-radius: 0.375rem /* 6px */
```
- **Classes**: `h-9 rounded-md px-3`

##### Large Size
```css
height: 2.75rem         /* 44px */
padding-left: 2rem      /* 32px */
padding-right: 2rem     /* 32px */
border-radius: 0.375rem /* 6px */
```
- **Classes**: `h-11 rounded-md px-8`

##### Icon Size
```css
height: 2.5rem          /* 40px */
width: 2.5rem           /* 40px */
```
- **Classes**: `h-10 w-10`

#### Style Variants

##### Default Variant
```css
background-color: hsl(var(--primary))
color: hsl(var(--primary-foreground))
```
- **Classes**: `bg-primary text-primary-foreground`
- **Hover**: `hover:bg-primary/90`

##### Destructive Variant
```css
background-color: hsl(var(--destructive))
color: hsl(var(--destructive-foreground))
```
- **Classes**: `bg-destructive text-destructive-foreground`
- **Hover**: `hover:bg-destructive/90`

##### Outline Variant
```css
border: 1px solid hsl(var(--input))
background-color: hsl(var(--background))
```
- **Classes**: `border border-input bg-background`
- **Hover**: `hover:bg-accent hover:text-accent-foreground`

##### Secondary Variant
```css
background-color: hsl(var(--secondary))
color: hsl(var(--secondary-foreground))
```
- **Classes**: `bg-secondary text-secondary-foreground`
- **Hover**: `hover:bg-secondary/80`

##### Ghost Variant
- **Hover**: `hover:bg-accent hover:text-accent-foreground`

##### Link Variant
```css
color: hsl(var(--primary))
text-decoration: underline
text-underline-offset: 0.25rem /* 4px */
```
- **Classes**: `text-primary underline-offset-4`
- **Hover**: `hover:underline`

---

### 5. Card → shadcn/ui Card

**GitHub Path**: [card.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/card.tsx)

#### Design Tokens Used
- Card: `hsl(var(--card))`, `hsl(var(--card-foreground))`
- Muted: `hsl(var(--muted-foreground))`
- Border: `hsl(var(--border))`

#### Complete Styling Breakdown

##### Card Root
```css
border-radius: 0.5rem   /* 8px */
border: 1px solid hsl(var(--border))
background-color: hsl(var(--card))
color: hsl(var(--card-foreground))
box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05)
```
- **Classes**: `rounded-lg border bg-card text-card-foreground shadow-sm`

##### Card Header
```css
display: flex
flex-direction: column
padding: 1.5rem         /* 24px */
```
- **Classes**: `flex flex-col space-y-1.5 p-6`
- **Child Spacing**: `> * + *` gets `margin-top: 0.375rem` (6px)

##### Card Title
```css
font-size: 1.5rem       /* 24px */
font-weight: 600
line-height: 1
letter-spacing: -0.025em
```
- **Classes**: `text-2xl font-semibold leading-none tracking-tight`

##### Card Description
```css
font-size: 0.875rem     /* 14px */
color: hsl(var(--muted-foreground))
```
- **Classes**: `text-sm text-muted-foreground`

##### Card Content
```css
padding: 1.5rem         /* 24px */
padding-top: 0
```
- **Classes**: `p-6 pt-0`

##### Card Footer
```css
display: flex
align-items: center
padding: 1.5rem         /* 24px */
padding-top: 0
```
- **Classes**: `flex items-center p-6 pt-0`

---

### 6. Checkbox → shadcn/ui Checkbox

**GitHub Path**: [checkbox.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/checkbox.tsx)

#### Design Tokens Used
- Primary: `hsl(var(--primary))`, `hsl(var(--primary-foreground))`
- Ring: `hsl(var(--ring))`
- Ring Offset: `hsl(var(--background))`

#### Complete Styling Breakdown

##### Checkbox Root
```css
height: 1rem            /* 16px */
width: 1rem             /* 16px */
flex-shrink: 0
border-radius: 0.125rem /* 2px */
border: 1px solid hsl(var(--primary))
```
- **Size**: `h-4 w-4 shrink-0`
- **Border**: `rounded-sm border border-primary`
- **Focus**: `focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2`
- **Disabled**: `disabled:cursor-not-allowed disabled:opacity-50`

##### Checked State
```css
background-color: hsl(var(--primary))
color: hsl(var(--primary-foreground))
```
- **Classes**: `data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground`

##### Checkbox Indicator
```css
display: flex
align-items: center
justify-content: center
color: currentColor
```
- **Classes**: `flex items-center justify-center text-current`

---

### 7. Callout → shadcn/ui Alert

**GitHub Path**: [alert.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/alert.tsx)

#### Design Tokens Used
- Background: `hsl(var(--background))`
- Foreground: `hsl(var(--foreground))`
- Destructive: `hsl(var(--destructive))`
- Border: `hsl(var(--border))`

#### Complete Styling Breakdown

##### Alert Root
```css
position: relative
width: 100%
border-radius: 0.5rem   /* 8px */
border: 1px solid hsl(var(--border))
padding: 1rem           /* 16px */
```
- **Classes**: `relative w-full rounded-lg border p-4`

##### SVG Icon Positioning
```css
/* Icon positioning */
position: absolute
left: 1rem              /* 16px */
top: 1rem               /* 16px */
color: hsl(var(--foreground))

/* Content adjustment for icon */
padding-left: 1.75rem   /* 28px */ [siblings after SVG]
transform: translateY(-3px) [immediate div after SVG]
```
- **SVG Classes**: `[&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:text-foreground`
- **Content Classes**: `[&>svg~*]:pl-7 [&>svg+div]:translate-y-[-3px]`

#### Variants

##### Default Variant
```css
background-color: hsl(var(--background))
color: hsl(var(--foreground))
```
- **Classes**: `bg-background text-foreground`

##### Destructive Variant
```css
border-color: hsl(var(--destructive) / 0.5)
color: hsl(var(--destructive))
```
- **Classes**: `border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive`

##### Alert Title
```css
margin-bottom: 0.25rem  /* 4px */
font-weight: 500
line-height: 1
letter-spacing: -0.025em
```
- **Classes**: `mb-1 font-medium leading-none tracking-tight`

##### Alert Description
```css
font-size: 0.875rem     /* 14px */
```
- **Classes**: `text-sm [&_p]:leading-relaxed`

---

### 8. Divider → shadcn/ui Separator

**GitHub Path**: [separator.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/separator.tsx)

#### Design Tokens Used
- Border: `hsl(var(--border))`

#### Complete Styling Breakdown

##### Separator Base
```css
flex-shrink: 0
background-color: hsl(var(--border))
```
- **Classes**: `shrink-0 bg-border`

##### Horizontal Orientation
```css
height: 1px
width: 100%
```
- **Classes**: `h-[1px] w-full`

##### Vertical Orientation
```css
height: 100%
width: 1px
```
- **Classes**: `h-full w-[1px]`

---

### 9. Label → shadcn/ui Label

**GitHub Path**: [label.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/label.tsx)

#### Complete Styling Breakdown

##### Label Root
```css
font-size: 0.875rem     /* 14px */
font-weight: 500
line-height: 1
```
- **Classes**: `text-sm font-medium leading-none`

##### Peer States
```css
cursor: not-allowed     /* when peer disabled */
opacity: 0.7            /* when peer disabled */
```
- **Classes**: `peer-disabled:cursor-not-allowed peer-disabled:opacity-70`

---

### 10. Progress → shadcn/ui Progress

**GitHub Path**: [progress.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/progress.tsx)

#### Design Tokens Used
- Primary: `hsl(var(--primary))`
- Secondary: `hsl(var(--secondary))`

#### Complete Styling Breakdown

##### Progress Root
```css
position: relative
height: 1rem            /* 16px */
width: 100%
overflow: hidden
border-radius: 9999px
background-color: hsl(var(--secondary))
```
- **Classes**: `relative h-4 w-full overflow-hidden rounded-full bg-secondary`

##### Progress Indicator
```css
height: 100%
width: 100%
flex: 1 1 0%
background-color: hsl(var(--primary))
transition: all 150ms cubic-bezier(0.4, 0, 0.2, 1)
transform: translateX(-${100 - (value || 0)}%)
```
- **Classes**: `h-full w-full flex-1 bg-primary transition-all`
- **Transform**: Dynamic based on value percentage

---

### 11. Radio → shadcn/ui RadioGroup

**GitHub Path**: [radio-group.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/radio-group.tsx)

#### Design Tokens Used
- Primary: `hsl(var(--primary))`
- Ring: `hsl(var(--ring))`
- Background: `hsl(var(--background))`

#### Complete Styling Breakdown

##### RadioGroup Root
```css
display: grid
gap: 0.5rem             /* 8px */
```
- **Classes**: `grid gap-2`

##### RadioGroupItem
```css
aspect-ratio: 1 / 1
height: 1rem            /* 16px */
width: 1rem             /* 16px */
border-radius: 9999px
border: 1px solid hsl(var(--primary))
color: hsl(var(--primary))
```
- **Classes**: `aspect-square h-4 w-4 rounded-full border border-primary text-primary`
- **Focus**: `ring-offset-background focus:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2`
- **Disabled**: `disabled:cursor-not-allowed disabled:opacity-50`

##### RadioGroupIndicator
```css
display: flex
align-items: center
justify-content: center
height: 0.625rem        /* 10px */
width: 0.625rem         /* 10px */
fill: currentColor
color: currentColor
```
- **Classes**: `flex items-center justify-center h-2.5 w-2.5 fill-current text-current`

---

### 12. Select → shadcn/ui Select

**GitHub Path**: [select.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/select.tsx)

#### Design Tokens Used
- Background: `hsl(var(--background))`
- Foreground: `hsl(var(--foreground))`
- Border: `hsl(var(--input))`
- Popover: `hsl(var(--popover))`, `hsl(var(--popover-foreground))`
- Accent: `hsl(var(--accent))`, `hsl(var(--accent-foreground))`
- Ring: `hsl(var(--ring))`

#### Complete Styling Breakdown

##### SelectTrigger
```css
display: flex
height: 2.5rem          /* 40px */
width: 100%
align-items: center
justify-content: space-between
border-radius: 0.375rem /* 6px */
border: 1px solid hsl(var(--input))
background-color: hsl(var(--background))
padding: 0.75rem 0.5rem /* 12px 8px */
font-size: 0.875rem     /* 14px */
```
- **Classes**: `flex h-10 w-full items-center justify-between rounded-md border border-input bg-background px-3 py-2 text-sm`
- **Focus**: `focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2`
- **Disabled**: `disabled:cursor-not-allowed disabled:opacity-50`

##### SelectContent
```css
z-index: 50
max-height: var(--radix-select-content-available-height)
min-width: 8rem         /* 128px */
overflow: hidden
border-radius: 0.375rem /* 6px */
border: 1px solid hsl(var(--border))
background-color: hsl(var(--popover))
color: hsl(var(--popover-foreground))
box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)
```
- **Classes**: `z-50 max-h-96 min-w-[8rem] overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md`

##### SelectItem
```css
position: relative
display: flex
width: 100%
cursor: default
user-select: none
align-items: center
border-radius: 0.125rem /* 2px */
padding: 0.375rem 2rem 0.375rem 0.5rem /* 6px 32px 6px 8px */
font-size: 0.875rem     /* 14px */
outline: none
```
- **Classes**: `relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none`
- **Focus**: `focus:bg-accent focus:text-accent-foreground`
- **Disabled**: `data-[disabled]:pointer-events-none data-[disabled]:opacity-50`

---

### 13. Slider → shadcn/ui Slider

**GitHub Path**: [slider.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/slider.tsx)

#### Design Tokens Used
- Primary: `hsl(var(--primary))`
- Secondary: `hsl(var(--secondary))`
- Background: `hsl(var(--background))`
- Ring: `hsl(var(--ring))`

#### Complete Styling Breakdown

##### Slider Root
```css
position: relative
display: flex
width: 100%
touch-action: none
user-select: none
align-items: center
```
- **Classes**: `relative flex w-full touch-none select-none items-center`

##### Slider Track
```css
position: relative
height: 0.5rem          /* 8px */
width: 100%
flex-grow: 1
overflow: hidden
border-radius: 9999px
background-color: hsl(var(--secondary))
```
- **Classes**: `relative h-2 w-full grow overflow-hidden rounded-full bg-secondary`

##### Slider Range
```css
position: absolute
height: 100%
background-color: hsl(var(--primary))
```
- **Classes**: `absolute h-full bg-primary`

##### Slider Thumb
```css
display: block
height: 1.25rem         /* 20px */
width: 1.25rem          /* 20px */
border-radius: 9999px
border: 2px solid hsl(var(--primary))
background-color: hsl(var(--background))
transition: colors 150ms cubic-bezier(0.4, 0, 0.2, 1)
```
- **Classes**: `block h-5 w-5 rounded-full border-2 border-primary bg-background ring-offset-background transition-colors`
- **Focus**: `focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2`
- **Disabled**: `disabled:pointer-events-none disabled:opacity-50`

---

### 14. Switch → shadcn/ui Switch

**GitHub Path**: [switch.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/switch.tsx)

#### Design Tokens Used
- Primary: `hsl(var(--primary))`
- Input: `hsl(var(--input))`
- Background: `hsl(var(--background))`
- Ring: `hsl(var(--ring))`

#### Complete Styling Breakdown

##### Switch Root
```css
display: inline-flex
height: 1.5rem          /* 24px */
width: 2.75rem          /* 44px */
flex-shrink: 0
cursor: pointer
border-radius: 9999px
border: 2px solid transparent
transition: colors 150ms cubic-bezier(0.4, 0, 0.2, 1)
```
- **Classes**: `inline-flex h-6 w-11 shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors`
- **Focus**: `focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2`
- **Disabled**: `disabled:cursor-not-allowed disabled:opacity-50`

##### Switch States
```css
/* Checked */
background-color: hsl(var(--primary))

/* Unchecked */
background-color: hsl(var(--input))
```
- **Checked**: `data-[state=checked]:bg-primary`
- **Unchecked**: `data-[state=unchecked]:bg-input`

##### Switch Thumb
```css
pointer-events: none
display: block
height: 1.25rem         /* 20px */
width: 1.25rem          /* 20px */
border-radius: 9999px
background-color: hsl(var(--background))
box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)
ring: 0
transition: transform 150ms cubic-bezier(0.4, 0, 0.2, 1)
```
- **Classes**: `pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform`

##### Thumb States
```css
/* Checked position */
transform: translateX(1.25rem) /* 20px */

/* Unchecked position */  
transform: translateX(0)
```
- **Checked**: `data-[state=checked]:translate-x-5`
- **Unchecked**: `data-[state=unchecked]:translate-x-0`

---

### 15. TextField → shadcn/ui Input

**GitHub Path**: [input.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/input.tsx)

#### Design Tokens Used
- Background: `hsl(var(--background))`
- Border: `hsl(var(--input))`
- Foreground: `hsl(var(--foreground))`
- Muted Foreground: `hsl(var(--muted-foreground))`
- Ring: `hsl(var(--ring))`

#### Complete Styling Breakdown

##### Input Root
```css
height: 2.5rem          /* 40px */
width: 100%
border-radius: 0.375rem /* 6px */
border: 1px solid hsl(var(--input))
background-color: hsl(var(--background))
padding: 0.75rem 0.5rem /* 12px 8px */
font-size: 1rem         /* 16px */ /* mobile */
font-size: 0.875rem     /* 14px */ /* md: desktop */
```
- **Size**: `h-10 w-full`
- **Border**: `rounded-md border border-input`
- **Background**: `bg-background`
- **Padding**: `px-3 py-2`
- **Typography**: `text-base md:text-sm`

##### File Input Styling
```css
/* File input button */
border: 0
background-color: transparent
font-size: 0.875rem     /* 14px */
font-weight: 500
color: hsl(var(--foreground))
```
- **File Classes**: `file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground`

##### Input States
```css
/* Placeholder */
color: hsl(var(--muted-foreground))

/* Focus */
outline: none
box-shadow: 0 0 0 2px hsl(var(--ring)), 0 0 0 4px hsl(var(--background))

/* Disabled */
cursor: not-allowed
opacity: 0.5
```
- **Placeholder**: `placeholder:text-muted-foreground`
- **Focus**: `focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2`
- **Disabled**: `disabled:cursor-not-allowed disabled:opacity-50`

---

### 16. Tooltip → shadcn/ui Tooltip

**GitHub Path**: [tooltip.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/tooltip.tsx)

#### Design Tokens Used
- Popover: `hsl(var(--popover))`, `hsl(var(--popover-foreground))`
- Border: `hsl(var(--border))`

#### Complete Styling Breakdown

##### Tooltip Content
```css
z-index: 50
overflow: hidden
border-radius: 0.375rem /* 6px */
border: 1px solid hsl(var(--border))
background-color: hsl(var(--popover))
padding: 0.375rem 0.75rem /* 6px 12px */
font-size: 0.875rem     /* 14px */
color: hsl(var(--popover-foreground))
box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)
```
- **Classes**: `z-50 overflow-hidden rounded-md border bg-popover px-3 py-1.5 text-sm text-popover-foreground shadow-md`

##### Animations

###### Entry Animations
```css
/* Base entry */
animation: fade-in 200ms, zoom-in 200ms

/* Directional entry */
/* Bottom tooltip */
animation: slide-in-from-top 200ms

/* Left tooltip */  
animation: slide-in-from-right 200ms

/* Right tooltip */
animation: slide-in-from-left 200ms

/* Top tooltip */
animation: slide-in-from-bottom 200ms
```
- **Entry**: `animate-in fade-in-0 zoom-in-95`
- **Directional**: 
  - `data-[side=bottom]:slide-in-from-top-2`
  - `data-[side=left]:slide-in-from-right-2`
  - `data-[side=right]:slide-in-from-left-2`
  - `data-[side=top]:slide-in-from-bottom-2`

###### Exit Animations
```css
/* Base exit */
animation: fade-out 200ms, zoom-out 200ms
```
- **Exit**: `data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95`

###### Transform Origin
```css
transform-origin: var(--radix-tooltip-content-transform-origin)
```
- **Origin**: `origin-[--radix-tooltip-content-transform-origin]`

---

### 17. Spinner → shadcn/ui Skeleton

**GitHub Path**: [skeleton.tsx](https://github.com/shadcn-ui/ui/blob/main/apps/www/registry/default/ui/skeleton.tsx)

#### Design Tokens Used
- Muted: `hsl(var(--muted))`

#### Complete Styling Breakdown

##### Skeleton Root
```css
animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite
border-radius: 0.375rem /* 6px */
background-color: hsl(var(--muted))
```
- **Classes**: `animate-pulse rounded-md bg-muted`

##### Pulse Animation
```css
@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}
```
- **Duration**: 2 seconds
- **Timing**: cubic-bezier(0.4, 0, 0.6, 1)
- **Iteration**: infinite

---

## Migration Steps

### Step 1: Design Token Migration
1. **Extract current Remix design tokens**
2. **Map to shadcn/ui CSS variables**
3. **Update color references**
4. **Implement light/dark theme support**

### Step 2: Spacing Migration  
1. **Audit current spacing values**
2. **Convert to Tailwind scale**
3. **Update padding/margin classes**
4. **Standardize consistent spacing**

### Step 3: Typography Migration
1. **Audit font sizes and weights**
2. **Map to Tailwind typography scale**  
3. **Update line heights and letter spacing**
4. **Implement consistent text hierarchy**

### Step 4: Interactive States Migration
1. **Standardize focus patterns**
2. **Update hover states**
3. **Implement disabled patterns**
4. **Add transition effects**

### Step 5: Component-Specific Migration
1. **Update each component systematically**
2. **Test visual consistency** 
3. **Verify accessibility compliance**
4. **Update documentation**

---

## Common Patterns Summary

### Focus Ring Pattern
```css
focus-visible:outline-none 
focus-visible:ring-2 
focus-visible:ring-ring 
focus-visible:ring-offset-2
```

### Disabled Pattern  
```css
disabled:cursor-not-allowed 
disabled:opacity-50
```

### Hover Opacity Pattern
```css
hover:bg-primary/80  /* 80% opacity */
hover:bg-primary/90  /* 90% opacity */
```

### Standard Transitions
```css
transition-colors        /* 150ms */
transition-all          /* 150ms */  
transition-transform    /* 150ms */
```

### Standard Border Radius
- Small: `rounded-sm` (2px)
- Medium: `rounded-md` (6px) 
- Large: `rounded-lg` (8px)
- Full: `rounded-full` (circle)

### Standard Spacing
- Small: `p-2` (8px), `gap-2` (8px)
- Medium: `p-4` (16px), `gap-4` (16px)  
- Large: `p-6` (24px), `gap-6` (24px)
