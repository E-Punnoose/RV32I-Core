module msrv32_branch_logic (
    input wire branch,
    input wire [2:0] funct3,
    input wire zero,
    input wire slt,
    input wire sltu,
    output wire branch_taken
);

    reg condition_met;

    always @(*) begin
        case (funct3)
            3'b000: condition_met = zero;
            3'b001: condition_met = ~zero;
            3'b100: condition_met = slt;
            3'b101: condition_met = ~slt;
            3'b110: condition_met = sltu;
            3'b111: condition_met = ~sltu;
            default: condition_met = 1'b0;
        endcase
    end

    assign branch_taken = branch & condition_met;

endmodule