# Interpreter for Monsters

Bộ khung AI agent cho việc xây dựng ứng dụng Flutter. Repo chưa có mã ứng dụng; tên sản phẩm và phạm vi tính năng sẽ được xác định khi bắt đầu làm app.

```text
AGENTS.md                     Quy ước chung cho agent trong repo
.agents/
  roles/                      Prompt giao việc theo vai trò
    product.md
    flutter-engineer.md
    reviewer.md
  skills/                     Skill được Codex nhận diện trong dự án
    flutter-bootstrap/SKILL.md
    flutter-feature/SKILL.md
    flutter-verify/SKILL.md
```

## Bắt đầu

1. Mô tả app muốn xây, nền tảng đích và màn hình hoặc luồng đầu tiên.
2. Yêu cầu agent dùng `$flutter-bootstrap` để tạo dự án Flutter tại repo này.
3. Giao từng tính năng với `$flutter-feature`; dùng `$flutter-verify` trước khi bàn giao mã.

Các file `roles/` giúp chia công việc lớn cho các agent chuyên trách, nhưng không bắt buộc phải chạy nhiều agent. Sau khi tạo ứng dụng, cập nhật README này bằng lệnh chạy thật và các quyết định kiến trúc đã chọn.
