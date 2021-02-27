module WB
    (input logic MemtoRegW,
    input logic [31:0] ReadDataW, ALUOutW,
    output logic [31:0] ResultW);

    mux2x1 #(32)    wbmux (.ina(ALUOutW), .inb(ReadDataW), .control(MemtoRegW), .outdata(ResultW));

endmodule
