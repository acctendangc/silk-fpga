`timescale 1ns/1ps

module tb_ntt_top;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg start = 1'b0;
    reg mode = 1'b0;
    reg [11:0] data_in = 12'd1;

    wire [11:0] data_out;
    wire done;

    ntt_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .mode(mode),
        .data_in(data_in),
        .data_out(data_out),
        .done(done)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (rst_n && !done)
            data_in <= data_in + 12'd1;
    end

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_ntt_top);

        #20;
        rst_n = 1'b1;
        #20;
        start = 1'b1;
        #10;
        start = 1'b0;

        wait(done);
        #20;
        $display("NTT smoke test complete. data_out=%0d", data_out);
        $finish;
    end

    initial begin
        #20000;
        $display("TIMEOUT");
        $finish;
    end
endmodule
