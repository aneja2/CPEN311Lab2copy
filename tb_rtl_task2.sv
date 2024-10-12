module tb_rtl_task2();

  // Parameters
  localparam CLOCK_PERIOD = 20;  // Clock period for a 50 MHz clock

  // Inputs
  logic CLOCK_50;
  logic [3:0] KEY;
  logic [9:0] SW;

  // Outputs
  logic [9:0] LEDR;
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  logic [7:0] VGA_R, VGA_G, VGA_B;
  logic VGA_HS, VGA_VS, VGA_CLK;
  logic [7:0] VGA_X;
  logic [6:0] VGA_Y;
  logic [2:0] VGA_COLOUR;
  logic VGA_PLOT;

  // Instantiate the task2 module
  task2 uut (
    .CLOCK_50(CLOCK_50),
    .KEY(KEY),
    .SW(SW),
    .LEDR(LEDR),
    .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
    .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
    .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_CLK(VGA_CLK),
    .VGA_X(VGA_X), .VGA_Y(VGA_Y), .VGA_COLOUR(VGA_COLOUR), .VGA_PLOT(VGA_PLOT)
  );

  // Clock generation
  always # (CLOCK_PERIOD / 2) CLOCK_50 = ~CLOCK_50;

  // Testbench initialization
  initial begin
    // Initial values
    CLOCK_50 = 0;
    KEY = 4'b1111;  // Active-low reset, start with reset deasserted
    SW = 10'b0000000000;  // No switches pressed

    // Assert reset
    @(posedge CLOCK_50);
    KEY[3] = 0;  // Activate reset (active-low)

    // Deassert reset after a few clock cycles
    repeat (5) @(posedge CLOCK_50);
    KEY[3] = 1;  // Deactivate reset

    // Wait for the fill process to complete by monitoring VGA plot signals
    wait (VGA_PLOT == 1);

    // Wait until done
    @(posedge CLOCK_50);
    wait (LEDR[0] == 1);  // Done flag is on LEDR[0] in task2

    // Simulation ends
    $stop;
  end

endmodule: tb_rtl_task2
