---
name: flutter-feature
description: Xây hoặc sửa màn hình, luồng người dùng và logic tính năng trong ứng dụng Flutter của repo này.
---

# Flutter feature

Đọc yêu cầu và mã liên quan để xác định hành vi, trạng thái UI và dữ liệu cần thiết. Nếu app chưa được tạo, dùng `$flutter-bootstrap` trước.

Ưu tiên một luồng chạy được từ đầu đến cuối. Tái sử dụng widget, theme, điều hướng và cách quản lý trạng thái hiện có; chỉ thêm dependency khi có lợi ích rõ ràng. Thiết kế cho kích thước màn hình và cách nhập liệu mục tiêu; xử lý trạng thái rỗng, tải và lỗi khi tính năng có các trạng thái đó.

Thêm hoặc sửa test khi có logic hoặc hành vi dễ hồi quy. Dùng `$flutter-verify` để kiểm tra phần thay đổi trước khi bàn giao. Nêu rõ giả định sản phẩm và giới hạn còn lại.
