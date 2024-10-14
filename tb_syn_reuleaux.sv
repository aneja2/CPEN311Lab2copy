module tb_syn_reuleaux();

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

// Instantiate synthesized reuleaux module
reuleaux_syn dut(
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

// Test procedure
initial begin
    // Test case 1
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
    start = 1;
    wait(done);
    start = 0;
    #50

    // Test case 2
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

    // Test case 3
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

    #50;
end

endmodule: tb_syn_reuleaux
