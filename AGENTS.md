# Hướng dẫn agent cho dự án Flutter

Repo đã có ứng dụng Flutter với hai chặng Bram và Vesper. Hãy đọc `README.md`, `process.ms`, `monster_translator_ai_agent_brief.md` và `docs/technical_plan.md` trước khi mở rộng gameplay.

## Cách làm việc

- Làm rõ mục tiêu sản phẩm và nền tảng đích khi chúng ảnh hưởng đến quyết định kỹ thuật; với việc có thể sửa lại dễ dàng, chọn phương án đơn giản và tiếp tục.
- Giữ thay đổi theo phạm vi yêu cầu. Không tự chọn gói quản lý trạng thái, định tuyến, backend hoặc dịch vụ bên ngoài trước khi có nhu cầu cụ thể.
- Khi đã có mã Flutter, tuân theo cấu trúc, quy ước và dependency hiện hữu. Đặt mã dùng chung ở nơi dễ tìm; chỉ tách module khi có ranh giới rõ.
- Không đưa khóa bí mật, token hoặc cấu hình cá nhân vào repo.
- Trước khi báo hoàn tất một thay đổi mã, chạy các kiểm tra phù hợp với phạm vi thay đổi và báo rõ kiểm tra nào chưa chạy được.

## Skill theo công việc

- Dùng `$flutter-bootstrap` khi khởi tạo ứng dụng Flutter trong repo trống này hoặc thiết lập lại bộ khung dự án.
- Dùng `$flutter-feature` khi triển khai một màn hình, luồng người dùng hoặc tính năng Flutter.
- Dùng `$flutter-verify` khi cần kiểm tra thay đổi mã Flutter trước khi bàn giao.

## Vai trò tham khảo

Các tệp trong `.agents/roles/` là prompt để giao việc theo vai trò. Chúng không tự khởi chạy agent hoặc tạo quy trình phê duyệt. Một agent có thể thực hiện nhiều vai trò nếu công việc nhỏ.
