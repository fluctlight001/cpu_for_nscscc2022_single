// cache
`define TAG_WD 22    // tag + v
`define INDEX_NUM 64 // 块高  // depth
`define CACHELINE_WD 256
`define HIT_WD 2
`define LRU_WD 1
// 单行16条的版本
module cache_top(
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
    output wire rd_req,
    output wire [31:0] rd_addr,
    // output wire wr_req,
    // output wire [31:0] wr_addr,
    // output wire [255:0] cacheline_old,
    input wire reload, 
    input wire [255:0] cacheline_new
);
    reg [`TAG_WD-1:0] tag_way0 [`INDEX_NUM-1:0]; // v + tag 
    reg [`TAG_WD-1:0] tag_way1 [`INDEX_NUM-1:0];
    reg [`INDEX_NUM-1:0] lru_r;
    wire [`TAG_WD-2:0] tag;
    wire [5:0] index;
    wire [4:0] offset;

    wire hit;
    wire hit_way0;
    wire hit_way1;
    wire miss;
    wire lru;

    wire [31:0] rdata_way0, rdata_way1;

    assign {
        tag,
        index,
        offset
    } = sram_addr;


    // lru lru_r指向的即为最闲的那个
    always @ (posedge clk) begin
        if (!resetn) begin
            lru_r  <= `INDEX_NUM'b0;
        end
        else if (hit_way0) begin
            lru_r[index] <= 1'b1;
        end
        else if (hit_way1) begin
            lru_r[index] <= 1'b0;
        end
        else if (reload) begin
            lru_r[index] <= ~lru_r[index];
        end
    end

    // way0
    always @ (posedge clk) begin
        if (!resetn) begin
            tag_way0[  0] <= 22'b0;
            tag_way0[  1] <= 22'b0;
            tag_way0[  2] <= 22'b0;
            tag_way0[  3] <= 22'b0;
            tag_way0[  4] <= 22'b0;
            tag_way0[  5] <= 22'b0;
            tag_way0[  6] <= 22'b0;
            tag_way0[  7] <= 22'b0;
            tag_way0[  8] <= 22'b0;
            tag_way0[  9] <= 22'b0;
            tag_way0[ 10] <= 22'b0;
            tag_way0[ 11] <= 22'b0;
            tag_way0[ 12] <= 22'b0;
            tag_way0[ 13] <= 22'b0;
            tag_way0[ 14] <= 22'b0;
            tag_way0[ 15] <= 22'b0;
            tag_way0[ 16] <= 22'b0;
            tag_way0[ 17] <= 22'b0;
            tag_way0[ 18] <= 22'b0;
            tag_way0[ 19] <= 22'b0;
            tag_way0[ 20] <= 22'b0;
            tag_way0[ 21] <= 22'b0;
            tag_way0[ 22] <= 22'b0;
            tag_way0[ 23] <= 22'b0;
            tag_way0[ 24] <= 22'b0;
            tag_way0[ 25] <= 22'b0;
            tag_way0[ 26] <= 22'b0;
            tag_way0[ 27] <= 22'b0;
            tag_way0[ 28] <= 22'b0;
            tag_way0[ 29] <= 22'b0;
            tag_way0[ 30] <= 22'b0;
            tag_way0[ 31] <= 22'b0;
            tag_way0[ 32] <= 22'b0;
            tag_way0[ 33] <= 22'b0;
            tag_way0[ 34] <= 22'b0;
            tag_way0[ 35] <= 22'b0;
            tag_way0[ 36] <= 22'b0;
            tag_way0[ 37] <= 22'b0;
            tag_way0[ 38] <= 22'b0;
            tag_way0[ 39] <= 22'b0;
            tag_way0[ 40] <= 22'b0;
            tag_way0[ 41] <= 22'b0;
            tag_way0[ 42] <= 22'b0;
            tag_way0[ 43] <= 22'b0;
            tag_way0[ 44] <= 22'b0;
            tag_way0[ 45] <= 22'b0;
            tag_way0[ 46] <= 22'b0;
            tag_way0[ 47] <= 22'b0;
            tag_way0[ 48] <= 22'b0;
            tag_way0[ 49] <= 22'b0;
            tag_way0[ 50] <= 22'b0;
            tag_way0[ 51] <= 22'b0;
            tag_way0[ 52] <= 22'b0;
            tag_way0[ 53] <= 22'b0;
            tag_way0[ 54] <= 22'b0;
            tag_way0[ 55] <= 22'b0;
            tag_way0[ 56] <= 22'b0;
            tag_way0[ 57] <= 22'b0;
            tag_way0[ 58] <= 22'b0;
            tag_way0[ 59] <= 22'b0;
            tag_way0[ 60] <= 22'b0;
            tag_way0[ 61] <= 22'b0;
            tag_way0[ 62] <= 22'b0;
            tag_way0[ 63] <= 22'b0;
        end
        else if (reload&(~lru_r[index])) begin
            tag_way0[index] <= {1'b1,tag};
        end
    end

    // way1
    always @ (posedge clk) begin
        if (!resetn) begin
            tag_way1[  0] <= 22'b0;
            tag_way1[  1] <= 22'b0;
            tag_way1[  2] <= 22'b0;
            tag_way1[  3] <= 22'b0;
            tag_way1[  4] <= 22'b0;
            tag_way1[  5] <= 22'b0;
            tag_way1[  6] <= 22'b0;
            tag_way1[  7] <= 22'b0;
            tag_way1[  8] <= 22'b0;
            tag_way1[  9] <= 22'b0;
            tag_way1[ 10] <= 22'b0;
            tag_way1[ 11] <= 22'b0;
            tag_way1[ 12] <= 22'b0;
            tag_way1[ 13] <= 22'b0;
            tag_way1[ 14] <= 22'b0;
            tag_way1[ 15] <= 22'b0;
            tag_way1[ 16] <= 22'b0;
            tag_way1[ 17] <= 22'b0;
            tag_way1[ 18] <= 22'b0;
            tag_way1[ 19] <= 22'b0;
            tag_way1[ 20] <= 22'b0;
            tag_way1[ 21] <= 22'b0;
            tag_way1[ 22] <= 22'b0;
            tag_way1[ 23] <= 22'b0;
            tag_way1[ 24] <= 22'b0;
            tag_way1[ 25] <= 22'b0;
            tag_way1[ 26] <= 22'b0;
            tag_way1[ 27] <= 22'b0;
            tag_way1[ 28] <= 22'b0;
            tag_way1[ 29] <= 22'b0;
            tag_way1[ 30] <= 22'b0;
            tag_way1[ 31] <= 22'b0;
            tag_way1[ 32] <= 22'b0;
            tag_way1[ 33] <= 22'b0;
            tag_way1[ 34] <= 22'b0;
            tag_way1[ 35] <= 22'b0;
            tag_way1[ 36] <= 22'b0;
            tag_way1[ 37] <= 22'b0;
            tag_way1[ 38] <= 22'b0;
            tag_way1[ 39] <= 22'b0;
            tag_way1[ 40] <= 22'b0;
            tag_way1[ 41] <= 22'b0;
            tag_way1[ 42] <= 22'b0;
            tag_way1[ 43] <= 22'b0;
            tag_way1[ 44] <= 22'b0;
            tag_way1[ 45] <= 22'b0;
            tag_way1[ 46] <= 22'b0;
            tag_way1[ 47] <= 22'b0;
            tag_way1[ 48] <= 22'b0;
            tag_way1[ 49] <= 22'b0;
            tag_way1[ 50] <= 22'b0;
            tag_way1[ 51] <= 22'b0;
            tag_way1[ 52] <= 22'b0;
            tag_way1[ 53] <= 22'b0;
            tag_way1[ 54] <= 22'b0;
            tag_way1[ 55] <= 22'b0;
            tag_way1[ 56] <= 22'b0;
            tag_way1[ 57] <= 22'b0;
            tag_way1[ 58] <= 22'b0;
            tag_way1[ 59] <= 22'b0;
            tag_way1[ 60] <= 22'b0;
            tag_way1[ 61] <= 22'b0;
            tag_way1[ 62] <= 22'b0;
            tag_way1[ 63] <= 22'b0;
        end
        else if (reload&lru_r[index]) begin
            tag_way1[index] <= {1'b1,tag};
        end
    end

    assign lru = lru_r[index];
    
    assign hit_way0 = sram_en & (~|({1'b1,tag} ^ tag_way0[index]));
    assign hit_way1 = sram_en & (~|({1'b1,tag} ^ tag_way1[index]));
    assign hit = hit_way0 | hit_way1;

    assign miss = sram_en & ~(|sram_wen) & ~hit;
    assign stallreq = miss;

    assign rd_req = miss;
    assign rd_addr = {sram_addr[31:5],5'b0};
    
    way u0_way(
    	.clk           (clk           ),
        .en            (hit_way0      ),
        .wen           (sram_wen      ),
        .addr          (sram_addr     ),
        .din           (sram_wdata    ),
        .dout          (rdata_way0    ),

        .writeback     (1'b0          ),
        .reload        (reload&~lru   ),
        .cacheline_new (cacheline_new ),
        .cacheline_old ( )
    );
    
    way u1_way(
    	.clk           (clk           ),
        .en            (hit_way1      ),
        .wen           (sram_wen      ),
        .addr          (sram_addr     ),
        .din           (sram_wdata    ),
        .dout          (rdata_way1    ),

        .writeback     (1'b0          ),
        .reload        (reload&lru    ),
        .cacheline_new (cacheline_new ),
        .cacheline_old ( )
    );

    reg [1:0] hit_r;
    always @ (posedge clk) begin
        hit_r <= {hit_way1, hit_way0};
    end
    assign sram_rdata = hit_r[0] ? rdata_way0 : rdata_way1; 
endmodule