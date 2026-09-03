module msrv32_dmem (
    input         clk,
    input         mem_write,
    input         mem_read,
    input  [2:0]  funct3,
    input  [31:0] addr,
    input  [31:0] write_data,
    output reg [31:0] read_data
);

    reg [31:0] ram [0:1023];
    wire [11:2] word_addr = addr[11:2];
    wire [1:0]  byte_offset = addr[1:0];

    wire [31:0] mem_word = ram[word_addr];

    reg [31:0] raw_read_data;
    always @(*) begin
        case (byte_offset)
            2'b00:   raw_read_data = mem_word;
            2'b01:   raw_read_data = {8'b0, mem_word[31:8]};
            2'b10:   raw_read_data = {16'b0, mem_word[31:16]};
            2'b11:   raw_read_data = {24'b0, mem_word[31:24]};
            default: raw_read_data = mem_word;
        endcase

        case (funct3)
            3'b000:  read_data = {{24{raw_read_data[7]}}, raw_read_data[7:0]};
            3'b001:  read_data = {{16{raw_read_data[15]}}, raw_read_data[15:0]};
            3'b010:  read_data = raw_read_data;
            3'b100:  read_data = {24'b0, raw_read_data[7:0]};
            3'b101:  read_data = {16'b0, raw_read_data[15:0]};
            default: read_data = raw_read_data;
        endcase
    end

    always @(posedge clk) begin
        if (mem_write) begin
            case (funct3)
                3'b000: begin
                    case (byte_offset)
                        2'b00: ram[word_addr][7:0]   <= write_data[7:0];
                        2'b01: ram[word_addr][15:8]  <= write_data[7:0];
                        2'b10: ram[word_addr][23:16] <= write_data[7:0];
                        2'b11: ram[word_addr][31:24] <= write_data[7:0];
                    endcase
                end
                3'b001: begin
                    case (byte_offset[1])
                        1'b0:  ram[word_addr][15:0]  <= write_data[15:0];
                        1'b1:  ram[word_addr][31:16] <= write_data[15:0];
                    endcase
                end
                3'b010: begin
                    ram[word_addr] <= write_data;
                end
                default: ;
            endcase
        end
    end

endmodule