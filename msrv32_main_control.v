module msrv32_main_control (
    input  [6:0] opcode,
    output       branch,
    output       mem_read,
    output       mem_to_reg,
    output [1:0] alu_op,
    output       mem_write,
    output       alu_src,
    output       reg_write
);

  reg [7:0] controls;

  assign {branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = controls;

  always @(*) begin
    case (opcode)
      7'b0110011: controls = 8'b0_0_0_10_0_0_1;
      7'b0010011: controls = 8'b0_0_0_10_0_1_1;
      7'b0000011: controls = 8'b0_1_1_00_0_1_1;
      7'b0100011: controls = 8'b0_0_0_00_1_1_0;
      7'b1100011: controls = 8'b1_0_0_01_0_0_0;
      7'b1101111: controls = 8'b0_0_0_00_0_0_1;
      7'b1100111: controls = 8'b0_0_0_10_0_1_1;
      7'b0110111: controls = 8'b0_0_0_00_0_1_1;
      7'b0010111: controls = 8'b0_0_0_00_0_1_1;
      default:    controls = 8'b0_0_0_00_0_0_0;
    endcase
  end

endmodule