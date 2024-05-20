/*
======================================
* Subscriber for coverage collection
======================================
*/
`include "uvm_macros.svh"

package sub;
  import uvm_pkg::*;
  import seq_item::*;
  import opcode_pkg::*;
  class cov extends uvm_subscriber #(seq_item_mon);
    `uvm_component_utils(cov)
    seq_item_mon txn;

    covergroup operations();
      rst: coverpoint txn.rst;
      carry_in: coverpoint txn.srcCy;
      carry_aux: coverpoint txn.srcAc;
      bit_in: coverpoint txn.bit_in;
      all_opcode_variants: cross txn.op_code, carry_in, carry_aux;
    endgroup

    covergroup outputs();
      opcode: coverpoint txn.op_code;
      carry_out: coverpoint txn.desCy;
      aux_carry_out: coverpoint txn.desAc;
      overflow: coverpoint txn.desOv;
      all_opcode_results: cross opcode, carry_out, aux_carry_out, overflow{
        ignore_bins no_xch = binsof(opcode) intersect {XCH};
        ignore_bins no_inc = binsof(opcode) intersect {INC};
        ignore_bins no_rr = binsof(opcode) intersect {RR};
        ignore_bins no_rl = binsof(opcode) intersect {RL};
        ignore_bins no_xor = binsof(opcode) intersect {XOR};
        ignore_bins no_nop = binsof(opcode) intersect {NOP};
        ignore_bins only_carry_on_rrc = binsof(opcode) intersect {RRC} && binsof(aux_carry_out) && binsof(overflow);
        ignore_bins only_carry_on_rlc = binsof(opcode) intersect {RLC} && binsof(aux_carry_out) && binsof(overflow);
        ignore_bins only_carry_on_or = binsof(opcode) intersect {OR} && binsof(aux_carry_out) && binsof(overflow);
        ignore_bins only_carry_on_and = binsof(opcode) intersect {AND} && binsof(aux_carry_out) && binsof(overflow);
        ignore_bins only_carry_on_not = binsof(opcode) intersect {NOT} && binsof(aux_carry_out) && binsof(overflow);
        ignore_bins only_carry_on_da = binsof(opcode) intersect {DA} && binsof(aux_carry_out) && binsof(overflow);
        ignore_bins no_ac_on_div = binsof(opcode) intersect {DIV} && binsof(aux_carry_out);
        ignore_bins no_ac_on_mul = binsof(opcode) intersect {MUL} && binsof(aux_carry_out);
      }
    endgroup

    covergroup multicycle_ops;
      consecutive_multicycle_ops: coverpoint txn.op_code {
        bins conseq_mul_div[] = (MUL, DIV => MUL, DIV);
      }
    endgroup

    function new(string name, uvm_component parent = null);
      super.new(name, parent);
      // txn = new;
      operations = new();
      outputs = new;
      multicycle_ops = new;
    endfunction

    virtual function void write(seq_item_mon t);
      // Sample All Covergroups
      txn = t;
      operations.sample();
      outputs.sample();
      multicycle_ops.sample();
    endfunction
  endclass


endpackage
