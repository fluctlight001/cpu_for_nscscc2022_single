`include "lib/defines.vh"
module DC (
    input wire clk,
    input wire rst,
    input wire [`StallBus-1:0] stall,

    input wire [`EX_TO_DC_WD-1:0] ex_to_dc_bus,

    output wire [`DC_TO_MEM_WD-1:0] dc_to_mem_bus,

    output wire [`DC_TO_RF_WD-1:0] dc_to_rf_bus
);

    reg [`EX_TO_DC_WD-1:0] ex_to_dc_bus_r;

    always @ (posedge clk) begin
        if (rst) begin
            ex_to_dc_bus_r <= `EX_TO_DC_WD'b0;
        end
        else if (stall[4]==`Stop && stall[5]==`NoStop) begin
            ex_to_dc_bus_r <= `EX_TO_DC_WD'b0;
        end
        else if (stall[4]==`NoStop) begin
            ex_to_dc_bus_r <= ex_to_dc_bus;
        end
    end

    assign dc_to_mem_bus = ex_to_dc_bus_r;

    assign dc_to_rf_bus = {ex_to_dc_bus_r[153], ex_to_dc_bus_r[152], ex_to_dc_bus_r[151], ex_to_dc_bus_r[142:77], ex_to_dc_bus_r[37:0]};
endmodule