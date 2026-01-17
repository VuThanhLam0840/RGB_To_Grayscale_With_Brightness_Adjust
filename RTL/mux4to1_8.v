module mux4to1_8 #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0] a, b, c, d,
    input  wire [1:0] sel,
    output reg  [WIDTH-1:0] out
);

    always @* begin
        case (sel)
            2'd0: out = a;
            2'd1: out = b;
            2'd2: out = c;
            2'd3: out = d;
            default: out = {WIDTH{1'b0}};
        endcase
    end

endmodule
