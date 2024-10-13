module tb_task4();

    logic CLOCK_50;
    logic [3:0] KEY;
    logic [9:0] SW;
    logic [9:0] LEDR;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    logic [7:0] VGA_R, VGA_G, VGA_B;
    logic VGA_HS, VGA_VS, VGA_CLK;
    logic [7:0] VGA_X;
    logic [6:0] VGA_Y;
    logic [2:0] VGA_COLOUR;
    logic VGA_PLOT;

    // Clock generation
    initial begin
        CLOCK_50 = 0;
        forever #10 CLOCK_50 = ~CLOCK_50;  // 50MHz clock
    end

    // Instantiate the unsynthesized RTL task4 module
    task4 uut (
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .SW(SW),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_CLK(VGA_CLK),
        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_COLOUR(VGA_COLOUR),
        .VGA_PLOT(VGA_PLOT)
    );

    // Test sequence
    initial begin
        // Initialize inputs
        KEY = 4'b1111;  // All keys high initially (reset inactive)
        SW = 10'b0;     // No switches active

        // Apply reset
        #20;
        KEY[3] = 0;  // Assert reset (active-low)

        // Deassert reset after some time
        #40;
        KEY[3] = 1;

        // Monitor signals over time
        #100000;

        // Output VGA signals during simulation (for visual observation)
        $display("VGA_X = %0d, VGA_Y = %0d, VGA_COLOUR = %0d", VGA_X, VGA_Y, VGA_COLOUR);

        // Let the system run to observe its behavior and outputs
        #1000000;
        $finish;
    end

endmodule: tb_task4
