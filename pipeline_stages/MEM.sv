module MEM
    (input logic clk, reset, MemWriteM,
    input logic [31:0] ALUOutM, WriteDataM,
    output logic [31:0] ReadDataM);

    dmem    dm (.clk(clk), .we(MemWriteM), .addr(ALUOutM), .writedata(WriteDataM), .readdata(ReadDataM));

endmodule
