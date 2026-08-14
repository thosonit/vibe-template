# Cấu trúc & quy ước của `design-system.html`

Tài liệu này mô tả pattern chuẩn được rút ra từ 2 file tham chiếu `references/example-anthropic.html` và `references/example-mongodb.html` (dạng "Design System Analysis" tạo bởi công cụ getdesign.md/awesome-design-md). Dùng tài liệu này làm khuôn khi sinh file `design-system.html` mới, và cả khi bổ sung section/component vào file đã có.

## ⚠️ Phần KHÔNG được sao chép lại

Trong 2 file mẫu có một số nội dung chỉ là "chrome" quảng bá của công cụ đã tạo ra chúng, KHÔNG phải một phần design system của brand được phân tích — không bao giờ copy các phần này vào file mới:

- Link/badge `getdesign.md` và `awesome-design-md` GitHub trong nav.
- Footer 4 cột quảng bá "VoltAgent Framework / VoltOps..." ở cuối file.
- Script `cloudflareinsights.com` beacon.

Nav và footer trong file mới phải mang thương hiệu/nội dung của chính design system đang mô tả (tên brand, hoặc để trống/placeholder trung lập), không phải thương hiệu của công cụ tạo file.

## 1. Bộ khung trang (page skeleton)

Thứ tự bắt buộc trong file:

```
<html>
  <head>
    <meta charset, viewport, title>
    <link> Google Fonts (preconnect + stylesheet) — chỉ load đúng font mà DESIGN.md yêu cầu
    <style> — 1 khối CSS duy nhất, mọi màu/font/spacing dùng CSS custom properties trong :root
  </head>
  <body>
    <nav>            — sticky, 3 cột (brand | anchor links | CTA)
    <div class="hero"> — 2 cột: content (h1+p+2 CTA) | art (code mockup hoặc visual)
    <section id="colors">      — 01, luôn có
    <section id="typography">  — 02, luôn có
    <section id="components">  — 03, Button Variants, luôn có
    <section>...</section>     — các section tiếp theo, đánh số tiếp, tùy theo DESIGN.md có component gì
    <section id="responsive">  — luôn là section cuối cùng trước footer
    <footer>
  </body>
</html>
```

File là **self-contained**: toàn bộ CSS nằm trong 1 thẻ `<style>`, không có JS logic (trừ khi người dùng yêu cầu tương tác thật), không phụ thuộc framework ngoài — vì mục đích là để AI agent khác đọc file này và hiểu design system, không phải để deploy làm website thật.

## 2. Ánh xạ token DESIGN.md → CSS variable

| DESIGN.md token | CSS variable gợi ý | Ghi chú |
|---|---|---|
| `colors.primary` | `--primary` | Màu CTA chính |
| `colors.<tên khác>` (secondary, tertiary, accent-*...) | `--<tên>` | Giữ nguyên tên token làm tên biến để agent đọc code sau này khớp trực tiếp với DESIGN.md |
| Trạng thái pressed/hover/active nếu component có định nghĩa | `--<tên>-active` / `--<tên>-hover` | |
| Màu chữ đặt trên nền màu đó | `--on-<tên>` | vd `--on-primary` |
| Nền chính (thường là `colors.neutral` hoặc `canvas`) | `--canvas` | |
| Các biến thể nền phụ | `--surface`, `--surface-soft`, `--surface-card`, `--surface-dark`... | Số lượng tùy theo DESIGN.md định nghĩa bao nhiêu surface token |
| Đường viền mảnh | `--hairline`, `--hairline-soft` | Nếu DESIGN.md không có sẵn, suy ra từ màu neutral làm mờ nhẹ |
| Text hierarchy | `--ink` (chữ chính), `--body`, `--muted`, `--muted-soft` | |
| `typography.<tên>.fontFamily` (display/heading) | `--display` | font-stack đầy đủ kèm fallback |
| `typography.<tên>.fontFamily` (body) | `--text` | |
| Font code/mono nếu có | `--mono` | Nếu DESIGN.md không khai báo, mặc định `ui-monospace, 'JetBrains Mono', monospace` |
| `rounded.*` | dùng trực tiếp trong class (`.btn { border-radius: var(--radius-md) }`) nếu cần biến, hoặc numeric literal nếu chỉ dùng 1 lần | |
| `spacing.*` | dùng trong section 10 "Spacing Scale" để minh họa trực quan | |

Nếu DESIGN.md thiếu token nào (vd không có `secondary`), KHÔNG tự bịa ra một token mới không có căn cứ — hỏi người dùng hoặc suy luận hợp lý từ palette đã có (vd làm variant sáng/tối hơn của primary) và ghi chú rõ trong phần "rationale" của section đó rằng đây là suy luận, không phải token gốc.

## 3. Danh mục section

### Section lõi — LUÔN xuất hiện, đúng thứ tự này:

| # | id/section-label | Nội dung | Class chính |
|---|---|---|---|
| 01 | Color Palette | Nhóm màu theo group (Brand/Accent, Surface, Text) — mỗi màu 1 `.swatch` gồm khối màu + tên + hex + role | `.palette-group`, `.palette-grid`, `.swatch`, `.swatch-color`, `.swatch-meta`, `.swatch-name`, `.swatch-hex`, `.swatch-role` |
| 02 | Typography Scale | Mỗi dòng: metadata (tên scale, size/weight/line-height/letter-spacing) bên trái, câu ví dụ render thật bên phải | `.type-row`, `.type-meta`, `.type-sample` |
| 03 | Button Variants | Mọi biến thể button định nghĩa trong `components` của DESIGN.md: primary, primary-active, primary-disabled, secondary, secondary-on-dark, text-link, icon-circular... | `.button-grid`, `.button-cell`, `.button-label`, `.btn` + class biến thể, `.button-meta` |
| xx | Cards & Containers | Card cơ bản (feature card), card đặc thù theo domain sản phẩm (code mockup nếu là dev tool, testimonial nếu là B2B SaaS...) | `.card-grid`, `.feature-card` |
| xx | Spacing Scale | Thanh trực quan cho từng bậc spacing | `.spacing-row`, `.spacing-block`, `.spacing-bar`, `.spacing-label` |
| xx | Border Radius Scale | Ô vuông minh họa từng bậc bo góc | `.radius-row`, `.radius-block` |
| xx | Elevation & Depth | Card minh họa các tầng elevation/nền khác nhau | `.elevation-grid`, `.elevation-card` |
| xx (cuối cùng) | Responsive Behavior | Bảng breakpoint + thang thiết bị trực quan + ghi chú touch target/collapsing strategy | `.responsive-table`, `.device-ladder`, `.device-bar`, `.responsive-sub` |

### Section tùy chọn — thêm vào NẾU DESIGN.md có định nghĩa component tương ứng, hoặc người dùng yêu cầu cụ thể:

- **Badges & Status** — nếu có badge/pill/status token.
- **Forms & Inputs** — nếu sản phẩm có form (input, focus state).
- **Pricing Tiers** — nếu là SaaS có pricing.
- **Coral/Accent Callout Card** (CTA banner full-bleed) — nếu brand có mẫu callout nổi bật.
- **Connector/Service Tiles** — nếu có danh sách tích hợp/dịch vụ dạng lưới nhỏ.
- **Tabs & Navigation** — nếu có tab UI.
- **Code Mockup Card** — chỉ thêm nếu đây là sản phẩm dev-facing (API, SDK...).
- **Testimonials / Logo Wall / FAQ Accordion** — nếu là trang marketing B2B.

Không thêm section tùy chọn một cách máy móc cho mọi brand — chỉ thêm khi có căn cứ từ DESIGN.md (component đã định nghĩa) hoặc từ yêu cầu người dùng. Một design system tối giản (ví dụ chỉ có button + card) không cần ép đủ 13-17 section như 2 file mẫu.

## 4. Pattern chi tiết từng phần dùng lại

**Section header pattern** (áp dụng cho mọi section):
```html
<section id="...">
  <div class="section-label">03 — Button Variants</div>
  <h2 class="section-heading">Tiêu đề ngắn mô tả phong cách</h2>
  <p class="section-intro">1-2 câu giải thích RATIONALE — tại sao chọn cách phối này, không chỉ liệt kê lại giá trị.</p>
  ... nội dung ...
</section>
```
Số thứ tự phải liên tục, không nhảy số, không trùng số khi thêm section mới về sau (xem mục 6).

**Nav pattern**:
```html
<nav class="nav"> <!-- display:grid; grid-template-columns:1fr auto 1fr -->
  <div class="nav-left">...brand...</div>
  <ul class="nav-links"><li><a href="#colors">Colors</a></li>...</ul>
  <button class="nav-cta">...</button>
</nav>
```
Anchor link trong `.nav-links` phải khớp đúng `id` của các section chính (tối thiểu: colors, typography, components, responsive).

**Hero pattern**: grid 2 cột (nội dung trái, minh họa phải). Minh họa bên phải nên là 1 trong 2 dạng: (a) code mockup dạng terminal nếu sản phẩm dev-facing, hoặc (b) khối màu/hình minh họa phong cách nếu là brand tiêu dùng — quyết định dựa trên bản chất sản phẩm mô tả trong DESIGN.md.

**Responsive breakpoints**: dùng đúng 2 mốc `@media (max-width: 1024px)` và `@media (max-width: 720px)`, mỗi mốc thu gọn grid về ít cột hơn, ẩn phần trang trí không thiết yếu, giảm font-size heading.

## 5. Yêu cầu chất lượng (frontend-design)

File `design-system.html` là sản phẩm hiển thị (visual output), không phải chỉ là dữ liệu — nó phải THỰC SỰ trông đẹp, đúng cá tính brand trong DESIGN.md, không phải bản demo xám xịt. Trước khi hoàn thiện: tham khảo `/mnt/skills/public/frontend-design/SKILL.md` để quyết định các chi tiết mà DESIGN.md không nói rõ (tỷ lệ khoảng trắng, cách phối icon, độ tương phản, chi tiết vi mô như hover/shadow) — đừng để mọi design system trông giống hệt nhau về bố cục vi mô chỉ vì đổi màu.

## 6. Quy tắc khi BỔ SUNG component/section vào file đã có

Khi người dùng yêu cầu thêm 1 component hoặc UI mới vào `design-system.html` đã tồn tại:

1. Đọc lại DESIGN.md liên quan (nếu component mới cần token chưa có trong DESIGN.md — ví dụ thêm 1 màu mới — phải hỏi người dùng có muốn cập nhật DESIGN.md trước, hoặc dùng token đã có sẵn để suy ra, không tự bịa màu ngoài palette).
2. Đọc file `design-system.html` hiện có để lấy đúng: tên biến CSS đang dùng (`:root`), quy ước class hiện tại, số thứ tự section cuối cùng.
3. Section mới chèn vào TRƯỚC section "Responsive Behavior" (section responsive luôn ở cuối cùng) và được đánh số tiếp theo số cuối cùng hiện có +1.
4. Style của component mới thêm vào cuối khối `<style>` hiện có (không tạo `<style>` thứ 2), dùng lại đúng biến CSS `:root` đã có — không định nghĩa lại màu bằng mã hex trực tiếp.
5. Nếu section mới đủ quan trọng để cần truy cập nhanh, thêm 1 mục vào `.nav-links` trỏ tới `id` mới — nhưng không bắt buộc với mọi component nhỏ.
6. Sau khi chèn, xem lại toàn bộ để đảm bảo không phá vỡ layout ở các breakpoint responsive đã có (section mới cần kế thừa đúng pattern grid/gap của các section cùng loại).
