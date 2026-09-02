module msrv32_imm_gen (
    input  wire [31:0] in,
    output reg  [31:0] imm_out
);

    wire [6:0] opcode = in[6:0];

    always @(*) begin
        case (opcode)
            7'b0000011, 7'b0010011, 7'b1100111: begin
                imm_out = {{20{in[31]}}, in[31:20]};
            end

            7'b0100011: begin
                imm_out = {{20{in[31]}}, in[31:25], in[11:7]};
            end

            7'b1100011: begin
                imm_out = {{19{in[31]}}, in[31], in[7], in[30:25], in[11:8], 1'b0};
            end

            7'b0110111, 7'b0010111: begin
                imm_out = {in[31:12], 12'b0};
            end

            7'b1101111: begin
                imm_out = {{11{in[31]}}, in[31], in[19:12], in[20], in[30:21], 1'b0};
            end

            default: begin
                imm_out = 32'b0;
            end
        endcase
    end

endmodule