---
name: design-md-builder
description: Build, lint, fix, and export DESIGN.md files — Google's open format for describing a visual identity/design system (colors, typography, spacing, components) to AI coding agents. Use this skill whenever the user wants to create a design system file, a DESIGN.md, a brand style guide for AI agents, wants to define design tokens for their project, mentions "DESIGN.md", "design tokens for agents", or wants to export a design system to Tailwind/DTCG/tokens.json. Also use it if the user has an existing DESIGN.md they want validated, linted, fixed, or updated.
---

# DESIGN.md Builder

Xây dựng file `DESIGN.md` đúng chuẩn đặc tả mở của Google (`google-labs-code/design.md`, hiện ở `version: alpha`) — file mô tả hệ thống thiết kế (design tokens + rationale) cho AI coding agent đọc và tạo UI nhất quán.

Quy trình có 4 bước cố định. Không bỏ qua bước lint — đó là bước đảm bảo file thực sự hợp lệ theo spec, không chỉ "trông giống".

## Bước 1 — Hỏi mong muốn của người dùng

Trước khi viết bất kỳ dòng token nào, cần nắm được các thông tin cốt lõi. Nếu người dùng đã cung cấp sẵn trong yêu cầu (ví dụ đã đưa mã màu, tên brand, phong cách...), đừng hỏi lại — chỉ hỏi phần còn thiếu.

Dùng `ask_user_input_v0` để thu thập nhanh (người dùng chọn nút thay vì gõ), tối đa 3 câu hỏi/lần gọi. Ưu tiên hỏi theo nhóm sau, có thể chia làm 2 lượt gọi nếu cần:

**Lượt 1 — định hướng phong cách:**
- Tên/thương hiệu của design system này là gì? (nếu chưa có tên, đề xuất cho họ chọn hoặc để trống rồi tự đặt tên gợi tả)
- Vibe/phong cách tổng thể: ví dụ Minimalist/Editorial, Playful/Vibrant, Corporate/Trust, Dark & Techy, Warm & Organic... (hỏi qua `ask_user_input_v0` dạng single_select với vài lựa chọn gợi ý + để họ mô tả thêm bằng câu tự do nếu muốn)
- Có brand màu/logo sẵn có cần bám theo không, hay để Claude đề xuất palette mới?

**Lượt 2 — chi tiết kỹ thuật (nếu người dùng có vẻ rành kỹ thuật hoặc dự án đã có sẵn stack):**
- Có đang dùng Tailwind, hay framework CSS nào cụ thể không? (ảnh hưởng tới việc có nên chuẩn bị sẵn để export sau)
- Có component cụ thể nào cần định nghĩa token riêng ngay từ đầu không (button, card, input...) hay để mặc định vài component phổ biến?
- Font chữ ưu tiên (nếu có), hay để Claude đề xuất theo vibe đã chọn?

Nếu người dùng chỉ nói kiểu "làm giúp tôi 1 file DESIGN.md cho app fintech nghiêm túc" — đây đã đủ ngữ cảnh để suy luận hợp lý (nghiêm túc/trust → neutral + 1 accent, sans-serif rõ ràng). Hỏi tối thiểu 1 câu để xác nhận thay vì hỏi dồn dập, rồi tiến hành với giả định hợp lý, nêu rõ giả định đó trong câu trả lời.

## Bước 2 — Xây dựng file DESIGN.md

Đọc `references/spec.md` (đặc tả đầy đủ đã được tóm gọn) trước khi viết file nếu đây là lần đầu trong phiên làm việc, để đảm bảo bám sát:

- **Token schema** đúng field: `version`, `name`, `description`, `colors`, `typography`, `rounded`, `spacing`, `components`.
- **colors** phải có ít nhất token `primary` (nếu thiếu, linter sẽ cảnh báo và agent khác sẽ tự bịa màu).
- **typography** nên có ít nhất 1-2 token (ví dụ `h1`, `body-md`) — thiếu hoàn toàn sẽ khiến agent dùng font mặc định.
- **components** nên tham chiếu ngược lại `colors`/`typography`/`rounded` bằng cú pháp `{colors.primary}` thay vì lặp giá trị thô — tránh bị cảnh báo `orphaned-tokens` và giữ file dễ bảo trì khi đổi màu.
- **Thứ tự section markdown** (`##`) PHẢI theo đúng: Overview → Colors → Typography → Layout → Elevation & Depth → Shapes → Components → Do's and Don'ts. Có thể bỏ qua section nào không cần thiết, nhưng không được đảo thứ tự các section đã chọn viết.
- Mỗi section nên có 2-5 câu/gạch đầu dòng giải thích **lý do** (why), không chỉ liệt kê lại giá trị token đã có trong YAML — đó là điểm khác biệt giữa DESIGN.md tốt và DESIGN.md hời hợt.
- Viết file bằng `create_file` vào `/mnt/user-data/outputs/DESIGN.md` (hoặc tên khác nếu người dùng có nhiều design system trong cùng dự án, ví dụ `DESIGN-dark.md`).

## Bước 3 — Lint và tự sửa

Đây là bước bắt buộc, không tự đánh giá "chắc đúng rồi" bằng mắt — luôn chạy linter thật:

```bash
npx -y @google/design.md lint /mnt/user-data/outputs/DESIGN.md 2>&1 | grep -v "npm error config prefix"
```

(Dòng `npm error config prefix cannot be changed...` là nhiễu vô hại từ môi trường sandbox, không phải lỗi thật — luôn lọc bỏ dòng đó khi đọc output, đừng hiểu nhầm thành lỗi của file.)

Kết quả trả về JSON gồm `findings[]` (mỗi finding có `severity`: `error`/`warning`/`info`) và `summary`. Xử lý theo severity:

- **`error`** (ví dụ `broken-ref` — token reference trỏ tới token không tồn tại): PHẢI sửa ngay bằng `str_replace`, đây là lỗi làm file không hợp lệ.
- **`warning`**: nên sửa nếu hợp lý (ví dụ `missing-primary`, `missing-typography`, `contrast-ratio` dưới chuẩn WCAG AA 4.5:1, `section-order` sai thứ tự, `unknown-key` — có thể là lỗi gõ nhầm như `colours:` thay vì `colors:`). Với `orphaned-tokens` (màu định nghĩa nhưng không component nào dùng), cân nhắc: nếu là màu semantic dự phòng (success/warning/error) có thể giữ nguyên và giải thích trong response, không bắt buộc phải xóa hay gán gượng ép vào component.
- **`info`**: chỉ mang tính tham khảo (ví dụ `token-summary`), không cần hành động.

Sau khi sửa, chạy lại lint để xác nhận `errors: 0`. Lặp lại tối đa vài lần cho tới khi sạch lỗi. Nếu còn warning có chủ đích giữ lại, nói rõ với người dùng lý do thay vì im lặng bỏ qua.

Tóm tắt ngắn gọn kết quả lint cho người dùng (số lỗi/cảnh báo đã sửa, còn gì giữ nguyên và vì sao) — không dán nguyên JSON thô vào câu trả lời.

## Bước 4 — Xuất sang định dạng khác (chỉ khi được yêu cầu)

Không tự động thực hiện bước này trừ khi người dùng hỏi hoặc đã cho biết stack của họ ở Bước 1 (ví dụ "tôi dùng Tailwind"). Nếu có tín hiệu đó, có thể chủ động hỏi 1 câu ngắn gọn kiểu "Bạn có muốn mình xuất luôn sang Tailwind config không?" thay vì tự ý xuất file thừa.

Các lệnh export:

```bash
# Tailwind v4 (CSS @theme block) — phổ biến nhất cho dự án mới
npx -y @google/design.md export --format css-tailwind /mnt/user-data/outputs/DESIGN.md > /mnt/user-data/outputs/theme.css

# Tailwind v3 (theme.extend JSON, dùng trong tailwind.config.js)
npx -y @google/design.md export --format json-tailwind /mnt/user-data/outputs/DESIGN.md > /mnt/user-data/outputs/tailwind.theme.json

# W3C DTCG tokens.json — dùng khi cần tương thích Figma Variables / Storybook
npx -y @google/design.md export --format dtcg /mnt/user-data/outputs/DESIGN.md > /mnt/user-data/outputs/tokens.json
```

Sau khi export, dùng `present_files` để đưa (các) file kết quả cho người dùng — luôn kèm cả `DESIGN.md` gốc lẫn file export, không chỉ file export đơn lẻ.

Nếu người dùng muốn so sánh với phiên bản cũ (đã sửa design system trước đó), dùng lệnh `diff`:

```bash
npx -y @google/design.md diff DESIGN-v1.md DESIGN-v2.md 2>&1 | grep -v "npm error config prefix"
```

## Ghi chú quan trọng

- Định dạng đang ở `version: alpha` — có thể thay đổi. Nếu lệnh CLI trả về lỗi lạ không khớp với `references/spec.md`, khả năng cao package đã cập nhật; cân nhắc chạy `npx -y @google/design.md spec --rules` để lấy spec mới nhất trực tiếp từ CLI thay vì chỉ tin vào tài liệu tĩnh.
- Không cần cài đặt package trước — luôn dùng `npx -y @google/design.md ...`, package sẽ tự tải từ npm registry (đã được whitelist trong môi trường).
- Nếu người dùng chỉ muốn xem/hiểu spec chứ chưa muốn tạo file, có thể trả lời trực tiếp từ `references/spec.md` mà không cần chạy CLI hay tạo file.
