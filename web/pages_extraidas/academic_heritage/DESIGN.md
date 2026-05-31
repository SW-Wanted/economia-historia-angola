---
name: Academic Heritage
colors:
  surface: '#fcf9f8'
  surface-dim: '#dcd9d9'
  surface-bright: '#fcf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f2'
  surface-container: '#f0eded'
  surface-container-high: '#eae7e7'
  surface-container-highest: '#e5e2e1'
  on-surface: '#1c1b1b'
  on-surface-variant: '#58413f'
  inverse-surface: '#313030'
  inverse-on-surface: '#f3f0ef'
  outline: '#8c716e'
  outline-variant: '#e0bfbc'
  surface-tint: '#ac322e'
  primary: '#690008'
  on-primary: '#ffffff'
  primary-container: '#8b1a1a'
  on-primary-container: '#ff9a91'
  inverse-primary: '#ffb3ac'
  secondary: '#5d5f5d'
  on-secondary: '#ffffff'
  secondary-container: '#e2e3e1'
  on-secondary-container: '#636563'
  tertiary: '#2f3131'
  on-tertiary: '#ffffff'
  tertiary-container: '#454748'
  on-tertiary-container: '#b5b5b6'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdad6'
  primary-fixed-dim: '#ffb3ac'
  on-primary-fixed: '#410003'
  on-primary-fixed-variant: '#8a1a1a'
  secondary-fixed: '#e2e3e1'
  secondary-fixed-dim: '#c6c7c5'
  on-secondary-fixed: '#1a1c1b'
  on-secondary-fixed-variant: '#454746'
  tertiary-fixed: '#e2e2e2'
  tertiary-fixed-dim: '#c6c6c7'
  on-tertiary-fixed: '#1a1c1c'
  on-tertiary-fixed-variant: '#454747'
  background: '#fcf9f8'
  on-background: '#1c1b1b'
  surface-variant: '#e5e2e1'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 48px
    fontWeight: '800'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: '1.3'
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: '1.4'
  body-lg:
    fontFamily: Merriweather
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.8'
  body-md:
    fontFamily: Merriweather
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: '1.2'
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: '1.2'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  sidebar-width: 280px
  max-content-width: 1160px
  gutter: 24px
  margin-desktop: 40px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
  stack-xl: 64px
---

## Brand & Style
The brand personality is intellectual, authoritative, and deeply rooted in Angolan history, yet delivered with a modern editorial edge. It bridges the gap between academic rigor and digital accessibility, aiming to educate a sophisticated audience about economic evolution.

The design style is **Modern Editorial**. It prioritizes high-quality typography and structured content blocks. By utilizing a "Bone" background and "Bordeaux" accents, the system evokes the feeling of a premium physical journal or a modern newsroom. It is clean and organized, using generous whitespace to allow complex economic narratives to breathe. Visuals are treated with a documentary-style lens, using subtle shadows and high-contrast elements to denote importance.

## Colors
The palette is rooted in a classic academic tradition but refreshed for high-resolution screens.

*   **Primary (Bordeaux):** Used for primary actions, branding, and highlighting "Premium" or "Heritage" content. It carries the weight of history and authority.
*   **Background (Bone):** A soft, off-white that reduces eye strain during long-form reading, providing a more "paper-like" feel than pure white.
*   **Surface (Pure White):** Used for elevated cards and containers to create a distinct separation from the background.
*   **Text (Deep Charcoal):** Used for primary body and headings to ensure maximum legibility without the harshness of pure black.
*   **Secondary Text (Subtle Grey):** Used for metadata, such as read times, view counts, and secondary labels.

## Typography
The typography system follows a "Sans-Head, Serif-Body" pairing common in high-end editorial design.

**Plus Jakarta Sans** is used for headings, navigation, and labels. Its modern, geometric construction provides a clear, authoritative structure to the UI. Use heavier weights (700-800) for article titles to command attention.

**Merriweather** is the workhorse for long-form reading. As a serif font designed specifically for screens, it provides the "bookish" comfort required for academic content while maintaining high legibility at standard sizes.

A strict hierarchy is maintained: headlines use tight line heights for impact, while body text uses a generous 1.6x to 1.8x line height to facilitate effortless scanning and deep reading.

## Layout & Spacing
The layout follows a **Fixed Sidebar + Fluid Content** model optimized for a 1440px desktop experience.

*   **Sidebar:** A fixed 280px left-hand navigation column. It houses the primary logo, global search, and category navigation.
*   **Main Canvas:** The content area utilizes a maximum width of 1160px to prevent line lengths from becoming too long for comfortable reading.
*   **Grid:** A 12-column grid system is used within the main canvas. Content cards typically span 4 columns (for a 3-up grid) or 6 columns (for a 2-up grid).
*   **Responsive Reflow:** On smaller screens (Tablet), the sidebar collapses into a drawer. On Mobile, the layout shifts to a single column with 16px margins.
*   **Vertical Rhythm:** Use the `stack` variables to maintain consistent vertical breathing room between editorial sections.

## Elevation & Depth
This design system uses a **Tonal & Soft Shadow** approach to depth. 

*   **Level 0 (Background):** The "Bone" background serves as the lowest layer.
*   **Level 1 (Cards):** Pure White surfaces use a very subtle, highly diffused shadow (e.g., `0px 4px 20px rgba(0,0,0,0.04)`) to appear slightly lifted.
*   **Interaction State:** Upon hover, cards may increase their shadow spread or slightly shift upwards (2px) to provide tactile feedback.
*   **Overlays:** Modals and dropdowns use a medium shadow with a 10% opacity bordeaux tint to keep the elevation consistent with the brand's primary color.

## Shapes
The shape language is "Rounded-Professional." 

A standard corner radius of **16px (1rem)** is applied to all primary cards and image containers, creating a softened, modern look that counters the "stiff" nature of academic content. 

Buttons and Chips use a **Pill-shape (Full Rounding)** or a **16px radius** depending on their scale. Small UI elements like checkboxes or input fields should follow a **8px (0.5rem)** radius to maintain harmony without becoming overly "bubbly."

## Components

*   **Buttons:** 
    *   *Primary:* Solid Bordeaux background, White text, 16px or Pill-shaped. 
    *   *Secondary:* Bordeaux border, Bordeaux text, transparent background.
*   **Cards:** Pure White background, 16px corner radius. Feature images should be clipped to the top of the card with the same radius. Include a 1px soft grey border if the background contrast is low.
*   **Chips/Tags:** Used for categories (e.g., "Microtextos"). Use a light grey or soft Bordeaux tint background with `label-sm` typography.
*   **Input Fields:** Subtle "Bone" background or white with a 1px stroke. Use 16px padding and an 8px corner radius. Icons (like search) should be Deep Charcoal.
*   **Sidebar Nav:** Vertical list with 12px vertical spacing. Active states should be marked with a Bordeaux left-edge indicator and a bolded weight in `plusJakartaSans`.
*   **Quote Blocks:** Large Merriweather italic text, often contained within a Bordeaux background block with white text to signify an "Insight" or "Breakout" section.
*   **Progress Indicators:** For long-form articles, use a slim Bordeaux line at the top of the viewport to indicate reading progress.