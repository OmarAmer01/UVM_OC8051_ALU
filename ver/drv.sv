/*
=================================
* Driver.
* Date: 5/6/24
=================================
*/

`include "uvm_macros.svh"

package drv;
  import uvm_pkg::*;
  import seq_item::*;
  import opcode_pkg::*;
  class drv extends uvm_driver #(seq_item);
    `uvm_component_utils(drv)

    virtual alu_if vif;

    function new(string name = "drv", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Get vif handle
      if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_if", vif)) begin
        `uvm_fatal("DRV", "Could not get handle to controller virtual interface");
      end
    endfunction


    virtual task run_phase(uvm_phase phase);
      seq_item txn_to_drive;
      super.run_phase(phase);
      vif.init_inputs();
      forever begin
        seq_item_port.get_next_item(txn_to_drive);
        drive_txn(txn_to_drive);
        seq_item_port.item_done();
      end
    endtask

    task drive_txn(seq_item txn);
      if (txn.rst) begin
        vif.reset_alu();
        vif.op_code <= NOP;
        vif.src1 <= 8'hff;
        vif.src2 <= 8'hff;
        vif.src3 <= 8'hff;
        vif.srcCy <= 1'b1;
        vif.srcAc <= 1'b1;
        vif.bit_in <= 1'b1;
      end else begin

        vif.op_code <= txn.op_code;
        vif.src1 <= txn.src1;
        vif.src2 <= txn.src2;
        vif.src3 <= txn.src3;
        vif.srcCy <= txn.srcCy;
        vif.srcAc <= txn.srcAc;
        vif.bit_in <= txn.bit_in;
      end
      if ((txn.op_code == MUL) | (txn.op_code == DIV)) repeat (4) @(vif.drv);
      else @(vif.drv);

    endtask

  endclass
endpackage
