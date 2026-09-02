`timescale 1ns / 1ps

module msrv32_imm_gen_tb;

    reg  [31:0] in;
    wire [31:0] imm_out;

    msrv32_imm_gen uut (
        .in(in),
        .imm_out(imm_out)
    );

    initial begin
        $monitor("Time: %0t | Instruction: 0x%08h | Immediate: 0x%08h", $time, in, imm_out);
        in = 32'hFFF10093;
        #10;

        in = 32'h00112223;
        #10;

        in = 32'hFE208CE3;
        #10;

        in = 32'h123450B7;
        #10;

        in = 32'h020000EF;
        #10;

        in = 32'h003100B3;
        #10;

        $finish;
    end

endmodule