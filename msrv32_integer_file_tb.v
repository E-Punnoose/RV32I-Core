module msrv32_integer_file_tb;

    reg        ms_riscv32_mp_clk_in;
    reg        ms_riscv32_mp_rst_in;
    reg  [4:0] rs_1_addr_in, rs_2_addr_in;
    reg  [4:0] rd_addr_in;
    reg        wr_en_in;
    reg  [31:0] rd_in;
    wire [31:0] rs_1_out, rs_2_out;

    msrv32_integer_file INTF (
        .ms_riscv32_mp_clk_in (ms_riscv32_mp_clk_in),
        .ms_riscv32_mp_rst_in (ms_riscv32_mp_rst_in),
        .rs_1_addr_in         (rs_1_addr_in),
        .rs_2_addr_in         (rs_2_addr_in),
        .rs_1_out             (rs_1_out),
        .rs_2_out             (rs_2_out),
        .rd_addr_in           (rd_addr_in),
        .wr_en_in             (wr_en_in),
        .rd_in                (rd_in)
    );

    initial begin
        ms_riscv32_mp_clk_in = 0;
        forever #10 ms_riscv32_mp_clk_in = ~ms_riscv32_mp_clk_in;
    end

    task initialize;
    begin
        ms_riscv32_mp_rst_in = 0;
        rs_1_addr_in         = 5'd0;
        rs_2_addr_in         = 5'd0;
        rd_addr_in           = 5'd0;
        wr_en_in             = 1'b0;
        rd_in                = 32'd0;
    end
    endtask

    task reset;
    begin
        ms_riscv32_mp_rst_in = 1'b1;
        #20;
        ms_riscv32_mp_rst_in = 1'b0;
    end
    endtask

    task stimulus_write(
        input [4:0]  rd_addr,
        input        wr_en,
        input [31:0] rd
    );
    begin
        @(negedge ms_riscv32_mp_clk_in);
        rd_addr_in = rd_addr;
        rd_in      = rd;
        wr_en_in   = wr_en;
    end
    endtask

    task stimulus_read(
        input [4:0] rs1_addr,
        input [4:0] rs2_addr,
        input       wr_en
    );
    begin
        @(negedge ms_riscv32_mp_clk_in);
        rs_1_addr_in = rs1_addr;
        rs_2_addr_in = rs2_addr;
        wr_en_in     = wr_en;
    end
    endtask

    initial begin
        $monitor("rd_in=%d rs1_addr=%d rs2_addr=%d wr_en=%b | rs1_out=%d rs2_out=%d",
                  rd_in, rs_1_addr_in, rs_2_addr_in, wr_en_in, rs_1_out, rs_2_out);

        initialize;
        reset;

        stimulus_write(5'd5, 1'b1, 32'd30);
        stimulus_write(5'd6, 1'b1, 32'd50);
        stimulus_read(5'd5, 5'd6, 1'b0);

        #100;
        $finish;
    end

endmodule