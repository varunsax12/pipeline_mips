module top
    (input logic clk, reset,
    output logic memwrite,
    output logic [31:0] writedata, dataaddr);

    // *****************************logic signals************************************

    // IF stage
    logic StallF, FlushF;
    logic [31:0] InstrF, PCPlus4F, jumpdst;

    // ID stage
    logic ForwardAD, ForwardBD, BranchD, JumpD, RegWriteD, MemtoRegD, MemWriteD, ALUResultWSrcD, RegDstD, IF2IDClear, StallD;
    logic [31:0] InstrD, srcaD, srcbD, SignImmD, PCPlus4D, PCBranchD;
    logic [4:0] RsD, RtD, RdD;
    logic [2:0] ALUControlD;
    logic [1:0] PCSrcD;

    // EX stage
    logic ALUSrcE, RegDstE, RegWriteE, MemtoRegE, FlushE;
    logic [1:0] ForwardAE, ForwardBE;
    logic [2:0] ALUControlE;
    logic [4:0] RsE, RtE, RdE, WriteRegE;
    logic [31:0] srcaE, srcbE, SignImmE, ALUOutE, WriteDataE;

    // MEM stage
    logic MemWriteM, RegWriteM, MemtoRegM;
    logic [4:0] WriteRegM;
    logic [31:0] ALUOutM, WriteDataM, ReadDataM;

    // WB stage
    logic RegWriteW, MemtoRegW;
    logic [4:0] WriteRegW;
    logic [31:0] ResultW, ReadDataW, ALUOutW;

    // output assignment for top module to avoid difficult wire naming
    assign memwrite = MemWriteM;
    assign writedata = WriteDataM;
    assign dataaddr = ALUOutM;

    // ***************************module instantiations******************************

    // IF stage
    IF       ifstage  (.clk(clk), .reset(reset), .PCSrcD(PCSrcD), .StallF(StallF), .PCBranchD(PCBranchD), .InstrF(InstrF), .PCPlus4F(PCPlus4F), .jumpdst(jumpdst));

    // IF to ID register
    IF2ID    if2idreg (.clk(clk), .clr(FlushF|reset), .en(~StallD), .InstrF(InstrF), .PCPlus4F(PCPlus4F), .InstrD(InstrD), .PCPlus4D(PCPlus4D));

    // ID stage
    ID       idstage  (.clk(clk), .reset(reset), .ForwardAD(ForwardAD), .ForwardBD(ForwardBD), .BranchD(BranchD), .InstrD(InstrD), .WriteRegW(WriteRegW), .ResultW(ResultW), .ALUOutM(ALUOutM), .PCSrcD(PCSrcD), .srcaD(srcaD), .srcbD(srcbD), .SignImmD(SignImmD), .PCPlus4D(PCPlus4D), .jumpdst(jumpdst), .RsD(RsD), .RtD(RtD), .RdD(RdD), .RegWriteW(RegWriteW), .RegWriteD(RegWriteD), .MemtoRegD(MemtoRegD), .MemWriteD(MemWriteD), .RegDstD(RegDstD), .ALUSrcD(ALUSrcD), .FlushF(FlushF), .ALUControlD(ALUControlD), .JumpD(JumpD), .PCBranchD(PCBranchD));

    // ID to EX register
    ID2EX    id2exreg (.clk(clk), .clr(FlushE|reset), .RegWriteD(RegWriteD), .MemtoRegD(MemtoRegD), .MemWriteD(MemWriteD), .ALUSrcD(ALUSrcD), .RegDstD(RegDstD), .BranchD(BranchD), .ALUControlD(ALUControlD), .RegWriteE(RegWriteE), .MemtoRegE(MemtoRegE), .MemWriteE(MemWriteE), .ALUSrcE(ALUSrcE), .RegDstE(RegDstE), .BranchE(BranchE), .ALUControlE(ALUControlE), .srcaD(srcaD), .srcbD(srcbD), .SignImmD(SignImmD), .RsD(RsD), .RtD(RtD), .RdD(RdD), .srcaE(srcaE), .srcbE(srcbE), .SignImmE(SignImmE), .RsE(RsE), .RtE(RtE), .RdE(RdE));

    // EX stage
    EX       exstage  (.clk(clk), .reset(reset), .ALUControlE(ALUControlE), .ALUSrcE(ALUSrcE), .RegDstE(RegDstE), .srcaE(srcaE), .srcbE(srcbE), .SignImmE(SignImmE), .RsE(RsE), .RtE(RtE), .RdE(RdE), .ResultW(ResultW), .ALUOutM(ALUOutM), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE), . ALUOutE(ALUOutE), .WriteDataE(WriteDataE), .WriteRegE(WriteRegE));

    // EX to MEM register
    EX2MEM   ex2memreg(.clk(clk), .RegWriteE(RegWriteE), .MemtoRegE(MemtoRegE), .MemWriteE(MemWriteE), .RegWriteM(RegWriteM), .MemtoRegM(MemtoRegM), .MemWriteM(MemWriteM), .ALUOutE(ALUOutE), .WriteDataE(WriteDataE), .WriteRegE(WriteRegE), .ALUOutM(ALUOutM), .WriteDataM(WriteDataM), .WriteRegM(WriteRegM), .reset(reset));

    // MEM stage
    MEM      memstage (.clk(clk), .reset(reset), .MemWriteM(MemWriteM), .ALUOutM(ALUOutM), .WriteDataM(WriteDataM), .ReadDataM(ReadDataM));

    // MEM to WB register
    MEM2WB   mem2wbreg(.clk(clk), .RegWriteM(RegWriteM), .MemtoRegM(MemtoRegM), .MemWriteM(MemWriteM), .RegWriteW(RegWriteW), .MemtoRegW(MemtoRegW), .ReadDataM(ReadDataM), .ALUOutM(ALUOutM), .WriteRegM(WriteRegM), .ReadDataW(ReadDataW), .ALUOutW(ALUOutW), .WriteRegW(WriteRegW), .reset(reset));

    // WB stage
    WB       wbstage  (.MemtoRegW(MemtoRegW), .ReadDataW(ReadDataW), .ALUOutW(ALUOutW), .ResultW(ResultW));

    // hazard handling unit
    hazardunit hzu    (.RsE(RsE), .RtE(RtE), .RsD(RsD), .RtD(RtD), .WriteRegM(WriteRegM), .WriteRegE(WriteRegE), .WriteRegW(WriteRegW), .RegWriteM(RegWriteM), .RegWriteW(RegWriteW), .RegWriteE(RegWriteE), .MemToRegE(MemtoRegE), .MemToRegM(MemtoRegM), .BranchD(BranchD), .JumpD(JumpD), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE), .StallF(StallF), .StallD(StallD), .FlushE(FlushE), .ForwardAD(ForwardAD), .ForwardBD(ForwardBD));

endmodule
