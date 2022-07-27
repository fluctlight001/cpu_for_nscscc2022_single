`include "lib/defines.vh"
module mycpu_top(
    input wire clk,
    input wire soc_clk,
    input wire resetn,
    input wire soc_resetn,
    input wire [5:0] ext_int,

    //直连串口信号
    output wire txd,  //直连串口发送端
    input  wire rxd,  //直连串口接收端

    output wire[15:0] leds,       //16位LED，输出时1点亮

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
    output wire [3:0] dwr_wstrb,
    output wire [31:0] dwr_addr,
    output wire [31:0] dwr_data,
    input wire dreload,
    input wire [31:0] drd_data,

    //debug_*
    output wire [31:0] debug_wb_pc,
    output wire [3:0] debug_wb_rf_wen,
    output wire [4:0] debug_wb_rf_wnum,
    output wire [31:0] debug_wb_rf_wdata 
);
    //cpu inst sram
    wire        cpu_inst_en;
    wire [3 :0] cpu_inst_wen;
    wire [31:0] cpu_inst_addr;
    wire [31:0] cpu_inst_wdata;
    wire [31:0] cpu_inst_rdata;
    //cpu data sram
    wire        cpu_data_en;
    wire [3 :0] cpu_data_wen;
    wire [31:0] cpu_data_addr;
    wire [31:0] cpu_data_wdata;
    wire [31:0] cpu_data_rdata;
    //inst sram
    wire        inst_sram_en;
    wire [3 :0] inst_sram_wen;
    wire [31:0] inst_sram_addr;
    wire [31:0] inst_sram_wdata;
    wire [31:0] inst_sram_rdata;
    //data sram
    wire        data_sram_en;
    wire [3 :0] data_sram_wen;
    wire [31:0] data_sram_addr;
    wire [31:0] data_sram_wdata;
    wire [31:0] data_sram_rdata;
    //conf
    wire        conf_en;
    wire [3 :0] conf_wen;
    wire [31:0] conf_addr;
    wire [31:0] conf_wdata;
    wire [31:0] conf_rdata;

    wire [31:0] cpu_inst_addr_v, cpu_data_addr_v;

    wire stallreq_for_icache, stallreq_for_dcache, stallreq_for_out;
    assign stallreq_for_out = stallreq_for_icache | stallreq_for_dcache;

    mycpu_core u_mycpu_core(
    	.clk               (clk               ),
        .rst               (~resetn           ),
        .int               (ext_int           ),
        .stallreq_for_out  (stallreq_for_out  ),
        .inst_sram_en      (cpu_inst_en       ),
        .inst_sram_wen     (cpu_inst_wen      ),
        .inst_sram_addr    (cpu_inst_addr_v   ),
        .inst_sram_wdata   (cpu_inst_wdata    ),
        .inst_sram_rdata   (cpu_inst_rdata    ),
        .data_sram_en      (cpu_data_en       ),
        .data_sram_wen     (cpu_data_wen      ),
        .data_sram_addr    (cpu_data_addr_v   ),
        .data_sram_wdata   (cpu_data_wdata    ),
        .data_sram_rdata   (cpu_data_rdata    ),
        .debug_wb_pc       (debug_wb_pc       ),
        .debug_wb_rf_wen   (debug_wb_rf_wen   ),
        .debug_wb_rf_wnum  (debug_wb_rf_wnum  ),
        .debug_wb_rf_wdata (debug_wb_rf_wdata )
    );

    mmu u0_mmu(
    	.addr_i (cpu_inst_addr_v ),
        .addr_o (cpu_inst_addr   )
    );

    mmu u1_mmu(
    	.addr_i (cpu_data_addr_v ),
        .addr_o (cpu_data_addr   )
    );

    bridge_1x3 u_bridge_1x3(
        .clk             (clk             ),
        .resetn          (resetn          ),
        .cpu_data_en     (cpu_data_en     ),
        .cpu_data_wen    (cpu_data_wen    ),
        .cpu_data_addr   (cpu_data_addr   ),
        .cpu_data_wdata  (cpu_data_wdata  ),
        .cpu_data_rdata  (cpu_data_rdata  ),
        .inst_sram_en    (inst_sram_en    ),
        .inst_sram_wen   (inst_sram_wen   ),
        .inst_sram_addr  (inst_sram_addr  ),
        .inst_sram_wdata (inst_sram_wdata ),
        .inst_sram_rdata (inst_sram_rdata ),
        .data_sram_en    (data_sram_en    ),
        .data_sram_wen   (data_sram_wen   ),
        .data_sram_addr  (data_sram_addr  ),
        .data_sram_wdata (data_sram_wdata ),
        .data_sram_rdata (data_sram_rdata ),
        .conf_en         (conf_en         ),
        .conf_wen        (conf_wen        ),
        .conf_addr       (conf_addr       ),
        .conf_wdata      (conf_wdata      ),
        .conf_rdata      (conf_rdata      )
    );

    assign inst_sram_rdata = cpu_inst_rdata;
    cache u_icache(
    	.clk             (clk             ),
        .resetn          (resetn          ),
        .stallreq        (stallreq_for_icache        ),
        .data_sram_en    (cpu_inst_en | inst_sram_en    ),
        .data_sram_wen   (inst_sram_en ? inst_sram_wen : cpu_inst_wen    ),
        .data_sram_addr  (inst_sram_en ? inst_sram_addr : cpu_inst_addr  ),
        .data_sram_wdata (inst_sram_en ? inst_sram_wdata : cpu_inst_wdata),
        .data_sram_rdata (cpu_inst_rdata ),
        .rd_req          (ird_req          ),
        .rd_addr         (ird_addr         ),
        .wr_req          (iwr_req          ),
        .wr_addr         (iwr_addr         ),
        .cacheline_old   (icacheline_old   ),
        .reload          (ireload          ),
        .cacheline_new   (icacheline_new   )
    );
    
    // cache u_dcache(
    // 	.clk             (clk             ),
    //     .resetn          (resetn          ),
    //     .stallreq        (stallreq_for_dcache        ),
    //     .data_sram_en    (data_sram_en    ),
    //     .data_sram_wen   (data_sram_wen   ),
    //     .data_sram_addr  (data_sram_addr  ),
    //     .data_sram_wdata (data_sram_wdata ),
    //     .data_sram_rdata (data_sram_rdata ),
    //     .rd_req          (drd_req          ),
    //     .rd_addr         (drd_addr         ),
    //     .wr_req          (dwr_req          ),
    //     .wr_addr         (dwr_addr         ),
    //     .cacheline_old   (dcacheline_old   ),
    //     .reload          (dreload          ),
    //     .cacheline_new   (dcacheline_new   )
    // );

    uncache u_dcache(
    	.clk        (clk        ),
        .resetn     (resetn     ),
        .stallreq   (stallreq_for_dcache   ),
        .conf_en    (data_sram_en    ),
        .conf_wen   (data_sram_wen   ),
        .conf_addr  (data_sram_addr  ),
        .conf_wdata (data_sram_wdata ),
        .conf_rdata (data_sram_rdata ),
        .rd_req     (drd_req     ),
        .rd_addr    (drd_addr    ),
        .wr_req     (dwr_req     ),
        .wr_wstrb   (dwr_wstrb   ),
        .wr_addr    (dwr_addr    ),
        .wr_data    (dwr_data    ),
        .reload     (dreload     ),
        .rd_data    (drd_data    )
    );
    
    
    confreg u_confreg(
        .clk        (clk        ),
        .soc_clk    (soc_clk    ),
        .resetn     (resetn     ),
        .soc_resetn (soc_resetn ),
        .conf_en    (conf_en    ),
        .conf_wen   (conf_wen   ),
        .conf_addr  (conf_addr  ),
        .conf_wdata (conf_wdata ),
        .conf_rdata (conf_rdata ),
        .txd        (txd        ),
        .rxd        (rxd        ),
        .led        (leds       )
        // .switch     (8'b0     )
    );
    
    
    
    
endmodule 