module tb_rtl_reuleaux();

    logic clk;
    logic rst_n;
    logic [2:0] colour;
    logic [7:0] centre_x;
    logic [6:0] centre_y;
    logic [7:0] diameter;
    logic start;
    logic done;
    logic [7:0] vga_x;
    logic [6:0] vga_y;
    logic [2:0] vga_colour;
    logic vga_plot;

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50MHz clock
    end

    // Instantiate the reuleaux module
    reuleaux uut (
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

    // Test sequence
    initial begin
        // Initial values
        rst_n = 0;
        start = 0;
        colour = 3'b010;    // Green
        centre_x = 8'd80;   // Centre of the screen
        centre_y = 7'd60;
        diameter = 8'd80;   // Diameter

        // Apply reset
        #20;
        rst_n = 1;

        // Start drawing Reuleaux triangle
        #30;
        start = 1;

        // Wait for done signal
        wait(done == 1);

        // Deassert start
        #10;
        start = 0;

        // Simulation finish
        #1000;
        $finish;
    end

endmodule: tb_rtl_reuleaux
