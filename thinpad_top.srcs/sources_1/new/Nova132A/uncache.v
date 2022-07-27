`include "lib/defines.vh"
`define STAGE_WD 4
`define WAIT 4'b1000
// `define VIRTUAL_UART_ADDR 32'h1faf_fff0
module uncache(
    input wire clk,
    input wire resetn,
    output wire stallreq,

    input wire conf_en,
    input wire [3:0] conf_wen,
    input wire [31:0] conf_addr,
    input wire [31:0] conf_wdata,
    output reg [31:0] conf_rdata,

    output reg rd_req,
    output reg [31:0] rd_addr,
    output reg wr_req,
    output reg [3:0] wr_wstrb,
    output reg [31:0] wr_addr,
    output reg [31:0] wr_data,

    input wire reload,
    input wire [31:0] rd_data
);
    reg valid;
    reg finish;
    reg buffer_valid;


    wire conf_rd_req;
    wire conf_wr_req;
    assign conf_rd_req = conf_en & ~valid & ~(|conf_wen);
    assign conf_wr_req = conf_en & ~valid & (|conf_wen);

    assign stallreq = conf_rd_req & ~valid | conf_wr_req & buffer_valid & ~valid;
    always @ (posedge clk) begin
        if (!resetn) begin
            valid <= 1'b0;
        end
        else if (finish) begin
            valid <= 1'b1;
        end
        else begin
            valid <= 1'b0;
        end
    end

    // assign rd_req = conf_en & ~valid & ~(|conf_wen);
    // assign rd_addr = conf_addr;
    // assign wr_req = conf_en & ~valid & (|conf_wen);
    // assign wr_wstrb = conf_wen;
    // assign wr_addr = conf_addr;
    // assign wr_data = conf_wdata;

    always @ (posedge clk) begin
        if (!resetn) begin
            conf_rdata <= 32'b0;
        end
        else if (reload) begin
            conf_rdata <= rd_data; 
        end
    end

    reg [`STAGE_WD-1:0] stage;
    always @ (posedge clk) begin
        if (!resetn) begin
            buffer_valid <= 1'b0;

            stage <= `STAGE_WD'b1;
            finish <= 1'b0;

            rd_req <= 1'b0;
            rd_addr <= 32'b0;
            wr_req <= 1'b0;
            wr_wstrb <= 4'b0;
            wr_addr <= 32'b0;
            wr_data <= 32'b0;
        end
        else begin
            case(1'b1)
                stage[0]:begin
                    if (reload) begin
                        buffer_valid <= 1'b0;
                        wr_req <= 1'b0;
                        wr_wstrb <= 4'b0;
                        wr_addr <= 32'b0;
                        wr_data <= 32'b0;    
                    end
                    if (conf_rd_req & ~buffer_valid) begin
                        rd_req <= 1'b1;
                        rd_addr <= conf_addr;
                        stage <= stage << 1;
                    end
                    else if (conf_wr_req & ~buffer_valid) begin
                        wr_req <= 1'b1;
                        wr_wstrb <= conf_wen;
                        wr_addr <= conf_addr;
                        wr_data <= conf_wdata;
                        buffer_valid <= 1'b1;
                        // finish <= 1'b1;
                        // stage <= 4'b0;
                    end
                    else if (conf_wr_req & buffer_valid) begin
                        if (reload) begin
                            wr_req <= 1'b1;
                            wr_wstrb <= conf_wen;
                            wr_addr <= conf_addr;
                            wr_data <= conf_wdata;
                            buffer_valid <= 1'b1;
                            finish <= 1'b1;
                            stage <= `WAIT;
                        end
                    end
                    else if (conf_rd_req & buffer_valid) begin
                        if (reload) begin
                            rd_req <= 1'b1;
                            rd_addr <= conf_addr;
                            buffer_valid <= 1'b0;
                            stage <= stage << 1;
                        end
                    end
                end
                stage[1]:begin
                    if (reload) begin
                        rd_req <= 1'b0;
                        rd_addr <= 32'b0;
                        wr_req <= 1'b0;
                        wr_wstrb <= 4'b0;
                        wr_addr <= 32'b0;
                        wr_data <= 32'b0;

                        finish <= 1'b1;
                        stage <= `WAIT;
                    end
                end
                stage[2]:begin
                    if (reload) begin
                        wr_req <= 1'b0;
                        wr_wstrb <= 4'b0;
                        wr_addr <= 32'b0;
                        wr_data <= 32'b0;
                        stage <= `STAGE_WD'b1;
                    end
                end
                stage[3]:begin
                    finish <= 1'b0;

                    rd_req <= 1'b0;
                    rd_addr <= 32'b0;
                    // wr_req <= 1'b0;
                    // wr_wstrb <= 4'b0;
                    // wr_addr <= 32'b0;
                    // wr_data <= 32'b0;
                    if (~stallreq) begin
                        stage <= `STAGE_WD'b1;
                    end
                end
                default:begin
                    stage <= `STAGE_WD'b1;
                end
            endcase
        end
    end
endmodule