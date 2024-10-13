module tb_rtl_task4();

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
        forever #10 CLOCK_50 = ~CLOCK_50; // 50MHz clock
    end

    // Instantiate the task4 top-level module
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
        KEY = 4'b1111;  // Initially all keys unpressed
        SW = 10'b0;

        // Apply reset by pressing KEY[3]
        #20;
        KEY[3] = 0;  // Assert reset
        #40;
        KEY[3] = 1;  // Deassert reset

        // Observe the automatic behavior of drawing the Reuleaux triangle
        // The top module should automatically draw a green Reuleaux triangle

        // Wait for some time to allow the VGA outputs to settle
        #100000;

        // End the simulation after a long enough time for observation
        $finish;
    end

endmodule: tb_rtl_task4
