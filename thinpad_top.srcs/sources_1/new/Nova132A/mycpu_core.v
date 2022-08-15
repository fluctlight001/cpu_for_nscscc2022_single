`include "lib/defines.vh"
module mycpu_core(
    input wire clk,
    input wire rst,
    input wire [5:0] int,
    input wire stallreq_out,

    output wire inst_sram_en,
    output wire [3:0] inst_sram_wen,
    output wire [31:0] inst_sram_addr,
    output wire [31:0] inst_sram_wdata,
    input wire [31:0] inst_sram_rdata,

    output wire data_sram_en,
    output wire [3:0] data_sram_wen,
    output wire [31:0] data_sram_addr,
    output wire [31:0] data_sram_wdata,
    input wire [31:0] data_sram_rdata,

    output wire [31:0] debug_wb_pc,
    output wire [3:0] debug_wb_rf_wen,
    output wire [4:0] debug_wb_rf_wnum,
    output wire [31:0] debug_wb_rf_wdata
);
    wire [`IF_TO_IC_WD-1:0] if_to_ic_bus;
    wire [`IC_TO_ID_WD-1:0] ic_to_id_bus;
    wire [`ID_TO_EX_WD-1:0] id_to_ex_bus;
    wire [`EX_TO_DC_WD-1:0] ex_to_dc_bus;
    wire [`DC_TO_MEM_WD-1:0] dc_to_mem_bus;
    wire [`MEM_TO_WB_WD-1:0] mem_to_wb_bus;
    wire [`BR_WD-1:0] br_bus; 
    wire [`DATA_SRAM_WD-1:0] ex_dt_sram_bus;
    wire [`EX_TO_RF_WD-1:0] ex_to_rf_bus;
    wire [`DC_TO_RF_WD-1:0] dc_to_rf_bus;
    wire [`MEM_TO_RF_WD-1:0] mem_to_rf_bus;
    wire [`WB_TO_RF_WD-1:0] wb_to_rf_bus;
    wire [`StallBus-1:0] stall;
    wire stallreq_for_load;
    wire stallreq_for_bru;
    wire stallreq_for_ex;

    IF u_IF(
    	.clk             (clk             ),
        .rst             (rst             ),
        .stall           (stall           ),
        .br_bus          (br_bus          ),
        .if_to_ic_bus    (if_to_ic_bus    ),
        .inst_sram_en    (inst_sram_en    ),
        .inst_sram_wen   (inst_sram_wen   ),
        .inst_sram_addr  (inst_sram_addr  ),
        .inst_sram_wdata (inst_sram_wdata )
    );

    IC u_IC(
    	.clk          (clk          ),
        .rst          (rst          ),
        .stall        (stall        ),
        .if_to_ic_bus (if_to_ic_bus ),
        .br_bus       (br_bus       ),
        .ic_to_id_bus (ic_to_id_bus )
    );

    ID u_ID(
    	.clk                (clk               ),
        .rst                (rst               ),
        .stall              (stall             ),
        .stallreq_for_load  (stallreq_for_load ),
        .stallreq_for_bru   (stallreq_for_bru  ),
        .ic_to_id_bus       (ic_to_id_bus      ),
        .inst_sram_rdata    (inst_sram_rdata   ),
        .ex_to_rf_bus       (ex_to_rf_bus      ),
        .dc_to_rf_bus       (dc_to_rf_bus      ),
        .mem_to_rf_bus      (mem_to_rf_bus     ),
        .wb_to_rf_bus       (wb_to_rf_bus      ),
        .id_to_ex_bus       (id_to_ex_bus      ),
        .br_bus             (br_bus            )
    );

    EX u_EX(
    	.clk             (clk             ),
        .rst             (rst             ),
        .stall           (stall           ),
        .stallreq_for_ex (stallreq_for_ex ),
        .br_bus          (br_bus          ),
        .id_to_ex_bus    (id_to_ex_bus    ),
        .ex_to_dc_bus    (ex_to_dc_bus    ),
        .ex_to_rf_bus    (ex_to_rf_bus    ),
        .data_sram_en    (data_sram_en    ),
        .data_sram_wen   (data_sram_wen   ),
        .data_sram_addr  (data_sram_addr  ),
        .data_sram_wdata (data_sram_wdata )
    );

    DC u_DC(
    	.clk           (clk           ),
        .rst           (rst           ),
        .stall         (stall         ),
        .ex_to_dc_bus  (ex_to_dc_bus  ),
        .dc_to_mem_bus (dc_to_mem_bus ),
        .dc_to_rf_bus  (dc_to_rf_bus  )
    );
    

    MEM u_MEM(
    	.clk             (clk             ),
        .rst             (rst             ),
        .stall           (stall           ),
        .dc_to_mem_bus   (dc_to_mem_bus   ),
        .data_sram_rdata (data_sram_rdata ),
        .mem_to_wb_bus   (mem_to_wb_bus   ),
        .mem_to_rf_bus   (mem_to_rf_bus   )
    );
    
    WB u_WB(
    	.clk               (clk               ),
        .rst               (rst               ),
        .stall             (stall             ),
        .mem_to_wb_bus     (mem_to_wb_bus     ),
        .wb_to_rf_bus      (wb_to_rf_bus      ),
        .debug_wb_pc       (debug_wb_pc       ),
        .debug_wb_rf_wen   (debug_wb_rf_wen   ),
        .debug_wb_rf_wnum  (debug_wb_rf_wnum  ),
        .debug_wb_rf_wdata (debug_wb_rf_wdata )
    );

    CTRL u_CTRL(
    	.rst               (rst               ),
        .stallreq_for_ex   (stallreq_for_ex   ),
        .stallreq_for_bru  (stallreq_for_bru  ),
        .stallreq_for_load (stallreq_for_load ),
        .stallreq_out      (stallreq_out      ),
        .stall             (stall             )
    );
    
    
endmodule