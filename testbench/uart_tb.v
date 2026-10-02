`timescale 1ns/1ps

module uart_tb;

    // Small values for faster simulation
    parameter CLK_FREQ  = 1_000_000;
    parameter BAUD_RATE = 10_000;

    reg clk;
    reg rst;

    reg       start;
    reg [7:0] tx_data;

    wire tx;
    wire busy;

    wire [7:0] rx_data;
    wire valid;


    // UART TRANSMITTER
    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) transmitter (

        .clk(clk),
        .rst(rst),
        .start(start),
        .data(tx_data),

        .tx(tx),
        .busy(busy)
    );


    // UART RECEIVER
    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) receiver (

        .clk(clk),
        .rst(rst),
        .rx(tx),

        .data(rx_data),
        .valid(valid)
    );


    // Generate clock
    always #500 clk = ~clk;


    // Test
    initial begin

        clk   = 0;
        rst   = 1;
        start = 0;
        tx_data = 8'h00;

        // Reset
        #2000;
        rst = 0;

        // Send A (ASCII = 41)
        #2000;

        tx_data = 8'h41;
        start = 1;

        #1000;
        start = 0;

        // Wait for transmission
        #1_000_000;

        // Send 5 (ASCII = 35)
        tx_data = 8'h35;
        start = 1;

        #1000;
        start = 0;

        // Wait
        #1_000_000;

        $finish;

    end


    // Display received data
    always @(posedge valid) begin

        $display(
            "Time = %0t | Received Data = %h",
            $time,
            rx_data
        );

    end

endmodule
