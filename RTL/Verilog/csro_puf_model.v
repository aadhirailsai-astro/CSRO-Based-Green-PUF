`timescale 1ns / 1ps
// -----------------------------------------------------------------------------
// Four behavioural CSRO instances.
// Slight delay variations are intentionally introduced to emulate
// process-induced frequency mismatch observed in fabricated ring oscillators.
// The selected delay values (~±2%) are based on representative values reported
// in literature and are used only for behavioural verification.
// -----------------------------------------------------------------------------

// Behavioural 5-stage current-starved ring oscillator model
module csro_stage #(
    parameter real STAGE_DELAY = 1.0
)(
    input  wire enable,
    output wire clk_out
);

    wire w1, w2, w3, w4, w5;

    assign #STAGE_DELAY w1 = enable ? ~w5 : 1'b0;
    assign #STAGE_DELAY w2 = ~w1;
    assign #STAGE_DELAY w3 = ~w2;
    assign #STAGE_DELAY w4 = ~w3;
    assign #STAGE_DELAY w5 = ~w4;

    assign clk_out = w5;

endmodule


// Top-level behavioural CSRO-PUF model
module puf_top (
    input  wire       clk_sys,
    input  wire       enable,
    input  wire [1:0] challenge_in,
    output reg        puf_response
);

    wire [3:0] ro_clks;

    reg clk_a;
    reg clk_b;

    reg [7:0] count_a;
    reg [7:0] count_b;
    reg [7:0] ref_timer;

    localparam [7:0] MEASUREMENT_WINDOW = 8'd100;

    // Four behavioural CSROs with slight delay variation.
    // These delay values emulate process-induced frequency differences.
    csro_stage #(.STAGE_DELAY(1.00)) osc0 (
        .enable(enable),
        .clk_out(ro_clks[0])
    );

    csro_stage #(.STAGE_DELAY(1.02)) osc1 (
        .enable(enable),
        .clk_out(ro_clks[1])
    );

    csro_stage #(.STAGE_DELAY(0.98)) osc2 (
        .enable(enable),
        .clk_out(ro_clks[2])
    );

    csro_stage #(.STAGE_DELAY(1.01)) osc3 (
        .enable(enable),
        .clk_out(ro_clks[3])
    );

    // Challenge-controlled oscillator pair selection
    always @(*) begin
        case (challenge_in)
            2'b00: begin
                clk_a = ro_clks[0];
                clk_b = ro_clks[1];
            end

            2'b01: begin
                clk_a = ro_clks[0];
                clk_b = ro_clks[2];
            end

            2'b10: begin
                clk_a = ro_clks[1];
                clk_b = ro_clks[3];
            end

            2'b11: begin
                clk_a = ro_clks[2];
                clk_b = ro_clks[3];
            end

            default: begin
                clk_a = ro_clks[0];
                clk_b = ro_clks[1];
            end
        endcase
    end

    // Counter for selected oscillator A
    always @(posedge clk_a or negedge enable) begin
        if (!enable)
            count_a <= 8'd0;
        else if (ref_timer < MEASUREMENT_WINDOW)
            count_a <= count_a + 1'b1;
    end

    // Counter for selected oscillator B
    always @(posedge clk_b or negedge enable) begin
        if (!enable)
            count_b <= 8'd0;
        else if (ref_timer < MEASUREMENT_WINDOW)
            count_b <= count_b + 1'b1;
    end

    // Reference timer defines the evaluation window
    always @(posedge clk_sys or negedge enable) begin
        if (!enable) begin
            ref_timer    <= 8'd0;
            puf_response <= 1'b0;
        end
        else if (ref_timer < MEASUREMENT_WINDOW) begin
            ref_timer <= ref_timer + 1'b1;
        end
        else begin
            puf_response <= (count_a > count_b);
        end
    end

endmodule
