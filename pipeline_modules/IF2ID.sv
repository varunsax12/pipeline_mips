// NOTE: F suffix refers to signals from fetch stage
// D suffix refers to signals in the decode stage

module IF2ID
    (input logic [31:0] InstrF, PCPlus4F,
    input clk, clr, en,
    output logic [31:0] InstrD, PCPlus4D);

    // NOTE: clr has precedence over enable, this ensures that during the stall situation
    // it resets the STALL signals so that in the subsequent cycle, the next instruction
    // depending on branch or jump is loaded correctly into PCreg out, else in the next clock cycle
    // the stall signals remain and the computation is done using PC+4 as the jump or branch address
    // never got loaded

    always_ff @(posedge clk)
        begin
            if(clr)
                begin
                    InstrD <= 32'b0;
                    PCPlus4D <= 32'b0;
                end
            else if(en) //logic 0 enable
                begin
                    InstrD <= InstrF;
                    PCPlus4D <= PCPlus4F;
                end
        end
endmodule
