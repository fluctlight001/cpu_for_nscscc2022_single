`include "lib/defines.vh"
module IC (
    input wire clk,
    input wire rst,
    input wire [`StallBus-1:0] stall,

    input wire [`IF_TO_IC_WD-1:0] if_to_ic_bus,
    input wire [`BR_WD-1:0] br_bus,

    output wire [`IC_TO_ID_WD-1:0] ic_to_id_bus
);

    reg [`IF_TO_IC_WD-1:0] if_to_ic_bus_r;
    wire br_e;
    wire [31:0] br_addr;

    assign {
        br_e,
        br_addr
    } = br_bus;

    always @ (posedge clk) begin
        if (rst) begin
            if_to_ic_bus_r <= `IF_TO_IC_WD'b0;
        end
        else if (stall[1]==`Stop && stall[2]==`NoStop) begin
            if_to_ic_bus_r <= `IF_TO_IC_WD'b0;
        end
        else if (stall[1]==`NoStop && br_e) begin
            if_to_ic_bus_r <= `IF_TO_IC_WD'b0;
        end
        else if (stall[1]==`NoStop) begin
            if_to_ic_bus_r <= if_to_ic_bus;
        end
    end

    assign ic_to_id_bus = if_to_ic_bus_r;

endmodule