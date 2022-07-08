`include "defines.vh"
module decoder_2_4 (
    input wire [1:0] in,
    output reg [3:0] out
);
    always @ (*) begin
        case(in)
            2'b00:begin out = 4'b0001; end
            2'b01:begin out = 4'b0010; end
            2'b10:begin out = 4'b0100; end
            2'b11:begin out = 4'b1000; end
            default:begin
                out = 4'b0000;
            end
        endcase
    end
endmodule 