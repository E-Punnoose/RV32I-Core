module msrv32_mem_wb (
    input wire clk,
    input wire reset,
    input wire reg_write_in,
    input wire mem_to_reg_in,
    input wire [31:0] mem_data_in,
    input wire [31:0] alu_result_in,
    input wire [4:0] rd_addr_in,
    output reg reg_write_out,
    output reg mem_to_reg_out,
    output reg [31:0] mem_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0] rd_addr_out
);

always @(posedge clk) begin
    if (reset) begin
        reg_write_out  <= 1'b0;
        mem_to_reg_out <= 1'b0;
        mem_data_out   <= 32'b0;
        alu_result_out <= 32'b0;
        rd_addr_out    <= 5'b0;
    end else begin
        reg_write_out  <= reg_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        mem_data_out   <= mem_data_in;
        alu_result_out <= alu_result_in;
        rd_addr_out    <= rd_addr_in;
    end
end

endmodule