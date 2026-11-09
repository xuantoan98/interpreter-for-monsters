# Kế hoạch và thiết kế kỹ thuật MVP

Chặng mở đầu dùng **Bram**, quái vật rừng chibi. Sáu cuộc gặp Bram nối tiếp năm cuộc gặp **Vesper**; cả 11 bài đã triển khai. Xem [mỹ thuật và các bản xem trước](design_system.md).

## Quyết định đã chốt

- Android ưu tiên, Flutter giữ khả năng tương thích iOS; chưa phát hành iOS trong MVP.
- Chơi offline, không giới hạn lượt, năng lượng hoặc quảng cáo.
- Người chơi chọn diễn giải rồi chọn phản hồi. Mỗi lựa chọn sai có phản ứng hài hước, manh mối và cho thử lại ngay. Sau câu trả lời đúng, game giải thích và cập nhật sổ tay.
- Bram truyền tín hiệu bằng ánh cổ, ba vòng đuôi, móng, tư thế và tiếng kêu. Tín hiệu âm thanh có vạch nhịp và mô tả chữ; không phụ thuộc riêng vào màu sắc.
- MVP hiện có 11 tín hiệu và 11 cuộc gặp: Bram 01–06, Vesper 01–05.

## Vòng chơi Vesper

Vesper mở khi hoàn thành Bram 06; mỗi cuộc gặp mở sau bài trước. Năm bài dạy lời chào hỏi, đi theo, giữ yên lặng, cảnh báo và ghép nhịp để mang lông về tổ. Người chơi đọc cánh, mắt thứ ba, đuôi sao và nhịp hú; mỗi âm có vạch nhịp và câu mô tả luôn hiển thị. Bài cuối kết hợp hai mẫu nhịp đã học. Đáp án sai giữ người chơi trong cùng bước, đổi biểu cảm Vesper, đưa hậu quả vui và manh mối.

## Vòng chơi Bram đầu tiên

1. Bram đứng cạnh chiếc giỏ rỗng; cổ phát sáng ba nhịp và kêu ba tiếng ụm.
2. Người chơi suy luận Bram đói. Sai thì Bram phản ứng, cho manh mối và được thử lại.
3. Người chơi chọn cách đáp lại. Đưa táo là đáp án phù hợp; các cách khác tạo hậu quả vui và gợi ý.
4. Game giải thích tổ hợp tín hiệu, lưu từ “đói” và mở cuộc gặp bên suối.
5. Các cuộc gặp tiếp theo thêm vật chứng, cử chỉ dẫn đường và tình huống cùng ánh cổ nhưng khác tư thế.

## Tổ chức mã

| Phần | Trách nhiệm |
|---|---|
| `lib/game/game_content.dart` | Dữ liệu sáu cuộc gặp Bram, lựa chọn, hậu quả, lời giải thích và đường dẫn asset. |
| `lib/game/vesper_content.dart` | Dữ liệu năm cuộc gặp Vesper và quy tắc ngôn ngữ mới. |
| `lib/game/game_session.dart` | Chuyển bước diễn giải, phản hồi, kết quả, hoàn thành và thử lại. |
| `lib/game/progress_store.dart` | Lưu tiến độ, từ đã học và tùy chọn âm thanh trên máy. |
| `lib/ui/monster_art.dart` | Ghép nền và tư thế quái vật, tạo chuyển động nhẹ theo trạng thái. |
| `assets/images/`, `assets/audio/` | Nền, nhân vật và tiếng kêu cục bộ. |
| `lib/main.dart` | Trang chính, cuộc gặp, kết quả và sổ tay. |

Audio dùng `audioplayers`, tiến độ dùng `shared_preferences`. Không có backend, tài khoản hoặc API. Tên hiển thị của nhân vật mở đầu là **Bram**; ID nội dung và asset `ram_*` là khóa kỹ thuật đã có từ trước, được giữ nguyên để tiến độ của người chơi không mất khi đổi tên. Tiến độ Slime thử nghiệm trước đó không tự mở khóa chặng Bram.

## Thứ tự tiếp theo

1. Cho người chơi mới thử cả hai chặng mà không giải thích trước; kiểm tra cả chế độ tắt âm.
2. Ghi chỗ họ hiểu sai ngoài dự kiến, mức độ vui của phản ứng, nhịp độ 11 bài và khả năng nhận diện quy tắc Vesper.
3. Điều chỉnh tín hiệu, manh mối, độ dài câu và hình ảnh theo phản hồi; nghiệm thu lần cuối trên Android trước khi phát hành.

Hai chặng đã có nội dung và luồng chơi. Chưa có kết quả thử với người chơi mới hoặc yêu cầu phát hành cửa hàng.
