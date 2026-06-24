# Run Instructions: Journal Trend Analyzer (Mobile Only)

Tài liệu này hướng dẫn chi tiết các bước thiết lập và chạy ứng dụng **Journal Trend Analyzer** trên thiết bị di động (Android Emulator hoặc máy thật) dành cho đồ án môn PRM393 - Lab2.

---

## Bước 1: Yêu cầu hệ thống (Prerequisites)
Trước khi bắt đầu, hãy đảm bảo máy tính của bạn đã được cài đặt đầy đủ các phần mềm sau:
1. **Flutter SDK**: Đã cài đặt và thêm vào biến môi trường (Environment Variables).
2. **Android Studio**: Dùng để quản lý Android SDK và tạo máy ảo (Emulator).
3. **IDE (Trình soạn thảo mã)**: Visual Studio Code (VS Code) hoặc Android Studio.

*Gợi ý: Mở terminal/CMD và gõ lệnh `flutter doctor` để kiểm tra xem bạn đã cài đặt thiếu thành phần nào không. Nếu có đánh dấu `[✓]` ở dòng Flutter và Android toolchain là bạn đã sẵn sàng.*

---

## Bước 2: Đổi tên thư mục nộp bài (Bắt buộc theo yêu cầu Lab)
Yêu cầu của Lab2 bắt buộc mã nguồn phải nằm trong thư mục có định dạng `PRM393_Lab2_StudentID`.
1. Hãy đóng ứng dụng VS Code/Android Studio hiện tại.
2. Tìm đến thư mục `PRM_Project2` hiện tại. Đổi tên thư mục này thành `PRM393_Lab2_<Mã_Số_Sinh_Viên_Của_Bạn>` (Ví dụ: `PRM393_Lab2_SE123456`).
3. Mở lại thư mục vừa đổi tên trong VS Code hoặc Android Studio.

---

## Bước 3: Cài đặt thư viện (Dependencies)
Ứng dụng sử dụng một số thư viện bên ngoài (Provider, fl_chart, http, go_router...). Bạn cần tải chúng về trước khi chạy.
1. Mở Terminal (trong VS Code, nhấn `Ctrl + ~`).
2. Di chuyển vào thư mục chứa code Flutter (thư mục con `journaltrend`):
   ```bash
   cd journaltrend
   ```
3. Chạy lệnh cài đặt thư viện:
   ```bash
   flutter pub get
   ```

---

## Bước 4: Thiết lập thiết bị di động (Mobile Device)

### Cách 1: Chạy trên máy thật (Android Physical Device) - Khuyến nghị vì mượt hơn
1. Bật điện thoại Android của bạn, vào **Cài đặt (Settings)** > **Giới thiệu điện thoại (About Phone)**.
2. Chạm 7 lần vào dòng **Số bản dựng (Build Number)** để bật chế độ Nhà phát triển.
3. Quay lại **Cài đặt** > **Tùy chọn nhà phát triển (Developer Options)**. Bật **Gỡ lỗi USB (USB Debugging)**.
4. Cắm cáp kết nối điện thoại với máy tính. Cho phép máy tính truy cập (Allow USB debugging) trên màn hình điện thoại.

### Cách 2: Chạy trên máy ảo (Android Emulator)
1. Mở Android Studio.
2. Chọn **Device Manager** (hoặc Virtual Device Manager).
3. Nhấn **Create Device**, chọn một mẫu điện thoại (ví dụ: Pixel 6) và ấn Next để cài đặt.
4. Sau khi cài xong, nhấn nút **Play** (tam giác) để bật máy ảo lên.

---

## Bước 5: Chạy ứng dụng

1. Trong Terminal (đang ở thư mục `journaltrend`), kiểm tra xem máy tính đã nhận diện được thiết bị (máy thật/máy ảo) chưa bằng lệnh:
   ```bash
   flutter devices
   ```
   *(Bạn sẽ thấy tên thiết bị Android của mình hiện ra trong danh sách).*

2. Cuối cùng, chạy ứng dụng bằng lệnh:
   ```bash
   flutter run
   ```
3. Lần đầu tiên chạy (build APK) sẽ mất khoảng 1-3 phút. Xin hãy kiên nhẫn. Sau khi hoàn thành, ứng dụng Journal Trend Analyzer sẽ tự động bật lên trên màn hình điện thoại/máy ảo của bạn!

---

## Bước 6: Sử dụng Github Copilot để Review Code (Dành cho Project Report)
Vì đồ án yêu cầu phải có AI-Assisted Code Review trong báo cáo PDF:
1. Mở các file như `lib/services/openalex_service.dart` hoặc `lib/providers/search_provider.dart` trong VS Code.
2. Bôi đen toàn bộ đoạn code trong file đó.
3. Nhấn chuột phải -> chọn **Copilot** -> **Review and Comment** (hoặc hỏi trong khung chat Copilot: *"Review this code for bugs, code smells, or improvements"*).
4. **Chụp ảnh màn hình (Screenshot)** kết quả Copilot trả lời.
5. Sửa 1-2 dòng code theo gợi ý của nó (ví dụ: tối ưu hàm, bắt thêm exception) rồi chụp lại ảnh để lấy minh chứng đưa vào Report.

1. **List all available emulators** on your system:
   ```bash
   flutter emulators
   ```

2. **Launch a specific emulator** (e.g., `Small_Phone`):
   ```bash
   flutter emulators --launch Small_Phone
   ```

3. **Check connected devices** to ensure the emulator is online and get its device ID (e.g., `emulator-5554`):
   ```bash
   flutter devices
   ```

4. **Run the application** on the active emulator:
   ```bash
   flutter run -d emulator-5554
   ```
   *(Or simply run `flutter run` if it is the only active mobile device).*

