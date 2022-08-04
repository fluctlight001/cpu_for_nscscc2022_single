`include "lib/defines.vh"
module MEM(
    input wire clk,
    input wire rst,
    // input wire flush,
    input wire [`StallBus-1:0] stall,

    input wire [`DC_TO_MEM_WD-1:0] dc_to_mem_bus,
    input wire [31:0] data_sram_rdata,

    output wire [`MEM_TO_WB_WD-1:0] mem_to_wb_bus,
    
    output wire [`MEM_TO_RF_WD-1:0] mem_to_rf_bus
);

    reg [`DC_TO_MEM_WD-1:0] dc_to_mem_bus_r;
    reg [31:0] data_sram_rdata_r;

    always @ (posedge clk) begin
        if (rst) begin
            dc_to_mem_bus_r <= `DC_TO_MEM_WD'b0;
            data_sram_rdata_r <= 32'b0;
        end
        // else if (flush) begin
        //     dc_to_mem_bus_r <= `DC_TO_MEM_WD'b0;
        // end
        else if (stall[5]==`Stop && stall[6]==`NoStop) begin
            dc_to_mem_bus_r <= `DC_TO_MEM_WD'b0;
            data_sram_rdata_r <= 32'b0;
        end
        else if (stall[5]==`NoStop) begin
            dc_to_mem_bus_r <= dc_to_mem_bus;
            data_sram_rdata_r <= data_sram_rdata;
        end
    end

    wire [31:0] mem_pc;
    wire data_ram_en;
    wire data_ram_wen;
    wire [3:0] data_ram_sel;
    wire sel_rf_res;
    wire rf_we;
    wire [4:0] rf_waddr;
    wire [31:0] rf_wdata;
    wire [31:0] ex_result;
    wire [31:0] mem_result;
    wire [`HILO_WD-1:0] hilo_bus;
    wire [7:0] mem_op;

    assign {
        mem_op,         // 150:143
        hilo_bus,       // 142:77
        mem_pc,         // 76:45
        data_ram_en,    // 44
        data_ram_wen,   // 43
        data_ram_sel,   // 42:39
        sel_rf_res,     // 38
        rf_we,          // 37
        rf_waddr,       // 36:32
        ex_result       // 31:0
    } =  dc_to_mem_bus_r;



    wire inst_lb,   inst_lbu,   inst_lh,    inst_lhu,   inst_lw;
    wire inst_sb,   inst_sh,    inst_sw;

    assign {
        inst_lb, inst_lbu, inst_lh, inst_lhu, 
        inst_lw, inst_sb, inst_sh, inst_sw
    } = mem_op;

    wire [7:0] b_data;
    wire [15:0] h_data;
    wire [31:0] w_data;

    assign b_data = data_ram_sel[3] ? data_sram_rdata_r[31:24] : 
                    data_ram_sel[2] ? data_sram_rdata_r[23:16] :
                    data_ram_sel[1] ? data_sram_rdata_r[15: 8] : 
                    data_ram_sel[0] ? data_sram_rdata_r[ 7: 0] : 8'b0;
    assign h_data = data_ram_sel[2] ? data_sram_rdata_r[31:16] :
                    data_ram_sel[0] ? data_sram_rdata_r[15: 0] : 16'b0;
    assign w_data = data_sram_rdata_r;

    assign mem_result = inst_lb     ? {{24{b_data[7]}},b_data} :
                        inst_lbu    ? {{24{1'b0}},b_data} :
                        inst_lh     ? {{16{h_data[15]}},h_data} :
                        inst_lhu    ? {{16{1'b0}},h_data} :
                        inst_lw     ? w_data : 32'b0; 
    


    assign rf_wdata = sel_rf_res & data_ram_en ? mem_result : ex_result;

    assign mem_to_wb_bus = {
        hilo_bus,   // 135:70
        mem_pc,     // 69:38
        rf_we,      // 37
        rf_waddr,   // 36:32
        rf_wdata    // 31:0
    };

    assign mem_to_rf_bus = {
        hilo_bus,
        rf_we,
        rf_waddr,
        rf_wdata
    };




endmodule