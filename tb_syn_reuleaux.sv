module tb_syn_reuleaux();

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
        forever #10 clk = ~clk;  // 50MHz clock
    end

    // Instantiate the synthesized reuleaux module
    reuleaux_syn uut (
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
        // Initialize inputs
        rst_n = 0;            // Start with reset asserted
        colour = 3'b010;      // Green color
        centre_x = 8'd80;     // X-coordinate of the center
        centre_y = 7'd60;     // Y-coordinate of the center
        diameter = 8'd80;     // Diameter of 80
        start = 0;            // Start is initially deasserted

        // Reset the system
        #20;
        rst_n = 1;           // Deassert reset

        // Start drawing the Reuleaux triangle
        #20;
        start = 1;

        // Wait until done signal is asserted
        wait(done);

        // Once done, deassert start and observe the final states
        start = 0;

        // Wait a few cycles before ending the simulation
        #1000;
        $finish;
    end

endmodule: tb_syn_reuleaux
