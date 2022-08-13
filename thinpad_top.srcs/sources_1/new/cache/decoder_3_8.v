module decoder_3_8 (
    input wire [2:0] in,
    output reg [7:0] out
);
    always @ (*) begin
        case(in)
            3'd0:begin out=8'b00000001; end
            3'd1:begin out=8'b00000010; end
            3'd2:begin out=8'b00000100; end
            3'd3:begin out=8'b00001000; end
            3'd4:begin out=8'b00010000; end
            3'd5:begin out=8'b00100000; end
            3'd6:begin out=8'b01000000; end
            3'd7:begin out=8'b10000000; end
            default:begin
                out=32'b0;
            end
        endcase
    end
endmodule