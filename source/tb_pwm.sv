`timescale 1ns/10ps

module tb_pwm ();

  // 10MHz Clock Rate
  localparam CLK_PERIOD        = 100;
  
  // 10MHz D-FF Timing Constraints
  localparam PROPAGATION_DELAY = 1.1; // Allow for 1.1ns for FF propogation delay

  // TB-Specific Localparams
  localparam  VALUE = 8'b0;

  // Inactive Inputs and Reset Output Values
  localparam  EN_OFF = 1'b0;
  localparam  INACTIVE_SAMPLE_VALUE = 8'b0;
  localparam  RESET_PWM_O = 1'b0;

  // Declare Test Case Signals
  integer tb_test_case_num;
  string  tb_test_case_name;
  int     tb_bit_num;
  logic   tb_mismatch;
  logic   tb_check;

  // Declare DUT Connection Signals
  logic tb_clk;
  logic tb_nrst;
  logic [7:0] tb_sample;
  logic tb_pwm_o;
  logic tb_en;

  // Declare the Test Bench Signals for Expected Results
  logic tb_expected_pwm_o;

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
    tb_sample = INACTIVE_SAMPLE_VALUE;
    tb_en = EN_OFF;
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
    if(tb_expected_pwm_o == tb_pwm_o) begin // Check passed
      $display("Correct output %s during %s test case.", check_tag, tb_test_case_name);
    end
    else begin // Check failed
      tb_mismatch = 1'b1;
      $error("Incorrect output %s during %s test case. \nExpected %h, got %h.", check_tag, tb_test_case_name, tb_expected_pwm_o, tb_pwm_o);
    end

    // Wait some small amount of time so check pulse timing is visible on waves
    #(0.1);
    tb_check = 1'b0;
  end
  endtask

  // DUT Portmap
  pwm DUT 
  (
    .clk(tb_clk), 
    .nrst(tb_nrst), 
    .mixed_sample(tb_sample),
    .enable(tb_en),
    .PWM_o(tb_pwm_o)
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

    // Initialize module-task-specific test cases
    // tb_stream_check_tag = "N/A";
    // tb_bit_num          = -1;   // Initialize to invalid number
    
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
    tb_expected_pwm_o = RESET_PWM_O;
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
    // Test Case 2: PWM with a 127 sample (Half PWM)
    // ************************************************************************
    // Start Testcase, Task finishes at Negedge
    start_testcase("Basic half PWM");

    // Stimuli Set
    tb_sample = 8'd127;
    tb_en = 1'b1;

    // Immediate check (Given enable count should be 1 here)
    #(CLK_PERIOD)
    tb_expected_pwm_o = 1;
    check_output("after 1 cycle");

    // Before PWM goes low
    #(CLK_PERIOD * 126) // 125 negedges later
    tb_expected_pwm_o = 1;
    check_output("after 126 clock cycles");

    #(CLK_PERIOD)
    tb_expected_pwm_o = 0;
    check_output("after 127 cycles");

    #(CLK_PERIOD)
    tb_expected_pwm_o = 0;
    check_output("after 128 cycles");

    #(CLK_PERIOD * 127) // 127 negedges later
    tb_expected_pwm_o = 0;
    check_output("after 255 cycles");

    #(CLK_PERIOD) // Rollover
    tb_expected_pwm_o = 1;
    check_output("after rollover");

    // ************************************************************************
    // Test Case 3: PWM with a 0 sample (OFF PWM)
    // ************************************************************************
    // Start Testcase, Task finishes at Negedge
    start_testcase("Basic off PWM");

    // Stimuli Set
    tb_sample = 8'd0;
    tb_en = 1'b1;

    // Immediate check (Given enable count should be 1 here)
    #(CLK_PERIOD)
    tb_expected_pwm_o = 0;
    check_output("after 1 cycle");

    // Before PWM goes low
    #(CLK_PERIOD * 126) // 125 negedges later
    tb_expected_pwm_o = 0;
    check_output("after 126 clock cycles");

    #(CLK_PERIOD)
    tb_expected_pwm_o = 0;
    check_output("after 127 cycles");

    #(CLK_PERIOD)
    tb_expected_pwm_o = 0;
    check_output("after 128 cycles");

    #(CLK_PERIOD * 127) // 127 negedges later
    tb_expected_pwm_o = 0;
    check_output("after 255 cycles");

    #(CLK_PERIOD) // Rollover
    tb_expected_pwm_o = 0;
    check_output("after rollover");

    // ************************************************************************
    // Test Case 3: PWM with a 255 sample (FULL PWM)
    // ************************************************************************
    // Start Testcase, Task finishes at Negedge
    start_testcase("Basic full PWM");

    // Stimuli Set
    tb_sample = 8'd255;
    tb_en = 1'b1;

    // Immediate check (Given enable count should be 1 here)
    #(CLK_PERIOD)
    tb_expected_pwm_o = 1;
    check_output("after 1 cycle");

    // Before PWM goes low
    #(CLK_PERIOD * 126) // 125 negedges later
    tb_expected_pwm_o = 1;
    check_output("after 126 clock cycles");

    #(CLK_PERIOD)
    tb_expected_pwm_o = 1;
    check_output("after 127 cycles");

    #(CLK_PERIOD)
    tb_expected_pwm_o = 1;
    check_output("after 128 cycles");

    #(CLK_PERIOD * 126) // 126 negedges later
    tb_expected_pwm_o = 1;
    check_output("after 254 cycles");

    #(CLK_PERIOD) // Max Value has Dip
    tb_expected_pwm_o = 0;
    check_output("after rollover");

    #(CLK_PERIOD) // Rollover
    tb_expected_pwm_o = 1;
    check_output("after rollover");

    $display("Simulation complete");
    $stop;
  end

endmodule