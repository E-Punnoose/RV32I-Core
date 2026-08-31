module msrv32_alu_tb;

reg [31:0] op_1_in, op_2_in;
reg [3:0]  opcode_in;
wire [31:0] result_out;

msrv32_alu ALU (
    .op_1_in(op_1_in),
    .op_2_in(op_2_in),
    .opcode_in(opcode_in),
    .result_out(result_out)
);

task initialize;
begin 
    op_1_in = 32'd0;
    op_2_in = 32'd0;
    opcode_in = 4'd0; 
end 
endtask

task stimulus(input [31:0] op_1, input [31:0] op_2, input [3:0] opcode);
begin 
    #10;
    op_1_in = op_1;
    op_2_in = op_2;
    opcode_in = opcode;
end 
endtask

initial begin
    initialize; 
    stimulus(32'd20, 32'd40, 4'b0000);
    stimulus(32'd20, 32'd40, 4'b1000);
    stimulus(32'd60, 32'd50, 4'b0000);
    #100 $finish;
end

initial begin
    $monitor ("Time=%0t | operand1=%d, operand2=%d, opcode=%b, Output result_out=%d", 
              $time, op_1_in, op_2_in, opcode_in, result_out);
end

endmodule