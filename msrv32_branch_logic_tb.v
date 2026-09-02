module msrv32_branch_logic_tb;

    reg branch;
    reg [2:0] funct3;
    reg zero;
    reg slt;
    reg sltu;
    wire branch_taken;

    msrv32_branch_logic uut (
        .branch(branch),
        .funct3(funct3),
        .zero(zero),
        .slt(slt),
        .sltu(sltu),
        .branch_taken(branch_taken)
    );

    initial begin
        branch = 0; 
        funct3 = 3'b000; 
        zero = 0; 
        slt = 0; 
        sltu = 0;
        #10;

        branch = 1; funct3 = 3'b000; zero = 1; slt = 0; sltu = 0;
        #10;
        branch = 1; funct3 = 3'b000; zero = 0; slt = 0; sltu = 0;
        #10;

        branch = 1; funct3 = 3'b001; zero = 0; slt = 0; sltu = 0;
        #10;
        branch = 1; funct3 = 3'b001; zero = 1; slt = 0; sltu = 0;
        #10;

        branch = 1; funct3 = 3'b100; zero = 0; slt = 1; sltu = 0;
        #10;
        branch = 1; funct3 = 3'b100; zero = 0; slt = 0; sltu = 0;
        #10;

        branch = 1; funct3 = 3'b101; zero = 0; slt = 0; sltu = 0;
        #10;
        branch = 1; funct3 = 3'b101; zero = 0; slt = 1; sltu = 0;
        #10;

        branch = 1; funct3 = 3'b110; zero = 0; slt = 0; sltu = 1;
        #10;
        branch = 1; funct3 = 3'b110; zero = 0; slt = 0; sltu = 0;
        #10;

        branch = 1; funct3 = 3'b111; zero = 0; slt = 0; sltu = 0;
        #10;
        branch = 1; funct3 = 3'b111; zero = 0; slt = 0; sltu = 1;
        #10;

        branch = 0; funct3 = 3'b000; zero = 1; slt = 0; sltu = 0;
        #10;

        $finish;
    end

endmodule