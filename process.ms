# Tiến trình thực thi — Phiên dịch cho quái vật

Cập nhật: 2026-11-09 (Asia/Ho_Chi_Minh). File này là điểm bàn giao cho các phiên làm việc tiếp theo. Sau mỗi mốc triển khai, cập nhật trạng thái, kết quả kiểm tra và việc kế tiếp tại đây.

## Mục tiêu và quyết định đã chốt

- Game giải đố giao tiếp: quan sát hình, âm thanh, cử chỉ của quái vật; chọn ý nghĩa, rồi chọn phản hồi. Trả lời sai tạo tình huống hài hước, mở thêm manh mối và cho thử lại ngay. Trả lời đúng giải thích quy tắc tín hiệu trước khi chuyển tiếp.
- Flutter, ưu tiên Android; giữ cấu trúc tương thích iOS nhưng chưa phát hành iOS trong MVP. Không giới hạn lượt, quảng cáo hay năng lượng.
- Chặng đầu dùng **Bram**, một quái vật kaiju chibi nguyên bản, thay cho mẫu Slime ban đầu. Bram giao tiếp bằng nhịp sáng ở cổ, ba vòng đuôi, móng, tư thế và tiếng kêu ngắn. Không dùng Godzilla, King Kong hoặc tạo hình nhận diện thuộc thương hiệu khác.
- Chặng Bram có **6** cuộc gặp, tiếp theo là **5** cuộc gặp Vesper. Hiện có 11 tín hiệu/11 bài cho hai loài. **Thorn** mới là ý tưởng hình ảnh cho tương lai, chưa thuộc phạm vi MVP.
- Mỹ thuật 2D dễ thương, nét rõ, rừng tím kỳ ảo, thẻ giấy ngà; biểu cảm và tư thế thay đổi theo kết quả. Âm quan trọng luôn có nhịp/hình/chữ tương đương để chơi được khi tắt âm. Xem `docs/design_system.md`.
- Tên nhân vật hiển thị dùng một từ tiếng Anh: **Bram** (chặng mở đầu), **Vesper** (chặng kế tiếp), **Thorn** (concept tương lai, chưa thuộc MVP). Quyết định đổi tên được áp dụng vào lời thoại, giao diện và tài liệu ngày 2026-11-09. ID lưu tiến độ `ram_*`, `speciesId: 'ram'` và tên file asset `ram_*` là khóa kỹ thuật cũ, được giữ để bảo toàn tiến độ đã lưu trên thiết bị.

## Hiện trạng đã triển khai

| Hạng mục | Trạng thái |
| --- | --- |
| Bộ khung Flutter và cấu hình Android/iOS | Đã tạo |
| Ba giao diện: trang chính, gặp quái vật, sổ tay | Đã triển khai |
| Bram 01–06: đói, khát, đi theo, sợ, cảnh báo, tìm bạn | Đã chơi tuần tự được |
| Chọn ý nghĩa → chọn phản hồi → hậu quả/manh mối hoặc lời giải thích | Đã triển khai |
| Lưu tiến độ, từ đã học, tùy chọn âm thanh trên máy | Đã triển khai |
| Bram 05–06 và hai màn xem trước tương ứng | Đã triển khai; cầu gãy và tổ dưới trăng |
| Vesper 01–05: chào hỏi, đi theo, im lặng, cảnh báo, ghép nhịp | Đã chơi tuần tự được; mở sau Bram 06 |
| Kiểm tra kỹ thuật trên Android thật | Đã chạy trên Redmi K30 5G (Android 10) |
| Người dùng kiểm thử Bram 01–06 | Đã xác nhận hoàn tất; chưa nhận ghi chú chi tiết |
| Thử Vesper với người chơi mới | Chưa thực hiện |

Luồng hiện tại nằm tại `lib/main.dart`, dữ liệu Bram ở `lib/game/game_content.dart`, dữ liệu Vesper ở `lib/game/vesper_content.dart`, logic phiên chơi tại `lib/game/game_session.dart`, lưu cục bộ tại `lib/game/progress_store.dart`, ghép hình tại `lib/ui/monster_art.dart`. Ảnh xem trước của 11 bài ở `test/goldens/`. Vesper có bảy sprite, bốn nền mới và năm âm ngắn cục bộ trong `assets/`; `forest_moonlit_nest.png` được dùng lại để nối hai chặng. Các asset Slime cũ còn trong repo nhưng không dùng trong nội dung hiện tại.

## Kiểm chứng gần nhất

Ở mốc Bram 01–06, `flutter analyze --no-pub` và `flutter test --no-pub` đã đạt (18 test, gồm luồng 05→06 và giao diện điện thoại nhỏ). Bản debug đã build, cài và chạy bằng `flutter run -d 9d9af905 --debug --no-pub` trên Redmi K30 5G, Android 10. Đã thao tác tuần tự sáu cuộc gặp trên máy, xem màn 05/06, kiểm tra 6 từ trong sổ tay sau khi đóng mở lại app và thử nút tắt/bật âm. APK debug: `build/app/outputs/flutter-apk/app-debug.apk`. Đây là kiểm tra kỹ thuật của agent, **chưa phải thử với người chơi mới**; chưa đánh giá mức dễ hiểu, cảm giác chơi hoặc chất lượng âm nghe bằng tai người dùng. Khi mã thay đổi, chạy lại kiểm tra phù hợp.

Sau lần đổi tên Bram/Vesper/Thorn, `dart format --output=none --set-exit-if-changed` trên mã đã sửa, `flutter analyze --no-pub`, `flutter test --no-pub` (18 test) và build/cài bằng `flutter run -d 9d9af905 --debug --no-pub` đều đạt. Trên Redmi K30 5G, trang chính hiển thị tên Bram mới và vẫn hiện 6 từ đã học từ trước khi đổi tên. Các ảnh golden đã được tạo lại cho tên mới. Chưa có buổi thử với người chơi mới.

Ngày 2026-11-09, người dùng xác nhận đã kiểm thử qua cả sáu màn Bram và yêu cầu tiếp tục chặng mới. Đã triển khai Vesper 01–05, âm và vạch nhịp riêng, 5 ảnh xem trước, mở khóa tuần tự, sổ tay theo loài. Kiểm thử luồng tự động đã xác nhận chuyển Bram 06 → Vesper 01, thử lại khi sai, lưu từ mới và mở Vesper 02. `dart format --output=none --set-exit-if-changed lib test`, `flutter analyze --no-pub` và `flutter test --no-pub` đều đạt (24 test). Đã build APK debug, cài nâng cấp trên Redmi K30 5G và mở app; tiến độ cũ 6 từ Bram còn nguyên, nút Vesper 01 mở và màn gặp đầu hiển thị đúng. Sau chỉnh câu nhịp để tránh lộ đáp án, đã build/cài lại bản cuối; chưa kiểm thử bằng tay toàn bộ 5 cuộc gặp Vesper trên máy, chưa đánh giá chất lượng âm bằng tai người chơi.

Git hiện ở nhánh `develop`. Nhiều file Flutter, asset và tài liệu vẫn chưa được ghi vào commit; phiên sau phải xem `git status` trước khi sửa hay commit, không giả định working tree sạch.

## Việc tiếp theo, theo thứ tự

1. **Kiểm chứng Vesper với người chơi.** Đi qua năm cuộc gặp trên Android, kể cả khi tắt âm; ghi nhận người chơi có đọc được cánh, mắt và nhịp hú, có hiểu quy tắc ghép ở bài 05 và thấy hậu quả sai thú vị không.
2. **Điều chỉnh theo phản hồi.** Sửa những tín hiệu, manh mối, lời thoại hoặc hình ảnh gây hiểu sai ngoài dự kiến; giữ tiến độ cũ khi đổi nội dung.
3. **Nghiệm thu MVP Android.** Chơi toàn bộ hai chặng, xác minh lưu/khôi phục tiến độ, hiệu năng và bố cục trên thiết bị Android; tạo bản build bàn giao. Chưa có yêu cầu phát hành cửa hàng.

## Cách tiếp tục ở phiên sau

1. Đọc `AGENTS.md`, file này, `README.md`, `monster_translator_ai_agent_brief.md`, `docs/design_system.md` và `docs/technical_plan.md`.
2. Chạy `git status --short` và xem thay đổi hiện có; không ghi đè công việc chưa commit.
3. Tiếp tục từ bước chưa hoàn thành đầu tiên ở mục trên. Khi đổi quyết định sản phẩm hoặc hoàn tất một mốc, sửa file này cùng tài liệu liên quan.
