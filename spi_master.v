module spi_master (
    input  wire       clk,
    input  wire       rst_n,

    input  wire       start,
    input  wire [7:0] tx_data,
    input  wire       slave_sel,

    output reg        sclk,
    output reg        mosi,
    input  wire       miso,

    output reg        ss_0,
    output reg        ss_1,

    output reg        busy,
    output reg        done,
    output reg [7:0]  rx_data
);

    // Internal registers
    reg [7:0] tx_shift_reg;
    reg [7:0] rx_shift_reg;
    reg [2:0] bit_count;
    reg [7:0] clk_count;

    // SPI clock divider
    // SCLK toggles after 5 system-clock cycles
    parameter CLK_DIV = 8'd4;

    always @(posedge clk or negedge rst_n) begin

        // ---------------- RESET ----------------
        if (!rst_n) begin

            sclk         <= 1'b0;
            mosi         <= 1'b0;

            ss_0         <= 1'b1;
            ss_1         <= 1'b1;

            busy         <= 1'b0;
            done         <= 1'b0;

            rx_data      <= 8'b0;

            tx_shift_reg <= 8'b0;
            rx_shift_reg <= 8'b0;

            bit_count    <= 3'b0;
            clk_count    <= 8'b0;

        end

        // ---------------- NORMAL OPERATION ----------------
        else begin

            // done is normally LOW
            done <= 1'b0;

            // =================================================
            // START A NEW SPI TRANSFER
            // =================================================
            if (start && !busy) begin

                busy         <= 1'b1;

                tx_shift_reg <= tx_data;
                rx_shift_reg <= 8'b0;

                bit_count    <= 3'b0;
                clk_count    <= 8'b0;

                sclk         <= 1'b0;

                // Select one slave
                if (slave_sel == 1'b0) begin

                    ss_0 <= 1'b0;   // Slave 0 selected
                    ss_1 <= 1'b1;   // Slave 1 disabled

                end
                else begin

                    ss_0 <= 1'b1;   // Slave 0 disabled
                    ss_1 <= 1'b0;   // Slave 1 selected

                end

                // First bit placed on MOSI
                mosi <= tx_data[7];

            end

            // =================================================
            // SPI TRANSFER IN PROGRESS
            // =================================================
            else if (busy) begin

                // Clock divider
                if (clk_count == CLK_DIV) begin

                    clk_count <= 8'd0;

                    // -----------------------------------------
                    // RISING EDGE
                    // -----------------------------------------
                    if (sclk == 1'b0) begin

                        sclk <= 1'b1;

                        // Receive bit from slave
                        rx_shift_reg <= {
                            rx_shift_reg[6:0],
                            miso
                        };

                    end

                    // -----------------------------------------
                    // FALLING EDGE
                    // -----------------------------------------
                    else begin

                        sclk <= 1'b0;

                        // Check whether 8 bits are completed
                        if (bit_count == 3'd7) begin

                            // Transfer complete
                            busy <= 1'b0;
                            done <= 1'b1;

                            // Store received data
                            rx_data <= {
                                rx_shift_reg[6:0],
                                miso
                            };

                            // Release both slaves
                            ss_0 <= 1'b1;
                            ss_1 <= 1'b1;

                            // Clear MOSI
                            mosi <= 1'b0;

                            // Reset counter
                            bit_count <= 3'b0;

                        end

                        else begin

                            // Shift transmitted data
                            tx_shift_reg <= {
                                tx_shift_reg[6:0],
                                1'b0
                            };

                            // Move to next bit
                            bit_count <= bit_count + 1'b1;

                            // Put next bit on MOSI
                            mosi <= tx_shift_reg[6];

                        end

                    end

                end

                else begin

                    clk_count <= clk_count + 1'b1;

                end

            end

        end

    end

endmodule