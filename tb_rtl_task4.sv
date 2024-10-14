module tb_rtl_task4();

// Inputs
logic clk, rst_n, start;
logic [2:0] colour;
logic [7:0] centre_x, diameter;
logic [6:0] centre_y;

// Outputs
logic done;
logic [7:0] vga_x;
logic [6:0] vga_y;
logic [2:0] vga_colour;
logic vga_plot;

// Instantiate task4 module
task4 dut(
    .CLOCK_50(clk),
    .KEY({rst_n, start}),
    .LEDR(),
    .VGA_X(vga_x),
    .VGA_Y(vga_y),
    .VGA_COLOUR(vga_colour),
    .VGA_PLOT(vga_plot)
);

// Clock generation
initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end

// Test procedure
initial begin
    // Test case 1: Draw Reuleaux triangle at (80,60) with a diameter of 40
    rst_n = 1;
    start = 0;
    colour = 3'b010;
    centre_x = 8'd80;
    centre_y = 7'd60;
    diameter = 8'd40;

    #20
    rst_n = 0;
    
    #20
    rst_n = 1;
    
    #20
    start = 1;
    
    wait(done);
    start = 0;
    #50

    // Test case 2: Draw Reuleaux triangle with smaller diameter
    centre_x = 8'd60;
    centre_y = 7'd50;
    diameter = 8'd30;
    colour = 3'b001;

    #20
    rst_n = 0;
    #20
    rst_n = 1;
    start = 1;

    wait(done);
    start = 0;
    #50

    // Test case 3: Draw larger Reuleaux triangle
    centre_x = 8'd50;
    centre_y = 7'd50;
    diameter = 8'd60;
    colour = 3'b100;

    #20
    rst_n = 0;
    #20
    rst_n = 1;
    start = 1;

    wait(done);
    start = 0;
    #50

    // Test case 4: Off-screen Reuleaux triangle (out of range X)
    centre_x = 8'd190;
    centre_y = 7'd50;
    diameter = 8'd40;
    colour = 3'b110;

    #20
    rst_n = 0;
    #20
    rst_n = 1;
    start = 1;

    wait(done);
    start = 0;
    #50

    // Test case 5: Off-screen Reuleaux triangle (out of range Y)
    centre_x = 8'd60;
    centre_y = 7'd180;
    diameter = 8'd40;
    colour = 3'b011;

    #20
    rst_n = 0;
    #20
    rst_n = 1;
    start = 1;

    wait(done);
    start = 0;
    #50

    #50;
end

endmodule: tb_rtl_task4
