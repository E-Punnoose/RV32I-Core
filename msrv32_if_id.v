module msrv32_if_id (
    input  wire        clk,
    input  wire        reset,
    input  wire        if_id_write,
    input  wire        if_id_flush,
    input  wire [31:0] pc_in,
    input  wire [31:0] instr_in,
    output reg  [31:0] pc_out,
    output reg  [31:0] instr_out
);

    always @(posedge clk) begin
        if (reset || if_id_flush) begin
            pc_out    <= 32'h00000000;
            instr_out <= 32'h00000000;
        end else if (if_id_write) begin
            pc_out    <= pc_in;
            instr_out <= instr_in;
        end
    end

endmodule