module task3(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

    // Signals to connect to the circle module
    logic [7:0] centre_x = 80;
    logic [6:0] centre_y = 60;
    logic [7:0] radius = 40;
    logic [2:0] colour = 3'b010; // Green colour
    logic start, done;
    logic vga_x, vga_y, vga_colour, vga_plot;

    // Instantiate the circle module
    circle circle_inst (
        .clk(CLOCK_50),
        .rst_n(KEY[3]),
        .colour(colour),
        .centre_x(centre_x),
        .centre_y(centre_y),
        .radius(radius),
        .start(start),
        .done(done),
        .vga_x(VGA_X),
        .vga_y(VGA_Y),
        .vga_colour(VGA_COLOUR),
        .vga_plot(VGA_PLOT)
    );

    // Reset logic and start circle drawing
    always_ff @(posedge CLOCK_50 or negedge KEY[3]) begin
        if (!KEY[3]) begin
            start <= 1;
        end else if (done) begin
            start <= 0;
        end
    end

endmodule: task3
