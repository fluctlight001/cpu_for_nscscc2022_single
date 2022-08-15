`include "lib/defines.vh"
module ID(
    input wire clk,
    input wire rst,
    // input wire flush,
    input wire [`StallBus-1:0] stall,
    
    output wire stallreq_for_load,
    output wire stallreq_for_bru,

    input wire [`IC_TO_ID_WD-1:0] ic_to_id_bus,

    input wire [31:0] inst_sram_rdata,

    input wire [`EX_TO_RF_WD-1:0] ex_to_rf_bus,
    input wire [`DC_TO_RF_WD-1:0] dc_to_rf_bus,
    input wire [`MEM_TO_RF_WD-1:0] mem_to_rf_bus,
    input wire [`WB_TO_RF_WD-1:0] wb_to_rf_bus,

    output wire [`ID_TO_EX_WD-1:0] id_to_ex_bus,

    output wire [`BR_WD-1:0] br_bus 
);

    reg [`IC_TO_ID_WD-1:0] ic_to_id_bus_r;
    wire [31:0] inst;
    wire [31:0] id_pc;
    wire ce;

    wire ex_rf_we, dc_rf_we, mem_rf_we, wb_rf_we;
    wire [4:0] ex_rf_waddr, dc_rf_waddr, mem_rf_waddr, wb_rf_waddr;
    wire [31:0] ex_rf_wdata, dc_rf_wdata, mem_rf_wdata, wb_rf_wdata;

    wire ex_hi_we, dc_hi_we, mem_hi_we, wb_hi_we;
    wire ex_lo_we, dc_lo_we, mem_lo_we, wb_lo_we;
    wire [31:0] ex_hi_i, dc_hi_i, mem_hi_i, wb_hi_i;
    wire [31:0] ex_lo_i, dc_lo_i, mem_lo_i, wb_lo_i;

    wire [31:0] hi_o, lo_o;
    wire [31:0] hi, lo;

    wire ex_is_load, dc_is_load;
    wire ex_is_store, dc_is_store;
    wire ex_addr_in_base, dc_addr_in_base;

    reg flag;
    reg [31:0] buf_inst;
    reg [31:0] inst_sram_rdata_r;

    always @ (posedge clk) begin
        if (rst) begin
            ic_to_id_bus_r <= `IC_TO_ID_WD'b0;   
            flag <= 1'b0;
            buf_inst <= 32'b0;
            inst_sram_rdata_r <= 32'b0;
        end
        // else if (flush) begin
        //     ic_to_id_bus <= `IC_TO_ID_WD'b0;
        // end
        else if (stall[2]==`Stop && stall[3]==`NoStop) begin
            ic_to_id_bus_r <= `IC_TO_ID_WD'b0;
            flag <= 1'b0;
            inst_sram_rdata_r <= 32'b0;
        end
        else if (stall[2]==`NoStop && flag) begin
            ic_to_id_bus_r <= ic_to_id_bus;
            flag <= 1'b0;
            inst_sram_rdata_r <= buf_inst;
        end
        else if (stall[2]==`NoStop) begin
            ic_to_id_bus_r <= ic_to_id_bus;
            flag <= 1'b0;
            inst_sram_rdata_r <= flag ? buf_inst : inst_sram_rdata;
        end
        else if (~flag) begin
            flag <= 1'b1;
            buf_inst <= inst_sram_rdata;
        end
    end
    
    assign inst = ce ? inst_sram_rdata_r : 32'b0;
    assign {
        ce,
        id_pc
    } = ic_to_id_bus_r;

    assign {
        ex_addr_in_base,
        ex_is_store,
        ex_is_load,
        ex_hi_we, ex_hi_i, ex_lo_we, ex_lo_i, ex_rf_we, ex_rf_waddr, ex_rf_wdata
    } = ex_to_rf_bus;

    assign {
        dc_addr_in_base,
        dc_is_store,
        dc_is_load,
        dc_hi_we, dc_hi_i, dc_lo_we, dc_lo_i, dc_rf_we, dc_rf_waddr, dc_rf_wdata
    } = dc_to_rf_bus;

    assign {
        mem_hi_we, mem_hi_i, mem_lo_we, mem_lo_i, mem_rf_we, mem_rf_waddr, mem_rf_wdata
    } = mem_to_rf_bus;

    assign {
        wb_hi_we, wb_hi_i, wb_lo_we, wb_lo_i, wb_rf_we, wb_rf_waddr, wb_rf_wdata
    } = wb_to_rf_bus;

    wire [5:0] opcode;
    wire [4:0] rs,rt,rd,sa;
    wire [5:0] func;
    wire [15:0] imm;
    wire [25:0] instr_index;
    wire [19:0] code;
    wire [4:0] base;
    wire [15:0] offset;
    wire [2:0] sel;

    wire [63:0] op_d, func_d;
    wire [31:0] rs_d, rt_d, rd_d, sa_d;

    wire [2:0] sel_alu_src1;
    wire [3:0] sel_alu_src2;
    wire [11:0] alu_op;
    wire [7:0] hilo_op; 
    wire [7:0] mem_op;

    wire data_ram_en;
    wire data_ram_wen;
    
    wire rf_we;
    wire [4:0] rf_waddr;
    wire sel_rf_res;
    wire [2:0] sel_rf_dst;

    wire [31:0] rf_rdata1, rf_rdata2, rdata1, rdata2;
    wire [31:0] bru_rdata1, bru_rdata2;

    regfile u_regfile(
    	.clk    (clk    ),
        .raddr1 (rs ),
        .rdata1 (rf_rdata1 ),
        .raddr2 (rt ),
        .rdata2 (rf_rdata2 ),
        .we     (wb_rf_we     ),
        .waddr  (wb_rf_waddr  ),
        .wdata  (wb_rf_wdata  )
    );

    assign rdata1 = (ex_rf_we & ~|(ex_rf_waddr ^ rs)) ? ex_rf_wdata :
                    (dc_rf_we & ~|(dc_rf_waddr ^ rs)) ? dc_rf_wdata :
                    (mem_rf_we & ~|(mem_rf_waddr ^ rs)) ? mem_rf_wdata :
                    (wb_rf_we & ~|(wb_rf_waddr ^ rs)) ? wb_rf_wdata :
                                                       rf_rdata1;
    assign rdata2 = (ex_rf_we & ~|(ex_rf_waddr ^ rt)) ? ex_rf_wdata :
                    (dc_rf_we & ~|(dc_rf_waddr ^ rt)) ? dc_rf_wdata :
                    (mem_rf_we & ~|(mem_rf_waddr ^ rt)) ? mem_rf_wdata :
                    (wb_rf_we & ~|(wb_rf_waddr ^ rt)) ? wb_rf_wdata :
                                                       rf_rdata2;

    hilo_reg u_hilo_reg(
    	.clk   (clk      ),
        .rst   (rst      ),
        .hi_we (wb_hi_we ),
        .hi_i  (wb_hi_i  ),
        .lo_we (wb_lo_we ),
        .lo_i  (wb_lo_i  ),
        .hi_o  (hi_o     ),
        .lo_o  (lo_o     )
    );

    assign hi = ex_hi_we ? ex_hi_i :
                dc_hi_we ? dc_hi_i :
                mem_hi_we ? mem_hi_i :
                wb_hi_we ? wb_hi_i :
                           hi_o;
    assign lo = ex_lo_we ? ex_lo_i :
                dc_lo_we ? dc_lo_i :
                mem_lo_we ? mem_lo_i :
                wb_lo_we ? wb_lo_i :
                           lo_o;

    assign opcode = inst[31:26];
    assign rs = inst[25:21];
    assign rt = inst[20:16];
    assign rd = inst[15:11];
    assign sa = inst[10:6];
    assign func = inst[5:0];
    assign imm = inst[15:0];
    assign instr_index = inst[25:0];
    assign code = inst[25:6];
    assign base = inst[25:21];
    assign offset = inst[15:0];
    assign sel = inst[2:0];

    wire inst_add,  inst_addi,  inst_addu,  inst_addiu;
    wire inst_sub,  inst_subu,  inst_slt,   inst_slti;
    wire inst_sltu, inst_sltiu, inst_div,   inst_divu;
    wire inst_mult, inst_multu, inst_and,   inst_andi;
    wire inst_lui,  inst_nor,   inst_or,    inst_ori;
    wire inst_xor,  inst_xori,  inst_sllv,  inst_sll;
    wire inst_srav, inst_sra,   inst_srlv,  inst_srl;
    wire inst_beq,  inst_bne,   inst_bgez,  inst_bgtz;
    wire inst_blez, inst_bltz,  inst_bgezal,inst_bltzal;
    wire inst_j,    inst_jal,   inst_jr,    inst_jalr;
    wire inst_mfhi, inst_mflo,  inst_mthi,  inst_mtlo;
    wire inst_break,    inst_syscall;
    wire inst_lb,   inst_lbu,   inst_lh,    inst_lhu,   inst_lw;
    wire inst_sb,   inst_sh,    inst_sw;
    wire inst_eret, inst_mfc0,  inst_mtc0;
    wire inst_mul;

    wire op_add, op_sub, op_slt, op_sltu;
    wire op_and, op_nor, op_or, op_xor;
    wire op_sll, op_srl, op_sra, op_lui;

    decoder_6_64 u0_decoder_6_64(
    	.in  (opcode    ),
        .out (op_d      )
    );

    decoder_6_64 u1_decoder_6_64(
    	.in  (func      ),
        .out (func_d    )
    );
    
    decoder_5_32 u0_decoder_5_32(
    	.in  (rs        ),
        .out (rs_d      )
    );

    decoder_5_32 u1_decoder_5_32(
    	.in  (rt        ),
        .out (rt_d      )
    );

    decoder_5_32 u2_decoder_5_32(
    	.in  (rd        ),
        .out (rd_d      )
    );

    decoder_5_32 u3_decoder_5_32(
    	.in  (sa        ),
        .out (sa_d      )
    );
    
    

    assign inst_add     = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b10_0000];
    assign inst_addi    = op_d[6'b00_1000];
    assign inst_addu    = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b10_0001];
    assign inst_addiu   = op_d[6'b00_1001];
    assign inst_sub     = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b10_0010];
    assign inst_subu    = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b10_0011];
    assign inst_slt     = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b10_1010];
    assign inst_slti    = op_d[6'b00_1010];
    assign inst_sltu    = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b10_1011];
    assign inst_sltiu   = op_d[6'b00_1011];
    assign inst_div     = op_d[6'b00_0000] & rd_d[5'b0_0000] & sa_d[5'b0_0000] & func_d[6'b01_1010];
    assign inst_divu    = op_d[6'b00_0000] & rd_d[5'b0_0000] & sa_d[5'b0_0000] & func_d[6'b01_1011];
    assign inst_mul     = op_d[6'b01_1100] & sa_d[5'b0_0000] & func_d[6'b00_0010];
    assign inst_mult    = op_d[6'b00_0000] & rd_d[5'b0_0000] & sa_d[5'b0_0000] & func_d[6'b01_1000];
    assign inst_multu   = op_d[6'b00_0000] & rd_d[5'b0_0000] & sa_d[5'b0_0000] & func_d[6'b01_1001];
    assign inst_and     = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b10_0100];
    assign inst_andi    = op_d[6'b00_1100];
    assign inst_lui     = op_d[6'b00_1111];
    assign inst_nor     = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b10_0111];
    assign inst_or      = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b10_0101];
    assign inst_ori     = op_d[6'b00_1101];
    assign inst_xor     = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b10_0110];
    assign inst_xori    = op_d[6'b00_1110];
    assign inst_sllv    = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b00_0100];
    assign inst_sll     = op_d[6'b00_0000] & rs_d[5'b0_0000] & func_d[6'b00_0000];
    assign inst_srav    = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b00_0111];
    assign inst_sra     = op_d[6'b00_0000] & rs_d[5'b0_0000] & func_d[6'b00_0011];
    assign inst_srlv    = op_d[6'b00_0000] & sa_d[5'b0_0000] & func_d[6'b00_0110];
    assign inst_srl     = op_d[6'b00_0000] & rs_d[5'b0_0000] & func_d[6'b00_0010];
    assign inst_beq     = op_d[6'b00_0100];
    assign inst_bne     = op_d[6'b00_0101];
    assign inst_bgez    = op_d[6'b00_0001] & rt_d[5'b0_0001];
    assign inst_bgtz    = op_d[6'b00_0111] & rt_d[5'b0_0000];
    assign inst_blez    = op_d[6'b00_0110] & rt_d[5'b0_0000];
    assign inst_bltz    = op_d[6'b00_0001] & rt_d[5'b0_0000];
    assign inst_bgezal  = op_d[6'b00_0001] & rt_d[5'b1_0001];
    assign inst_bltzal  = op_d[6'b00_0001] & rt_d[5'b1_0000];
    assign inst_j       = op_d[6'b00_0010];
    assign inst_jal     = op_d[6'b00_0011];
    assign inst_jr      = op_d[6'b00_0000] & rt_d[5'b0_0000] & rd_d[5'b0_0000] & sa_d[5'b0_0000] & func_d[6'b00_1000];
    assign inst_jalr    = op_d[6'b00_0000] & rt_d[5'b0_0000] & sa_d[5'b0_0000] & func_d[6'b00_1001];
    assign inst_mfhi    = op_d[6'b00_0000] & rs_d[5'b0_0000] & rt_d[5'b0_0000] & sa_d[5'b0_0000] & func_d[6'b01_0000];
    assign inst_mflo    = op_d[6'b00_0000] & rs_d[5'b0_0000] & rt_d[5'b0_0000] & sa_d[5'b0_0000] & func_d[6'b01_0010];
    assign inst_mthi    = op_d[6'b00_0000] & rt_d[5'b0_0000] & rd_d[5'b0_0000] & sa_d[5'b0_0000] & func_d[6'b01_0001];
    assign inst_mtlo    = op_d[6'b00_0000] & rt_d[5'b0_0000] & rd_d[5'b0_0000] & sa_d[5'b0_0000] & func_d[6'b01_0011];
    assign inst_break   = op_d[6'b00_0000] & func_d[6'b00_1101];
    assign inst_syscall = op_d[6'b00_0000] & func_d[6'b00_1100];
    assign inst_lb      = op_d[6'b10_0000];
    assign inst_lbu     = op_d[6'b10_0100];
    assign inst_lh      = op_d[6'b10_0001];
    assign inst_lhu     = op_d[6'b10_0101];
    assign inst_lw      = op_d[6'b10_0011];
    assign inst_sb      = op_d[6'b10_1000];
    assign inst_sh      = op_d[6'b10_1001];
    assign inst_sw      = op_d[6'b10_1011];
    assign inst_mfc0    = op_d[6'b01_0000] & rs_d[5'b0_0000] & sa_d[5'b0_0000] & (inst[5:3]==3'b000);
    assign inst_mtc0    = op_d[6'b01_0000] & rs_d[5'b0_0100] & sa_d[5'b0_0000] & (inst[5:3]==3'b000);

    // rs to reg1
    assign sel_alu_src1[0] = inst_add | inst_addiu | inst_addu | inst_subu | inst_ori | inst_or | inst_sw | inst_lw 
                           | inst_xor | inst_sltu | inst_slt | inst_slti | inst_sltiu | inst_addi | inst_sub 
                           | inst_and | inst_andi | inst_nor | inst_xori | inst_sllv | inst_srav | inst_srlv
                           | inst_lb | inst_lbu | inst_lh | inst_lhu | inst_sb | inst_sh
                           | inst_mul;

    // pc to reg1
    assign sel_alu_src1[1] = inst_jal | inst_bltzal | inst_bgezal | inst_jalr;

    // sa_zero_extend to reg1
    assign sel_alu_src1[2] = inst_sll | inst_sra | inst_srl;

    
    // rt to reg2
    assign sel_alu_src2[0] = inst_add | inst_addu | inst_subu | inst_sll | inst_or | inst_xor | inst_sltu | inst_slt
                           | inst_sub | inst_and | inst_nor | inst_sllv | inst_sra | inst_srav | inst_srl | inst_srlv
                           | inst_mul;
    
    // imm_sign_extend to reg2
    assign sel_alu_src2[1] = inst_lui | inst_addiu | inst_sw | inst_lw | inst_slti | inst_sltiu | inst_addi | inst_lb
                           | inst_lbu | inst_lh | inst_lhu | inst_sb | inst_sh;

    // 32'b8 to reg2
    assign sel_alu_src2[2] = inst_jal | inst_bltzal | inst_bgezal | inst_jalr;

    // imm_zero_extend to reg2
    assign sel_alu_src2[3] = inst_ori | inst_andi | inst_xori;



    assign op_add = inst_add | inst_addi | inst_addiu | inst_addu | inst_jal | inst_sw | inst_lw | inst_bltzal | inst_bgezal
                  | inst_jalr | inst_lb | inst_lbu | inst_lh | inst_lhu | inst_sb | inst_sh;
    assign op_sub = inst_subu | inst_sub;
    assign op_slt = inst_slt | inst_slti;
    assign op_sltu = inst_sltu | inst_sltiu;
    assign op_and = inst_and | inst_andi;
    assign op_nor = inst_nor;
    assign op_or = inst_ori | inst_or;
    assign op_xor = inst_xor | inst_xori;
    assign op_sll = inst_sll | inst_sllv;
    assign op_srl = inst_srl | inst_srlv;
    assign op_sra = inst_sra | inst_srav;
    assign op_lui = inst_lui;

    assign alu_op = {op_add, op_sub, op_slt, op_sltu,
                     op_and, op_nor, op_or, op_xor,
                     op_sll, op_srl, op_sra, op_lui};

    assign hilo_op = {
        inst_mfhi, inst_mflo, inst_mthi, inst_mtlo,
        inst_mult, inst_multu, inst_div, inst_divu
    };

    assign mem_op = {
        inst_lb, inst_lbu, inst_lh, inst_lhu, 
        inst_lw, inst_sb, inst_sh, inst_sw
    };

    // load and store enable
    assign data_ram_en = inst_sw | inst_lw | inst_lb | inst_lbu | inst_lh | inst_lhu | inst_sb | inst_sh;

    // write enable
    assign data_ram_wen = inst_sw | inst_sb | inst_sh;

    // 0 from alu_res ; 1 from ld_res
    assign sel_rf_res = inst_lw | inst_lh | inst_lhu | inst_lb | inst_lbu; 

    assign stallreq_for_load =    ex_is_load & ex_rf_we & ((~|(ex_rf_waddr ^ rs)) | (~|(ex_rf_waddr ^ rt))) & (|ex_rf_waddr)
                                | dc_is_load & dc_rf_we & ((~|(dc_rf_waddr ^ rs)) | (~|(dc_rf_waddr ^ rt))) & (|dc_rf_waddr)
                                | ex_is_store & ex_addr_in_base //| dc_is_store
                                | ex_is_load & ex_addr_in_base;
                                // | dc_is_load & dc_addr_in_base;
                                //ex_is_load | dc_is_load | ex_is_store | dc_is_store;



    // regfile store enable
    assign rf_we = inst_ori | inst_lui | inst_addiu | inst_subu | inst_jal | inst_addu | inst_sll | inst_or 
                 | inst_lw | inst_xor | inst_sltu | inst_slt | inst_slti | inst_sltiu | inst_add | inst_addi
                 | inst_sub | inst_and | inst_andi | inst_nor | inst_xori | inst_sllv | inst_sra | inst_srav
                 | inst_srl | inst_srlv | inst_bltzal | inst_bgezal | inst_jalr | inst_mflo | inst_mfhi
                 | inst_lh | inst_lhu | inst_lb | inst_lbu | inst_mul;



    // store in [rd]
    assign sel_rf_dst[0] = inst_addu | inst_subu | inst_sll | inst_or | inst_xor | inst_sltu | inst_slt | inst_add
                         | inst_sub | inst_and | inst_nor | inst_sllv | inst_sra | inst_srav | inst_srl | inst_srlv
                         | inst_mflo | inst_mfhi | inst_mul;
    // store in [rt] 
    assign sel_rf_dst[1] = inst_ori | inst_lui | inst_addiu | inst_lw | inst_slti | inst_sltiu | inst_addi | inst_andi
                         | inst_xori | inst_lh | inst_lhu | inst_lb | inst_lbu;
    // store in [31]
    assign sel_rf_dst[2] = inst_jal | inst_bltzal | inst_bgezal | inst_jalr;

    // sel for regfile address
    assign rf_waddr = {5{sel_rf_dst[0]}} & rd 
                    | {5{sel_rf_dst[1]}} & rt
                    | {5{sel_rf_dst[2]}} & 32'd31;

    wire [31:0] data_ram_addr = rdata1 + {{16{inst[15]}},inst[15:0]};

    assign id_to_ex_bus = {
        data_ram_addr,  // 268:237
        inst_mul,       // 236
        mem_op,         // 235:228
        hilo_op,        // 227:220
        hi, lo,         // 219:156
        id_pc,          // 155:124
        inst,           // 123:92
        alu_op,         // 91:80
        sel_alu_src1,   // 79:77
        sel_alu_src2,   // 76:73
        data_ram_en,    // 72
        data_ram_wen,   // 71
        rf_we,          // 70
        rf_waddr,       // 69:65
        sel_rf_res,     // 64
        rdata1,         // 63:32
        rdata2          // 31:0
    };


    wire br_e;
    wire [31:0] br_addr;
    wire rs_eq_rt;
    wire rs_ge_z;
    wire rs_gt_z;
    wire rs_le_z;
    wire rs_lt_z;
    wire [31:0] pc_plus_4;
    assign pc_plus_4 = id_pc + 32'h4;

    assign bru_rdata1 = (dc_rf_we & ~|(dc_rf_waddr ^ rs))    ? dc_rf_wdata :
                        (mem_rf_we & ~|(mem_rf_waddr ^ rs))  ? mem_rf_wdata :
                        (wb_rf_we & ~|(wb_rf_waddr ^ rs))    ? wb_rf_wdata :
                                                              rf_rdata1;
    assign bru_rdata2 = (dc_rf_we & ~|(dc_rf_waddr ^ rt))    ? dc_rf_wdata :
                        (mem_rf_we & ~|(mem_rf_waddr ^ rt))  ? mem_rf_wdata :
                        (wb_rf_we & ~|(wb_rf_waddr ^ rt))    ? wb_rf_wdata :
                                                              rf_rdata2;
    assign stallreq_for_bru = ex_rf_we & (~|(ex_rf_waddr^rt) | ~|(ex_rf_waddr^rs)) 
                            & (inst_beq | inst_bne | inst_bgez | inst_bgtz 
                            | inst_blez | inst_bltz | inst_bltzal | inst_bgezal
                            | inst_j | inst_jr | inst_jal | inst_jalr);
    // assign stallreq_for_bru = 1'b0;

    assign rs_eq_rt = ~|(bru_rdata1 ^ bru_rdata2);
    assign rs_ge_z  = ~bru_rdata1[31];
    assign rs_gt_z  = ($signed(bru_rdata1) > 0);
    assign rs_le_z  = (bru_rdata1[31] | (~|bru_rdata1));
    assign rs_lt_z  = (bru_rdata1[31]);

    // assign rs_eq_rt = (rdata1 == rdata2);
    // assign rs_ge_z  = ~rdata1[31];
    // assign rs_gt_z  = ($signed(rdata1) > 0);
    // assign rs_le_z  = (rdata1[31] == 1'b1 || rdata1 == 32'b0);
    // assign rs_lt_z  = (rdata1[31]);

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
                   : inst_j     ? {id_pc[31:28],instr_index,2'b0}
                   : inst_jr    ? bru_rdata1 
                   : inst_jal   ? {id_pc[31:28],instr_index,2'b0} 
                   : inst_jalr  ? bru_rdata1 : 32'b0;

    assign br_bus = {
        br_e,
        br_addr
    };
    


endmodule