module tb_comparator();
    logic [3:0] in1, in2;
    logic result;

    comparator uut(.in1(in1), .in2(in2), .result(result));

    initial
        begin
            in1 = 1; in2 = 1;
            #5;
            assert(result===1) else $error("case 1 failed");
            in2 = 2;
            #5;
            assert(result===0) else $error("case 2 failed");
        end
endmodule
