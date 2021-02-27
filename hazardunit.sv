module hazardunit
    (input logic [4:0] RsE, RtE, RsD, RtD, WriteRegM, WriteRegW, WriteRegE,
    input logic RegWriteM, RegWriteW, RegWriteE, MemToRegE, MemToRegM, BranchD, JumpD,
    output logic [1:0] ForwardAE, ForwardBE,
    output logic StallF, StallD, FlushE, ForwardAD, ForwardBD);

    // forwarding logic for srca
    always_comb
        begin
            if ((RsE!==0) && (RsE===WriteRegM) && RegWriteM) ForwardAE = 2'b10;
            else if ((RsE!=0) && (RsE===WriteRegW) && RegWriteW) ForwardAE = 2'b01;
            else ForwardAE = 2'b00;
        end

    // forwarding logic for srcb
    always_comb
        begin
            if ((RtE!==0) && (RtE===WriteRegM) && RegWriteM) ForwardBE = 2'b10;
            else if ((RtE!=0) && (RtE===WriteRegW) && RegWriteW) ForwardBE = 2'b01;
            else ForwardBE = 2'b00;
        end

    // stalling logic for lw commands
    logic lwstall;
    assign lwstall = (((RsD===RtE) || (RtD===RtE)) && MemToRegE);

    // stalling and flush logic for branch/jump
    logic branchstall;
    assign ForwardAD = ((RsD!==0) && (RsD===WriteRegM) && RegWriteM);
    assign ForwardBD = ((RtD!==0) && (RtD===WriteRegM) && RegWriteM);
    logic branchcond1, branchcond2;
    assign branchcond1 = (BranchD && RegWriteE && (WriteRegE===RsD || WriteRegE===RtD));
    assign branchcond2 = (BranchD && MemToRegM && (WriteRegM===RsD || WriteRegM===RtD));
    assign branchstall = (branchcond1 || branchcond2);

    // jump does not require any condition check as it is always taken
    logic flag;
    assign flag = (lwstall || branchstall);
    assign StallF = flag;
    assign StallD = flag;
    assign FlushE = (flag || JumpD) ;

endmodule
