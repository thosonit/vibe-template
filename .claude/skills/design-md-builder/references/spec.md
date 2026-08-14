# DESIGN.md — Đặc tả định dạng (condensed, dựa trên google-labs-code/design.md, version: alpha)

Nguồn gốc: https://github.com/google-labs-code/design.md — spec đầy đủ tại `docs/spec.md` trong repo đó.

## 1. Cấu trúc file

Một file DESIGN.md gồm 2 lớp:

1. **YAML front matter** — token thiết kế máy đọc được, nằm giữa 2 dòng `---` ở đầu file.
2. **Markdown body** — văn xuôi giải thích lý do, tổ chức theo heading `##`.

Token là nguồn giá trị chuẩn (normative). Văn xuôi chỉ giải thích ngữ cảnh áp dụng — không được mâu thuẫn với token.

## 2. Token schema

```yaml
version: alpha              # tùy chọn, hiện tại luôn là "alpha"
name: <string>               # bắt buộc
description: <string>        # tùy chọn
colors:
  <token-name>: <Color>
typography:
  <token-name>: <Typography>
rounded:
  <scale-level>: <Dimension>
spacing:
  <scale-level>: <Dimension | number>
components:
  <component-name>:
    <token-name>: <string | token reference>
```

Lưu ý: `colors` nên có tối thiểu một token tên `primary` (linter sẽ cảnh báo `missing-primary` nếu thiếu — agent đọc file sẽ tự bịa ra màu chính nếu không có).

## 3. Kiểu token (Token Types)

| Type            | Định dạng                                                                                                          | Ví dụ                                 |
| --------------- | -------------------------------------------------------------------------------------------------------------------| -------------------------------------- |
| Color           | Bất kỳ màu CSS hợp lệ nào (hex, `rgb()`, `oklch()`, tên màu, v.v.)                                                  | `"#1A1C1E"`, `"oklch(62% 0.18 250)"`  |
| Dimension       | số + đơn vị (`px`, `em`, `rem`)                                                                                     | `48px`, `-0.02em`                     |
| Token Reference | `{path.to.token}` — trỏ tới token khác đã định nghĩa                                                               | `{colors.primary}`                    |
| Typography      | object với các field: `fontFamily`, `fontSize`, `fontWeight`, `lineHeight`, `letterSpacing`, `fontFeature`, `fontVariation` | xem ví dụ bên dưới              |

Ví dụ Typography đầy đủ:
```yaml
typography:
  h1:
    fontFamily: Public Sans
    fontSize: 3rem
    fontWeight: 700
    lineHeight: 1.1
    letterSpacing: "-0.02em"
```

## 4. Thứ tự section (bắt buộc nếu section đó xuất hiện)

Section dùng heading `##`. Có thể bỏ qua section, nhưng nếu có mặt thì PHẢI xuất hiện đúng thứ tự này (linter rule `section-order`, mức warning nếu sai thứ tự):

| # | Section            | Tên khác được chấp nhận (alias) |
| - | ------------------ | -------------------------------- |
| 1 | Overview           | Brand & Style                    |
| 2 | Colors             |                                   |
| 3 | Typography         |                                   |
| 4 | Layout             | Layout & Spacing                 |
| 5 | Elevation & Depth  | Elevation                        |
| 6 | Shapes             |                                   |
| 7 | Components         |                                   |
| 8 | Do's and Don'ts    |                                   |

Không được có 2 section trùng heading — đây là lỗi cứng (error), file sẽ bị từ chối.

## 5. Component tokens

Components ánh xạ tên tới nhóm sub-token:

```yaml
components:
  button-primary:
    backgroundColor: "{colors.tertiary}"
    textColor: "{colors.on-tertiary}"
    rounded: "{rounded.sm}"
    padding: 12px
  button-primary-hover:
    backgroundColor: "{colors.tertiary-container}"
```

Thuộc tính component hợp lệ: `backgroundColor`, `textColor`, `typography`, `rounded`, `padding`, `size`, `height`, `width`.

Biến thể (hover, active, pressed, disabled...) được biểu diễn bằng entry component RIÊNG BIỆT có tên liên quan, ví dụ `button-primary-hover`, `button-primary-active` — không lồng state vào bên trong 1 component.

## 6. Cách agent xử lý nội dung không xác định

| Tình huống                             | Hành vi                          |
| --------------------------------------- | --------------------------------- |
| Heading section lạ                      | Giữ nguyên, không báo lỗi         |
| Tên color token lạ                      | Chấp nhận nếu value hợp lệ        |
| Tên typography token lạ                 | Chấp nhận như typography hợp lệ   |
| Component property lạ                   | Chấp nhận, kèm warning            |
| Heading section trùng lặp               | Lỗi — từ chối file                |

## 7. CLI — `@google/design.md` (npm package)

Cài đặt / chạy trực tiếp:
```bash
npx @google/design.md lint DESIGN.md
npx @google/design.md diff DESIGN.md DESIGN-v2.md
npx @google/design.md export --format json-tailwind DESIGN.md > tailwind.theme.json
npx @google/design.md export --format css-tailwind DESIGN.md > theme.css
npx @google/design.md export --format dtcg DESIGN.md > tokens.json
npx @google/design.md spec --rules
```

**Lưu ý Windows/PowerShell**: nếu `npx @google/design.md ...` không có output hoặc mở nhầm trình soạn thảo Markdown, dùng alias không dấu chấm:
```bash
npx -p @google/design.md designmd lint DESIGN.md
```

### `lint`
Trả JSON gồm `findings[]` (mỗi finding có `severity`: error/warning/info, `path`, `message`) và `summary: {errors, warnings, info}`. Exit code `1` nếu có error, `0` nếu không.

### Các rule của linter (9 rules)

| Rule                 | Severity | Kiểm tra gì                                                                                   |
| -------------------- | -------- | ---------------------------------------------------------------------------------------------- |
| `broken-ref`         | error    | Token reference (`{colors.primary}`) không trỏ tới token nào tồn tại                           |
| `missing-primary`    | warning  | Có colors nhưng thiếu token `primary`                                                          |
| `contrast-ratio`     | warning  | Cặp `backgroundColor`/`textColor` của component dưới ngưỡng WCAG AA (4.5:1)                    |
| `orphaned-tokens`    | warning  | Color token định nghĩa nhưng không được component nào tham chiếu                               |
| `token-summary`      | info     | Tóm tắt số lượng token mỗi nhóm                                                                 |
| `missing-sections`   | info     | Section tùy chọn (spacing, rounded) vắng mặt dù các token khác đã có                            |
| `missing-typography` | warning  | Có colors nhưng thiếu typography token                                                         |
| `section-order`      | warning  | Section xuất hiện sai thứ tự chuẩn                                                              |
| `unknown-key`        | warning  | Key YAML cấp cao nhìn giống lỗi chính tả của key chuẩn (vd `colours:` → `colors:`)              |

### `export`
| Format          | Output | Mô tả                                                          |
| --------------- | ------ | ---------------------------------------------------------------|
| `json-tailwind` | JSON   | Tailwind v3 `theme.extend` config object                       |
| `css-tailwind`  | CSS    | Tailwind v4 `@theme {...}` block, CSS custom properties         |
| `tailwind`      | JSON   | Alias của `json-tailwind`                                      |
| `dtcg`          | JSON   | W3C Design Tokens Format Module (tokens.json)                   |

Exit code: `0` export thành công, `1` sai `--format` hoặc lỗi emitter, `2` không đọc được file input.

## 8. Trạng thái

Format đang ở `version: alpha`, có thể thay đổi. Luôn ưu tiên chạy `lint` thật (qua npx) thay vì tự đoán lỗi, vì linter là nguồn sự thật chính xác nhất.
