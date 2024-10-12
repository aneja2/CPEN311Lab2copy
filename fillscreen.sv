module fillscreen(input logic clk, input logic rst_n, input logic [2:0] colour,
                  input logic start, output logic done,
                  output logic [7:0] vga_x, output logic [6:0] vga_y,
                  output logic [2:0] vga_colour, output logic vga_plot);
    // Define state machine states
    typedef enum logic [1:0] {IDLE, FILL, DONE} state_t;
    state_t state;

    // Registers to hold the current x, y coordinates
    logic [7:0] x_counter;  // 8-bit for x (0-159)
    logic [6:0] y_counter;  // 7-bit for y (0-119)

    // Begin state machine
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset state
            state <= IDLE;
            x_counter <= 0;
            y_counter <= 0;
            done <= 0;
            vga_plot <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        // Start the fill process
                        state <= FILL;
                        done <= 0;
                        x_counter <= 0;
                        y_counter <= 0;
                    end
                end

                FILL: begin
                    // Set the current pixel coordinates
                    vga_x <= x_counter;
                    vga_y <= y_counter;
                    vga_colour <= x_counter % 8;  // Color based on x mod 8
                    vga_plot <= 1;  // Signal to plot this pixel

                    // Increment y first, then x
                    if (y_counter == 119) begin
                        y_counter <= 0;
                        if (x_counter == 159) begin
                            // Reached the end of the screen
                            state <= DONE;
                        end else begin
                            x_counter <= x_counter + 1;
                        end
                    end else begin
                        y_counter <= y_counter + 1;
                    end
                end

                DONE: begin
                    done <= 1;
                    vga_plot <= 0;
                    if (!start) begin
                        // Return to IDLE once done and start is deasserted
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end
  
endmodule

