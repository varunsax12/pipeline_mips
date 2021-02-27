module IF
    (input logic clk, reset, StallF,
    input logic [1:0] PCSrcD,
    input logic [31:0] PCBranchD, jumpdst,
    output logic [31:0] InstrF, PCPlus4F);

    logic [31:0] PCnext, PCF;

    mux4x1         pcmux  (.in1(PCPlus4F), .in2(PCBranchD), .in3(jumpdst), .in4(32'bz), .control(PCSrcD), .outdata(PCnext));
    dff_en #(32)   pcdff  (.clk(clk), .reset(reset), .enable(~StallF), .d(PCnext), .q(PCF));
    adder          pcadder(.ina(PCF), .inb(32'b100), .outdata(PCPlus4F));
    imem           imem1  (.addr(PCF[7:2]), .rd(InstrF));

endmodule
