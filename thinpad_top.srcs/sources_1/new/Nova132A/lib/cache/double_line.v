`include "../defines.vh"
module double_line (
    input wire clk,
    input wire en,
    input wire [31:0] addr,
    output wire [63:0] dout,

    input wire reload,
    input wire [511:0] cacheline_new
); 
    wire [255:0] cacheline0_new, cacheline1_new, cacheline0_old, cacheline1_old;
    assign cacheline0_new = {cacheline_new[479:448], cacheline_new[415:384], cacheline_new[351:320], cacheline_new[287:256], cacheline_new[223:192], cacheline_new[159:128], cacheline_new[95:64], cacheline_new[31:0]};
    assign cacheline1_new = {cacheline_new[511:480], cacheline_new[447:416], cacheline_new[383:352], cacheline_new[319:288], cacheline_new[255:224], cacheline_new[191:160], cacheline_new[127:96], cacheline_new[63:32]};
    
    wire [3:0] wen;
    wire [31:0] din;
    wire [31:0] dout0, dout1;
    wire writeback;
    assign wen = 4'b0;
    assign din = 32'b0;
    assign writeback = 1'b0;
    icache_line u0_line(
    	.clk           (clk           ),
        .en            (en            ),
        .wen           (wen           ),
        .addr          (addr          ),
        .din           (din           ),
        .dout          (dout0         ),
        .writeback     (writeback     ),
        .reload        (reload        ),
        .cacheline_new (cacheline0_new ),
        .cacheline_old (cacheline0_old )
    );

    icache_line u1_line(
    	.clk           (clk           ),
        .en            (en            ),
        .wen           (wen           ),
        .addr          (addr          ),
        .din           (din           ),
        .dout          (dout1         ),
        .writeback     (writeback     ),
        .reload        (reload        ),
        .cacheline_new (cacheline1_new ),
        .cacheline_old (cacheline1_old )
    );
    
    assign dout = {dout1, dout0};
endmodule