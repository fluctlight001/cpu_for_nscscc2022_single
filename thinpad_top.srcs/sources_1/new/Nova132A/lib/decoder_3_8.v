`include "defines.vh"
module decoder_3_8 (
    input wire [2:0] in,
    output reg [7:0] out
);
    always @ (*) begin
        case(in)
            3'b000:begin out = 8'b1; end
            3'b001:begin out = 8'b10; end
            3'b010:begin out = 8'b100; end
            3'b011:begin out = 8'b1000; end
            3'b100:begin out = 8'b10000; end
            3'b101:begin out = 8'b100000; end
            3'b110:begin out = 8'b1000000; end 
            3'b111:begin out = 8'b10000000; end
            default:begin
                out = 4'b0000;
            end
        endcase
    end
endmodule 