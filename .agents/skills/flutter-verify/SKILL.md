---
name: flutter-verify
description: Kiểm tra thay đổi Flutter bằng phân tích tĩnh, test và chạy app khi chuẩn bị bàn giao mã ứng dụng.
---

# Flutter verify

Chọn kiểm tra dựa trên thay đổi thực tế. Với mã Dart/Flutter, chạy `dart format --output=none --set-exit-if-changed` trên file đã sửa, `flutter analyze` và test liên quan. Khi thay đổi ảnh hưởng khởi động, điều hướng hoặc giao diện, chạy app trên thiết bị hoặc emulator sẵn có nếu khả thi và kiểm tra luồng chính.

Sửa lỗi do thay đổi gây ra và chạy lại phần kiểm tra liên quan. Phân biệt lỗi mới với lỗi đã tồn tại. Báo kết quả từng kiểm tra, môi trường chạy và những phần chưa xác minh được. Không coi việc không có thiết bị hoặc SDK là kết quả pass.
