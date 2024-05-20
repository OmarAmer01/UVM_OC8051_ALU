/*
=================================
* Monitor.
* Date: 5/6/24
=================================
*/

`include "uvm_macros.svh"

package mon;
  import uvm_pkg::*;
  import seq_item::*;
  import opcode_pkg::*;
  class mon extends uvm_monitor;
    `uvm_component_utils(mon)

    virtual alu_if vif;

    uvm_analysis_port #(seq_item_mon) mon2score;
    uvm_analysis_port #(seq_item_mon) mon2cov;

    function new(string name = "mon", uvm_component parent = null);
      super.new(name, parent);
      mon2score = new("mon2score", this);
      mon2cov = new("mon2cov", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);


      // Get vif handle
      if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_if", vif)) begin
        `uvm_fatal("MON", "Failed to aquire vif handle.")
      end
    endfunction

    virtual task run_phase(uvm_phase phase);
      seq_item_mon txn;
      forever begin
        @(vif.mon);
        txn = new;
        txn.rst = vif.rst;
        txn.op_code = opcode_e'(vif.op_code);
        txn.src1 = vif.src1;
        txn.src2 = vif.src2;
        txn.src3 = vif.src3;
        txn.srcCy = vif.srcCy;
        txn.srcAc = vif.srcAc;
        txn.bit_in = vif.bit_in;
        txn.des1 = vif.des1;
        txn.des2 = vif.des2;
        txn.des_acc = vif.des_acc;
        txn.desCy = vif.desCy;
        txn.desAc = vif.desAc;
        txn.desOv = vif.desOv;
        txn.sub_result = vif.sub_result;

        mon2score.write(txn);
        mon2cov.write(txn);
      end
    endtask

  endclass
endpackage
