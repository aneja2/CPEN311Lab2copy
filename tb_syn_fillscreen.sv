module tb_syn_fillscreen();

  // Parameters
  localparam CLOCK_PERIOD = 20;  // Clock period for a 50 MHz clock

  // Inputs
  logic clk;
  logic rst_n;
  logic [2:0] colour;
  logic start;

  // Outputs
  logic done;
  logic [7:0] vga_x;
  logic [6:0] vga_y;
  logic [2:0] vga_colour;
  logic vga_plot;

  // Instantiate the synthesized fillscreen module
  // Replace "fillscreen_syn" with the correct synthesized module name if necessary
  fillscreen_syn uut (
    .clk(clk),
    .rst_n(rst_n),
    .colour(colour),
    .start(start),
    .done(done),
    .vga_x(vga_x),
    .vga_y(vga_y),
    .vga_colour(vga_colour),
    .vga_plot(vga_plot)
  );

  // Clock generation
  always # (CLOCK_PERIOD / 2) clk = ~clk;

  // Testbench initialization
  initial begin
    // Initial values
    clk = 0;
    rst_n = 0;  // Start with reset active
    start = 0;
    colour = 3'b000;  // Black by default
    
    // Wait for a few clock cycles
    repeat (5) @(posedge clk);
    
    // Release reset
    rst_n = 1;
    
    // Start the fill process
    @(posedge clk);
    start = 1;

    // Wait for 'done' to go high
    wait (done == 1);

    // Stop the fill process
    @(posedge clk);
    start = 0;

    // Wait for a few more clock cycles
    repeat (5) @(posedge clk);

    // End simulation
    $stop;
  end

endmodule: tb_syn_fillscreen
