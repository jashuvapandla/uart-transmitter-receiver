module uart_rx #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire rst,
    input wire rx,

    output reg [7:0] data,
    output reg valid
);

    // Number of clock cycles for one UART bit
    localparam BIT_TIME = CLK_FREQ / BAUD_RATE;

    reg [15:0] counter;
    reg [3:0] bit_count;
    reg [7:0] received_data;
    reg receiving;

    always @(posedge clk or posedge rst) begin

        if (rst) begin
            counter       <= 0;
            bit_count     <= 0;
            received_data <= 0;
            data          <= 0;
            valid         <= 0;
            receiving     <= 0;
        end

        else begin

            // valid is normally 0
            valid <= 0;

            // Wait for start bit
            if (!receiving) begin

                if (rx == 0) begin
                    receiving <= 1;
                    counter   <= BIT_TIME / 2;
                    bit_count <= 0;
                end

            end

            // Receiving data
            else begin

                if (counter == BIT_TIME - 1) begin

                    counter <= 0;

                    // Receive 8 data bits
                    if (bit_count < 8) begin

                        received_data[bit_count] <= rx;
                        bit_count <= bit_count + 1;

                    end

                    // Stop bit
                    else begin

                        data      <= received_data;
                        valid     <= 1;
                        receiving <= 0;
                        bit_count <= 0;

                    end

                end

                else begin
                    counter <= counter + 1;
                end

            end
        end
    end

endmodule
