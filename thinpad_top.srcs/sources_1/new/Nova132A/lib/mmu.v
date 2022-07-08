`include "defines.vh"
module mmu (
    input wire[31:0] addr_i,
    output wire [31:0] addr_o
);
    wire [2:0] addr_head_i, addr_head_o;
    wire kseg0, kseg1, other_seg;

    assign addr_head_i = addr_i[31:29];
    
    assign kseg0 = addr_head_i == 3'b100;
    assign kseg1 = addr_head_i == 3'b101;

    assign other_seg = ~kseg0 & ~kseg1;

    assign addr_head_o = {3{kseg0}}&3'b000 | {3{kseg1}}&3'b000 | {3{other_seg}}&addr_head_i;
    
    assign addr_o = {addr_head_o, addr_i[28:0]};

endmodule