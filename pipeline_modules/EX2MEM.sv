module EX2MEM
    (input logic clk, reset,
    // control signals in
    input logic RegWriteE, MemtoRegE, MemWriteE,
    // control signals out
    output logic RegWriteM, MemtoRegM, MemWriteM,
    // datapath in
    input logic [31:0] ALUOutE, WriteDataE,
    input logic [4:0] WriteRegE,
    // datapath out
    output logic [31:0] ALUOutM, WriteDataM,
    output logic [4:0] WriteRegM);

    always_ff @(posedge clk)
        begin
            if(reset)
                begin
                    RegWriteM  <= 0;
                    MemtoRegM  <= 0;
                    MemWriteM  <= 0;
                    ALUOutM    <= 0;
                    WriteDataM <= 0;
                    WriteRegM  <= 0;
                end
            else
                begin
                    RegWriteM  <= RegWriteE;
                    MemtoRegM  <= MemtoRegE;
                    MemWriteM  <= MemWriteE;
                    ALUOutM    <= ALUOutE;
                    WriteDataM <= WriteDataE;
                    WriteRegM  <= WriteRegE;
                end
        end

endmodule
