`timescale 1ns / 1ps
module msrv32_core_tb;

    reg clk;
    reg rst;

    msrv32_core uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #20;
        rst = 0;
        #800;
        $finish;
    end

    initial begin
        #400;
        $display("=== REGISTER FILE ===");
        $display("x1 = %0d  (expect 5)",  uut.reg_file_inst.reg_file[1]);
        $display("x2 = %0d  (expect 10)", uut.reg_file_inst.reg_file[2]);
        $display("x3 = %0d  (expect 15)", uut.reg_file_inst.reg_file[3]);
        $display("x4 = %0d  (expect 16)", uut.reg_file_inst.reg_file[4]);
        $display("x5 = %0d  (expect 1)",  uut.reg_file_inst.reg_file[5]);
        $display("=== DATA MEMORY ===");
        $display("dmem[2] = %0d  (expect 15)", uut.dmem_inst.ram[2]);
        $display("=== PASS/FAIL ===");
        if (uut.reg_file_inst.reg_file[1] == 32'd5  &&
            uut.reg_file_inst.reg_file[2] == 32'd10 &&
            uut.reg_file_inst.reg_file[3] == 32'd15 &&
            uut.reg_file_inst.reg_file[4] == 32'd16 &&
            uut.reg_file_inst.reg_file[5] == 32'd1  &&
            uut.dmem_inst.ram[2]          == 32'd15)
            $display("ALL PASS");
        else
            $display("FAIL - check values above");
    end

endmodule