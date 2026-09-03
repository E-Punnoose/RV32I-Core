module msrv32_hazard_unit (
    input wire id_ex_mem_read,
    input wire [4:0] id_ex_rd,
    input wire [4:0] if_id_rs1,
    input wire [4:0] if_id_rs2,
    input wire branch_taken,
    output reg pc_write,
    output reg if_id_write,
    output reg hazard_mux_sel,
    output reg flush
);

    wire load_use_hazard;

    assign load_use_hazard = id_ex_mem_read && 
                             ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2)) && 
                             (id_ex_rd != 5'b00000);

    always @(*) begin
        if (load_use_hazard) begin
            pc_write       = 1'b0;
            if_id_write    = 1'b0;
            hazard_mux_sel = 1'b1;
        end else begin
            pc_write       = 1'b1;
            if_id_write    = 1'b1;
            hazard_mux_sel = 1'b0;
        end

        if (branch_taken) begin
            flush = 1'b1;
        end else begin
            flush = 1'b0;
        end
    end

endmodule