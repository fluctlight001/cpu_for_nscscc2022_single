`include "../defines.vh"
module bank(
    input wire clk,
    input wire en,
    input wire [3:0] wen,
    input wire [6:0] index,
    input wire [31:0] din,
    output wire [31:0] dout
);
    cache_bank bank(
        .clka   (clk),
        .ena    (en),
        .wea    (wen),
        .addra  (index),
        .dina   (din),
        .douta  (dout)
    );

endmodule