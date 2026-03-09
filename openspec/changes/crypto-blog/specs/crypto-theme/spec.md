## ADDED Requirements

### Requirement: Dark mode default theme
The blog SHALL use a dark color scheme by default, with dark backgrounds and light text, appropriate for a crypto/fintech aesthetic.

#### Scenario: Initial page load
- **WHEN** user visits the blog for the first time
- **THEN** the page renders with a dark background, light text, and accent colors consistent with the crypto theme

### Requirement: Professional typography
The blog SHALL use professional, readable typography with a sans-serif font for headings and UI, and optimized line-height/spacing for long-form reading.

#### Scenario: Article readability
- **WHEN** user reads a long article
- **THEN** the text has comfortable line-height (1.6+), appropriate font size (16px+ body), and max content width for readability

### Requirement: Consistent color scheme
The blog SHALL use a cohesive color palette: dark backgrounds (#0a0a0a range), accent colors (cyan/blue tones for crypto feel), category-specific badge colors, and proper contrast ratios (WCAG AA).

#### Scenario: Color contrast
- **WHEN** the blog is tested for accessibility
- **THEN** all text meets WCAG AA contrast ratio (4.5:1 for normal text, 3:1 for large text)

#### Scenario: Category badge colors
- **WHEN** articles are displayed with category badges
- **THEN** each category (News, Knowledge, Analysis) has a distinct, visually identifiable badge color
