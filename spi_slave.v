module spi_slave (
    input  wire       sclk,
    input  wire       rst_n,
    input  wire       ss,
    input  wire       mosi,

    output reg        miso
);

    reg [7:0] tx_data;
    reg [7:0] rx_data;
    reg [2:0] bit_count;

    always @(posedge sclk or negedge rst_n) begin

        if (!rst_n) begin
            tx_data  <= 8'b10101010;
            rx_data  <= 8'b0;
            bit_count <= 3'b0;
            miso     <= 1'b0;
        end

        else if (!ss) begin

            // Receive data from master
            rx_data <= {rx_data[6:0], mosi};

            // Send data to master
            miso <= tx_data[7];

            // Shift transmit data
            tx_data <= {tx_data[6:0], 1'b0};

            // Count bits
            if (bit_count == 3'd7)
                bit_count <= 3'b0;
            else
                bit_count <= bit_count + 1'b1;

        end

        else begin
            miso <= 1'b0;
        end

    end

endmodule