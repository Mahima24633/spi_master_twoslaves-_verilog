`timescale 1ns/1ps

module tb_spi_master;

    reg clk;
    reg rst_n;

    reg start;
    reg [7:0] tx_data;
    reg slave_sel;

    wire [7:0] rx_data;
    wire busy;
    wire done;

    // ---------------- DUT ----------------

    spi_system dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .start     (start),
        .tx_data   (tx_data),
        .slave_sel (slave_sel),

        .rx_data   (rx_data),
        .busy      (busy),
        .done      (done)
    );

    // ---------------- CLOCK ----------------

    always #5 clk = ~clk;

    // ---------------- TEST ----------------

    initial begin

        // Initial values
        clk       = 1'b0;
        rst_n     = 1'b0;
        start     = 1'b0;
        tx_data   = 8'b0;
        slave_sel = 1'b0;

        // Reset
        #20;
        rst_n = 1'b1;

        // =====================================
        // TEST 1 : SLAVE 0
        // =====================================

        #20;

        tx_data   = 8'b11001100;
        slave_sel = 1'b0;
        start     = 1'b1;

        #10;
        start = 1'b0;

        wait(done);

        #20;

        // =====================================
        // TEST 2 : SLAVE 1
        // =====================================

        tx_data   = 8'b10101010;
        slave_sel = 1'b1;
        start     = 1'b1;

        #10;
        start = 1'b0;

        wait(done);

        #20;

        $finish;

    end

    // ---------------- WAVEFORM ----------------

    initial begin
        $dumpfile("spi.vcd");
        $dumpvars(0, tb_spi_master.dut);
    end

endmodule