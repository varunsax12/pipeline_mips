module ID
    (input logic clk, reset,
    // hazard unit signals in
    input logic ForwardAD, ForwardBD,
    // hazard unit signals out
    output logic BranchD,
    // IF inputs
    input logic [31:0] InstrD,
    // WB inputs
    input logic [4:0] WriteRegW,
    input logic [31:0] ResultW,
    // MEM inputs
    input logic [31:0] ALUOutM, PCPlus4D,
    // ID outputs
    output logic [1:0] PCSrcD,
    output logic [31:0] srcaD, srcbD, SignImmD, jumpdst, PCBranchD,
    output logic [4:0] RsD, RtD, RdD,
    // control signals
    input logic RegWriteW,
    output logic RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, FlushF, JumpD,
    output logic [2:0] ALUControlD);

    logic EqualD;
    logic [31:0] rfsrca, rfsrcb, SignImmShiftD;

    assign RsD = InstrD[25:21];
    assign RtD = InstrD[20:16];
    assign RdD = InstrD[15:11];

    // controller
    controlunit  cu      (.opcode(InstrD[31:26]), .funct(InstrD[5:0]), .RegWrite(RegWriteD), .RegDst(RegDstD), .ALUSrc(ALUSrcD), .MemWrite(MemWriteD), .MemtoReg(MemtoRegD), .Jump(JumpD), .alucontrol(ALUControlD), .Branch(BranchD), .reset(reset));
    // register file
    regfile      rf      (.clk(clk), .we(RegWriteW), .a1(InstrD[25:21]), .a2(InstrD[20:16]), .a3(WriteRegW), .rd1(rfsrca), .rd2(rfsrcb), .wd3(ResultW));
    mux2x1       srcamux (.ina(rfsrca), .inb(ALUOutM), .control(ForwardAD), .outdata(srcaD));
    mux2x1       srcbmux (.ina(rfsrcb), .inb(ALUOutM), .control(ForwardBD), .outdata(srcbD));

    signext      signextID   (.data(InstrD[15:0]), .outdata(SignImmD));
    shiftleft    shiftleftID (.indata(SignImmD), .outdata(SignImmShiftD));
    adder        immadderID  (.ina(SignImmShiftD), .inb(PCPlus4D), .outdata(PCBranchD));

    // shift left imm for jump
    shiftleft    shiftleftimm (.indata({6'b0, InstrD[25:0]}), .outdata(jumpdst));

    // branch handling logic
    comparator    branchcomp  (.in1(srcaD), .in2(srcbD), .result(EqualD));

    always_comb
        begin
            if(EqualD && BranchD) PCSrcD = 2'b01;
            else if (JumpD) PCSrcD = 2'b10;
            else PCSrcD = 2'b00;
        end
    assign FlushF = (PCSrcD[1] | PCSrcD[0]);

endmodule
