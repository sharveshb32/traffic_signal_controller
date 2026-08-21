`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.08.2026 16:55:38
// Design Name: 
// Module Name: traffic_4_way_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module traffic_4_way_tb;

    // Inputs
    reg rst;
    reg clk;
    reg amb_1, amb_2, amb_3, amb_4;
    reg car_1, car_2, car_3, car_4;

    // Outputs
    wire [1:0] sig_1, sig_2, sig_3, sig_4;

    // Instantiate the Unit Under Test (UUT)
    traffic_4_way uut (
        .rst(rst), 
        .clk(clk), 
        .amb_1(amb_1), .amb_2(amb_2), .amb_3(amb_3), .amb_4(amb_4), 
        .car_1(car_1), .car_2(car_2), .car_3(car_3), .car_4(car_4), 
        .sig_1(sig_1), .sig_2(sig_2), .sig_3(sig_3), .sig_4(sig_4)
    );

    // Clock Generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        rst = 1;
        clk = 0;
        amb_1 = 0; amb_2 = 0; amb_3 = 0; amb_4 = 0;
        car_1 = 0; car_2 = 0; car_3 = 0; car_4 = 0;

        // Apply Reset
        #25;
        rst = 0;

        // =======================================================
        // SCENARIO 1: Heavy Traffic in ALL 4 Lanes
        // Cycles: g1 -> g2 -> g3 -> g4
        // =======================================================
        $display("\n--- SCENARIO 1: Traffic in ALL 4 Lanes ---");
        car_1 = 1; car_2 = 1; car_3 = 1; car_4 = 1;
        #1000; 

        // =======================================================
        // SCENARIO 2: Sudden Ambulance Override (Lane 3)
        // Mid-cycle interruption test
        // =======================================================
        $display("\n--- SCENARIO 2: Emergency! Ambulance on Lane 3 ---");
        amb_3 = 1;  // Instantly force green on Lane 3
        #250;      // Hold ambulance active
        amb_3 = 0;  // Deactivate ambulance
        #300;      // Let normal flow resume

        // =======================================================
        // SCENARIO 3: Traffic in 3 Lanes (Lanes 1, 2, and 3)
        // Bypasses Lane 4
        // =======================================================
        $display("\n--- SCENARIO 3: Traffic in 3 Lanes (1, 2, 3) ---");
        car_1 = 1; car_2 = 1; car_3 = 1; car_4 = 0;
        #800;

        // =======================================================
        // SCENARIO 4: Sudden Ambulance Override (Lane 4)
        // Tests overriding a lane that has NO normal car traffic
        // =======================================================
        $display("\n--- SCENARIO 4: Emergency! Ambulance on Empty Lane 4 ---");
        amb_4 = 1;
        #200;
        amb_4 = 0;
        #300;

        // =======================================================
        // SCENARIO 5: Traffic in 2 Lanes (Lanes 1 and 3)
        // Bounces between g1 and g3
        // =======================================================
        $display("\n--- SCENARIO 5: Traffic in 2 Lanes (1 and 3) ---");
        car_1 = 1; car_2 = 0; car_3 = 1; car_4 = 0;
        #600;

        // =======================================================
        // SCENARIO 6: Traffic in 1 Lane (Lane 1 only)
        // Default sequential traversal
        // =======================================================
        $display("\n--- SCENARIO 6: Traffic in 1 Lane (Lane 1 only) ---");
        car_1 = 1; car_2 = 0; car_3 = 0; car_4 = 0;
        #600;

        $display("\n--- ALL TEST SCENARIOS COMPLETED ---");
        $finish;
    end

    // Real-time Console Display
    initial begin
        $monitor("Time = %0t ns | State = %0d | Signals(1,2,3,4) = [%b %b %b %b] | Amb(1,2,3,4) = [%b %b %b %b]", 
                 $time, uut.curr_state, sig_1, sig_2, sig_3, sig_4, 
                 amb_1, amb_2, amb_3, amb_4);
    end

endmodule
