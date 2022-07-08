`include "lib/defines.vh"
module DF (
    input wire clk,
    input wire rst,
    input wire [`StallBus-1:0] stall,

    input wire [`EX_TO_DF_WD-1:0] ex_to_df_bus,

    output wire [`DF_TO_DC_WD-1:0] df_to_dc_bus,
    
    output wire [`DF_TO_RF_WD-1:0] df_to_rf_bus,

    output wire data_sram_en,
    output wire [3:0] data_sram_wen,
    output wire [31:0] data_sram_addr,
    output wire [31:0] data_sram_wdata
);

    reg [`EX_TO_DF_WD-1:0] ex_to_df_bus_r;

    always @ (posedge clk) begin
        if (rst) begin
            ex_to_df_bus_r <= `EX_TO_DF_WD'b0;
        end
        else if (stall[4]==`Stop && stall[5]==`NoStop) begin
            ex_to_df_bus_r <= `EX_TO_DF_WD'b0;
        end
        else if (stall[4]==`NoStop) begin
            ex_to_df_bus_r <= ex_to_df_bus;
        end
    end

    assign df_to_dc_bus = ex_to_df_bus_r;

    assign df_to_rf_bus = {
        ex_to_df_bus_r[151],
        ex_to_df_bus_r[142:77],
        ex_to_df_bus_r[37:0]
    };

    wire [`SRAM_WD-1:0] data_sram_ctl;
    assign data_sram_ctl = ex_to_df_bus_r[`EX_TO_DF_WD-1:152];
    assign{
        data_sram_en,
        data_sram_wen, 
        data_sram_addr,
        data_sram_wdata
    } =  data_sram_ctl;

    
endmodule