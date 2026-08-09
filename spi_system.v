module spi_system (
    input  wire       clk,
    input  wire       rst_n,

    input  wire       start,
    input  wire [7:0] tx_data,
    input  wire       slave_sel,

    output wire [7:0] rx_data,
    output wire       busy,
    output wire       done
);

    // SPI shared lines
    wire sclk;
    wire mosi;
    wire miso;

    // Individual slave-select lines
    wire ss_0;
    wire ss_1;

    // Slave MISO outputs
    wire miso_0;
    wire miso_1;

    // ---------------- MASTER ----------------

    spi_master master (
        .clk       (clk),
        .rst_n     (rst_n),
        .start     (start),
        .tx_data   (tx_data),
        .slave_sel (slave_sel),

        .sclk      (sclk),
        .mosi      (mosi),
        .miso      (miso),

        .ss_0      (ss_0),
        .ss_1      (ss_1),

        .busy      (busy),
        .done      (done),
        .rx_data   (rx_data)
    );

    // ---------------- SLAVE 0 ----------------

    spi_slave slave0 (
        .sclk (sclk),
        .rst_n(rst_n),
        .ss   (ss_0),
        .mosi (mosi),
        .miso (miso_0)
    );

    // ---------------- SLAVE 1 ----------------

    spi_slave slave1 (
        .sclk (sclk),
        .rst_n(rst_n),
        .ss   (ss_1),
        .mosi (mosi),
        .miso (miso_1)
    );

    // Only the selected slave drives MISO
    assign miso = (!ss_0) ? miso_0 :
                  (!ss_1) ? miso_1 :
                  1'b0;

endmodule