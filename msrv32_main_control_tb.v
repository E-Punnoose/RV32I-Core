`timescale 1ns/1ps

module msrv32_main_control_tb;

  reg  [6:0] opcode;
  wire       branch;
  wire       mem_read;
  wire       mem_to_reg;
  wire [1:0] alu_op;
  wire       mem_write;
  wire       alu_src;
  wire       reg_write;

  msrv32_main_control uut (
      .opcode(opcode),
      .branch(branch),
      .mem_read(mem_read),
      .mem_to_reg(mem_to_reg),
      .alu_op(alu_op),
      .mem_write(mem_write),
      .alu_src(alu_src),
      .reg_write(reg_write)
  );

  initial begin
    $dumpfile("msrv32_main_control.vcd");
    $dumpvars(0, msrv32_main_control_tb);

    opcode = 7'b0110011; #10;
    opcode = 7'b0010011; #10;
    opcode = 7'b0000011; #10;
    opcode = 7'b0100011; #10;
    opcode = 7'b1100011; #10;
    opcode = 7'b1101111; #10;
    opcode = 7'b1100111; #10;
    opcode = 7'b0110111; #10;
    opcode = 7'b0010111; #10;
    opcode = 7'b1111111; #10;

    $finish;
  end

endmodule