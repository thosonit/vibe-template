---
name: design-system-html-builder
description: Build a self-contained design-system.html file (colors, typography, buttons, cards, spacing, radius, elevation, responsive rules) from a DESIGN.md design-token file, so other AI coding agents have a rich, visual, copy-pasteable reference for building UI consistent with the brand. Use this skill whenever the user asks to "generate a design system page/site", "visualize my DESIGN.md", "create a design-system.html", "showcase my design tokens", or wants to add/extend components in an existing design-system.html. Also use it if the user uploads or references a page like a "Design System Analysis" (colors/typography/components showcase) and wants one built, extended, or updated for their own project.
---

# Design System HTML Builder

Sinh ra file `design-system.html` — một trang tĩnh, tự chứa, trình bày trực quan toàn bộ design token (màu, typography, spacing, radius, elevation, component) lấy từ file `DESIGN.md`. Mục đích của file này KHÁC với `DESIGN.md`: DESIGN.md là dữ liệu token cho agent đọc trực tiếp, còn `design-system.html` là bản trình bày trực quan đầy đủ để agent (và con người) *nhìn thấy* design system trông như thế nào trước khi code UI thật — giảm sai lệch khi áp dụng token vào layout thực tế.

Đọc `references/structure-spec.md` trước khi bắt đầu bất kỳ việc tạo/sửa file nào trong skill này — đây là đặc tả cấu trúc, quy ước đặt tên class/biến CSS, và danh mục section bắt buộc/tùy chọn. Hai file `references/example-anthropic.html` và `references/example-mongodb.html` là ví dụ thật để đối chiếu khi cần xem cách 1 pattern cụ thể được implement (mở bằng `Read` khi cần, không cần đọc toàn bộ nếu `structure-spec.md` đã đủ).

Skill có 2 chế độ: **(A) Tạo mới** và **(B) Bổ sung/mở rộng** file đã có. Xác định chế độ trước khi làm gì khác — nếu người dùng đề cập tới 1 file `design-system.html` đã tồn tại (upload, hoặc đã tạo trong phiên trước), luôn dùng chế độ B thay vì tạo lại từ đầu.

## Chế độ A — Tạo mới file design-system.html

### Bước 1 — Tìm và đọc DESIGN.md

- Tìm `DESIGN.md` trong `docs/design/` (theo cấu trúc chuẩn của project — xem `CLAUDE.md`). Nếu người dùng chỉ đường dẫn khác, đọc trực tiếp bằng `Read`.
- Nếu chưa có, hỏi người dùng cung cấp, hoặc nếu họ nói "chưa có, tạo giúp tôi luôn" thì trước tiên chạy quy trình của skill `design-md-builder` (dùng tool `Skill`) để tạo DESIGN.md, rồi mới tiếp tục.
- KHÔNG tự bịa token nếu DESIGN.md không có — thà hỏi lại còn hơn tạo ra design system sai lệch với ý định thật của người dùng.

### Bước 2 — Lập kế hoạch section

Dựa trên token và phần `components` trong DESIGN.md, xác định:
- Section lõi (luôn có — xem mục 3 trong `structure-spec.md`): Colors, Typography, Buttons, Cards, Spacing Scale, Border Radius Scale, Elevation & Depth, Responsive Behavior.
- Section tùy chọn nào có căn cứ (component đã định nghĩa trong DESIGN.md, hoặc người dùng có yêu cầu riêng): badges, forms, pricing, callout, tiles, tabs, code mockup, testimonials...

Nếu không chắc nên thêm section tùy chọn nào, hỏi nhanh người dùng qua `AskUserQuestion` (ví dụ: "Sản phẩm của bạn có cần trang pricing/testimonial trong bản showcase này không, hay chỉ cần các thành phần UI cơ bản?") thay vì tự quyết hoặc hỏi dài dòng.

### Bước 3 — Chạy quy trình frontend-design thật sự, không chỉ "tham khảo"

Gọi `Skill({skill: "frontend-design:frontend-design"})` và **thực sự đi qua quy trình 2 pha** của nó cho những phần DESIGN.md không quy định chi tiết (bố cục hero, cách minh họa icon, chi tiết hover/shadow, có nên đánh số section hay không):

1. **Brainstorm trước khi viết code**: dựa trên DESIGN.md, phác nhanh (trong thinking, không cần show hết cho người dùng) — layout hero sẽ trông ra sao, minh họa nào là "signature element" đặc trưng cho brand này (không phải khối hero chung chung), và bố cục section có nên dùng label số thứ tự hay không.
2. **Tự phản biện trước khi build**: hỏi lại — nếu output đang định làm có rơi vào 1 trong 3 "look mặc định" mà frontend-design cảnh báo không (cream+serif+terracotta; nền đen+accent neon; broadsheet với hairline + đánh số 01/02/03 khắp nơi)? Pattern `section-label` đánh số kế thừa từ 2 file mẫu tham chiếu (`example-anthropic.html`, `example-mongodb.html`) CHÍNH LÀ dạng broadsheet này — chỉ giữ cách đánh số đó nếu nó thực sự hợp lý với DESIGN.md đang xử lý (ví dụ bản thân DESIGN.md có phong cách editorial/broadsheet), còn nếu DESIGN.md mô tả 1 brand có cá tính khác hẳn (playful, tối giản phi-hairline, v.v.) thì nên bỏ số thứ tự hoặc đổi cách trình bày section cho phù hợp — đừng giữ nguyên khuôn chỉ vì đó là format của file mẫu.
3. Chỉ sau khi đã tự phản biện xong mới viết code, bám theo kế hoạch đã chốt.

File cuối cùng phải phản ánh đúng cá tính brand trong DESIGN.md — không phải một template dùng chung cho mọi brand chỉ khác màu.

### Bước 4 — Viết file

Dùng `Write` để viết `docs/design/design-system.html` (cùng thư mục với `DESIGN.md`) theo đúng skeleton, ánh xạ token, và pattern class trong `structure-spec.md`:
- Toàn bộ màu/font lấy từ biến CSS `:root`, đặt tên biến bám sát tên token gốc trong DESIGN.md (xem bảng ánh xạ mục 2 trong spec) — để agent đọc code sau này dễ đối chiếu ngược lại DESIGN.md.
- Section đánh số liên tục, đúng thứ tự lõi trước, tùy chọn chèn giữa, Responsive Behavior luôn là section cuối.
- KHÔNG copy nav-badge/footer quảng bá của công cụ gốc (xem cảnh báo đầu `structure-spec.md`) — nav và footer phải mang bản sắc của chính brand đang mô tả.
- File tự chứa hoàn toàn: 1 khối `<style>` duy nhất, không phụ thuộc framework ngoài, chỉ load Google Fonts nếu DESIGN.md có chỉ định font ngoài hệ thống.

### Bước 5 — Present

Báo lại ngắn gọn cho người dùng: đường dẫn file vừa ghi (`docs/design/design-system.html`), bao nhiêu section, những gì suy luận thêm ngoài DESIGN.md gốc (nếu có) và vì sao.

## Chế độ B — Bổ sung / mở rộng component vào file đã có

Dùng khi người dùng nói kiểu "thêm cho tôi 1 component X vào design-system.html", "bổ sung phần Y", "thêm UI cho Z".

### Bước 1 — Đọc cả 2 nguồn sự thật

1. Đọc `DESIGN.md` liên quan để lấy token/rule chuẩn (màu, font, rounded, spacing đã định nghĩa). Nếu component mới cần token/màu chưa có trong DESIGN.md, KHÔNG tự bịa — hỏi người dùng: dùng tạm token gần nhất đã có, hay cập nhật DESIGN.md trước (và nếu cập nhật, chạy lại lint qua skill `design-md-builder` nếu có).
2. Đọc file `design-system.html` hiện có (bằng `Read`) để lấy: danh sách biến CSS đang dùng trong `:root`, quy ước class hiện tại, số thứ tự section cuối cùng trước "Responsive Behavior".

### Bước 2 — Xây component mới đúng quy ước sẵn có, vẫn qua lăng kính frontend-design

Ngay cả khi bổ sung, không tắt tư duy thẩm mỹ: gọi `Skill({skill: "frontend-design:frontend-design"})` (đặc biệt phần "Restraint and self-critique") để component mới không bị lạc tông so với phần còn lại — cùng mức độ chi tiết, cùng ngôn ngữ hover/shadow, không mang thêm 1 "signature element" mới cạnh tranh với cái đã có.

Theo mục 6 của `structure-spec.md`:
- Section mới chèn TRƯỚC section "Responsive Behavior", đánh số tiếp theo số cuối +1.
- Style mới nối vào cuối khối `<style>` hiện có (không tạo `<style>` thứ hai), tái sử dụng đúng biến `:root` đã có thay vì viết mã hex trực tiếp.
- Giữ đúng pattern header section (`section-label` + `section-heading` + `section-intro`) và pattern grid/gap tương tự các section cùng loại đã có (vd nếu thêm biến thể button, dùng lại `.button-grid`/`.button-cell` hiện có thay vì tạo class song song).
- Nếu section đủ quan trọng, thêm mục vào `.nav-links` trỏ tới `id` mới.

### Bước 3 — Chèn bằng Edit và kiểm tra lại

Dùng `Edit` để chèn section mới ngay trước `<section id="responsive">` (hoặc thẻ tương đương), và chèn CSS mới ngay trước thẻ đóng `</style>`. Sau khi chèn, xem lại nhanh 2 breakpoint media query hiện có để đảm bảo section mới không vỡ layout ở mobile — nếu component mới dùng grid nhiều cột, thêm dòng thu gọn cột vào đúng media query hiện có thay vì bỏ qua.

### Bước 4 — Present

Báo lại ngắn gọn: phần vừa thêm vào `design-system.html` và section số bao nhiêu.

## Lưu ý chung

- File `design-system.html` không chứa logic tương tác thật (không cần JS) trừ khi người dùng yêu cầu rõ một demo có thể click/tương tác — mục tiêu chính là trình bày trực quan token + component, không phải xây 1 website hoạt động đầy đủ.
- Nếu DESIGN.md ở trạng thái chưa lint sạch (còn error), nên báo cho người dùng biết trước khi build design-system.html từ nó, vì lỗi token (`broken-ref`...) sẽ khiến trang hiển thị sai.
- Không giới hạn cứng phải đủ 13-17 section như 2 file mẫu — số lượng section phụ thuộc vào độ phong phú thật của DESIGN.md đầu vào.
