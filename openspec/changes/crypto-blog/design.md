## Context

Project hiện tại là AI Vibecode OS starter template, chưa có frontend nào. Cần thêm một trang blog chuyên nghiệp về crypto với nội dung tĩnh (markdown-based), deploy nhanh, SEO tốt.

## Goals / Non-Goals

**Goals:**
- Blog tĩnh, nhanh, SEO-friendly với nội dung crypto
- Dark mode mặc định, giao diện chuyên nghiệp
- Bài viết viết bằng markdown, dễ thêm mới
- Phân loại theo category: News, Knowledge, Analysis
- Responsive trên mobile/tablet/desktop
- Deploy được lên Vercel/Netlify

**Non-Goals:**
- Không làm CMS backend hay admin panel
- Không tích hợp real-time price feed hay trading
- Không làm hệ thống comment hay user auth
- Không làm newsletter/email subscription (có thể thêm sau)

## Decisions

### 1. Framework: Astro
- **Chọn**: Astro (static site generator)
- **Lý do**: Output HTML tĩnh, zero JS by default → nhanh, SEO tốt. Hỗ trợ markdown content collections native. Nhẹ hơn Next.js cho use case blog thuần content.
- **Thay thế xem xét**: Next.js (quá nặng cho static blog), Hugo (ít flexible với component), 11ty (ecosystem nhỏ hơn)

### 2. Styling: Tailwind CSS
- **Chọn**: Tailwind CSS v4
- **Lý do**: Utility-first, dễ custom dark theme, ecosystem lớn, tích hợp tốt với Astro
- **Thay thế xem xét**: Vanilla CSS (tốn thời gian), Sass (không cần thiết cho project size này)

### 3. Content: Astro Content Collections
- **Chọn**: Content Collections API của Astro
- **Lý do**: Type-safe frontmatter, built-in markdown rendering, auto-generated slugs
- **Cấu trúc**: `src/content/blog/` chứa `.md` files với frontmatter (title, date, category, thumbnail, summary)

### 4. Deploy: Static output
- **Chọn**: `astro build` → static HTML → deploy Vercel/Netlify
- **Lý do**: Không cần server, free tier đủ dùng, CDN global

## Risks / Trade-offs

- [Không có real-time data] → Chấp nhận: blog là content tĩnh, không cần live prices
- [Astro learning curve] → Thấp: Astro syntax đơn giản, giống HTML
- [Không có CMS] → Chấp nhận: thêm bài bằng cách tạo file markdown, phù hợp cho developer workflow
- [SEO cần content thật] → Tạo vài bài mẫu để demo, content thật bổ sung sau
