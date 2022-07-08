module add (
  input wire [64:0] ina,
  input wire [64:0] inb,
  input wire [64:0] inc,
  output wire [64:0] s,
  output wire [64:0] c
);
  assign c[0] = 1'b0;
  wire ov;
  fa bit0 (.a(ina[ 0]), .b(inb[ 0]), .cin(inc[ 0]), .s(s[ 0]), .c(c[ 1]));
  fa bit1 (.a(ina[ 1]), .b(inb[ 1]), .cin(inc[ 1]), .s(s[ 1]), .c(c[ 2]));
  fa bit2 (.a(ina[ 2]), .b(inb[ 2]), .cin(inc[ 2]), .s(s[ 2]), .c(c[ 3]));
  fa bit3 (.a(ina[ 3]), .b(inb[ 3]), .cin(inc[ 3]), .s(s[ 3]), .c(c[ 4]));
  fa bit4 (.a(ina[ 4]), .b(inb[ 4]), .cin(inc[ 4]), .s(s[ 4]), .c(c[ 5]));
  fa bit5 (.a(ina[ 5]), .b(inb[ 5]), .cin(inc[ 5]), .s(s[ 5]), .c(c[ 6]));
  fa bit6 (.a(ina[ 6]), .b(inb[ 6]), .cin(inc[ 6]), .s(s[ 6]), .c(c[ 7]));
  fa bit7 (.a(ina[ 7]), .b(inb[ 7]), .cin(inc[ 7]), .s(s[ 7]), .c(c[ 8]));
  fa bit8 (.a(ina[ 8]), .b(inb[ 8]), .cin(inc[ 8]), .s(s[ 8]), .c(c[ 9]));
  fa bit9 (.a(ina[ 9]), .b(inb[ 9]), .cin(inc[ 9]), .s(s[ 9]), .c(c[10]));
  fa bit10(.a(ina[10]), .b(inb[10]), .cin(inc[10]), .s(s[10]), .c(c[11]));
  fa bit11(.a(ina[11]), .b(inb[11]), .cin(inc[11]), .s(s[11]), .c(c[12]));
  fa bit12(.a(ina[12]), .b(inb[12]), .cin(inc[12]), .s(s[12]), .c(c[13]));
  fa bit13(.a(ina[13]), .b(inb[13]), .cin(inc[13]), .s(s[13]), .c(c[14]));
  fa bit14(.a(ina[14]), .b(inb[14]), .cin(inc[14]), .s(s[14]), .c(c[15]));
  fa bit15(.a(ina[15]), .b(inb[15]), .cin(inc[15]), .s(s[15]), .c(c[16]));
  fa bit16(.a(ina[16]), .b(inb[16]), .cin(inc[16]), .s(s[16]), .c(c[17]));
  fa bit17(.a(ina[17]), .b(inb[17]), .cin(inc[17]), .s(s[17]), .c(c[18]));
  fa bit18(.a(ina[18]), .b(inb[18]), .cin(inc[18]), .s(s[18]), .c(c[19]));
  fa bit19(.a(ina[19]), .b(inb[19]), .cin(inc[19]), .s(s[19]), .c(c[20]));
  fa bit20(.a(ina[20]), .b(inb[20]), .cin(inc[20]), .s(s[20]), .c(c[21]));
  fa bit21(.a(ina[21]), .b(inb[21]), .cin(inc[21]), .s(s[21]), .c(c[22]));
  fa bit22(.a(ina[22]), .b(inb[22]), .cin(inc[22]), .s(s[22]), .c(c[23]));
  fa bit23(.a(ina[23]), .b(inb[23]), .cin(inc[23]), .s(s[23]), .c(c[24]));
  fa bit24(.a(ina[24]), .b(inb[24]), .cin(inc[24]), .s(s[24]), .c(c[25]));
  fa bit25(.a(ina[25]), .b(inb[25]), .cin(inc[25]), .s(s[25]), .c(c[26]));
  fa bit26(.a(ina[26]), .b(inb[26]), .cin(inc[26]), .s(s[26]), .c(c[27]));
  fa bit27(.a(ina[27]), .b(inb[27]), .cin(inc[27]), .s(s[27]), .c(c[28]));
  fa bit28(.a(ina[28]), .b(inb[28]), .cin(inc[28]), .s(s[28]), .c(c[29]));
  fa bit29(.a(ina[29]), .b(inb[29]), .cin(inc[29]), .s(s[29]), .c(c[30]));
  fa bit30(.a(ina[30]), .b(inb[30]), .cin(inc[30]), .s(s[30]), .c(c[31]));
  fa bit31(.a(ina[31]), .b(inb[31]), .cin(inc[31]), .s(s[31]), .c(c[32]));
  fa bit32(.a(ina[32]), .b(inb[32]), .cin(inc[32]), .s(s[32]), .c(c[33]));
  fa bit33(.a(ina[33]), .b(inb[33]), .cin(inc[33]), .s(s[33]), .c(c[34]));
  fa bit34(.a(ina[34]), .b(inb[34]), .cin(inc[34]), .s(s[34]), .c(c[35]));
  fa bit35(.a(ina[35]), .b(inb[35]), .cin(inc[35]), .s(s[35]), .c(c[36]));
  fa bit36(.a(ina[36]), .b(inb[36]), .cin(inc[36]), .s(s[36]), .c(c[37]));
  fa bit37(.a(ina[37]), .b(inb[37]), .cin(inc[37]), .s(s[37]), .c(c[38]));
  fa bit38(.a(ina[38]), .b(inb[38]), .cin(inc[38]), .s(s[38]), .c(c[39]));
  fa bit39(.a(ina[39]), .b(inb[39]), .cin(inc[39]), .s(s[39]), .c(c[40]));
  fa bit40(.a(ina[40]), .b(inb[40]), .cin(inc[40]), .s(s[40]), .c(c[41]));
  fa bit41(.a(ina[41]), .b(inb[41]), .cin(inc[41]), .s(s[41]), .c(c[42]));
  fa bit42(.a(ina[42]), .b(inb[42]), .cin(inc[42]), .s(s[42]), .c(c[43]));
  fa bit43(.a(ina[43]), .b(inb[43]), .cin(inc[43]), .s(s[43]), .c(c[44]));
  fa bit44(.a(ina[44]), .b(inb[44]), .cin(inc[44]), .s(s[44]), .c(c[45]));
  fa bit45(.a(ina[45]), .b(inb[45]), .cin(inc[45]), .s(s[45]), .c(c[46]));
  fa bit46(.a(ina[46]), .b(inb[46]), .cin(inc[46]), .s(s[46]), .c(c[47]));
  fa bit47(.a(ina[47]), .b(inb[47]), .cin(inc[47]), .s(s[47]), .c(c[48]));
  fa bit48(.a(ina[48]), .b(inb[48]), .cin(inc[48]), .s(s[48]), .c(c[49]));
  fa bit49(.a(ina[49]), .b(inb[49]), .cin(inc[49]), .s(s[49]), .c(c[50]));
  fa bit50(.a(ina[50]), .b(inb[50]), .cin(inc[50]), .s(s[50]), .c(c[51]));
  fa bit51(.a(ina[51]), .b(inb[51]), .cin(inc[51]), .s(s[51]), .c(c[52]));
  fa bit52(.a(ina[52]), .b(inb[52]), .cin(inc[52]), .s(s[52]), .c(c[53]));
  fa bit53(.a(ina[53]), .b(inb[53]), .cin(inc[53]), .s(s[53]), .c(c[54]));
  fa bit54(.a(ina[54]), .b(inb[54]), .cin(inc[54]), .s(s[54]), .c(c[55]));
  fa bit55(.a(ina[55]), .b(inb[55]), .cin(inc[55]), .s(s[55]), .c(c[56]));
  fa bit56(.a(ina[56]), .b(inb[56]), .cin(inc[56]), .s(s[56]), .c(c[57]));
  fa bit57(.a(ina[57]), .b(inb[57]), .cin(inc[57]), .s(s[57]), .c(c[58]));
  fa bit58(.a(ina[58]), .b(inb[58]), .cin(inc[58]), .s(s[58]), .c(c[59]));
  fa bit59(.a(ina[59]), .b(inb[59]), .cin(inc[59]), .s(s[59]), .c(c[60]));
  fa bit60(.a(ina[60]), .b(inb[60]), .cin(inc[60]), .s(s[60]), .c(c[61]));
  fa bit61(.a(ina[61]), .b(inb[61]), .cin(inc[61]), .s(s[61]), .c(c[62]));
  fa bit62(.a(ina[62]), .b(inb[62]), .cin(inc[62]), .s(s[62]), .c(c[63]));
  fa bit63(.a(ina[63]), .b(inb[63]), .cin(inc[63]), .s(s[63]), .c(c[64]));
  fa bit64(.a(ina[64]), .b(inb[64]), .cin(inc[64]), .s(s[64]), .c(ov));
endmodule