module reuleaux(input logic clk, input logic rst_n, input logic [2:0] colour,
                input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] diameter,
                input logic start, output logic done,
                output logic [7:0] vga_x, output logic [6:0] vga_y,
                output logic [2:0] vga_colour, output logic vga_plot);

    logic [7:0] c_x1, c_x2, c_x3;
    logic [6:0] c_y1, c_y2, c_y3;
    logic c1d, c2d, c3d;
    logic [7:0] vga_cx1, vga_cx2, vga_cx3;
    logic [6:0] vga_cy1, vga_cy2, vga_cy3;
    logic [2:0] vga_cc1, vga_cc2, vga_cc3;
    logic vga_cp1, vga_cp2, vga_cp3;
    
    localparam circle1 = 2'd0, circle2 = 2'd1, circle3 = 2'd2, doneState = 2'd3;
    logic [1:0] currState = circle1, nextState = circle1;

    circle c1(
        .clk(clk),
        .rst_n(rst_n),
        .centre_x(c_x1),
        .centre_y(c_y1),
        .radius(diameter >> 1),
        .colour(colour),
        .start(start),
        .done(c1d),
        .vga_x(vga_cx1),
        .vga_y(vga_cy1),
        .vga_colour(vga_cc1),
        .vga_plot(vga_cp1)
    );

    circle c2(
        .clk(clk),
        .rst_n(rst_n),
        .centre_x(c_x2),
        .centre_y(c_y2),
        .radius(diameter >> 1),
        .colour(colour),
        .start(start),
        .done(c2d),
        .vga_x(vga_cx2),
        .vga_y(vga_cy2),
        .vga_colour(vga_cc2),
        .vga_plot(vga_cp2)
    );

    circle c3(
        .clk(clk),
        .rst_n(rst_n),
        .centre_x(c_x3),
        .centre_y(c_y3),
        .radius(diameter >> 1),
        .colour(colour),
        .start(start),
        .done(c3d),
        .vga_x(vga_cx3),
        .vga_y(vga_cy3),
        .vga_colour(vga_cc3),
        .vga_plot(vga_cp3)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 0;
            currState <= circle1;
            c_x1 <= 120;
            c_x2 <= 40;
            c_x3 <= 80;
            c_y1 <= 60 + (80 * 288)/1000;
            c_y2 <= 60 + (80 * 288)/1000;
            c_y3 <= 60 - (80 * 577)/1000;
        end else if (start) begin
            done <= 0;
            c_x1 <= centre_x + (diameter >> 1);
            c_x2 <= centre_x - (diameter >> 1);
            c_x3 <= centre_x;
            c_y1 <= centre_y + (diameter * 288)/1000;
            c_y2 <= centre_y + (diameter * 288)/1000;
            c_y3 <= centre_y - (diameter * 577)/1000;
        end else begin
            currState <= nextState;
            if (currState == doneState) done <= 1;
        end
    end

    always_ff @(posedge clk) begin
        vga_plot = 0;

        case(currState)
        circle1: begin
            vga_colour = vga_cc1;
            vga_x = vga_cx1;
            vga_y = vga_cy1;
            vga_plot = vga_cp1;
            if (c1d) nextState = circle2;
        end

        circle2: begin
            vga_colour = vga_cc2;
            vga_x = vga_cx2;
            vga_y = vga_cy2;
            vga_plot = vga_cp2;
            if (c2d) nextState = circle3;
        end

        circle3: begin
            vga_colour = vga_cc3;
            vga_x = vga_cx3;
            vga_y = vga_cy3;
            vga_plot = vga_cp3;
            if (c3d) nextState = doneState;
        end

        doneState: begin
            done <= 1;
        end

        default: nextState = circle1;
        endcase
    end

endmodule

