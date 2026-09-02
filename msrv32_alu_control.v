module msrv32_alu_control (
    input wire [1:0] alu_op,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [3:0] alu_ctrl
);

    always @(*) begin
        case (alu_op)
            2'b00: begin
                alu_ctrl = 4'b0000;
            end
            
            2'b01: begin
                alu_ctrl = 4'b1000;
            end
            
            2'b10: begin
                if ((funct3 == 3'b000 || funct3 == 3'b101) && funct7[5] == 1'b1) begin
                    alu_ctrl = {1'b1, funct3};
                end else begin
                    alu_ctrl = {1'b0, funct3};
                end
            end
            
            default: begin
                alu_ctrl = 4'b0000;
            end
        endcase
    end

endmodule