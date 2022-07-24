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

    //icache 
    output wire ird_req,
    output wire [31:0] ird_addr,
    output wire iwr_req,
    output wire [31:0] iwr_addr,
    output wire [255:0] icacheline_old,
    input wire ireload,
    input wire [255:0] icacheline_new,

    //dcache
    output wire drd_req,
    output wire [31:0] drd_addr,
    output wire dwr_req,
    output wire [31:0] dwr_addr,
    output wire [255:0] dcacheline_old,
    input wire dreload,
    input wire [255:0] dcacheline_new
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
            base_ram_addr_r <= 19'b0;
            base_ram_be_n_r <= 4'b0;
            base_ram_ce_n_r <= 1'b1;
            base_ram_oe_n_r <= 1'b1;
            base_ram_we_n_r <= 1'b1;
            base_ram_data_r <= 32'b0;

            ext_ram_addr_r <= 19'b0;
            ext_ram_be_n_r <= 4'b0;
            ext_ram_ce_n_r <= 1'b1;
            ext_ram_oe_n_r <= 1'b1;
            ext_ram_we_n_r <= 1'b1;
            ext_ram_data_r <= 32'b0;
        end
        // todo
        else begin
            base_ram_addr_r <= inst_sram_en ? inst_sram_addr[21:2] : cpu_inst_addr[21:2];
            base_ram_be_n_r <= (|inst_sram_wen) ? ~inst_sram_wen : 4'b0;
            base_ram_ce_n_r <= ~cpu_inst_en & ~inst_sram_en;
            base_ram_oe_n_r <= ~(cpu_inst_en & ~(|cpu_inst_wen)) & ~(inst_sram_en & ~(|inst_sram_wen));
            base_ram_we_n_r <= ~(cpu_inst_en & (|cpu_inst_wen)) & ~(inst_sram_en & (|inst_sram_wen));
            base_ram_data_r <= inst_sram_wdata;

            ext_ram_addr_r <= data_sram_addr[21:2];
            ext_ram_be_n_r <= (|data_sram_wen) ? ~data_sram_wen : 4'b0;
            ext_ram_ce_n_r <= ~data_sram_en;
            ext_ram_oe_n_r <= ~(data_sram_en & ~(|data_sram_wen));
            ext_ram_we_n_r <= ~(data_sram_en & (|data_sram_wen));
            ext_ram_data_r <= data_sram_wdata;
        end
    end
endmodule