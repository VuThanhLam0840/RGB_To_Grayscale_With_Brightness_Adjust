`timescale 1ns / 1ps

module top #(
    parameter WIDTH = 2048,
    parameter HEIGHT = 1365,
    parameter INFILE = "in.txt",
    parameter OUTFILE = "out_2.txt"
)(
    input wire clk,
    input wire rst,
    input wire start,
    input wire op,
    input wire [7:0] Value,
    output wire [1:0] enable_wr,
    output wire [2:0] State,
    output wire [7:0] Red_o, Green_o, Blue_o, Gray_o,
    output wire [10:0] Col_o, Row_o
);

    // Internal signals
    wire [1:0] Col_ctrl, Row_ctrl,  data_ctrl, gray_ctrl;
    wire Col_done, Row_done;

    // Instantiate Controller
    controller u_controller (
        .clk(clk),
        .rst(rst),
        .start(start),
        .Col_done(Col_done),
        .Row_done(Row_done),
        .Col_ctrl(Col_ctrl),
        .Row_ctrl(Row_ctrl),
        .enable_wr(enable_wr),
        .data_ctrl(data_ctrl),
        .gray_ctrl(gray_ctrl),
        .State(State)
    );

    // Instantiate Datapath
    datapath #(
        .WIDTH(WIDTH),
        .HEIGHT(HEIGHT),
        .INFILE(INFILE),
        .OUTFILE(OUTFILE)
    ) u_datapath (
        .clk(clk),
        .Col_ctrl(Col_ctrl),
        .Row_ctrl(Row_ctrl),
        .enable_wr(enable_wr),
        .data_ctrl(data_ctrl),
        .gray_ctrl(gray_ctrl),
        .Col_done(Col_done),
        .Row_done(Row_done),
        .Red_o(Red_o),
        .Green_o(Green_o),
        .Blue_o(Blue_o),
        .Gray_o(Gray_o),
        .Col_o(Col_o),
        .Row_o(Row_o),
        .Value(Value),
        .op(op)
    );

endmodule