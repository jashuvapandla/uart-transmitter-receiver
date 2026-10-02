module uart_tx #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] data,

    output reg tx,
    output reg busy
);

    // Number of clock cycles required for one UART bit
    localparam BIT_TIME = CLK_FREQ / BAUD_RATE;

    reg [15:0] counter;
    reg [3:0] bit_count;
    reg [9:0] data_frame;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            tx         <= 1'b1;
            busy       <= 1'b0;
            counter    <= 0;
            bit_count  <= 0;
            data_frame <= 0;
        end

        else begin

            // Start sending data
            if (start && !busy) begin

                // 1 start bit + 8 data bits + 1 stop bit
                data_frame <= {1'b1, data, 1'b0};

                busy      <= 1'b1;
                counter   <= 0;
                bit_count <= 0;

                // Start bit
                tx <= 1'b0;
            end

            // Transmission is in progress
            else if (busy) begin

                if (counter == BIT_TIME - 1) begin

                    counter <= 0;

                    if (bit_count == 9) begin

                        // Transmission finished
                        busy <= 1'b0;
                        tx   <= 1'b1;

                    end
                    else begin

                        bit_count <= bit_count + 1;

                        // Send next bit
                        tx <= data_frame[bit_count + 1];

                    end
                end

                else begin
                    counter <= counter + 1;
                end
            end
        end
    end

endmodule
