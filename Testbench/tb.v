`timescale 1ns / 1ps

module tb_top();
    // Parameters
    parameter WIDTH = 2048;
    parameter HEIGHT = 1365;
    parameter INFILE = "in.txt";
    parameter OUTFILE = "out_2.txt";
    parameter CLOCK_PERIOD = 2; // 10ns = 100MHz

    // Signals
    reg clk;
    reg rst;
    reg start;
    reg [7:0] Value;
    reg op;
    wire [2:0] State;
    wire enable_wr;
    wire [7:0] Red_o, Green_o, Blue_o, Gray_o;
    wire [10:0] Row_o,Col_o;

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk = ~clk;
    end

    // Instantiate Top module
    top #(
        .WIDTH(WIDTH),
        .HEIGHT(HEIGHT),
        .INFILE(INFILE),
        .OUTFILE(OUTFILE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .State(State),
        .Red_o(Red_o),
        .Value(Value),
        .op(op),
        .Green_o(Green_o),
        .Blue_o(Blue_o),
        .Gray_o(Gray_o),
        .Row_o(Row_o),
        .Col_o(Col_o),
        .enable_wr(enable_wr)
    );

    // Test stimulus
    initial begin
        // Initialize
        rst = 0;
        start = 0;
        
        // Display header
        $display("========================================");
        $display("BGR to Grayscale Conversion Testbench");
        $display("Image Size: %0d x %0d", WIDTH, HEIGHT);
        $display("Total Pixels: %0d", WIDTH * HEIGHT);
        $display("========================================");
        
        // Reset
        #2;
        rst = 1;
        #2;
        rst = 0;
        #2;
        
        // Start processing
        $display("Starting conversion at time %0t", $time);
        start = 1;
        #(CLOCK_PERIOD);
        start = 0;
        Value = 8'd100;
        op = 0;
        // Wait for completion
        wait(State == 3'd0 && dut.u_datapath.Row_done && dut.u_datapath.Col_done);
        #100;
        
        $display("Conversion completed at time %0t", $time);
        $display("Output file: %s", OUTFILE);
        $display("========================================");
        
        $finish;
    end

  
  


endmodule