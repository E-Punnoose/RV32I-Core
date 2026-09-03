module msrv32_imem (
    input  [31:0] pc_addr,
    output [31:0] instr_out
);

    reg [31:0] rom [0:1023];

    initial begin
        $readmemh("firmware.hex", rom);
    end

    assign instr_out = rom[pc_addr[11:2]];

endmodule