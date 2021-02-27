// NOTE: Suffix D refers to signals from ID
// Suffix E refers to signals from EX

module ID2EX
    (
    // control signals in
    input logic RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, BranchD,
    input logic [2:0] ALUControlD,
    //control signals out
    output logic RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE, BranchE,
    output logic [2:0] ALUControlE,
    // datapathi signals in
    input logic [31:0] srcaD, srcbD, SignImmD,
    input logic [4:0] RsD, RtD, RdD,
    // datapath signals out
    output logic [31:0] srcaE, srcbE, SignImmE,
    output logic [4:0] RsE, RtE, RdE,
    // additional signals
    input logic clk, clr);

    always_ff @(posedge clk)
        begin
            if(clr)
                begin
                    RegWriteE   <= 0;
                    MemtoRegE   <= 0;
                    MemWriteE   <= 0;
                    ALUSrcE     <= 0;
                    RegDstE     <= 0;
                    BranchE     <= 0;
                    ALUControlE <= 0;
                    srcaE       <= 0;
                    srcbE       <= 0;
                    SignImmE    <= 0;
                    RsE         <= 0;
                    RtE         <= 0;
                    RdE         <= 0;
                end
            else
                begin
                    RegWriteE   <= RegWriteD;
                    MemtoRegE   <= MemtoRegD;
                    MemWriteE   <= MemWriteD;
                    ALUSrcE     <= ALUSrcD;
                    RegDstE     <= RegDstD;
                    BranchE     <= BranchD;
                    ALUControlE <= ALUControlD;
                    srcaE       <= srcaD;
                    srcbE       <= srcbD;
                    SignImmE    <= SignImmD;
                    RsE         <= RsD;
                    RtE         <= RtD;
                    RdE         <= RdD;
                end
        end

endmodule
