module tb_rtl_reuleaux();

// Your testbench goes here. Our toplevel will give up after 1,000,000 ticks.

// input
logic clk, rst_n, start;
logic [2:0] colour;
logic [7:0] centre_x, diameter;
logic [6:0] centre_y;

// output
logic done;
logic [7:0] vga_x;
logic [6:0] vga_y;
logic [2:0] vga_colour;
logic vga_plot;

// Instantiation of reuleaux module
reuleaux dut(
    .clk(clk),
    .rst_n(rst_n),
    .colour(colour),
    .centre_x(centre_x),
    .centre_y(centre_y),
    .diameter(diameter),
    .start(start),
    .done(done),
    .vga_x(vga_x),
    .vga_y(vga_y),
    .vga_colour(vga_colour),
    .vga_plot(vga_plot)
);

// Clock generation
initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end

// Test sequence
initial begin
    // Test case 1: Standard Reuleaux triangle
    rst_n = 1;
    start = 0;
    colour = 3'b010;    // Green
    centre_x = 8'd80;   // Centre of the screen
    centre_y = 7'd60;   // Centre of the screen
    diameter = 8'd40;   // Diameter of 40 pixels

    #20
    rst_n = 0;

    #20
    rst_n = 1;

    #20
    start = 1;

    wait(done);
    start = 0;
    #50

    // Test case 2: Smaller Reuleaux triangle
    centre_x = 8'd60;
    centre_y = 7'd40;
    diameter = 8'd30;
    colour = 3'b001;    // Blue

    #20
    rst_n = 0;
    #20
    start = 1;
    #20
    rst_n = 1;

    wait(done);
    start = 0;
    #50

    // Test case 3: Larger Reuleaux triangle
    centre_x = 8'd50;
    centre_y = 7'd50;
    diameter = 8'd60;
    colour = 3'b100;    // Red

    #20
    rst_n = 0;
    #20
    start = 1;
    #20
    rst_n = 1;

    wait(done);
    start = 0;
    #50

    // Test case 4: Off-screen Reuleaux triangle (X-coordinate out of range)
    centre_x = 8'd190;
    centre_y = 7'd50;
    diameter = 8'd40;
    colour = 3'b110;    // Yellow

    #20
    rst_n = 0;
    #20
    start = 1;
    #20
    rst_n = 1;

    wait(done);
    start = 0;
    #50

    // Test case 5: Off-screen Reuleaux triangle (Y-coordinate out of range)
    centre_x = 8'd60;
    centre_y = 7'd180;
    diameter = 8'd40;
    colour = 3'b011;    // Cyan

    #20
    rst_n = 0;
    #20
    start = 1;
    #20
    rst_n = 1;

    wait(done);
    start = 0;
    #50

    #50;
end

endmodule: tb_rtl_reuleaux
