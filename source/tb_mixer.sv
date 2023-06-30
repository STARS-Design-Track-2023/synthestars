`timescale 1ns/10ps

module tb_sequential_divider ();

  // 10MHz Clock Rate
  localparam CLK_PERIOD        = 100;
  
  // 10MHz D-FF Timing Constraints
  localparam PROPAGATION_DELAY = 1.1; // Allow for 1.1ns for FF propogation delay

  // TB-Specific Localparams
  localparam  VALUE = 8'b0;

  // Inactive Inputs and Reset Output Values
  localparam  ENABLE_OFF = 1'b0;
  localparam  INPUT_OFF = 104'b0;
  localparam  RESET_SAMPLE_VALUE = 8'b0;

  // Declare Test Case Signals
  integer tb_test_case_num;
  string  tb_test_case_name;
  int     tb_bit_num;
  logic   tb_mismatch;
  logic   tb_check;

  // Declare DUT Connection Signals
  logic   tb_clk;
  logic   tb_nrst;
  logic   tb_en;
  logic   [7:0] tb_sample;
  logic [7:0] tb_n1, tb_n2, tb_n3, tb_n4, tb_n5, tb_n6, tb_n7, 
              tb_n8, tb_n9, tb_n10, tb_n11, tb_n12, tb_n13;
  
  // Declare the Test Bench Signals for Expected Results
  logic [7:0] tb_expected_sample;

  // Clock generation block
  always begin
    // Start with clock low to avoid false rising edge events at t=0
    tb_clk = 1'b0;
    // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
    tb_clk = 1'b1;
    // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
    #(CLK_PERIOD/2.0);
  end

  task start_dut;
  begin
    // Init Test Case Meta Variables
    tb_test_case_num         = 0;
    tb_test_case_name        = "Test Bench Initializaton";
    tb_mismatch              = 1'b0;
    tb_check                 = 1'b0;
  end
  endtask

  // Task for standard DUT reset procedure
  task reset_dut;
  begin
    // Activate the reset
    tb_nrst = 1'b0;

    // Maintain the reset for more than one cycle
    @(posedge tb_clk);
    @(posedge tb_clk);

    // Wait until safely away from rising edge of the clock before releasing
    @(negedge tb_clk);
    tb_nrst = 1'b1;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    @(negedge tb_clk);
    @(negedge tb_clk);
  end
  endtask

  // Set input signals to zero before starting with new testcases
  task deactivate_signals;
  begin
    tb_en = ENABLE_OFF;
    {tb_n1,tb_n2,tb_n3,tb_n4,tb_n5,tb_n6,tb_n7,tb_n8,tb_n9,tb_n10,tb_n11,tb_n12,tb_n13} = INPUT_OFF;
  end
  endtask

  // Set input signals to zero before starting with new testcases
  task start_testcase;
    input string test_case_name;
  begin
    // Space test case out from previous test case
    #(CLK_PERIOD * 3);

    // Set name and number
    tb_test_case_num  = tb_test_case_num + 1;
    tb_test_case_name = test_case_name;

    // Reset and deactivate DUT
    deactivate_signals();
    reset_dut();
  end
  endtask

  // Task to cleanly and consistently check DUT output values
  task check_output;
    input string check_tag;
  begin
    tb_mismatch = 1'b0;
    tb_check    = 1'b1;
    if(tb_expected_sample == tb_sample) begin // Check passed
      $display("Correct output %s during %s test case.", check_tag, tb_test_case_name);
    end
    else begin // Check failed
      tb_mismatch = 1'b1;
      $error("Incorrect output %s during %s test case. \nExpected %h, got %h.", check_tag, tb_test_case_name, tb_expected_sample, tb_sample);
    end

    // Wait some small amount of time so check pulse timing is visible on waves
    #(0.1);
    tb_check =1'b0;
  end
  endtask

  // DUT Portmap
  mixer DUT 
  (
    .clk(tb_clk), 
    .nrst(tb_nrst), 
    .en(tb_en),
    .n1(tb_n1),
    .n2(tb_n2),
    .n3(tb_n3),
    .n4(tb_n4),
    .n5(tb_n5),
    .n6(tb_n6),
    .n7(tb_n7),
    .n8(tb_n8),
    .n9(tb_n9),
    .n10(tb_n10),
    .n11(tb_n11),
    .n12(tb_n12),
    .n13(tb_n13)
  );

  // Signal Dump
  initial begin
    $dumpfile ("dump.vcd");
    $dumpvars;
  end
  
  // Test Cases
  initial begin
    // Initialize all of the test inputs and test environment
    deactivate_signals();
    start_dut();
    
    // Wait some time before starting first test case
    #(0.1);

    // ************************************************************************
    // Test Case 1: Power-on Reset of the DUT
    // ************************************************************************
    tb_test_case_num  = tb_test_case_num + 1;
    tb_test_case_name = "Power on Reset";
    // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
    // Wait some time before applying test case stimulus
    #(0.1);
    // Apply test case initial stimulus
    deactivate_signals();
    tb_nrst = 1'b0; // Manually enable chip reset

    // Wait for a bit before checking for correct functionality
    #(CLK_PERIOD * 0.5);

    // Check that internal state was correctly reset
    tb_expected_sample = RESET_SAMPLE_VALUE;
    check_output("after reset applied");

    // Check that the reset value is maintained during a clock cycle
    #(CLK_PERIOD);
    check_output("after clock cycle while in reset");
    
    // Release the reset away from a clock edge
    @(negedge tb_clk);
    tb_nrst = 1'b1;   // Deactivate the chip reset

    // Check that internal state was correctly keep after reset release
    #(PROPAGATION_DELAY);
    check_output("after reset was released");

    // ************************************************************************
    // Test Case 2: 1 Signal Mixed
    // ************************************************************************
    // Start Testcase, Task finishes at Negedge
    start_testcase("One Signal Through Mixer");

    tb_n1 = 8'd56;
    
    // Pulse tb_en
    tb_en = 1;
    #(CLK_PERIOD);
    tb_en = 0;

    // Wait for Division to complete
    #(CLK_PERIOD * 11);

    // Sample 1 Check
    tb_expected_sample = 56;
    check_output("after passing sample #1");

    tb_n1 = 8'd0;
    tb_n7 = 8'd87;

    // Pulse tb_en
    tb_en = 1;
    #(CLK_PERIOD);
    tb_en = 0;

    #(CLK_PERIOD * 11);
    check_output("after passing sample #2");

    // ************************************************************************
    // Test Case 3: Three Signals Mixed
    // ************************************************************************
    // Start Testcase, Task finishes at Negedge
    start_testcase("Three Mixed Signals");

    tb_n2 = 8'd56;
    tb_n3 = 8'd67;
    tb_n4 = 8'd78;
    
    // Pulse tb_en
    tb_en = 1;
    #(CLK_PERIOD);
    tb_en = 0;

    // Wait for Division to complete
    #(CLK_PERIOD * 11);

    // Sample 1 Check
    tb_expected_sample = 8'd67;
    check_output("after passing sample #1");

    tb_n2 = 8'd0;
    tb_n3 = 8'd0;
    tb_n4 = 8'd0;
    tb_n5 = 8'd128;
    tb_n10 = 8'd192;
    tb_n12 = 8'd252;
    
    // Pulse tb_en
    tb_en = 1;
    #(CLK_PERIOD);
    tb_en = 0;

    // Wait for Division to complete
    #(CLK_PERIOD * 11);

    // Sample 1 Check
    tb_expected_sample = 190;
    check_output("after passing sample #2");

    // ************************************************************************
    // Test Case 3: Thirteen Signals Mixed
    // ************************************************************************
    // Start Testcase, Task finishes at Negedge
    start_testcase("Thirteen Mixed Signals");

    tb_n1 = 8'd2;
    tb_n2 = 8'd5;
    tb_n3 = 8'd11;
    tb_n4 = 8'd17;
    tb_n5 = 8'd23;
    tb_n6 = 8'd31;
    tb_n7 = 8'd41;
    tb_n8 = 8'd47;
    tb_n9 = 8'd59;
    tb_n10 = 8'd67;
    tb_n11 = 8'd73;
    tb_n12 = 8'd83;
    tb_n13 = 8'd91;
    
    // Pulse tb_en
    tb_en = 1;
    #(CLK_PERIOD);
    tb_en = 0;

    // Wait for Division to complete
    #(CLK_PERIOD * 11);

    // Sample 1 Check
    tb_expected_sample = 8'd42;
    check_output("after passing sample #1");

    $display("Simulation complete");
    $stop;
  end

endmodule