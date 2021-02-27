module MEM2WB
    (input logic clk, reset,
    // control signals in
    input logic RegWriteM, MemtoRegM, MemWriteM,
    // control signals out
    output logic RegWriteW, MemtoRegW,
    // datapath in
    input logic [31:0] ReadDataM, ALUOutM,
    input logic [4:0] WriteRegM,
    // datapath out
    output logic [31:0] ReadDataW, ALUOutW,
    output logic [4:0] WriteRegW);

    always_ff @(posedge clk)
        begin
            if(reset)
                begin
                    RegWriteW <= 0;
                    MemtoRegW <= 0;
                    ReadDataW <= 0;
                    ALUOutW   <= 0;
                    WriteRegW <= 0;
                end
            else
            begin
                RegWriteW <= RegWriteM;
                MemtoRegW <= MemtoRegM;
                ReadDataW <= ReadDataM;
                ALUOutW   <= ALUOutM;
                WriteRegW <= WriteRegM;
            end
        end

endmodule
