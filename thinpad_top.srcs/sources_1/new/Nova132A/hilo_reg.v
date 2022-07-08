`include "lib/defines.vh"
module hilo_reg(
    input wire clk,
    input wire rst,

    input wire hi_we,
    input wire [31:0] hi_i,
    input wire lo_we,
    input wire [31:0] lo_i,


    output wire [31:0] hi_o,
    output wire [31:0] lo_o
);

    reg [31:0] hi_reg, lo_reg;

    // write 
    always @ (posedge clk) begin
        if (rst) begin
            hi_reg <= 32'b0;
            lo_reg <= 32'b0;
        end
        else if (hi_we & lo_we) begin
            hi_reg <= hi_i;
            lo_reg <= lo_i;
        end
        else if (hi_we & ~lo_we) begin
            hi_reg <= hi_i;
        end 
        else if (~hi_we & lo_we) begin
            lo_reg <= lo_i;
        end
    end

    assign hi_o = hi_reg;
    assign lo_o = lo_reg;

endmodule