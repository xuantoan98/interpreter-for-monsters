---
name: flutter-bootstrap
description: Khởi tạo hoặc chỉnh bộ khung Flutter trong repo khi chưa có ứng dụng, pubspec hoặc cấu hình nền tảng cần thiết.
---

# Flutter bootstrap

Kiểm tra repo trước khi tạo file để tránh ghi đè công việc sẵn có. Xác định nền tảng đích từ yêu cầu; nếu chưa rõ, dùng các nền tảng Flutter mặc định phù hợp môi trường và ghi lại giả định.

Tạo ứng dụng bằng Flutter CLI trong repo hiện tại. Chọn tên package Dart hợp lệ, giữ metadata và file cấu hình do CLI sinh ra. Không thêm package kiến trúc, dịch vụ mạng hoặc backend khi chưa có chức năng cần chúng.

Sau khi tạo, chạy `flutter pub get`, `flutter analyze` và test mẫu hoặc test liên quan nếu có. Cập nhật `README.md` với lệnh chạy thật, nền tảng đã tạo và cấu trúc mã hiện tại. Nếu SDK hoặc công cụ nền tảng thiếu, ghi rõ lệnh nào bị chặn và nguyên nhân.
