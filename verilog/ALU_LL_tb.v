module ALU_LL_tb ();

    reg  [31:0] A, B;
    reg  [3:0]  G_sel;
    wire [31:0] S;
    wire [3:0]  ZCNVFlags;

    ALU_LL alu (
        .A(A),
        .B(B),
        .G_sel(G_sel),
        .G(S),
        .ZCNVFlags(ZCNVFlags)
    );

    parameter ADD = 4'b0000,
              SUB = 4'b0001,
              XOR = 4'b1000,
              OR  = 4'b1100,
              AND = 4'b1110;

    initial begin
        // Vector set 1
        A     = 32'h7FFFFFFF;
        B     = 32'h00000001;
        G_sel = ADD;
        #10 G_sel = SUB;
        #10 G_sel = XOR;
        #10 G_sel = OR;
        #10 G_sel = AND;

        #20;

        // Vector set 2
        A     = 32'hFFFFFFFF;
        B     = 32'hFFFFFFFF;
        G_sel = ADD;
        #10 G_sel = SUB;
        #10 G_sel = XOR;
        #10 G_sel = OR;
        #10 G_sel = AND;

        #20;

        $finish;
    end

endmodule
