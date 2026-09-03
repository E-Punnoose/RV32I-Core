module msrv32_core (
    input wire clk,
    input wire rst
);

    wire [31:0] pc_current, pc_next, pc_plus4;
    wire [31:0] instruction_if, instruction_id;
    wire [31:0] pc_id, pc_ex;
    wire        pc_write, if_id_write, if_id_flush;

    wire        ctrl_branch, ctrl_mem_read, ctrl_mem_to_reg, ctrl_mem_write, ctrl_alu_src, ctrl_reg_write;
    wire [1:0]  ctrl_alu_op;
    wire [3:0]  alu_op_id_out;
    
    wire        hazard_mux_sel;
    wire        branch_id, mem_read_id, mem_to_reg_id, mem_write_id, alu_src_id, reg_write_id;
    wire [3:0]  alu_op_id;
    wire        jal_id, jalr_id;

    wire [31:0] reg_rd1, reg_rd2, reg_wd;
    wire [31:0] imm_id, imm_ex;
    
    wire [31:0] rs1_data_ex, rs2_data_ex;
    wire [4:0]  rs1_ex, rs2_ex, rd_ex;
    wire [2:0]  funct3_ex;
    wire [6:0]  funct7_ex, opcode_ex;
    wire        branch_ex, jal_ex, jalr_ex, mem_read_ex, mem_write_ex, mem_to_reg_ex, reg_write_ex, alu_src_ex;
    wire [3:0]  alu_op_ex;
    
    wire [31:0] alu_in1, alu_in2, alu_result_ex, ex_mem_alu_result;
    wire [31:0] rs2_forwarded;
    wire [1:0]  forward_a, forward_b;
    wire        branch_taken_logic, branch_taken;
    wire [31:0] branch_target;

    wire [31:0] alu_result_mem, alu_result_wb;
    wire [31:0] rs2_data_mem;
    wire [4:0]  rd_mem, rd_wb;
    wire [2:0]  funct3_mem;
    wire        mem_read_mem, mem_write_mem, reg_write_mem, mem_to_reg_mem;
    wire        reg_write_wb, mem_to_reg_wb;
    wire [31:0] dmem_rdata, dmem_rdata_wb;

    msrv32_pc pc_inst (
        .clk(clk),
        .reset(rst),
        .pc_in(pc_next),
        .pc_write(pc_write),
        .pc_out(pc_current)
    );

    assign pc_plus4 = pc_current + 32'd4;
    assign pc_next = branch_taken ? branch_target : pc_plus4;

    msrv32_imem imem_inst (
        .pc_addr(pc_current),
        .instr_out(instruction_if)
    );

    msrv32_if_id if_id_inst (
        .clk(clk),
        .reset(rst),
        .if_id_write(if_id_write),
        .if_id_flush(if_id_flush),
        .pc_in(pc_current),
        .instr_in(instruction_if),
        .pc_out(pc_id),
        .instr_out(instruction_id)
    );

    msrv32_main_control ctrl_inst (
        .opcode(instruction_id[6:0]),
        .branch(ctrl_branch),
        .mem_read(ctrl_mem_read),
        .mem_to_reg(ctrl_mem_to_reg),
        .alu_op(ctrl_alu_op),
        .mem_write(ctrl_mem_write),
        .alu_src(ctrl_alu_src),
        .reg_write(ctrl_reg_write)
    );

    msrv32_alu_control alu_ctrl_inst (
        .alu_op(ctrl_alu_op),
        .funct3(instruction_id[14:12]),
        .funct7(instruction_id[31:25]),
        .alu_ctrl(alu_op_id_out)
    );

    assign branch_id     = hazard_mux_sel ? 1'b0 : ctrl_branch;
    assign mem_read_id   = hazard_mux_sel ? 1'b0 : ctrl_mem_read;
    assign mem_to_reg_id = hazard_mux_sel ? 1'b0 : ctrl_mem_to_reg;
    assign mem_write_id  = hazard_mux_sel ? 1'b0 : ctrl_mem_write;
    assign alu_src_id    = hazard_mux_sel ? 1'b0 : ctrl_alu_src;
    assign reg_write_id  = hazard_mux_sel ? 1'b0 : ctrl_reg_write;
    assign alu_op_id     = hazard_mux_sel ? 4'b0 : alu_op_id_out;
    
    assign jal_id  = (instruction_id[6:0] == 7'b1101111);
    assign jalr_id = (instruction_id[6:0] == 7'b1100111);

    msrv32_integer_file reg_file_inst (
        .ms_riscv32_mp_clk_in(clk),
        .ms_riscv32_mp_rst_in(rst),
        .rs_1_addr_in(instruction_id[19:15]),
        .rs_2_addr_in(instruction_id[24:20]),
        .rs_1_out(reg_rd1),
        .rs_2_out(reg_rd2),
        .rd_addr_in(rd_wb),
        .wr_en_in(reg_write_wb),
        .rd_in(reg_wd)
    );

    msrv32_imm_gen imm_gen_inst (
        .in(instruction_id),
        .imm_out(imm_id)
    );

    msrv32_hazard_unit hazard_inst (
        .id_ex_mem_read(mem_read_ex),
        .id_ex_rd(rd_ex),
        .if_id_rs1(instruction_id[19:15]),
        .if_id_rs2(instruction_id[24:20]),
        .branch_taken(branch_taken),
        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .hazard_mux_sel(hazard_mux_sel),
        .flush(if_id_flush)
    );

    msrv32_id_ex id_ex_inst (
        .clk(clk),
        .reset(rst),
        .flush(if_id_flush),
        .alu_src_in(alu_src_id),
        .alu_op_in(alu_op_id),
        .mem_write_in(mem_write_id),
        .mem_read_in(mem_read_id),
        .reg_write_in(reg_write_id),
        .mem_to_reg_in(mem_to_reg_id),
        .branch_in(branch_id),
        .jal_in(jal_id),
        .jalr_in(jalr_id),
        .pc_in(pc_id),
        .rs1_data_in(reg_rd1),
        .rs2_data_in(reg_rd2),
        .imm_in(imm_id),
        .rs1_addr_in(instruction_id[19:15]),
        .rs2_addr_in(instruction_id[24:20]),
        .rd_addr_in(instruction_id[11:7]),
        .funct3_in(instruction_id[14:12]),
        .funct7_in(instruction_id[31:25]),
        .opcode_in(instruction_id[6:0]),
        .alu_src_out(alu_src_ex),
        .alu_op_out(alu_op_ex),
        .mem_write_out(mem_write_ex),
        .mem_read_out(mem_read_ex),
        .reg_write_out(reg_write_ex),
        .mem_to_reg_out(mem_to_reg_ex),
        .branch_out(branch_ex),
        .jal_out(jal_ex),
        .jalr_out(jalr_ex),
        .pc_out(pc_ex),
        .rs1_data_out(rs1_data_ex),
        .rs2_data_out(rs2_data_ex),
        .imm_out(imm_ex),
        .rs1_addr_out(rs1_ex),
        .rs2_addr_out(rs2_ex),
        .rd_addr_out(rd_ex),
        .funct3_out(funct3_ex),
        .funct7_out(funct7_ex),
        .opcode_out(opcode_ex)
    );

    assign alu_in1 = (forward_a == 2'b10) ? alu_result_mem :
                     (forward_a == 2'b01) ? reg_wd : rs1_data_ex;

    assign rs2_forwarded = (forward_b == 2'b10) ? alu_result_mem :
                           (forward_b == 2'b01) ? reg_wd : rs2_data_ex;

    assign alu_in2 = alu_src_ex ? imm_ex : rs2_forwarded;

    msrv32_alu alu_inst (
        .op_1_in(alu_in1),
        .op_2_in(alu_in2),
        .opcode_in(alu_op_ex),
        .result_out(alu_result_ex)
    );

    msrv32_forwarding_unit fwd_inst (
        .ex_mem_rd(rd_mem),
        .ex_mem_reg_write(reg_write_mem),
        .mem_wb_rd(rd_wb),
        .mem_wb_reg_write(reg_write_wb),
        .id_ex_rs1(rs1_ex),
        .id_ex_rs2(rs2_ex),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    msrv32_branch_logic branch_logic_inst (
        .branch(branch_ex),
        .funct3(funct3_ex),
        .zero(alu_in1 == alu_in2),
        .slt($signed(alu_in1) < $signed(alu_in2)),
        .sltu(alu_in1 < alu_in2),
        .branch_taken(branch_taken_logic)
    );

    assign branch_target     = jalr_ex ? (alu_in1 + imm_ex) : (pc_ex + imm_ex);
    assign branch_taken      = branch_taken_logic || jal_ex || jalr_ex;
    assign ex_mem_alu_result = (jal_ex || jalr_ex) ? (pc_ex + 32'd4) : alu_result_ex;

    msrv32_ex_mem ex_mem_inst (
        .clk(clk),
        .reset(rst),
        .mem_write_in(mem_write_ex),
        .mem_read_in(mem_read_ex),
        .reg_write_in(reg_write_ex),
        .mem_to_reg_in(mem_to_reg_ex),
        .funct3_in(funct3_ex),
        .alu_result_in(ex_mem_alu_result),
        .rs2_data_in(rs2_forwarded),
        .rd_addr_in(rd_ex),
        .mem_write_out(mem_write_mem),
        .mem_read_out(mem_read_mem),
        .reg_write_out(reg_write_mem),
        .mem_to_reg_out(mem_to_reg_mem),
        .funct3_out(funct3_mem),
        .alu_result_out(alu_result_mem),
        .rs2_data_out(rs2_data_mem),
        .rd_addr_out(rd_mem)
    );

    msrv32_dmem dmem_inst (
        .clk(clk),
        .mem_write(mem_write_mem),
        .mem_read(mem_read_mem),
        .funct3(funct3_mem),
        .addr(alu_result_mem),
        .write_data(rs2_data_mem),
        .read_data(dmem_rdata)
    );

    msrv32_mem_wb mem_wb_inst (
        .clk(clk),
        .reset(rst),
        .reg_write_in(reg_write_mem),
        .mem_to_reg_in(mem_to_reg_mem),
        .mem_data_in(dmem_rdata),
        .alu_result_in(alu_result_mem),
        .rd_addr_in(rd_mem),
        .reg_write_out(reg_write_wb),
        .mem_to_reg_out(mem_to_reg_wb),
        .mem_data_out(dmem_rdata_wb),
        .alu_result_out(alu_result_wb),
        .rd_addr_out(rd_wb)
    );

    assign reg_wd = mem_to_reg_wb ? dmem_rdata_wb : alu_result_wb;

endmodule