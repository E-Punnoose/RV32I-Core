module msrv32_id_ex (
    input wire clk,
    input wire reset,
    input wire flush,
    input wire alu_src_in,
    input wire [3:0] alu_op_in,
    input wire mem_write_in,
    input wire mem_read_in,
    input wire reg_write_in,
    input wire mem_to_reg_in,
    input wire branch_in,
    input wire jal_in,
    input wire jalr_in,
    input wire [31:0] pc_in,
    input wire [31:0] rs1_data_in,
    input wire [31:0] rs2_data_in,
    input wire [31:0] imm_in,
    input wire [4:0] rs1_addr_in,
    input wire [4:0] rs2_addr_in,
    input wire [4:0] rd_addr_in,
    input wire [2:0] funct3_in,
    input wire [6:0] funct7_in,
    input wire [6:0] opcode_in,
    output reg alu_src_out,
    output reg [3:0] alu_op_out,
    output reg mem_write_out,
    output reg mem_read_out,
    output reg reg_write_out,
    output reg mem_to_reg_out,
    output reg branch_out,
    output reg jal_out,
    output reg jalr_out,
    output reg [31:0] pc_out,
    output reg [31:0] rs1_data_out,
    output reg [31:0] rs2_data_out,
    output reg [31:0] imm_out,
    output reg [4:0] rs1_addr_out,
    output reg [4:0] rs2_addr_out,
    output reg [4:0] rd_addr_out,
    output reg [2:0] funct3_out,
    output reg [6:0] funct7_out,
    output reg [6:0] opcode_out
);

always @(posedge clk) begin
    if (reset || flush) begin
        alu_src_out    <= 1'b0;
        alu_op_out     <= 4'b0;
        mem_write_out  <= 1'b0;
        mem_read_out   <= 1'b0;
        reg_write_out  <= 1'b0;
        mem_to_reg_out <= 1'b0;
        branch_out     <= 1'b0;
        jal_out        <= 1'b0;
        jalr_out       <= 1'b0;
        pc_out         <= 32'b0;
        rs1_data_out   <= 32'b0;
        rs2_data_out   <= 32'b0;
        imm_out        <= 32'b0;
        rs1_addr_out   <= 5'b0;
        rs2_addr_out   <= 5'b0;
        rd_addr_out    <= 5'b0;
        funct3_out     <= 3'b0;
        funct7_out     <= 7'b0;
        opcode_out     <= 7'b0;
    end else begin
        alu_src_out    <= alu_src_in;
        alu_op_out     <= alu_op_in;
        mem_write_out  <= mem_write_in;
        mem_read_out   <= mem_read_in;
        reg_write_out  <= reg_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        branch_out     <= branch_in;
        jal_out        <= jal_in;
        jalr_out       <= jalr_in;
        pc_out         <= pc_in;
        rs1_data_out   <= rs1_data_in;
        rs2_data_out   <= rs2_data_in;
        imm_out        <= imm_in;
        rs1_addr_out   <= rs1_addr_in;
        rs2_addr_out   <= rs2_addr_in;
        rd_addr_out    <= rd_addr_in;
        funct3_out     <= funct3_in;
        funct7_out     <= funct7_in;
        opcode_out     <= opcode_in;
    end
end

endmodule