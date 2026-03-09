## ADDED Requirements

### Requirement: Responsive layout with header and footer
The blog SHALL have a consistent layout with header (logo, navigation) and footer across all pages. The layout MUST be responsive and work on mobile (320px+), tablet (768px+), and desktop (1024px+).

#### Scenario: Desktop navigation
- **WHEN** user visits the blog on a desktop browser
- **THEN** the header displays the blog logo, navigation links (Home, News, Knowledge, Analysis, About), and the layout uses a centered content area with max-width

#### Scenario: Mobile navigation
- **WHEN** user visits the blog on a mobile device
- **THEN** the navigation collapses into a hamburger menu that expands on tap

#### Scenario: Footer content
- **WHEN** user scrolls to the bottom of any page
- **THEN** the footer displays copyright info and social links

### Requirement: Navigation links to category pages
The navigation SHALL include links to each category page (News, Knowledge, Analysis) and a Home link showing all posts.

#### Scenario: Category navigation
- **WHEN** user clicks a category link in the navigation
- **THEN** user is taken to a page listing only articles in that category

### Requirement: SEO meta tags on all pages
Every page SHALL include proper meta tags: title, description, Open Graph (og:title, og:description, og:image), and canonical URL.

#### Scenario: Article page meta tags
- **WHEN** a search engine crawls an article page
- **THEN** the page has unique title, description from the article summary, og:image from the article thumbnail, and canonical URL
