`include "../defines.vh"
module icache_line(
    input wire clk,
    input wire en,
    input wire [3:0] wen,
    input wire [31:0] addr,
    input wire [31:0] din,
    output wire [31:0] dout,

    input wire writeback,
    input wire reload,
    input wire [255:0] cacheline_new,
    output wire [255:0] cacheline_old
);
    wire [7:0] bank_sel;
    reg [7:0] bank_sel_r;
    wire [7:0] bank_en;
    wire [3:0] bank_wen [7:0];
    wire [31:0] bank_din [7:0];
    wire [31:0] bank_dout [7:0];

    wire [19:0] tag;
    wire [5:0] index;
    wire [2:0] offset;
    assign {tag, index, offset} = addr[31:3];

    genvar i;
    generate 
        for (i = 0; i < 8; i = i + 1) begin : bank
            i_bank u_bank(
                .clk   (clk   ),
                .en    (bank_en[i]    ),
                .wen   (bank_wen[i]   ),
                .index (index ),
                .din   (bank_din[i]   ),
                .dout  (bank_dout[i]  )
            );        
        end
    endgenerate
    
    decoder_3_8 u_decoder_3_8(
    	.in  (offset  ),
        .out (bank_sel )
    );

    assign bank_en = writeback | reload ? 8'hff : bank_sel;
    assign bank_wen[0] = reload ? 4'hf : bank_sel[0] ? wen : 4'b0;
    assign bank_wen[1] = reload ? 4'hf : bank_sel[1] ? wen : 4'b0;
    assign bank_wen[2] = reload ? 4'hf : bank_sel[2] ? wen : 4'b0;
    assign bank_wen[3] = reload ? 4'hf : bank_sel[3] ? wen : 4'b0;
    assign bank_wen[4] = reload ? 4'hf : bank_sel[4] ? wen : 4'b0;
    assign bank_wen[5] = reload ? 4'hf : bank_sel[5] ? wen : 4'b0;
    assign bank_wen[6] = reload ? 4'hf : bank_sel[6] ? wen : 4'b0;
    assign bank_wen[7] = reload ? 4'hf : bank_sel[7] ? wen : 4'b0;
    assign {bank_din[7], bank_din[6], bank_din[5], bank_din[4], bank_din[3], bank_din[2], bank_din[1], bank_din[0]} = reload ? cacheline_new : {8{din}};
    assign cacheline_old = {bank_dout[7], bank_dout[6], bank_dout[5], bank_dout[4], bank_dout[3], bank_dout[2], bank_dout[1], bank_dout[0]};
    
    always @ (posedge clk) begin
        bank_sel_r <= bank_sel;
    end
    assign dout = {32{bank_sel_r[7]}} & bank_dout[7] 
                | {32{bank_sel_r[6]}} & bank_dout[6] 
                | {32{bank_sel_r[5]}} & bank_dout[5] 
                | {32{bank_sel_r[4]}} & bank_dout[4] 
                | {32{bank_sel_r[3]}} & bank_dout[3] 
                | {32{bank_sel_r[2]}} & bank_dout[2] 
                | {32{bank_sel_r[1]}} & bank_dout[1] 
                | {32{bank_sel_r[0]}} & bank_dout[0]; 


    
endmodule