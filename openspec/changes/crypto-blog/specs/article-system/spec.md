## ADDED Requirements

### Requirement: Markdown-based article content
Articles SHALL be stored as markdown files in `src/content/blog/` with frontmatter fields: title, date, category, summary, thumbnail, and author.

#### Scenario: Valid article frontmatter
- **WHEN** a markdown file is added to `src/content/blog/` with all required frontmatter fields
- **THEN** the article appears in the blog listing and is accessible via its slug

#### Scenario: Missing required frontmatter
- **WHEN** a markdown file is missing required frontmatter fields
- **THEN** the build fails with a clear error message indicating which fields are missing

### Requirement: Article listing page
The home page SHALL display a list of articles sorted by date (newest first), showing thumbnail, title, category badge, date, and summary for each article.

#### Scenario: Home page article list
- **WHEN** user visits the home page
- **THEN** articles are displayed as cards in a grid, sorted by date descending, with thumbnail, title, category badge, publication date, and summary

#### Scenario: Empty state
- **WHEN** there are no articles in a category
- **THEN** the category page displays a message indicating no articles are available

### Requirement: Article detail page
Each article SHALL have a dedicated page at `/blog/<slug>` rendering the full markdown content with proper typography.

#### Scenario: Reading an article
- **WHEN** user clicks an article card from the listing
- **THEN** user navigates to `/blog/<slug>` showing the full article with title, date, author, category, and rendered markdown content

### Requirement: Category filtering
Articles SHALL be filterable by category (News, Knowledge, Analysis) via dedicated category pages.

#### Scenario: Viewing a category
- **WHEN** user navigates to a category page
- **THEN** only articles matching that category are displayed, sorted by date descending

### Requirement: Sample articles
The blog SHALL include at least 3 sample articles (one per category) to demonstrate the layout and content rendering.

#### Scenario: Initial content
- **WHEN** the blog is built for the first time
- **THEN** at least 3 sample articles exist covering News, Knowledge, and Analysis categories
