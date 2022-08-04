module mul (
  input wire clk,
  input wire resetn,
  input wire mul_signed, //signed is 1, unsigned is 0
  input wire [31:0] ina,
  input wire [31:0] inb,
  output wire signed [63:0] result

);
  reg one_mul_signed;
  reg [31:0] one_ina;
  reg [31:0] one_inb;
  reg signed [64:0] mul_temp [16:0];
  wire signed [32:0] ext_ina;
  wire signed [32:0] ext_inb;
  wire [1:0] code [16:0];
  wire [64:0] out;
  reg [33:0] kkk [15:0];
  reg [32:0] kkk1 [15:0];
  
//  always @ (posedge clk, posedge resetn) begin
//    if (!resetn) begin
//      one_mul_signed <= 1'b0;
//      one_ina <= 32'b0;
//      one_inb <= 32'b0;
//    end
//    else begin
//      one_mul_signed <= mul_signed;
//      one_ina <= ina;
//      one_inb <= inb;
//    end
//  end
//  reset
  
  //Extended implementation of signed and unsigned multiplication
  assign ext_ina = {mul_signed & ina[31], ina};
  assign ext_inb = {mul_signed & inb[31], inb};
    
  //decoder
  assign code[ 0][0] = ext_ina[ 1] & ext_ina[ 0];
  assign code[ 1][0] = (ext_ina[ 1] & ext_ina[ 2] & ~ext_ina[ 3]) + (ext_ina[ 1] & ~ext_ina[ 2] & ext_ina[ 3]) + (~ext_ina[ 1] & ext_ina[ 2] & ext_ina[ 3]);
  assign code[ 2][0] = (ext_ina[ 3] & ext_ina[ 4] & ~ext_ina[ 5]) + (ext_ina[ 3] & ~ext_ina[ 4] & ext_ina[ 5]) + (~ext_ina[ 3] & ext_ina[ 4] & ext_ina[ 5]);
  assign code[ 3][0] = (ext_ina[ 5] & ext_ina[ 6] & ~ext_ina[ 7]) + (ext_ina[ 5] & ~ext_ina[ 6] & ext_ina[ 7]) + (~ext_ina[ 5] & ext_ina[ 6] & ext_ina[ 7]);
  assign code[ 4][0] = (ext_ina[ 7] & ext_ina[ 8] & ~ext_ina[ 9]) + (ext_ina[ 7] & ~ext_ina[ 8] & ext_ina[ 9]) + (~ext_ina[ 7] & ext_ina[ 8] & ext_ina[ 9]);
  assign code[ 5][0] = (ext_ina[ 9] & ext_ina[10] & ~ext_ina[11]) + (ext_ina[ 9] & ~ext_ina[10] & ext_ina[11]) + (~ext_ina[ 9] & ext_ina[10] & ext_ina[11]);
  assign code[ 6][0] = (ext_ina[11] & ext_ina[12] & ~ext_ina[13]) + (ext_ina[11] & ~ext_ina[12] & ext_ina[13]) + (~ext_ina[11] & ext_ina[12] & ext_ina[13]);
  assign code[ 7][0] = (ext_ina[13] & ext_ina[14] & ~ext_ina[15]) + (ext_ina[13] & ~ext_ina[14] & ext_ina[15]) + (~ext_ina[13] & ext_ina[14] & ext_ina[15]);
  assign code[ 8][0] = (ext_ina[15] & ext_ina[16] & ~ext_ina[17]) + (ext_ina[15] & ~ext_ina[16] & ext_ina[17]) + (~ext_ina[15] & ext_ina[16] & ext_ina[17]);
  assign code[ 9][0] = (ext_ina[17] & ext_ina[18] & ~ext_ina[19]) + (ext_ina[17] & ~ext_ina[18] & ext_ina[19]) + (~ext_ina[17] & ext_ina[18] & ext_ina[19]);
  assign code[10][0] = (ext_ina[19] & ext_ina[20] & ~ext_ina[21]) + (ext_ina[19] & ~ext_ina[20] & ext_ina[21]) + (~ext_ina[19] & ext_ina[20] & ext_ina[21]);
  assign code[11][0] = (ext_ina[21] & ext_ina[22] & ~ext_ina[23]) + (ext_ina[21] & ~ext_ina[22] & ext_ina[23]) + (~ext_ina[21] & ext_ina[22] & ext_ina[23]);
  assign code[12][0] = (ext_ina[23] & ext_ina[24] & ~ext_ina[25]) + (ext_ina[23] & ~ext_ina[24] & ext_ina[25]) + (~ext_ina[23] & ext_ina[24] & ext_ina[25]);
  assign code[13][0] = (ext_ina[25] & ext_ina[26] & ~ext_ina[27]) + (ext_ina[25] & ~ext_ina[26] & ext_ina[27]) + (~ext_ina[25] & ext_ina[26] & ext_ina[27]);
  assign code[14][0] = (ext_ina[27] & ext_ina[28] & ~ext_ina[29]) + (ext_ina[27] & ~ext_ina[28] & ext_ina[29]) + (~ext_ina[27] & ext_ina[28] & ext_ina[29]);
  assign code[15][0] = (ext_ina[29] & ext_ina[30] & ~ext_ina[31]) + (ext_ina[29] & ~ext_ina[30] & ext_ina[31]) + (~ext_ina[29] & ext_ina[30] & ext_ina[31]);
  assign code[16][0] = 1'b0;
      
  assign code[ 0][1] = ext_ina[ 1];
  assign code[ 1][1] = (~ext_ina[ 1] & ext_ina[ 2] & ext_ina[ 3]) + (~ext_ina[ 2] & ext_ina[ 3]);
  assign code[ 2][1] = (~ext_ina[ 3] & ext_ina[ 4] & ext_ina[ 5]) + (~ext_ina[ 4] & ext_ina[ 5]);
  assign code[ 3][1] = (~ext_ina[ 5] & ext_ina[ 6] & ext_ina[ 7]) + (~ext_ina[ 6] & ext_ina[ 7]);
  assign code[ 4][1] = (~ext_ina[ 7] & ext_ina[ 8] & ext_ina[ 9]) + (~ext_ina[ 8] & ext_ina[ 9]);
  assign code[ 5][1] = (~ext_ina[ 9] & ext_ina[10] & ext_ina[11]) + (~ext_ina[10] & ext_ina[11]);
  assign code[ 6][1] = (~ext_ina[11] & ext_ina[12] & ext_ina[13]) + (~ext_ina[12] & ext_ina[13]);
  assign code[ 7][1] = (~ext_ina[13] & ext_ina[14] & ext_ina[15]) + (~ext_ina[14] & ext_ina[15]);
  assign code[ 8][1] = (~ext_ina[15] & ext_ina[16] & ext_ina[17]) + (~ext_ina[16] & ext_ina[17]);
  assign code[ 9][1] = (~ext_ina[17] & ext_ina[18] & ext_ina[19]) + (~ext_ina[18] & ext_ina[19]);
  assign code[10][1] = (~ext_ina[19] & ext_ina[20] & ext_ina[21]) + (~ext_ina[20] & ext_ina[21]);
  assign code[11][1] = (~ext_ina[21] & ext_ina[22] & ext_ina[23]) + (~ext_ina[22] & ext_ina[23]);
  assign code[12][1] = (~ext_ina[23] & ext_ina[24] & ext_ina[25]) + (~ext_ina[24] & ext_ina[25]);
  assign code[13][1] = (~ext_ina[25] & ext_ina[26] & ext_ina[27]) + (~ext_ina[26] & ext_ina[27]);
  assign code[14][1] = (~ext_ina[27] & ext_ina[28] & ext_ina[29]) + (~ext_ina[28] & ext_ina[29]);
  assign code[15][1] = (~ext_ina[29] & ext_ina[30] & ext_ina[31]) + (~ext_ina[30] & ext_ina[31]);
  assign code[16][1] = 1'b0;
      
  always @ (*) begin
    //2-bit booth encoding
    case(code[ 0])
      2'b00: begin
        mul_temp[ 0] = (~ext_ina[ 0] & ~ext_ina[ 1]) ? 65'b0 : {{32{ext_inb[32]}}, ext_inb};
      end
      2'b01: begin
        mul_temp[ 0] = {{31{ext_inb[32]}}, ext_inb << 1};
      end
      2'b10: begin
        kkk[ 0] = (~ext_inb + 1) << 1;
        mul_temp[ 0] = {{31{kkk[ 0][33]}}, kkk[ 0]};
      end
      2'b11: begin
        kkk1[ 0] = ~ext_inb + 1;
        mul_temp[ 0] = {{32{kkk1[ 0][32]}}, kkk1[ 0]};
      end
      default: begin
        mul_temp[ 0] = 65'b0;
      end
    endcase
    case(code[ 1])
      2'b00:begin
        mul_temp[ 1] = (ext_ina[ 1] & ext_ina[ 2] & ext_ina[ 3] || ~ext_ina[ 1] & ~ext_ina[ 2] & ~ext_ina[ 3]) ? 65'b0 : ({{30{ext_inb[32]}}, ext_inb, 2'b0});
      end
      2'b01:begin
        mul_temp[ 1] = {{29{ext_inb[32]}}, ext_inb << 1, 2'b0};
      end
      2'b10:begin
        kkk[ 1] = (~ext_inb + 1) << 1;
        mul_temp[ 1] = {{29{kkk[ 1][33]}}, kkk[ 1], 2'b0};
      end
      2'b11:begin
        kkk1[ 1] = ~ext_inb + 1;
        mul_temp[ 1] = {{30{kkk1[ 1][32]}}, kkk1[ 1], 2'b0};
      end
      default:begin
        mul_temp[ 1] = 65'b0;
      end
    endcase
    case(code[ 2])
      2'b00:begin
        mul_temp[ 2] = (ext_ina[ 3] & ext_ina[ 4] & ext_ina[ 5] || ~ext_ina[ 3] & ~ext_ina[ 4] & ~ext_ina[ 5]) ? 65'b0 : ({{28{ext_inb[32]}}, ext_inb, 4'b0});
      end
      2'b01:begin
        mul_temp[ 2] = {{27{ext_inb[32]}}, ext_inb << 1, 4'b0};
      end
      2'b10:begin
        kkk[ 2] = (~ext_inb + 1) << 1;
        mul_temp[ 2] = {{27{kkk[ 2][33]}}, kkk[ 2], 4'b0};
      end
      2'b11:begin
        kkk1[ 2] = ~ext_inb + 1;
        mul_temp[ 2] = {{28{kkk1[ 2][32]}}, kkk1[ 2], 4'b0};
      end
      default:begin
        mul_temp[ 2] = 65'b0;
      end
    endcase
    case(code[ 3])
      2'b00:begin
        mul_temp[ 3] = (ext_ina[ 5] & ext_ina[ 6] & ext_ina[ 7] || ~ext_ina[ 5] & ~ext_ina[ 6] & ~ext_ina[ 7]) ? 65'b0 : ({{26{ext_inb[32]}}, ext_inb, 6'b0});
      end
      2'b01:begin
        mul_temp[ 3] = {{25{ext_inb[32]}}, ext_inb << 1, 6'b0};
      end
      2'b10:begin
        kkk[ 3] = (~ext_inb + 1) << 1;
        mul_temp[ 3] = {{25{kkk[ 3][33]}}, kkk[ 3], 6'b0};
      end
      2'b11:begin
        kkk1[ 3] = ~ext_inb + 1;
        mul_temp[ 3] = {{26{kkk1[ 3][32]}}, kkk1[ 3], 6'b0};
      end
      default:begin
        mul_temp[ 3] = 65'b0;
      end
    endcase
    case(code[ 4])
      2'b00:begin
        mul_temp[ 4] = (ext_ina[ 7] & ext_ina[ 8] & ext_ina[ 9] || ~ext_ina[ 7] & ~ext_ina[ 8] & ~ext_ina[ 9]) ? 65'b0 : ({{24{ext_inb[32]}}, ext_inb, 8'b0});
      end
      2'b01:begin
        mul_temp[ 4] = {{23{ext_inb[32]}}, ext_inb << 1, 8'b0};
      end
      2'b10:begin
        kkk[ 4] = (~ext_inb + 1) << 1;
        mul_temp[ 4] = {{23{kkk[ 4][33]}}, kkk[ 4], 8'b0};
      end
      2'b11:begin
        kkk1[ 4] = ~ext_inb + 1;
        mul_temp[ 4] = {{24{kkk1[ 4][32]}}, kkk1[ 4], 8'b0};
      end
      default:begin
        mul_temp[ 4] = 65'b0;
      end
    endcase
    case(code[ 5])
      2'b00:begin
        mul_temp[ 5] = (ext_ina[ 9] & ext_ina[10] & ext_ina[11] || ~ext_ina[ 9] & ~ext_ina[10] & ~ext_ina[11]) ? 65'b0 : ({{22{ext_inb[32]}}, ext_inb, 10'b0});
      end
      2'b01:begin
        mul_temp[ 5] = {{21{ext_inb[32]}}, ext_inb << 1, 10'b0};
      end
      2'b10:begin
        kkk[ 5] = (~ext_inb + 1) << 1;
        mul_temp[ 5] = {{21{kkk[ 5][33]}}, kkk[ 5], 10'b0};
      end
      2'b11:begin
        kkk1[ 5] = ~ext_inb + 1;
        mul_temp[ 5] = {{22{kkk1[ 5][32]}}, kkk1[ 5], 10'b0};
      end
      default:begin
        mul_temp[ 5] = 65'b0;
      end
    endcase
    case(code[ 6])
      2'b00:begin
        mul_temp[ 6] = (ext_ina[11] & ext_ina[12] & ext_ina[13] || ~ext_ina[11] & ~ext_ina[12] & ~ext_ina[13]) ? 65'b0 : ({{20{ext_inb[32]}}, ext_inb, 12'b0});
      end
      2'b01:begin
        mul_temp[ 6] = {{19{ext_inb[32]}}, ext_inb << 1, 12'b0};
      end
      2'b10:begin
        kkk[ 6] = (~ext_inb + 1) << 1;
        mul_temp[ 6] = {{19{kkk[ 6][33]}}, kkk[ 6], 12'b0};
      end
      2'b11:begin
        kkk1[ 6] = ~ext_inb + 1;
        mul_temp[ 6] = {{20{kkk1[ 6][32]}}, kkk1[ 6], 12'b0};
      end
      default:begin
        mul_temp[ 6] = 65'b0;
      end
    endcase
    case(code[ 7])
      2'b00:begin
        mul_temp[ 7] = (ext_ina[13] & ext_ina[14] & ext_ina[15] || ~ext_ina[13] & ~ext_ina[14] & ~ext_ina[15]) ? 65'b0 : ({{18{ext_inb[32]}}, ext_inb, 14'b0});
      end
      2'b01:begin
        mul_temp[ 7] = {{17{ext_inb[32]}}, ext_inb << 1, 14'b0};
      end
      2'b10:begin
        kkk[ 7] = (~ext_inb + 1) << 1;
        mul_temp[ 7] = {{17{kkk[ 7][33]}}, kkk[ 7], 14'b0};
      end
      2'b11:begin
        kkk1[ 7] = ~ext_inb + 1;
        mul_temp[ 7] = {{18{kkk1[ 7][32]}}, kkk1[ 7], 14'b0};
      end
      default:begin
        mul_temp[ 7] = 65'b0;
      end
    endcase
    case(code[ 8])
      2'b00:begin
        mul_temp[ 8] = (ext_ina[15] & ext_ina[16] & ext_ina[17] || ~ext_ina[15] & ~ext_ina[16] & ~ext_ina[17]) ? 65'b0 : ({{16{ext_inb[32]}}, ext_inb, 16'b0});
      end
      2'b01:begin
        mul_temp[ 8] = {{15{ext_inb[32]}}, ext_inb << 1, 16'b0};
      end
      2'b10:begin
        kkk[ 8] = (~ext_inb + 1) << 1;
        mul_temp[ 8] = {{15{kkk[ 8][33]}}, kkk[ 8], 16'b0};
      end
      2'b11:begin
        kkk1[ 8] = ~ext_inb + 1;
        mul_temp[ 8] = {{16{kkk1[ 8][32]}}, kkk1[ 8], 16'b0};
      end
      default:begin
        mul_temp[ 8] = 65'b0;
      end
    endcase
    case(code[ 9])
      2'b00:begin
        mul_temp[ 9] = (ext_ina[17] & ext_ina[18] & ext_ina[19] || ~ext_ina[17] & ~ext_ina[18] & ~ext_ina[19]) ? 65'b0 : ({{14{ext_inb[32]}}, ext_inb, 18'b0});
      end
      2'b01:begin
        mul_temp[ 9] = {{13{ext_inb[32]}}, ext_inb << 1, 18'b0};
      end
      2'b10:begin
        kkk[ 9] = (~ext_inb + 1) << 1;
        mul_temp[ 9] = {{13{kkk[ 9][33]}}, kkk[ 9], 18'b0};
      end
      2'b11:begin
        kkk1[ 9] = ~ext_inb + 1;
        mul_temp[ 9] = {{14{kkk1[ 9][32]}}, kkk1[ 9], 18'b0};
      end
      default:begin
        mul_temp[ 9] = 65'b0;
      end
    endcase
    case(code[10])
      2'b00:begin
        mul_temp[10] = (ext_ina[19] & ext_ina[20] & ext_ina[21] || ~ext_ina[19] & ~ext_ina[20] & ~ext_ina[21]) ? 65'b0 : ({{12{ext_inb[32]}}, ext_inb, 20'b0});
      end
      2'b01:begin
        mul_temp[10] = {{11{ext_inb[32]}}, ext_inb << 1, 20'b0};
      end
      2'b10:begin
        kkk[10] = (~ext_inb + 1) << 1;
        mul_temp[10] = {{11{kkk[10][33]}}, kkk[10], 20'b0};
      end
      2'b11:begin
        kkk1[10] = ~ext_inb + 1;
        mul_temp[10] = {{12{kkk1[10][32]}}, kkk1[10], 20'b0};
      end
      default:begin
        mul_temp[10] = 65'b0;
      end
    endcase
    case(code[11])
      2'b00:begin
        mul_temp[11] = (ext_ina[21] & ext_ina[22] & ext_ina[23] || ~ext_ina[21] & ~ext_ina[22] & ~ext_ina[23]) ? 65'b0 : ({{10{ext_inb[32]}}, ext_inb, 22'b0});
      end
      2'b01:begin
        mul_temp[11] = {{9{ext_inb[32]}}, ext_inb << 1, 22'b0};
      end
      2'b10:begin
        kkk[11] = (~ext_inb + 1) << 1;
        mul_temp[11] = {{9{kkk[11][33]}}, kkk[11], 22'b0};
      end
      2'b11:begin
        kkk1[11] = ~ext_inb + 1;
        mul_temp[11] = {{10{kkk1[11][32]}}, kkk1[11], 22'b0};
      end
      default:begin
        mul_temp[11] = 65'b0;
      end
    endcase
    case(code[12])
      2'b00:begin
        mul_temp[12] = (ext_ina[23] & ext_ina[24] & ext_ina[25] || ~ext_ina[23] & ~ext_ina[24] & ~ext_ina[25]) ? 65'b0 : ({{8{ext_inb[32]}}, ext_inb, 24'b0});
      end
      2'b01:begin
        mul_temp[12] = {{7{ext_inb[32]}}, ext_inb << 1, 24'b0};
      end
      2'b10:begin
        kkk[12] = (~ext_inb + 1) << 1;
        mul_temp[12] = {{7{kkk[12][33]}}, kkk[12], 24'b0};
      end
      2'b11:begin
        kkk1[12] = ~ext_inb + 1;
        mul_temp[12] = {{8{kkk1[12][32]}}, kkk1[12], 24'b0};
      end
      default:begin
        mul_temp[12] = 65'b0;
      end
    endcase
    case(code[13])
      2'b00:begin
        mul_temp[13] = (ext_ina[25] & ext_ina[26] & ext_ina[27] || ~ext_ina[25] & ~ext_ina[26] & ~ext_ina[27]) ? 65'b0 : ({{6{ext_inb[32]}}, ext_inb, 26'b0});
      end
      2'b01:begin
        mul_temp[13] = {{5{ext_inb[32]}}, ext_inb << 1, 26'b0};
      end
      2'b10:begin
        kkk[13] = (~ext_inb + 1) << 1;
        mul_temp[13] = {{5{kkk[13][33]}}, kkk[13], 26'b0};
      end
      2'b11:begin
        kkk1[13] = ~ext_inb + 1;
        mul_temp[13] = {{6{kkk1[13][32]}}, kkk1[13], 26'b0};
      end
      default:begin
        mul_temp[13] = 65'b0;
      end
    endcase
    case(code[14])
      2'b00:begin
        mul_temp[14] = (ext_ina[27] & ext_ina[28] & ext_ina[29] || ~ext_ina[27] & ~ext_ina[28] & ~ext_ina[29]) ? 65'b0 : ({{4{ext_inb[32]}}, ext_inb, 28'b0});
      end
      2'b01:begin
        mul_temp[14] = {{3{ext_inb[32]}}, ext_inb << 1, 28'b0};
      end
      2'b10:begin
        kkk[14] = (~ext_inb + 1) << 1;
        mul_temp[14] = {{3{kkk[14][33]}}, kkk[14], 28'b0};
      end
      2'b11:begin
        kkk1[14] = ~ext_inb + 1;
        mul_temp[14] = {{4{kkk1[14][32]}}, kkk1[14], 28'b0};
      end
      default:begin
        mul_temp[14] = 65'b0;
      end
    endcase
    case(code[15])
      2'b00:begin
        mul_temp[15] = (ext_ina[29] & ext_ina[30] & ext_ina[31] || ~ext_ina[29] & ~ext_ina[30] & ~ext_ina[31]) ? 65'b0 : ({{2{ext_inb[32]}}, ext_inb, 30'b0});
      end
      2'b01:begin
        mul_temp[15] = {{1{ext_inb[32]}}, ext_inb << 1, 30'b0};
      end
      2'b10:begin
        kkk[15] = (~ext_inb + 1) << 1;
        mul_temp[15] = {{1{kkk[15][33]}}, kkk[15], 30'b0};
      end
      2'b11:begin
        kkk1[15] = ~ext_inb + 1;
        mul_temp[15] = {{2{kkk1[15][32]}}, kkk1[15], 30'b0};
      end
      default:begin
        mul_temp[15] = 65'b0;
      end
    endcase
    case(code[16])
      2'b00: begin
        mul_temp[16] = (ext_ina[31] & ext_ina[32] || ~ext_ina[31] & ~ext_ina[32]) ? 65'd0 : {ext_inb, 32'b0};
      end
      2'b01: begin
        mul_temp[16] = {ext_inb << 1, 32'b0};
      end
      2'b10: begin
        mul_temp[16] = {(~ext_inb + 1) << 1, 32'b0};
      end
      2'b11: begin
        mul_temp[16] = {~ext_inb + 1, 32'b0};
      end
      default: begin
        mul_temp[16] = 65'd0;
      end
    endcase
  end
  //Wallace Tree
  
  //level one
  wire signed [64:0] temp1_s [4:0];
  wire signed [64:0] carry [13:0];
  add unit0(.ina(mul_temp[16]), .inb(mul_temp[15]), .inc(mul_temp[14]), .s(temp1_s[0]), .c(carry[ 0]));
  add unit1(.ina(mul_temp[13]), .inb(mul_temp[12]), .inc(mul_temp[11]), .s(temp1_s[1]), .c(carry[ 1]));
  add unit2(.ina(mul_temp[10]), .inb(mul_temp[ 9]), .inc(mul_temp[ 8]), .s(temp1_s[2]), .c(carry[ 2]));
  add unit3(.ina(mul_temp[ 7]), .inb(mul_temp[ 6]), .inc(mul_temp[ 5]), .s(temp1_s[3]), .c(carry[ 3]));
  add unit4(.ina(mul_temp[ 4]), .inb(mul_temp[ 3]), .inc(mul_temp[ 2]), .s(temp1_s[4]), .c(carry[ 4]));

  //level two
  wire signed [64:0] temp2_s [3:0];
  add unit5(.ina(temp1_s[ 0]), .inb(temp1_s[ 1]), .inc(temp1_s[ 2]), .s(temp2_s[0]), .c(carry[ 5]));
  add unit6(.ina(temp1_s[ 3]), .inb(temp1_s[ 4]), .inc(mul_temp[ 1]), .s(temp2_s[1]), .c(carry[ 6]));
  add unit7(.ina(mul_temp[ 0]), .inb(carry[ 0]), .inc(carry[ 1]), .s(temp2_s[2]), .c(carry[ 7]));
  add unit8(.ina(carry[ 2]), .inb(carry[ 3]), .inc(carry[ 4]), .s(temp2_s[3]), .c(carry[ 8]));

  //level three
  wire signed [64:0] temp3_s [1:0];
  add  unit9(.ina(temp2_s[0]), .inb(temp2_s[1]), .inc(temp2_s[2]), .s(temp3_s[0]), .c(carry[ 9]));
  add unit10(.ina(temp2_s[3]), .inb(carry[ 5]), .inc(carry[ 6]), .s(temp3_s[1]), .c(carry[10]));

  //level four
  wire signed [64:0] temp4_s [1:0];
  add unit11(.ina(temp3_s[0]), .inb(temp3_s[1]), .inc(carry[7]), .s(temp4_s[0]), .c(carry[11]));
  add unit12(.ina(carry[8]), .inb(carry[9]), .inc(carry[10]), .s(temp4_s[1]), .c(carry[12]));
  
  reg signed [64:0] two_temp4_s [1:0];
  reg signed [64:0] carry1 [1:0];
  
  always @ (*) begin
    if (!resetn) begin
      two_temp4_s[0] <= 65'b0;
      two_temp4_s[1] <= 65'b0;
      carry1[0] <= 65'b0;
      carry1[1] <= 65'b0;
    end
    else begin
      two_temp4_s[0] <= temp4_s[0];
      two_temp4_s[1] <= temp4_s[1];
      carry1[0] <= carry[11];
      carry1[1] <= carry[12];
    end
  end

  //level five
  wire signed [64:0] temp5_s;
  wire signed [64:0] carry2;
  add unit13(.ina(two_temp4_s[0]), .inb(two_temp4_s[1]), .inc(carry1[0]), .s(temp5_s), .c(carry2));

  //level six
  wire signed [64:0] s;
  wire signed [64:0] c;
  add unit14(.ina(temp5_s), .inb(carry1[1]), .inc(carry2), .s(s), .c(c));

  assign result = s + c;

//  always @ (posedge clk, posedge resetn) begin
//    if (!resetn) begin
//      result <= 64'b0;
//    end
//    else begin
//      result <= out;
//    end
//  end
  
endmodule
