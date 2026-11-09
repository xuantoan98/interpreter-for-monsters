# Hướng mỹ thuật game — Bram và Vesper

Trạng thái: sáu cuộc gặp Bram và năm cuộc gặp Vesper đã có hình chơi được. Các ảnh xem trước được render ở 430 × 932 px.

## Cơ sở thiết kế

- Nghiên cứu về nhân vật trong game học tập cho thấy biểu cảm có tác động lớn lên cảm xúc người chơi. Suy ra: mỗi kết quả cần thay rõ nét mặt và tư thế của Bram. [Learning and Instruction](https://www.sciencedirect.com/science/article/pii/S0959475217304139).
- Nghiên cứu eye tracking về game giải vấn đề cho trẻ gợi ý màu và chuyển động giúp hướng chú ý. Suy ra: cổ và các vòng đuôi phát sáng của Bram là trọng tâm hình ảnh khi có tín hiệu. Kết quả này cần được kiểm chứng với người chơi của game. [UCL Discovery](https://discovery.ucl.ac.uk/id/eprint/10143343/).
- Tín hiệu quan trọng cần có hơn một cách thể hiện. Ánh sáng đi kèm nhịp vạch, tư thế và chữ; tiếng kêu luôn có mô tả trực quan. [Xbox Accessibility Guideline 103](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/103), [Guideline 104](https://learn.microsoft.com/en-us/gaming/accessibility/xbox-accessibility-guidelines/104).

## Nhân vật và ngôn ngữ

**Bram** là quái vật rừng cỡ lớn với tỷ lệ chibi: thân tròn phủ vảy teal, rêu và hoa nhỏ, hai vây sừng cam phát sáng, mắt hổ phách, một răng nanh, móng nhỏ, túi sáng ở cổ và ba vòng sáng trên đuôi cuộn. Dáng đầu to, chân ngắn và nét mặt cởi mở giữ nhân vật thân thiện. Kích thước và chi tiết vẫn đủ để đọc rõ ở màn hình điện thoại.

**Vesper** là quái vật cú lai rồng với lông chàm tím, cặp sừng trăng, ba mắt, cánh có ngón, đuôi sao và những vòng sáng ở cổ. Tạo hình có năm tư thế theo tình huống cùng biểu cảm vui/bối rối. [Concept quái vật tím](concepts/thorn_chibi_beast.png) ngoài MVP mang tên **Thorn**. [Concept Bram](concepts/bram_chibi_kaiju.png) và asset `ram_*` thể hiện cùng một nhân vật; tên asset và ID cũ vẫn giữ để bảo toàn tiến độ đã lưu.

Bram giao tiếp bằng **nhịp sáng ở cổ, thứ tự sáng trên đuôi, cử chỉ móng, tư thế và tiếng kêu trầm ngắn**. Cùng ánh cổ vàng có thể đi với giỏ rỗng để nói “đói”, hoặc đi với đuôi cuộn ôm thân để nói “sợ”. Luật được giải thích sau khi người chơi trả lời đúng; không dùng màu làm đáp án duy nhất.

Vesper giao tiếp bằng **cao độ và số nhịp hú, cánh, mắt thứ ba và đuôi sao**. Hai nhịp đi lên cùng đầu nghiêng là câu hỏi; cánh chỉ đường với tiếng thấp–cao là lời mời; cánh khép và nhịp đi xuống là yêu cầu im lặng; ba nhịp cao gấp cùng cánh xòe là cảnh báo. Bài cuối ghép nhịp đi lên và đi xuống để gọi bạn đến trả chiếc lông thật khẽ. Vạch nhịp, mô tả chữ và tư thế luôn hiện khi tắt âm.

Các biểu cảm/tư thế nằm trong `assets/images/ram_*.png`, gồm hai tư thế mới `ram_warning.png` (móng chặn, đuôi cuộn) và `ram_pointing.png` (chỉ tổ trống). Các lớp nhân vật có nền trong suốt và được ghép với sáu nền `forest_*.png` trong Flutter. Biến thể mới cần giữ vây sừng, túi cổ và ba vòng đuôi trong mọi tư thế. Tránh đưa chữ, nút hoặc đáp án vào ảnh.

Bảng màu giao diện giữ nền tím đêm `#251D3F`, thẻ giấy ngà `#FFF9EC`, nút tím `#553B7E` và tiến trình bạc hà `#7CE3B6`. Bram dùng teal/violet với điểm sáng cam; Vesper dùng chàm/tím với điểm sáng vàng trăng. Bối cảnh Vesper chuyển từ tổ dưới trăng sang hồ, vườn ngủ, vách gió và tổ lúc bình minh. Chữ **Nunito** được đóng gói cục bộ; giấy phép ở `assets/fonts/OFL.txt`.

## Bản xem trước

| Màn | Tín hiệu và thay đổi hình ảnh | Ảnh |
|---|---|---|
| Trang chính | Bram cạnh giỏ rỗng, giới thiệu thế giới. | [Trang chính](../test/goldens/home.png) |
| 01 · Bữa xế | Cổ sáng ba nhịp, mắt nhìn giỏ: đói. | [Cuộc gặp 01](../test/goldens/encounter.png) |
| 02 · Bờ suối | Ánh cổ dịu, móng với về cốc rỗng: khát. | [Cuộc gặp 02](../test/goldens/encounter_2.png) |
| 03 · Lối rẽ | Móng vẫy, ba vòng đuôi sáng: đi theo. | [Cuộc gặp 03](../test/goldens/encounter_3.png) |
| 04 · Hốc cây | Cổ vẫn sáng nhưng đuôi cuộn ôm thân: sợ. | [Cuộc gặp 04](../test/goldens/encounter_4.png) |
| 05 · Cầu gãy | Móng xòe chặn và đuôi cuộn: dừng lại, có nguy hiểm. | [Cuộc gặp 05](../test/goldens/encounter_5.png) |
| 06 · Tổ dưới trăng | Móng chỉ tổ trống, đuôi dẫn hướng: cùng tìm bạn. | [Cuộc gặp 06](../test/goldens/encounter_6.png) |
| Vesper 01 · Lời chào | Đầu nghiêng, mắt thứ ba chớp, hai nhịp đi lên. | [Vesper 01](../test/goldens/vesper_1.png) |
| Vesper 02 · Hồ trăng | Cánh chỉ lối và đuôi sao dẫn đường. | [Vesper 02](../test/goldens/vesper_2.png) |
| Vesper 03 · Vườn ngủ | Cánh khép, mắt hạ, nhịp đi xuống. | [Vesper 03](../test/goldens/vesper_3.png) |
| Vesper 04 · Vách gió | Cánh xòe, mắt sáng, ba nhịp báo động. | [Vesper 04](../test/goldens/vesper_4.png) |
| Vesper 05 · Chiếc lông | Ghép nhịp đã học, chỉ về tổ thật khẽ. | [Vesper 05](../test/goldens/vesper_5.png) |
| Sổ tay | Lưu quy tắc đã học, che ý nghĩa chưa khám phá. | [Sổ tay](../test/goldens/dictionary.png) |

[Trạng thái hiểu sai](../test/goldens/wrong_answer.png) cho thấy quái vật đổi biểu cảm và người chơi nhận một manh mối. Cần thử với người chơi mới để kiểm tra khả năng đọc tín hiệu Vesper.
