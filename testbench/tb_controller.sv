// using vector file based test bench

module tb_controlunit();
    logic [5:0] opcode, funct;
    logic Zero;
    logic RegWrite, RegDst, ALUSrc, MemWrite, MemtoReg, Jump, PCSrc;
    logic [2:0] alucontrol;

    //tb logic holders
    logic [22:0] testvectors [0:20];
    logic [9:0] output_expected;
    logic [31:0] vectornum, errors;
    logic delay;

    controlunit uut(.opcode(opcode), .funct(funct), .Zero(Zero), .RegWrite(RegWrite), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .Jump(Jump), .PCSrc(PCSrc), .alucontrol(alucontrol));

    // using delay to synchornize the inputs apply and output read: NOT USED AS CLK
    always
        begin
            delay = 0; #10;
            delay = 1; #10;
        end

    initial
        begin
            $readmemb("tb_vector_controlunit.tv", testvectors);
            vectornum = 0; errors = 0;
            $monitor("vectornum = %d, testvector = %b", vectornum, testvectors[vectornum]);
        end

    always @(posedge delay)
        begin
            {opcode, funct, Zero, output_expected} = testvectors[vectornum];
        end

    //check the results on the negedge of delay
    always @(negedge delay)
        begin
            if(output_expected!={RegWrite, RegDst, ALUSrc, MemWrite, MemtoReg, Jump, PCSrc, alucontrol})
                begin
                    $display("Error: opcode = %b, funct = %b, Zero = %b", opcode, funct, Zero);
                    $display("outputs = %b, expected = %b",
                    {RegWrite, RegDst, ALUSrc, MemWrite, MemtoReg, Jump, PCSrc, alucontrol}, output_expected);
                    errors = errors+1;
                end
            vectornum = vectornum + 1;
            if(testvectors[vectornum]===23'bx)
                begin
                    $display("%d tests completed with %d errors", vectornum, errors);
                    $finish;
                end
        end
endmodule
