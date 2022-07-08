`include "lib/defines.vh"
module DC (
    input wire clk,
    input wire rst,
    input wire [`StallBus-1:0] stall,

    input wire [`DF_TO_DC_WD-1:0] df_to_dc_bus,

    output wire [`DC_TO_MEM_WD-1:0] dc_to_mem_bus,

    output wire [`DC_TO_RF_WD-1:0] dc_to_rf_bus
);

    reg [`DF_TO_DC_WD-1:0] df_to_dc_bus_r;

    always @ (posedge clk) begin
        if (rst) begin
            df_to_dc_bus_r <= `DF_TO_DC_WD'b0;
        end
        else if (stall[5]==`Stop && stall[6]==`NoStop) begin
            df_to_dc_bus_r <= `DF_TO_DC_WD'b0;
        end
        else if (stall[5]==`NoStop) begin
            df_to_dc_bus_r <= df_to_dc_bus;
        end
    end

    assign dc_to_mem_bus = df_to_dc_bus_r;

    assign dc_to_rf_bus = {df_to_dc_bus_r[151], df_to_dc_bus_r[142:77], df_to_dc_bus_r[37:0]};
endmodule