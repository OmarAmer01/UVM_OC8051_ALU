/*
==========================================================================
* Scoreboard

* Author: Omar T. Amer
* Date: 5/11/24
==========================================================================
*/

`include "uvm_macros.svh"

`define FLUSH_QUEUE(NAME) \
while ( NAME.size > 0 ) void'( NAME.pop_back() );


package scb;
  import uvm_pkg::*;
  import seq_item::*;
  import checker_functions_pkg::*;
  import opcode_pkg::*;
  class scb extends uvm_scoreboard;
    `uvm_component_utils(scb)

    int cycle_no = 0;
    uvm_analysis_imp #(seq_item_mon, scb) ap_imp;

    function new(string name = "scb", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      ap_imp = new("ap_imp", this);
      super.build_phase(phase);
    endfunction

    virtual function void write(seq_item_mon txn);
      if (((txn.op_code == MUL) | (txn.op_code == DIV)) & (cycle_no < 3)) begin
        cycle_no++;  // Dont look while the ALU is "multiplying". Ha ha.
        // Or dividing as well.
        return;
      end

      cycle_no = 0;
      check_res(txn);
    endfunction

    virtual function void check_res(seq_item_mon txn);
      
      case (txn.op_code)
        NOP: check_nop(txn);
        ADD: check_add(txn);
        SUB: check_sub(txn);
        MUL: check_mul(txn);
        DIV: check_div(txn);
        DA: check_da(txn);
        NOT: check_not(txn);
        AND: check_and(txn);
        XOR: check_xor(txn);
        OR: check_or(txn);
        RL: check_rl(txn);
        RLC: check_rlc(txn);
        RR: check_rr(txn);
        RRC: check_rrc(txn);
        INC: check_inc(txn);
        XCH: check_xch(txn);
        default `uvm_fatal(get_name,$sformatf("Invalid Opcode %h", txn.op_code))
      endcase
    endfunction

  endclass
endpackage
