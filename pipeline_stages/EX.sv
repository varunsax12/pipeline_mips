module EX
    (input logic clk, reset,
    // control signals in
    input logic [2:0] ALUControlE,
    input logic ALUSrcE, RegDstE,
    // data inputs from decode
    input logic [31:0] srcaE, srcbE, SignImmE,
    input logic [4:0] RsE, RtE, RdE,
    // data inputs from wb
    input logic [31:0] ResultW,
    // data inputs from mem
    input logic [31:0] ALUOutM,
    // hazard unit inputs
    input logic [1:0] ForwardAE, ForwardBE,
    // output data
    output logic [31:0] ALUOutE, WriteDataE,
    output logic [4:0] WriteRegE);

    logic [31:0] SrcAE, SrcBE;
    logic zero;

    mux4x1         srcamux  (.in1(srcaE), .in2(ResultW), .in3(ALUOutM), .in4(32'bz), .control(ForwardAE), .outdata(SrcAE));
    mux4x1         srcb1mux (.in1(srcbE), .in2(ResultW), .in3(ALUOutM), .in4(32'bz), .control(ForwardBE), .outdata(WriteDataE));
    mux2x1 #(32)   srcb2mux (.ina(WriteDataE), .inb(SignImmE), .control(ALUSrcE), .outdata(SrcBE));

    mux2x1 #(5)    writemux (.ina(RtE), .inb(RdE), .control(RegDstE), .outdata(WriteRegE));

    alu            aluEX    (.control(ALUControlE), .srca(SrcAE), .srcb(SrcBE), .zero(zero), .result(ALUOutE));

endmodule
