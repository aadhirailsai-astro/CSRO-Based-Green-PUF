`timescale 1ns / 1ps

// -----------------------------------------------------------------------------
// File        : csro_puf_tb.v
// Project     : CSRO-Based Green PUF
// Description : Testbench for behavioural CSRO-PUF challenge-response simulation.
// -----------------------------------------------------------------------------

module csro_puf_tb;

    reg        clk_sys;
    reg        enable;
    reg  [1:0] challenge_in;
    wire       puf_response;

    // DUT instantiation
    puf_top dut (
        .clk_sys(clk_sys),
        .enable(enable),
        .challenge_in(challenge_in),
        .puf_response(puf_response)
    );

    // 100 MHz system clock: 10 ns period
    always #5 clk_sys = ~clk_sys;

    task run_challenge;
        input [1:0] challenge;
        begin
            enable       = 1'b0;
            challenge_in = challenge;
            #100;

            enable = 1'b1;

            // Measurement window = 100 clk_sys cycles = 1000 ns.
            // Extra wait time is added to allow response update.
            #1200;

            $display("Time = %0t | Challenge = %b | Count_A = %0d | Count_B = %0d | Response = %b",
                     $time, challenge, dut.count_a, dut.count_b, puf_response);

            enable = 1'b0;
            #100;
        end
    endtask

    initial begin
        clk_sys      = 1'b0;
        enable       = 1'b0;
        challenge_in = 2'b00;

        #100;

        $display("Starting CSRO-PUF behavioural simulation");

        run_challenge(2'b00);
        run_challenge(2'b01);
        run_challenge(2'b10);
        run_challenge(2'b11);

        $display("Simulation completed");
        $finish;
    end

endmodule
