module msrv32_forwarding_unit_tb;

    reg [4:0] ex_mem_rd;
    reg       ex_mem_reg_write;
    reg [4:0] mem_wb_rd;
    reg       mem_wb_reg_write;
    reg [4:0] id_ex_rs1;
    reg [4:0] id_ex_rs2;

    wire [1:0] forward_a;
    wire [1:0] forward_b;

    msrv32_forwarding_unit uut (
        .ex_mem_rd(ex_mem_rd),
        .ex_mem_reg_write(ex_mem_reg_write),
        .mem_wb_rd(mem_wb_rd),
        .mem_wb_reg_write(mem_wb_reg_write),
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    initial begin
        ex_mem_rd = 5'd0;
        ex_mem_reg_write = 1'b0;
        mem_wb_rd = 5'd0;
        mem_wb_reg_write = 1'b0;
        id_ex_rs1 = 5'd0;
        id_ex_rs2 = 5'd0;
        #10;

        id_ex_rs1 = 5'd5;
        id_ex_rs2 = 5'd10;
        #10;

        ex_mem_rd = 5'd5;
        ex_mem_reg_write = 1'b1;
        id_ex_rs1 = 5'd5;
        #10;

        ex_mem_reg_write = 1'b0;
        mem_wb_rd = 5'd10;
        mem_wb_reg_write = 1'b1;
        id_ex_rs2 = 5'd10;
        #10;

        ex_mem_rd = 5'd7;
        ex_mem_reg_write = 1'b1;
        mem_wb_rd = 5'd7;
        mem_wb_reg_write = 1'b1;
        id_ex_rs1 = 5'd7;
        #10;

        ex_mem_rd = 5'd0;
        ex_mem_reg_write = 1'b1;
        id_ex_rs1 = 5'd0;
        #10;

        $finish;
    end

endmodule