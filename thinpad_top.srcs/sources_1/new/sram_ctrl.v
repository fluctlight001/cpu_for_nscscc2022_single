`define STAGE_WD 12
module sram_ctrl(
    input wire clk,
    input wire resetn,

    //BaseRAM信号
    inout wire[31:0] base_ram_data,  //BaseRAM数据，低8位与CPLD串口控制器共享
    output wire[19:0] base_ram_addr, //BaseRAM地址
    output wire[3:0] base_ram_be_n,  //BaseRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output wire base_ram_ce_n,       //BaseRAM片选，低有效
    output wire base_ram_oe_n,       //BaseRAM读使能，低有效
    output wire base_ram_we_n,       //BaseRAM写使能，低有效

    //ExtRAM信号
    inout wire[31:0] ext_ram_data,  //ExtRAM数据
    output wire[19:0] ext_ram_addr, //ExtRAM地址
    output wire[3:0] ext_ram_be_n,  //ExtRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output wire ext_ram_ce_n,       //ExtRAM片选，低有效
    output wire ext_ram_oe_n,       //ExtRAM读使能，低有效
    output wire ext_ram_we_n,       //ExtRAM写使能，低有效

    // //icache 
    // input wire ird_req,
    // input wire [31:0] ird_addr,
    // input wire iwr_req,
    // input wire [31:0] iwr_addr,
    // input wire [255:0] icacheline_old,
    // output reg ireload,
    // output reg [255:0] icacheline_new,

    // //dcache
    // input wire drd_req,
    // input wire [31:0] drd_addr,
    // input wire dwr_req,
    // input wire [3:0] dwr_wstrb,
    // input wire [31:0] dwr_addr,
    // input wire [31:0] dwr_data,
    // output reg dreload,
    // output reg [31:0] drd_data

    //icache
    input wire ird_req,
    input wire [31:0] ird_addr,
    output reg ireload,
    output reg [255:0] icacheline_new,

    input wire iwr_req,
    input wire [3:0] iwr_wstrb,
    input wire [31:0] iwr_addr,
    input wire [31:0] iwr_data,
    output reg iwr_end,

    //dcache
    input wire drd_req,
    input wire [31:0] drd_addr,
    output reg dreload,
    output reg [255:0] dcacheline_new,

    input wire dwr_req,
    input wire [3:0] dwr_wstrb,
    input wire [31:0] dwr_addr,
    input wire [31:0] dwr_data,
    output reg dwr_end
);
    //reg for base ram
    reg [31:0] base_ram_data_r;
    reg [19:0] base_ram_addr_r;
    reg [3:0] base_ram_be_n_r;
    reg base_ram_ce_n_r;
    reg base_ram_oe_n_r;
    reg base_ram_we_n_r;
    //reg for ext ram
    reg [31:0] ext_ram_data_r;
    reg [19:0] ext_ram_addr_r;
    reg [3:0] ext_ram_be_n_r;
    reg ext_ram_ce_n_r;
    reg ext_ram_oe_n_r;
    reg ext_ram_we_n_r;

    reg [`STAGE_WD-1:0] stage_i;
    reg [`STAGE_WD-1:0] stage_d;

    reg [3:0] icache_offset;
    reg [3:0] icache_offset_w;
    reg [3:0] dcache_offset;
    reg [3:0] dcache_offset_w;

    reg ird_req_r, drd_req_r;
    reg iwr_req_r, dwr_req_r;

    assign base_ram_data = ~base_ram_we_n_r ? base_ram_data_r : 32'bz;
    assign ext_ram_data  = ~ext_ram_we_n_r  ? ext_ram_data_r  : 32'bz;

    assign base_ram_addr = base_ram_addr_r;
    assign base_ram_be_n = base_ram_be_n_r;
    assign base_ram_ce_n = base_ram_ce_n_r;
    assign base_ram_oe_n = base_ram_oe_n_r;
    assign base_ram_we_n = base_ram_we_n_r;

    assign ext_ram_addr = ext_ram_addr_r;
    assign ext_ram_be_n = ext_ram_be_n_r;
    assign ext_ram_ce_n = ext_ram_ce_n_r;
    assign ext_ram_oe_n = ext_ram_oe_n_r;
    assign ext_ram_we_n = ext_ram_we_n_r;

    //in
    assign cpu_inst_rdata = base_ram_data;
    assign inst_sram_rdata = base_ram_data;
    assign data_sram_rdata = ext_ram_data;

    //out
    always @ (posedge clk) begin
        if (!resetn) begin
            base_ram_addr_r <= 20'b0;
            base_ram_be_n_r <= 4'b0;
            base_ram_ce_n_r <= 1'b1;
            base_ram_oe_n_r <= 1'b1;
            base_ram_we_n_r <= 1'b1;
            base_ram_data_r <= 32'b0;

            stage_i <= `STAGE_WD'b1;
            ird_req_r <= 1'b0;
            iwr_req_r <= 1'b0;
            icache_offset <= 4'b0;
            icache_offset_w <= 4'b0;
            ireload <= 1'b0;
            iwr_end <= 1'b0;
            icacheline_new <= 256'b0;
        end
        else begin
            case(1'b1)
                stage_i[0]:begin
                    ireload <= 1'b0;
                    iwr_end <= 1'b0;
                    icacheline_new <= 256'b0;
                    ird_req_r <= ird_req;
                    iwr_req_r <= iwr_req;
                    if (ird_req) begin
                        base_ram_addr_r <= ird_addr[21:2] + icache_offset;
                        base_ram_be_n_r <= 4'b0;
                        base_ram_ce_n_r <= 1'b0;
                        base_ram_oe_n_r <= 1'b0;
                        base_ram_we_n_r <= 1'b1;
                        base_ram_data_r <= 32'b0;
                        stage_i <= stage_i << 1;
                        // icache_offset <= 4'b0;
                    end
                    else if (iwr_req) begin
                        base_ram_addr_r <= iwr_addr[21:2];
                        base_ram_be_n_r <= 4'b0;
                        base_ram_ce_n_r <= 1'b0;
                        base_ram_oe_n_r <= 1'b1;
                        base_ram_we_n_r <= 1'b0;
                        base_ram_data_r <= iwr_data;
                        stage_i <= 1'b0;
                        iwr_end <= 1'b1;
                        // icache_offset_w <= 4'b0;
                    end
                end
                stage_i[1]:begin
                    // icache_offset <= icache_offset + 1'b1;
                    stage_i <= stage_i << 1;
                end
                stage_i[2]:begin
                    icacheline_new[icache_offset*32+:32] <= base_ram_data;
                    if (icache_offset == 4'b0111) begin
                        base_ram_addr_r <= 20'b0;
                        base_ram_be_n_r <= 4'b0;
                        base_ram_ce_n_r <= 1'b1;
                        base_ram_oe_n_r <= 1'b1;
                        base_ram_we_n_r <= 1'b1;
                        base_ram_data_r <= 32'b0;
                        stage_i <= 1'b0;
                        ireload <= 1'b1;
                    end
                    else begin
                        base_ram_addr_r <= ird_addr[21:2] + icache_offset + 1'b1;
                        icache_offset <= icache_offset + 1'b1;
                        stage_i <= stage_i >> 1;
                    end
                end
                default:begin
                    stage_i <= 1'b1;
                    ireload <= 1'b0;
                    iwr_end <= 1'b0;
                    base_ram_addr_r <= 20'b0;
                    base_ram_be_n_r <= 4'b0;
                    base_ram_ce_n_r <= 1'b1;
                    base_ram_oe_n_r <= 1'b1;
                    base_ram_we_n_r <= 1'b1;
                    base_ram_data_r <= 32'b0;
                    icache_offset <= 4'b0;
                end

            endcase 
        end
        // todo
        // else begin
        //     base_ram_addr_r <= inst_sram_en ? inst_sram_addr[21:2] : cpu_inst_addr[21:2];
        //     base_ram_be_n_r <= (|inst_sram_wen) ? ~inst_sram_wen : 4'b0;
        //     base_ram_ce_n_r <= ~cpu_inst_en & ~inst_sram_en;
        //     base_ram_oe_n_r <= ~(cpu_inst_en & ~(|cpu_inst_wen)) & ~(inst_sram_en & ~(|inst_sram_wen));
        //     base_ram_we_n_r <= ~(cpu_inst_en & (|cpu_inst_wen)) & ~(inst_sram_en & (|inst_sram_wen));
        //     base_ram_data_r <= inst_sram_wdata;

        //     ext_ram_addr_r <= data_sram_addr[21:2];
        //     ext_ram_be_n_r <= (|data_sram_wen) ? ~data_sram_wen : 4'b0;
        //     ext_ram_ce_n_r <= ~data_sram_en;
        //     ext_ram_oe_n_r <= ~(data_sram_en & ~(|data_sram_wen));
        //     ext_ram_we_n_r <= ~(data_sram_en & (|data_sram_wen));
        //     ext_ram_data_r <= data_sram_wdata;
        // end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            ext_ram_addr_r <= 20'b0;
            ext_ram_be_n_r <= 4'b0;
            ext_ram_ce_n_r <= 1'b1;
            ext_ram_oe_n_r <= 1'b1;
            ext_ram_we_n_r <= 1'b1;
            ext_ram_data_r <= 32'b0;

            stage_d <= `STAGE_WD'b1;
            drd_req_r <= 1'b0;
            dwr_req_r <= 1'b0;
            dcache_offset <= 4'b0;
            dcache_offset_w <= 4'b0;
            dreload <= 1'b0;
            dwr_end <= 1'b0;
            dcacheline_new <= 256'b0;

        end
        else begin
            case(1'b1)
                stage_d[0]:begin
                    dreload <= 1'b0;
                    dwr_end <= 1'b0;
                    dcacheline_new <= 256'b0;
                    drd_req_r <= drd_req;
                    dwr_req_r <= dwr_req;
                    if (drd_req) begin
                        ext_ram_addr_r <= drd_addr[21:2];
                        ext_ram_be_n_r <= 4'b0;
                        ext_ram_ce_n_r <= 1'b0;
                        ext_ram_oe_n_r <= 1'b0;
                        ext_ram_we_n_r <= 1'b1;
                        ext_ram_data_r <= 32'b0;
                        stage_d <= stage_d << 1;
                        // dcache_offset <= 4'b0;
                    end
                    else if (dwr_req) begin
                        ext_ram_addr_r <= dwr_addr[21:2];
                        ext_ram_be_n_r <= 4'b0;
                        ext_ram_ce_n_r <= 1'b0;
                        ext_ram_oe_n_r <= 1'b1;
                        ext_ram_we_n_r <= 1'b0;
                        ext_ram_data_r <= dwr_data;
                        stage_d <= 1'b0;
                        dwr_end <= 1'b1;
                        // dcache_offset_w <= 4'b0;
                    end
                end
                stage_d[1]:begin
                    stage_d <= stage_d << 1;
                end
                stage_d[2]:begin
                    dcacheline_new[dcache_offset*32+:32] <= ext_ram_data;
                    if (dcache_offset == 4'b0111) begin
                        ext_ram_addr_r <= 20'b0;
                        ext_ram_be_n_r <= 4'b0;
                        ext_ram_ce_n_r <= 1'b1;
                        ext_ram_oe_n_r <= 1'b1;
                        ext_ram_we_n_r <= 1'b1;
                        ext_ram_data_r <= 32'b0;
                        stage_d <= 1'b0;
                        dreload <= 1'b1;
                    end
                    else begin
                        ext_ram_addr_r <= drd_addr[21:2] + dcache_offset + 1'b1;
                        dcache_offset <= dcache_offset + 1'b1;
                        stage_d <= stage_d >> 1;
                    end
                end
                default:begin
                    stage_d <= 1'b1;
                    dreload <= 1'b0;
                    dwr_end <= 1'b0;
                    ext_ram_addr_r <= 20'b0;
                    ext_ram_be_n_r <= 4'b0;
                    ext_ram_ce_n_r <= 1'b1;
                    ext_ram_oe_n_r <= 1'b1;
                    ext_ram_we_n_r <= 1'b1;
                    ext_ram_data_r <= 32'b0;
                    dcache_offset <= 4'b0;
                end
            endcase
        end
    end
endmodule