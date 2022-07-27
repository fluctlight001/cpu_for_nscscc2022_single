`include "lib/defines.vh"
`define TAG_WD 21
`define INDEX_WD 7
`define LRU_WD 128
`define OFFSET_WD 5
module cache(
    input wire clk,
    input wire resetn,
    output wire stallreq,

    input wire data_sram_en,
    input wire [3:0] data_sram_wen,
    input wire [31:0] data_sram_addr,
    input wire [31:0] data_sram_wdata,
    output wire [31:0] data_sram_rdata,

    output wire rd_req,
    output wire [31:0] rd_addr,
    output wire wr_req,
    output wire [31:0] wr_addr,
    output wire [255:0] cacheline_old,

    input wire reload,
    input wire [255:0] cacheline_new
);
    reg [`LRU_WD-1:0] lru;
    wire [`TAG_WD-2:0] tag;
    wire [`INDEX_WD-1:0] index;
    wire [`OFFSET_WD-1:0] offset;
    wire hit;
    wire miss;
    wire [31:0] rdata_way0, rdata_way1;
    wire [255:0] cacheline_old_way0, cacheline_old_way1;

    wire hit_way0, hit_way1;
    reg [1:0] hit_r;
    wire [`TAG_WD-1:0] tag_way0, tag_way1;
    always @ (posedge clk) begin
        if (!resetn) begin
            lru <= `LRU_WD'b0;
        end
        else if (hit_way0) begin
            lru[index] <= 1'b1;
        end
        else if (hit_way1) begin
            lru[index] <= 1'b0;
        end
        else if (reload) begin
            lru[index] <= ~lru[index];
        end
    end

    dcache_tag u0_tag(
        .clk    (clk        ),
        .we     (reload&~lru[index]     ),
        .a      (index      ),
        .d      ({1'b1, tag}),
        .spo    (tag_way0   )
    );
    dcache_tag u1_tag(
        .clk    (clk        ),
        .we     (reload&lru[index]     ),
        .a      (index      ),
        .d      ({1'b1, tag}),
        .spo    (tag_way1   )
    );

    assign {tag, index, offset} = data_sram_addr;
    assign hit_way0 = data_sram_en & {1'b1, tag} == tag_way0;
    assign hit_way1 = data_sram_en & {1'b1, tag} == tag_way1;
    assign hit = hit_way0 | hit_way1;
    assign miss = data_sram_en & ~hit;
    assign stallreq = miss;
    assign rd_req = data_sram_en & miss;
    assign rd_addr = {data_sram_addr[31:5],5'b0};
    assign wr_req = data_sram_en & miss & (lru[index] ? tag_way1[`TAG_WD-1] : tag_way0[`TAG_WD-1]);
    assign wr_addr = lru[index] ? {tag_way1[`TAG_WD-2:0], index, 5'b0} : {tag_way0[`TAG_WD-2:0], index, 5'b0};

    line u0_line(
    	.clk           (clk             ),
        .en            (hit_way0        ),
        .wen           (data_sram_wen   ),
        .addr          (data_sram_addr  ),
        .din           (data_sram_wdata ),
        .dout          (rdata_way0      ),

        .writeback     (wr_req&~lru[index]           ),
        .reload        (reload&~lru[index]          ),
        .cacheline_new (cacheline_new   ),
        .cacheline_old (cacheline_old_way0   )
    );

    line u1_line(
    	.clk           (clk             ),
        .en            (hit_way1        ),
        .wen           (data_sram_wen   ),
        .addr          (data_sram_addr  ),
        .din           (data_sram_wdata ),
        .dout          (rdata_way1      ),

        .writeback     (wr_req&lru[index]          ),
        .reload        (reload&lru[index]          ),
        .cacheline_new (cacheline_new   ),
        .cacheline_old (cacheline_old_way1   )
    );
    
    always @ (posedge clk) begin
        hit_r <= {hit_way1, hit_way0};
    end
    assign data_sram_rdata = {32{hit_r[0]}} & rdata_way0
                            |{32{hit_r[1]}} & rdata_way1;
    assign cacheline_old = lru[index] ? cacheline_old_way1 : cacheline_old_way0;

endmodule