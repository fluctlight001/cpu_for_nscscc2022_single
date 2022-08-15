module bru(
    input wire [31:0] pc,
    input wire [31:0] inst,

    input wire [31:0] rdata1,
    input wire [31:0] rdata2,

    input wire [11:0] bru_op,

    // output wire br_e,
    // output wire [31:0] br_addr
    output wire [32:0] br_bus
);

    wire inst_beq,  inst_bne,   inst_bgez,  inst_bgtz;
    wire inst_blez, inst_bltz,  inst_bgezal,inst_bltzal;
    wire inst_j,    inst_jal,   inst_jr,    inst_jalr;


    assign {
        inst_beq, inst_bne, inst_bgez, inst_bgtz, inst_blez, inst_bltz,
        inst_bltzal, inst_bgezal, inst_j, inst_jr, inst_jal, inst_jalr
    } = bru_op;

    wire br_e;
    wire [31:0] br_addr;
    wire rs_eq_rt;
    wire rs_ge_z;
    wire rs_gt_z;
    wire rs_le_z;
    wire rs_lt_z;
    wire [31:0] pc_plus_4;
    assign pc_plus_4 = pc + 32'h4;

    assign rs_eq_rt = (rdata1 == rdata2);
    assign rs_ge_z  = ~rdata1[31];
    assign rs_gt_z  = ($signed(rdata1) > 0);
    assign rs_le_z  = (rdata1[31] == 1'b1 || rdata1 == 32'b0);
    assign rs_lt_z  = (rdata1[31]);

    assign br_e = inst_beq & rs_eq_rt
                | inst_bne & ~rs_eq_rt
                | inst_bgez & rs_ge_z
                | inst_bgtz & rs_gt_z
                | inst_blez & rs_le_z
                | inst_bltz & rs_lt_z
                | inst_bltzal & rs_lt_z
                | inst_bgezal & rs_ge_z
                | inst_j
                | inst_jr
                | inst_jal
                | inst_jalr;
    assign br_addr = inst_beq   ? (pc_plus_4 + {{14{inst[15]}},inst[15:0],2'b0}) 
                   : inst_bne   ? (pc_plus_4 + {{14{inst[15]}},inst[15:0],2'b0})
                   : inst_bgez  ? (pc_plus_4 + {{14{inst[15]}},inst[15:0],2'b0})
                   : inst_bgtz  ? (pc_plus_4 + {{14{inst[15]}},inst[15:0],2'b0})
                   : inst_blez  ? (pc_plus_4 + {{14{inst[15]}},inst[15:0],2'b0})
                   : inst_bltz  ? (pc_plus_4 + {{14{inst[15]}},inst[15:0],2'b0})
                   : inst_bltzal? (pc_plus_4 + {{14{inst[15]}},inst[15:0],2'b0})
                   : inst_bgezal? (pc_plus_4 + {{14{inst[15]}},inst[15:0],2'b0})
                   : inst_j     ? {pc[31:28],inst[25:0],2'b0}
                   : inst_jr    ? rdata1 
                   : inst_jal   ? {pc[31:28],inst[25:0],2'b0} 
                   : inst_jalr  ? rdata1 : 32'b0;

    assign br_bus = {
        br_e,
        br_addr
    };

endmodule