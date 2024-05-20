/*
==================
* TB Top
* Date 5/6/24
==================
*/

import uvm_pkg::*;
`include "uvm_macros.svh"

import main_test::*;
module tb_top;

  logic clk;

  //TODO: Remove PERIOD magic number.
  initial begin : clk_gen
    clk = 0;
    forever #(50) clk = ~clk;
  end

  alu_if _alu_if (clk);

  oc8051_alu_wrapper dut(
      _alu_if
  );

  // bind oc8051_alu_wrapper alu_ac UUT(.*);

  // spi_slave_wrapper U1 (.*);
  // bind spi_slave_wrapper assertion_cover_spi_slave UUT (.*);


  initial begin
    uvm_config_db#(virtual alu_if)::set(uvm_root::get(), "*", "alu_if", _alu_if);

    run_test("main_test");
  end

endmodule
