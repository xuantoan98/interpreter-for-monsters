# Game Design & Implementation Brief
## Phiên dịch cho quái vật (Monster Translator)

> Tài liệu yêu cầu dành cho AI coding agent. Đọc toàn bộ trước khi thay đổi source code. Dùng tài liệu này làm cơ sở để phân tích, thiết kế, triển khai và kiểm thử MVP. Không tự ý mở rộng phạm vi hoặc thay đổi gameplay cốt lõi khi chưa có xác nhận.

---

## 1. Tổng quan sản phẩm

**Tên concept:** Phiên dịch cho quái vật (Monster Translator)<br>
**Thể loại:** Casual Puzzle / Simulation / Adventure / Comedy<br>
**Nền tảng mục tiêu:** Android trước, phát triển bằng Flutter; giữ tương thích iOS nhưng chưa phát hành iOS trong MVP.<br>
**Định hướng trải nghiệm:** Dễ tiếp cận, vui nhộn, giàu biểu cảm, khuyến khích khám phá và thử nghiệm.

### Ý tưởng cốt lõi

Người chơi vào vai một phiên dịch viên có khả năng giao tiếp với các loài quái vật. Quái vật không nói bằng ngôn ngữ của con người mà truyền đạt thông tin qua:

- Hình ảnh và biểu tượng.
- Màu sắc, hình dạng và trạng thái cơ thể.
- Âm thanh, âm vực và nhịp điệu.
- Cử chỉ, tư thế và chuyển động.
- Sự kết hợp của nhiều tín hiệu trong một ngữ cảnh.

Người chơi quan sát tín hiệu, suy luận ý nghĩa, chọn cách diễn giải và đưa ra phản hồi. Qua nhiều thử thách, người chơi dần học được “ngôn ngữ” của từng loài.

**Nguyên tắc trải nghiệm quan trọng:** Hiểu sai không đồng nghĩa với thua ngay. Sai lầm có thể tạo ra phản ứng bất ngờ, hài hước hoặc làm thay đổi tình huống. Game cần khiến người chơi cảm thấy họ đang học cách giao tiếp với một sinh vật sống, không chỉ làm bài trắc nghiệm.

---

## 2. Mục tiêu thiết kế

1. Người chơi hiểu cách chơi trong lần tương tác đầu tiên, không cần đọc hướng dẫn dài.
2. Mỗi lượt chơi ngắn, mục tiêu khoảng **30–90 giây**.
3. Tín hiệu trực quan, dễ quan sát và có thể kết hợp để tạo độ sâu.
4. Phản ứng của quái vật phải có cá tính, thể hiện rõ qua animation, biểu cảm và âm thanh.
5. Người chơi cảm nhận được tiến bộ nhờ từ điển, kiến thức đã mở khóa và thử thách mới.
6. Có thể bổ sung loài quái vật, tín hiệu, tình huống và nội dung mà không phải viết lại kiến trúc cốt lõi.

---

## 3. Vòng lặp gameplay chính

Mỗi thử thách gồm các bước:

1. **Gặp quái vật:** Hiển thị nhân vật, bối cảnh và trạng thái ban đầu.
2. **Nhận tín hiệu:** Quái vật biểu đạt thông điệp bằng một hoặc nhiều tín hiệu.
3. **Giải mã:** Người chơi chọn ý nghĩa mà họ cho là phù hợp.
4. **Phản hồi:** Người chơi chọn hành động hoặc phản hồi để gửi lại quái vật.
5. **Kết quả:** Quái vật phản ứng theo lựa chọn và ngữ cảnh.
6. **Học từ mới:** Game giải thích tín hiệu, cập nhật từ điển hoặc cung cấp manh mối.
7. **Tiếp tục:** Chuyển sang thử thách tiếp theo hoặc màn tổng kết.

### Phân biệt hai quyết định

Không gộp hai bước sau thành một nếu không có lý do UX rõ ràng:

- **Diễn giải:** “Quái vật đang muốn nói điều gì?”
- **Phản hồi:** “Tôi nên làm gì hoặc nói gì với nó?”

Sự tách biệt này tạo cảm giác giao tiếp hai chiều và cho phép thiết kế nhiều tình huống hài hước.

---

## 4. Hệ thống ngôn ngữ của quái vật

Mỗi loài sở hữu một bộ quy tắc tín hiệu riêng. Không dùng một bộ từ vựng chung cho tất cả loài.

### Các nhóm ý nghĩa

| Nhóm | Ví dụ |
|---|---|
| Cảm xúc | Vui, buồn, sợ hãi, tức giận |
| Nhu cầu | Đói, khát, nghỉ ngơi |
| Hành động | Đi, đến, dừng lại, giúp đỡ |
| Đối tượng | Bạn bè, thức ăn, kẻ thù |
| Trạng thái | Nguy hiểm, an toàn, cô đơn |

### Ví dụ loài quái vật

| Loài | Phương thức giao tiếp chính |
|---|---|
| Bram | Nhịp sáng ở cổ, vòng đuôi, cử chỉ móng và tiếng kêu trầm |
| Vesper | Tiếng kêu, nhịp điệu, âm vực |
| Quái vật Đá | Cử chỉ, tư thế, chuyển động cơ thể |
| Quái vật Lửa | Cường độ, màu ngọn lửa, nhịp bùng cháy |
| Quái vật Bóng Tối | Bóng đổ, hình ảnh và ký hiệu |

### Ví dụ quy tắc của Bram

| Tín hiệu | Ý nghĩa ví dụ |
|---|---|
| Cổ sáng ba nhịp + nhìn giỏ rỗng | Đói |
| Ánh cổ dịu + móng với về cốc rỗng | Khát |
| Vẫy móng + ba vòng đuôi sáng | Muốn người chơi đi theo |
| Cổ vẫn sáng vàng + đuôi cuộn ôm thân | Sợ hãi |

Các quy tắc trên là dữ liệu ví dụ cho prototype, không phải quy luật bắt buộc cho mọi màn. Tín hiệu phải được xét theo **ngữ cảnh và tổ hợp**, tránh việc một màu hoặc một cử chỉ luôn có duy nhất một nghĩa trong mọi tình huống.

### Quy tắc thiết kế nội dung

- Mỗi tín hiệu phải có mô tả, biểu hiện hình ảnh/âm thanh và ý nghĩa được định nghĩa trong dữ liệu.
- Mỗi câu đố phải có đáp án dự kiến và giải thích sau khi người chơi chọn.
- Nhiễu/đáp án sai phải hợp lý, không được mơ hồ đến mức người chơi không thể suy luận.
- Khi giới thiệu tín hiệu mới, cần có hướng dẫn hoặc ví dụ trước khi yêu cầu người chơi kết hợp nhiều tín hiệu.
- Không phụ thuộc hoàn toàn vào màu sắc để truyền tải thông tin; cần thêm hình dạng, biểu tượng hoặc chuyển động để dễ tiếp cận.

---

## 5. Phản hồi và xử lý câu trả lời

Thiết kế tối thiểu ba nhóm kết quả:

### A. Diễn giải phù hợp
- Quái vật thể hiện vui vẻ, đồng tình hoặc thực hiện hành động phù hợp.
- Hiển thị lời giải thích ngắn.
- Ghi nhận kiến thức/từ vựng mới nếu có.

### B. Diễn giải chưa phù hợp
- Không Game Over ngay.
- Quái vật phản ứng hài hước hoặc thể hiện rằng người chơi chưa hiểu đúng.
- Cung cấp manh mối giúp người chơi suy luận lại.
- Cho phép thử lại trong cùng thử thách nếu thiết kế màn chơi yêu cầu.

### C. Diễn giải tạo ra kết quả bất ngờ
- Một lựa chọn có thể tạo ra tình huống vui nhộn hoặc nhánh phản ứng đặc biệt.
- Phản ứng phải được thiết kế có chủ đích, không phải kết quả ngẫu nhiên thiếu logic.
- Có thể thưởng nội dung khám phá hoặc phản ứng hiếm, nhưng không làm người chơi hiểu sai quy tắc cốt lõi.

**Nguyên tắc:** Sai lầm là một phần của trải nghiệm học ngôn ngữ. Tránh phạt nặng, mất tiến trình hoặc kết thúc màn chơi đột ngột chỉ vì một lựa chọn sai.

---

## 6. Từ điển và tiến trình học

Mỗi loài có một trang từ điển riêng.

Thông tin một mục từ nên gồm:

- Tên/nhãn tín hiệu.
- Hình minh họa hoặc animation mẫu.
- Âm thanh mẫu nếu có.
- Ý nghĩa đã khám phá.
- Tổ hợp/ngữ cảnh liên quan.
- Trạng thái: chưa khám phá, đã gặp, đã hiểu.

Ví dụ:

| Tín hiệu Bram | Ý nghĩa | Trạng thái |
|---|---|---|
| Cổ sáng vàng | Chưa đủ để xác định ý nghĩa | Đã gặp |
| Ba nhịp sáng | Có thể là lời yêu cầu | Đã gặp |
| Ba nhịp sáng + giỏ rỗng | Đói | Đã học |
| Ba vòng sáng ở đuôi | Chưa xác định | Chưa học |

Không tiết lộ toàn bộ đáp án trong từ điển trước khi người chơi khám phá. Với mục chưa biết, chỉ hiển thị manh mối phù hợp.

### Tiến trình theo loài

Đề xuất cấu trúc 5 cấp độ cho mỗi loài:

1. Làm quen tín hiệu đơn giản.
2. Kết hợp hai tín hiệu.
3. Giải mã thông điệp phức tạp hơn.
4. Giao tiếp trong tình huống thực tế.
5. Hội thoại/tình huống tổng hợp.

Phần thưởng có thể gồm:
- Mở khóa mục từ điển.
- Điểm kinh nghiệm.
- Huy hiệu phiên dịch.
- Câu chuyện hoặc tương tác đặc biệt.
- Loài hoặc nhân vật mới.

---

## 7. Phạm vi MVP

Không xây dựng toàn bộ thế giới ngay từ đầu. Ưu tiên kiểm chứng vòng lặp gameplay.

### Phạm vi nội dung đã chốt

| Hạng mục | MVP |
|---|---|
| Loài quái vật | 2 |
| Nhân vật | 3–4 |
| Tín hiệu/từ vựng | Tổng 8–12 cho cả hai loài |
| Thử thách | Khoảng 11: Bram 5–7 (mốc thiết kế 6), Vesper khoảng 5 |
| Lựa chọn diễn giải | Thường có 3 lựa chọn |
| Kết quả | Phù hợp, chưa phù hợp, phản ứng đặc biệt |
| Từ điển | Có |
| Tiến trình | Có mở khóa cơ bản |
| Âm thanh/animation | Đủ để thể hiện tín hiệu và phản ứng |

### Gợi ý phạm vi hai loài đầu tiên

- **Bram:** Quái vật rừng chibi dùng nhịp sáng ở cổ, ba vòng đuôi, móng, tư thế và tiếng kêu. Phù hợp để hướng dẫn người chơi.
- **Vesper:** Dùng âm thanh, nhịp điệu và âm vực. Dùng để kiểm tra khả năng mở rộng sang phương thức giao tiếp khác.

### Các màn hình MVP

1. **Màn hình chính:** Bắt đầu, tiến trình, từ điển và thông tin lượt chơi (nếu cơ chế lượt được chốt).
2. **Màn hình gặp quái vật:** Nhân vật, bối cảnh, trạng thái và tín hiệu giao tiếp.
3. **Màn hình giải mã:** Các lựa chọn ý nghĩa, thao tác chọn và xác nhận.
4. **Màn hình phản hồi/kết quả:** Animation phản ứng, giải thích và nút tiếp tục/thử lại.
5. **Màn hình từ điển:** Danh sách tín hiệu và trạng thái khám phá.
6. **Màn hình tổng kết:** Kết quả thử thách, kiến thức mới và phần thưởng.

Có thể gộp giải mã và phản hồi thành các trạng thái trong cùng một màn hình nếu trải nghiệm rõ ràng; không bắt buộc tạo nhiều route chỉ để tách bước.

---

## 8. Cơ chế lượt chơi và quảng cáo — quyết định MVP

MVP không giới hạn lượt, không có năng lượng và không có quảng cáo, kể cả quảng cáo mô phỏng. Người chơi được thử lại ngay trong cùng thử thách. Mỗi lựa chọn sai cần có phản ứng hài hước và một manh mối mới; sau khi trả lời đúng, game giải thích tín hiệu rồi mới cho chuyển tiếp.

---

## 9. Yêu cầu UX/UI

### Định hướng hình ảnh
- Nhân vật dễ thương, biểu cảm rõ, có cá tính.
- Không khí kỳ ảo, thân thiện và hài hước; tránh tạo cảm giác kinh dị.
- Tín hiệu giao tiếp phải nổi bật và dễ phân biệt.
- Giao diện ưu tiên nội dung nhân vật và tín hiệu, hạn chế chi tiết trang trí gây nhiễu.
- Thiết kế mobile-first, thao tác thuận tiện bằng một tay khi phù hợp.
- Có trạng thái loading, empty, locked, success, retry và error rõ ràng.

### Nguyên tắc tương tác
- Vùng chạm đủ lớn.
- Phản hồi trực quan ngay sau thao tác.
- Không dùng màu sắc làm dấu hiệu duy nhất.
- Nội dung hướng dẫn ngắn, xuất hiện đúng thời điểm.
- Có thể tắt/giảm âm thanh; tín hiệu âm thanh quan trọng cần có phương án hỗ trợ bằng hình ảnh hoặc nhịp hiển thị.
- Phong cách đã chốt: 2D dễ thương, nét rõ, màu kỳ ảo; từng nhân vật có biểu cảm và cá tính riêng. Âm thanh ngắn, đặc trưng cho loài; mọi tín hiệu âm thanh quan trọng đều có biểu hiện trực quan thay thế.

---

## 10. Định hướng kỹ thuật cho AI coding agent

Trước khi code:

1. Kiểm tra cấu trúc repository, framework, phiên bản Flutter/Dart và quy ước hiện tại.
2. Đọc README, tài liệu dự án, kiến trúc, assets và các test đang có.
3. Xác định phần nào có thể tái sử dụng; không thay thế cấu trúc đang hoạt động nếu không cần thiết.
4. Viết kế hoạch triển khai theo từng giai đoạn và liệt kê các giả định.
5. Nếu có quyết định sản phẩm chưa được xác nhận (đặc biệt cơ chế lượt/quảng cáo), giữ thành cấu hình hoặc để ngoài phạm vi.

### Kiến trúc đề xuất

Ưu tiên tách dữ liệu nội dung khỏi UI và logic:

- **Game content/models:** Loài quái vật, tín hiệu, câu đố, lựa chọn, kết quả và phần thưởng.
- **Game engine/logic:** Đánh giá lựa chọn, xác định phản ứng, cập nhật tiến trình.
- **State management:** Trạng thái thử thách hiện tại, lựa chọn, kết quả, từ điển và tiến trình.
- **Screens/widgets:** Màn hình và component giao diện có thể tái sử dụng.
- **Persistence:** Lưu tiến trình cục bộ cho MVP.
- **Assets/audio:** Quản lý hình ảnh, animation và âm thanh theo ID; không hard-code đường dẫn rải rác trong widget.

Tên thư mục/lớp cụ thể phải tuân theo cấu trúc hiện có của repository. Không áp đặt package hoặc state-management library mới nếu dự án đã có lựa chọn phù hợp.

### Mô hình dữ liệu tối thiểu

Một thử thách cần biểu diễn được:

- `id`
- `speciesId`
- `monsterId`
- `signals`: danh sách tín hiệu theo thứ tự hoặc theo nhóm
- `prompt`
- `interpretationOptions`
- `correctInterpretationId`
- `responseOptions`
- `outcomes`: ánh xạ lựa chọn/phản hồi sang kết quả
- `explanation`
- `unlockedVocabularyIds`
- `difficulty`

Một tín hiệu cần có:

- `id`
- `speciesId`
- `name`
- `description`
- `visualAsset`
- `audioAsset` (có thể null)
- `meaning`
- `contextRules` (nếu có)

Không bắt buộc dùng đúng tên field trên nếu dự án có convention khác, nhưng phải giữ đủ khả năng biểu diễn nội dung.

### Quy tắc triển khai

- Nội dung thử thách nên được định nghĩa bằng dữ liệu, tránh viết cứng từng màn trong UI.
- Logic chấm/đánh giá phải có unit test.
- Tách logic giải mã và logic phản hồi.
- Không gọi API hoặc dùng backend nếu MVP chưa cần.
- Xử lý trường hợp asset thiếu, dữ liệu không hợp lệ và trạng thái chưa có tiến trình.
- Không thêm dependency lớn chỉ để giải quyết một chức năng nhỏ.
- Code phải dễ mở rộng thêm loài, tín hiệu và thử thách.

---

## 11. Kế hoạch thực thi đề xuất

### Phase 1 — Audit và lập kế hoạch
- Phân tích repository.
- Xác định kiến trúc, dependencies và cách chạy app/test.
- Báo cáo rủi ro và kế hoạch thay đổi.
- Không sửa code trước khi hiểu cấu trúc hiện tại.

### Phase 2 — Thiết kế UX và component
- Chốt flow từ màn hình chính đến một thử thách hoàn chỉnh.
- Xác định layout, typography, màu sắc, button, card, dialog và trạng thái.
- Ưu tiên hoàn thiện các màn hình gameplay cốt lõi trước.

### Phase 3 — Xây dựng dữ liệu và game logic
- Tạo model cho loài, tín hiệu, thử thách, lựa chọn và kết quả.
- Tạo dữ liệu mẫu cho Bram.
- Viết logic đánh giá và phản hồi.
- Viết unit test cho các trường hợp đúng, sai và phản ứng đặc biệt.

### Phase 4 — Xây dựng vertical slice (đang thực hiện)
Triển khai một vòng chơi hoàn chỉnh có thể chạy được:
- Gặp Bram.
- Nhận tín hiệu.
- Chọn diễn giải.
- Chọn phản hồi.
- Xem animation/kết quả.
- Nhận giải thích và mở khóa từ vựng.

Không mở rộng số lượng màn chơi trước khi vertical slice hoạt động tốt. Vertical slice đầu tiên là một thử thách Bram hoàn chỉnh, gồm cả đường trả lời sai, thử lại, giải thích và cập nhật từ điển.

### Phase 5 — Mở rộng MVP
- Sau khi kiểm chứng vòng lặp, hoàn thiện chặng làm quen Bram trong 5–7 thử thách (mốc thiết kế 6).
- Sau đó thêm Vesper với khoảng 5 thử thách, đưa tổng tín hiệu hai loài lên 8–12.
- Hoàn thiện từ điển và tiến trình.
- Bổ sung lưu dữ liệu cục bộ.

### Phase 6 — Kiểm thử và hoàn thiện
- Kiểm tra trên kích thước màn hình mobile phổ biến.
- Kiểm tra thao tác, trạng thái, animation và âm thanh.
- Kiểm tra dữ liệu thiếu hoặc lựa chọn không hợp lệ.
- Chạy formatter, analyzer và toàn bộ test.
- Sửa lỗi trước khi báo hoàn thành.

---

## 12. Tiêu chí nghiệm thu MVP

MVP chỉ được xem là hoàn thành khi:

- [ ] Người chơi có thể bắt đầu một thử thách từ màn hình chính.
- [ ] Quái vật hiển thị được ít nhất một tổ hợp tín hiệu.
- [ ] Người chơi có thể chọn cách diễn giải.
- [ ] Người chơi có thể chọn phản hồi.
- [ ] Game hiển thị kết quả phù hợp với lựa chọn.
- [ ] Câu trả lời sai không gây Game Over ngay lập tức.
- [ ] Có giải thích giúp người chơi hiểu tín hiệu.
- [ ] Từ điển cập nhật sau khi khám phá.
- [ ] Tiến trình cơ bản được lưu và khôi phục sau khi mở lại app.
- [ ] Có ít nhất một vòng chơi hoàn chỉnh với nội dung Bram.
- [ ] Nội dung MVP có 5–7 thử thách Bram (mốc thiết kế 6), khoảng 5 thử thách Vesper và tổng 8–12 tín hiệu sau khi vertical slice được kiểm chứng.
- [ ] Giao diện hoạt động trên các kích thước màn hình mobile mục tiêu.
- [ ] Không có lỗi nghiêm trọng trong luồng gameplay.
- [ ] Formatter, analyzer và test hiện có đều chạy thành công.

---

## 13. Ngoài phạm vi MVP

Không tự triển khai các hạng mục sau nếu chưa được yêu cầu:

- Multiplayer hoặc bảng xếp hạng online.
- Tài khoản, đăng nhập và đồng bộ cloud.
- AI tạo ngôn ngữ/quái vật theo thời gian thực.
- Hội thoại tự do bằng microphone.
- Hệ thống quảng cáo thật và thanh toán trong ứng dụng.
- Hàng chục loài quái vật hoặc cốt truyện dài.
- Backend riêng khi lưu trữ cục bộ đã đáp ứng MVP.

---

## 14. Chỉ dẫn cuối cho AI agent

Hãy làm việc theo nguyên tắc **phân tích trước, triển khai từng phần, kiểm thử liên tục**.

Khi bắt đầu:
1. Đọc tài liệu này và kiểm tra repository.
2. Tóm tắt hiện trạng dự án.
3. Đề xuất kế hoạch triển khai phù hợp với codebase.
4. Nêu rõ các giả định hoặc điểm còn cần xác nhận.
5. Bắt đầu từ một vertical slice có thể chơi được, không tạo hàng loạt màn hình tĩnh.
6. Sau mỗi phase, báo cáo file đã thay đổi, chức năng đã hoàn thành, test đã chạy và vấn đề còn tồn tại.

Không tuyên bố một chức năng đã hoàn thành nếu chưa chạy hoặc kiểm thử được. Không tự ý thay đổi concept cốt lõi: **người chơi học ngôn ngữ của từng loài thông qua tín hiệu, suy luận, phản hồi và những kết quả giàu biểu cảm/hài hước.**
