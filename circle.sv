module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] radius,
              input logic start, output logic done,
              output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot);

    logic [7:0] offset_x;
    logic [6:0] offset_y;
    logic [15:0] crit;
    logic [3:0] state;
    logic drawing;

    typedef enum logic [1:0] {
        IDLE,
        DRAW,
        DONE
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        case (current_state)
            IDLE: begin
                if (start) next_state = DRAW;
                else next_state = IDLE;
            end
            DRAW: begin
                if (offset_y > offset_x) next_state = DONE;
                else next_state = DRAW;
            end
            DONE: begin
                next_state = IDLE;
            end
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            offset_x <= 0;
            offset_y <= 0;
            crit <= 0;
            drawing <= 0;
            done <= 0;
        end else if (current_state == IDLE) begin
            offset_x <= radius;
            offset_y <= 0;
            crit <= 1 - radius;
            done <= 0;
            drawing <= 1;
        end else if (current_state == DRAW && drawing) begin
            if (offset_y <= offset_x) begin
                plot_pixel(centre_x + offset_x, centre_y + offset_y);
                plot_pixel(centre_x + offset_y, centre_y + offset_x);
                plot_pixel(centre_x - offset_x, centre_y + offset_y);
                plot_pixel(centre_x - offset_y, centre_y + offset_x);
                plot_pixel(centre_x - offset_x, centre_y - offset_y);
                plot_pixel(centre_x - offset_y, centre_y - offset_x);
                plot_pixel(centre_x + offset_x, centre_y - offset_y);
                plot_pixel(centre_x + offset_y, centre_y - offset_x);

                offset_y <= offset_y + 1;
                if (crit <= 0) crit <= crit + 2 * offset_y + 1;
                else begin
                    offset_x <= offset_x - 1;
                    crit <= crit + 2 * (offset_y - offset_x) + 1;
                end
            end else begin
                done <= 1;
                drawing <= 0;
            end
        end
    end

    task plot_pixel(input [7:0] x, input [6:0] y);
        vga_x <= x;
        vga_y <= y;
        vga_colour <= colour;
        vga_plot <= 1;
    endtask
endmodule
