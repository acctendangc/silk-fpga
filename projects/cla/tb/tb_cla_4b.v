`timescale 1ns/1ps

module tb_cla_4b;

    // 1. Khai báo các tín hiệu kết nối
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire [3:0] sum;
    wire cout;

    // Biến phụ để kiểm tra logic (Reference model)
    reg [4:0] expected_res;
    integer i, j, k;
    integer error_count = 0;

    // 2. Gọi khối CLA của bro (Dut - Device Under Test)
    // Đảm bảo tên module và tên port khớp với file .v của bro
    cla_4b dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    // 3. Kịch bản test
    initial begin
        $display("--- Bat dau Simulation cho khoi CLA 4-bit ---");
        error_count = 0;

        // Quét tất cả các tổ hợp của A (4-bit), B (4-bit) và Cin (1-bit)
        // Tổng cộng: 16 * 16 * 2 = 512 trường hợp
        for (k = 0; k < 2; k = k + 1) begin
            for (i = 0; i < 16; i = i + 1) begin
                for (j = 0; j < 16; j = j + 1) begin
                    
                    a = i;
                    b = j;
                    cin = k;
                    
                    #10; // Chờ mạch tổ hợp ổn định

                    // Tính toán kết quả kỳ vọng (Reference Model)
                    expected_res = a + b + cin;

                    // So sánh kết quả thực tế từ DUT và kỳ vọng
                    if ({cout, sum} !== expected_res) begin
                        $display("LOI tai: A=%d, B=%d, Cin=%b | Thuc te: {Cout,Sum}=%b, Ky vong: %b", 
                                  a, b, cin, {cout, sum}, expected_res);
                        error_count = error_count + 1;
                    end
                end
            end
        end

        // 4. Tong ket
        if (error_count == 0) begin
            $display(">>> KET QUA: PASS! Tat ca cac truong hop deu dung.");
        end else begin
            $display(">>> KET QUA: FAIL! Co %d loi duoc tim thay.", error_count);
        end
        
        $finish; // Ket thuc mo phong
    end

    // (Tuy chon) Xuat file vcd de soi dang song bang GTKWave
    initial begin
        $dumpfile("cla_4b.vcd");
        $dumpvars(0, tb_cla_4b);
    end

    
endmodule
