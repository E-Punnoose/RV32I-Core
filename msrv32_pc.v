module msrv32_pc (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] pc_in,
    input  wire        pc_write,
    output reg  [31:0] pc_out
);

    always @(posedge clk) begin
        if (reset) begin
            pc_out <= 32'h00000000;
        end else if (pc_write) begin
            pc_out <= pc_in;
        end
    end

endmodule