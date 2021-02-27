module controlunit
    (input logic [5:0] opcode, funct,
    //input logic Zero,
    input logic reset,
    output logic RegWrite, RegDst, ALUSrc, MemWrite, MemtoReg, Jump, Branch,
    output logic [2:0] alucontrol);

    // currently supports r-type, lw, sw, beq, addi, j

    logic [8:0] maincontrol;
    logic [1:0] ALUOp;

    assign {RegWrite, RegDst, ALUSrc, Branch, MemWrite, MemtoReg, ALUOp, Jump} = maincontrol;

    //branch logic for beq (used for single-cycle, moved to ID)
    //assign PCSrc = Branch&Zero;    

    // main decoder
    always_comb
        begin
            if(reset) maincontrol = 9'b000000000;
            else
            case(opcode)
                // takes the x as 0 to simplify
                6'b000000 : maincontrol = 9'b110000100;    //r-type
                6'b100011 : maincontrol = 9'b101001000; //lw
                6'b101011 : maincontrol = 9'b001010000; //sw
                6'b000100 : maincontrol = 9'b000100010; //beq
                6'b001000 : maincontrol = 9'b101000000; //addi
                6'b000010 : maincontrol = 9'b000000001; //j
                default   : maincontrol = 9'bxxxxxxxxx; //illegal operationn
            endcase
        end

    // alu decoder
    always_comb
        begin
            case(ALUOp)
                2'b00 : alucontrol = 3'b010; //add
                2'b01 : alucontrol = 3'b110; //sub (for beq)
                2'b10 : begin
                        case(funct)
                            6'b100000 : alucontrol = 3'b010; // add
                            6'b100010 : alucontrol = 3'b110; // sub
                            6'b100100 : alucontrol = 3'b000; // and
                            6'b100101 : alucontrol = 3'b001; // or
                            6'b101010 : alucontrol = 3'b111; // slt
                            default   : alucontrol = 3'bxxx; // illegal funct
                        endcase
                    end
                default : alucontrol = 3'bxxx; // illegal aluop
            endcase
        end
endmodule
