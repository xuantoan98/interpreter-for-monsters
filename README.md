# Phiên dịch cho quái vật

Game giải đố giao tiếp với quái vật. Người chơi quan sát tín hiệu, chọn cách diễn giải, chọn phản hồi rồi học ngôn ngữ của từng loài qua kết quả. Repo hiện có **ba giao diện và 11 cuộc gặp**: sáu của Bram, năm của Vesper.

## Chạy ứng dụng

Yêu cầu Flutter SDK và Android SDK. Từ thư mục gốc:

```bash
flutter pub get
flutter run -d <android-device-id>
```

Kiểm tra mã:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Trạng thái hiện tại

- Sáu cuộc gặp Bram nối tiếp năm cuộc gặp Vesper. Vesper mở sau Bram 06; mỗi bài tiếp theo mở khi hoàn thành bài trước.
- Lựa chọn sai có phản ứng hài hước và manh mối; không giới hạn lượt.
- Bram dùng ánh cổ/đuôi; Vesper dùng cánh, mắt thứ ba và nhịp hú. Mọi âm quan trọng có vạch nhịp và mô tả chữ; có thể tắt âm.
- Tiến độ hoàn thành và từ đã học được lưu cục bộ.
- Bản debug Android đã có đủ hai chặng; cảm giác chơi và độ rõ tín hiệu vẫn cần người chơi mới đánh giá.

## Tài liệu

- [Tiến trình thực thi và bước tiếp theo](process.ms)
- [Brief sản phẩm](monster_translator_ai_agent_brief.md)
- [Kế hoạch và thiết kế kỹ thuật](docs/technical_plan.md)
- [Nghiên cứu mỹ thuật, bộ ảnh và các màn xem trước](docs/design_system.md)
- [Hướng dẫn agent](AGENTS.md)
