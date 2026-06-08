# SILK FPGA - Hệ thống Tự động hóa RTL & Remote Lab

Chào mừng bạn đến với kho lưu trữ mã nguồn mở của **SILK FPGA Remote Lab**. Đây là hệ thống tự động hóa được thiết kế chuyên dụng dành cho cộng đồng kỹ sư thiết kế phần cứng, sinh viên và những người đam mê lập trình RTL.

Bạn không cần cài docker hay bất kì công cụ nào về laptop, chỉ cần có 1 tài khoản Github, fork repo này về và chạy thui :>>

Mình sẽ cập nhật liên tục hướng dẫn trên kênh youtube này, hãy theo dõi để không bỏ lỡ nhe !!!!

**Youtube Channel:** **https://www.youtube.com/@huyatieo** 

Kho lưu trữ này hiện tại cung cấp hai môi trường làm việc độc lập được cấu hình tự động hoàn toàn bằng GitHub Actions:
1. **`remote_lab/`**: Biên dịch mã nguồn RTL thành file trung gian để nạp lên Board ảo trên web remote lab.
2. **`projects/`**: Chạy luồng công cụ EDA mã nguồn mở để phân tích lỗi, vẽ sơ đồ nguyên lý, máy trạng thái, thống kê tài nguyên phần cứng, và chạy testbench cho các file dự án.

---

## 1. Thư mục `remote_lab` (Mô phỏng Board Ảo trên Web)

Thư mục này chứa môi trường biên dịch tự động, giúp chuyển đổi mã RTL của bạn thành file 'silkfpga.js'. Sử dụng file này để cấu hình cho board ảo nhé.

* **Board ảo:** **[Silk FPGA Remote Lab](https://silkfpga.ctw-sevina.com/)**

### 📌 Các chế độ ngoại vi hỗ trợ (Modes)
Bên trong `remote_lab` đã được chuẩn bị sẵn các thư mục mẫu (`vga`, `hex`, `uart`, `ps2`, `counter`) để bạn tham khảo cách thiết kế và nối dây chân cắm (I/O ports) với Top Module. 

Hệ thống nhận diện chế độ làm việc của bạn thông qua một tệp cấu hình bắt buộc tên là `mode.txt` nằm trong thư mục dự án của bạn. File này chỉ chứa duy nhất một từ khóa viết hoa tương ứng với 1 trong 5 chế độ:

| Chế độ (Ghi trong mode.txt) | Mô tả chức năng phần cứng |
| :--- | :--- |
| **`NONE`** | *(Chế độ mặc định)* Dành cho các bài mạch số cơ bản (Cổng logic, Counter, FSM thuần túy) không dùng ngoại vi đặc biệt. |
| **`HEX`** | Kết nối đầu ra của mạch với hệ thống LED 7 đoạn (7-segment display) trên board ảo. |
| **`VGA`** | Xuất tín hiệu đồng bộ và điểm ảnh ra màn hình hiển thị VGA ảo trên web. |
| **`UART`** | Kích hoạt bộ giao tiếp truyền nhận nối tiếp tuần tự (Serial Terminal). |
| **`PS2`** | Hỗ trợ nhận và xử lý tín hiệu quét mã phím (Scan Code) từ bàn phím ảo. |

### 🛠️ Cách sử dụng
1. **Fork** repository này về tài khoản GitHub cá nhân của bạn.
2. Truy cập vào thư mục `remote_lab/your_project`.
3. Copy các tệp mã nguồn thiết kế (`.v`, `.sv`) của bạn vào đây. Giữ nguyên file `project.v` (Tham khảo I/O port từ các thư mục mẫu).
4. Mở tệp `mode.txt` có sẵn, chỉnh sửa thành chế độ ngoại vi bạn làm (Ví dụ: `VGA`).
5. **Commit & Push** code lên nhánh chính của bạn, nghĩa là thay đổi nội dung bên trong thư mục của bạn rồi lưu lại với 'commit change' để workflow chạy.
6. Sang tab **Actions** trên GitHub, đợi chạy xong, chọn action **SILK FPGA - Auto Compile JS** ở bên trái, bạn chọn lần gần nhất push thành công (tick xanh trên cùng) và tải tệp nén `.zip` ở cuối workflow. Giải nén ra bạn sẽ có file `.js' sẵn sàng để kéo thả nạp lên trang web.
7. **Workflow chỉ chạy** khi phát hiện có sự thay đổi trong thư mục 'your_moudule'.
---

## 2. Thư mục `projects` (Báo cáo RTL)

Thư mục này hoạt động như một máy trạm EDA thu nhỏ chạy trên Cloud, tích hợp các bộ công cụ mã nguồn mở. Nhiệm vụ chính là phân tích, kiểm thử và trực quan hóa thiết kế phần cứng của bạn ngay khi push code mà không cần cài đặt rườm rà.

### 📁 Cấu trúc thư mục bắt buộc
Để pipeline không bị lỗi, cấu trúc thư mục của bạn bên trong `projects/` phải như sau:
```text
projects/    # Thư mục chung chứa toàn bộ dự án
├── systolic           # Thư mục dự án 1
 ├── config.txt          # Khai báo tên Top Module và Testbench
 ├── rtl/                # Nơi chứa toàn bộ file thiết kế (.v, .sv)
 ├── tb/                 # Nơi chứa file Testbench (.v, .sv)
 └── sim/                # Thư mục trống để hệ thống xuất file sóng (.vcd)
├── cla                # Thư mục dự án 2
├── proj_n             # Thư mục dự án n
```
Tệp config.txt bắt buộc phải khai báo chính xác theo định dạng sau:
``` text
TOP_MODULE = ten_top_module_cua_ban

TB_NAME = ten_file_testbench_cua_ban
```
### 🛠️ Cách sử dụng
1. **Fork** repository này về tài khoản GitHub cá nhân của bạn (nếu đã làm rồi thì làm 1 lần thui nhe).
2. Thêm các file thiết kế RTL '.v' và '.sv' vào thư mục rtl, file testbench vào thư mục tb ( phải có tiền tố 'tb_' ở trước thì mới là file tb hợp lệ, ví dụ: 'tb_mul.sv').
3. Nếu muốn tạo ra file sóng để xem, bạn phải thêm vào bên trong file tb như sau, bạn có thể xem sóng được tạo ra trong thư mục **sim** bằng gtkwave:
``` text
 initial begin
        // thêm vào để trình biên dịch tạo sóng
        $dumpfile("sim/waveform.vcd");
        $dumpvars(0, tb_mul);
 end
```

5. **Commit & Push** code lên nhánh chính của bạn, nghĩa là thay đổi nội dung bên trong các thư mục rồi lưu lại với commit change để workflow chạy.
6. Sang tab **Actions** trên GitHub, đợi chạy xong, chọn action **SILK EDA - General Check** ở bên trái, bạn chọn lần gần nhất push thành công (tick xanh trên cùng) và kéo xuống để xem báo cáo.
8. **Workflow** chỉ chạy khi phát hiện có sự thay đổi tại bên trong các thư mục dự án, khi bạn cập nhật 1 dự án cụ thể, action sẽ chạy và tạo kết quả cho chính xác dự án đó. 
