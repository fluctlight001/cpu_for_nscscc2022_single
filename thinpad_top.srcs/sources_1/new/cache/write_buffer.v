module write_buffer(
    input wire clk,
    input wire resetn,

    output wire stallreq,

    // sram_port
    input wire sram_en,
    input wire [3:0] sram_wen,
    input wire [31:0] sram_addr,
    input wire [31:0] sram_wdata,
    output wire [31:0] sram_rdata,
    // axi
    input wire wr_end,
    output wire wr_req,
    output wire [3:0] wr_wstrb,
    output wire [31:0] wr_addr,
    output wire [31:0] wr_data
);
    assign sram_rdata = 32'b0;
    assign wr_req = sram_en & (|sram_wen);
    assign wr_wstrb = sram_wen;
    assign wr_addr = sram_addr;
    assign wr_data = sram_wdata;
    assign stallreq = wr_req & ~wr_end;

endmodule