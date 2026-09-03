`timescale 1ns/1ps

module msrv32_hazard_unit_tb;

    reg id_ex_mem_read;
    reg [4:0] id_ex_rd;
    reg [4:0] if_id_rs1;
    reg [4:0] if_id_rs2;
    reg branch_taken;

    wire pc_write;
    wire if_id_write;
    wire hazard_mux_sel;
    wire flush;

    msrv32_hazard_unit uut (
        .id_ex_mem_read(id_ex_mem_read),
        .id_ex_rd(id_ex_rd),
        .if_id_rs1(if_id_rs1),
        .if_id_rs2(if_id_rs2),
        .branch_taken(branch_taken),
        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .hazard_mux_sel(hazard_mux_sel),
        .flush(flush)
    );

    initial begin
        id_ex_mem_read = 1'b0;
        id_ex_rd       = 5'b00000;
        if_id_rs1      = 5'b00000;
        if_id_rs2      = 5'b00000;
        branch_taken   = 1'b0;

        #10;
        id_ex_mem_read = 1'b1;
        id_ex_rd       = 5'b00001;
        if_id_rs1      = 5'b00001;
        if_id_rs2      = 5'b00010;

        #10;
        id_ex_mem_read = 1'b1;
        id_ex_rd       = 5'b00001;
        if_id_rs1      = 5'b00011;
        if_id_rs2      = 5'b00001;

        #10;
        id_ex_mem_read = 1'b0;
        id_ex_rd       = 5'b00001;
        if_id_rs1      = 5'b00001;
        if_id_rs2      = 5'b00010;

        #10;
        branch_taken   = 1'b1;

        #10;
        branch_taken   = 1'b0;

        #10;
        $finish;
    end

endmodule