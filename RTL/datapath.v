// Thu tu : B- G - R
//`include "parameter.v" 
module datapath#(
    parameter   WIDTH = 2048, 
                HEIGHT = 1365,
                INFILE = "in.txt",
                OUTFILE = "out_2.txt"
)(
    input wire clk,
    input wire [1:0] Col_ctrl, Row_ctrl,enable_wr, data_ctrl,gray_ctrl,
    output wire Col_done,Row_done,
    input wire [7:0] Value,
    input wire op,
    output [7:0] Red_o, Green_o, Blue_o, Gray_o,
    output [10:0] Col_o, Row_o
);
    parameter size_a = 8386560 ; // 2048 * 1365 *3
    parameter size_b = 2795520 ; //2048 * 1365
    reg [7:0] Red,Green,Blue,Gray;
    reg [7:0] mem [0: size_a-1];
    
    reg [7:0] mem_gray [0: size_b - 1] ;
    reg [10:0] Row,Col;
    wire [10:0] Row_in, Col_in;
    wire [7:0] Red_in, Green_in, Blue_in , Gray_in;

    initial begin
        $readmemh(INFILE,mem,0,size_a-1); // read file from INFILE
    end


    mux4to1_11 a0(
        .a(Row),
        .b(11'd0),
        .c(Row + 11'd1),
        .d(11'd0),
        .sel(Row_ctrl),
        .out(Row_in)
    );

    mux4to1_11 a7(
        .a(Col),
        .b(11'd0),
        .c(Col + 11'd1),
        .d(11'd0),
        .sel(Col_ctrl),
        .out(Col_in)
    );
    
    mux4to1_8 a4 (
        .a(Blue),
        .b(mem[Row*WIDTH*3 + Col*3  ]),
        .c(8'd0),
        .d(8'd0),
        .sel(data_ctrl),
        .out(Blue_in)
    );
    mux4to1_8 a2 (
        .a(Red),
        .b(mem[Row*WIDTH*3 + Col*3 + 2 ]),
        .c(8'd0),
        .d(8'd0),
        .sel(data_ctrl),
        .out(Red_in)
    );
    mux4to1_8 a3 (
        .a(Green),
        .b(mem[Row*WIDTH*3 + Col*3 + 1]),
        .c(8'd0),
        .d(8'd0),
        .sel(data_ctrl),
        .out(Green_in)
    );

    wire [7:0] new_Gray;
    BGR_to_Gray a6 (
        .B(Blue),
        .G(Green),
        .R(Red),
        .Value(Value),
        .op(op),
        .Gray(new_Gray)
    );
    mux4to1_8 a5 (
        .a(Gray),
        .b(new_Gray),
        .c(8'd0),
        .d(8'd0),
        .sel(gray_ctrl),
        .out(Gray_in)
    );

    always @(posedge clk)
    begin
        if(enable_wr) begin
            mem_gray[Row*WIDTH + Col] <= Gray;
        end
        Gray <= Gray_in;
        Red <= Red_in;
        Blue <= Blue_in;
        Green <= Green_in;
        Col <= Col_in;
        Row <= Row_in;
        if (Row_done && Col_done ) begin
            $writememh(OUTFILE,mem_gray,0,size_b-1);
        end
    end

    assign Row_done = (Row ==(HEIGHT -1 )) ? 1 : 0;
    assign Col_done = (Col == (WIDTH -1 )) ? 1 : 0;
    assign Red_o  = Red;
    assign Green_o = Green;
    assign Gray_o = Gray ; 
    assign Blue_o = Blue;
    assign Row_o = Row;
    assign Col_o = Col;

endmodule