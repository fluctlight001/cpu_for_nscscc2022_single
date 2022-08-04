`include "lib/defines.vh"
module WB(
    input wire clk,
    input wire rst,
    // input wire flush,
    input wire [`StallBus-1:0] stall,

    input wire [`MEM_TO_WB_WD-1:0] mem_to_wb_bus,

    output wire [`WB_TO_RF_WD-1:0] wb_to_rf_bus,

    output wire [31:0] debug_wb_pc,
    output wire [3:0] debug_wb_rf_wen,
    output wire [4:0] debug_wb_rf_wnum,
    output wire [31:0] debug_wb_rf_wdata 
);

    reg [`MEM_TO_WB_WD-1:0] mem_to_wb_bus_r;

    always @ (posedge clk) begin
        if (rst) begin
            mem_to_wb_bus_r <= `MEM_TO_WB_WD'b0;
        end
        // else if (flush) begin
        //     mem_to_wb_bus_r <= `MEM_TO_WB_WD'b0;
        // end
        else if (stall[6]==`Stop && stall[7]==`NoStop) begin
            mem_to_wb_bus_r <= `MEM_TO_WB_WD'b0;
        end
        else if (stall[6]==`NoStop) begin
            mem_to_wb_bus_r <= mem_to_wb_bus;
        end
    end

    wire [31:0] wb_pc;
    wire rf_we;
    wire [4:0] rf_waddr;
    wire [31:0] rf_wdata;
    wire [`HILO_WD-1:0] hilo_bus;

    assign {
        hilo_bus,
        wb_pc,
        rf_we,
        rf_waddr,
        rf_wdata
    } = mem_to_wb_bus_r;

    // assign wb_to_rf_bus = mem_to_wb_bus_r[`WB_TO_RF_WD-1:0];
    assign wb_to_rf_bus = {
        hilo_bus,
        rf_we,
        rf_waddr,
        rf_wdata
    };

    assign debug_wb_pc = wb_pc;
    assign debug_wb_rf_wen = {4{rf_we}};
    assign debug_wb_rf_wnum = rf_waddr;
    assign debug_wb_rf_wdata = rf_wdata;

    
endmodule