module task2(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

    // Instantiate the VGA adapter
    vga_adapter vga_core (
        // (connections to VGA core signals)
    );

    // Instantiate the fillscreen module
    fillscreen fs (
        .clk(CLOCK_50),
        .rst_n(KEY[3]),  // Active-low reset
        .colour(SW[2:0]),  // Ignored in Task 2
        .start(1'b1),  // Auto-start
        .done(LEDR[0]),  // Indicates done
        .vga_x(VGA_X),
        .vga_y(VGA_Y),
        .vga_colour(VGA_COLOUR),
        .vga_plot(VGA_PLOT)
    );

    // Connect VGA outputs to corresponding color channels
    assign VGA_R = {VGA_COLOUR[2], 7'b0};  // Red
    assign VGA_G = {VGA_COLOUR[1], 7'b0};  // Green
    assign VGA_B = {VGA_COLOUR[0], 7'b0};  // Blue

endmodule: task2
