/*
=============
Sequence Item
=============
*/

`include "uvm_macros.svh"

package seq_item;
  import uvm_pkg::*;
  import opcode_pkg::*;
  class seq_item extends uvm_sequence_item;


    rand opcode_e op_code;
    rand logic [7:0] src1, src2, src3;
    rand logic srcAc, srcCy, bit_in;
    rand logic rst;

    `uvm_object_utils(seq_item)


    function new(string name = "seq_item");
      super.new(name);
    endfunction
  endclass

  class seq_item_mon extends seq_item;
    logic [7:0] des1, des2, des_acc, sub_result;

    logic desCy;
    logic desAc;
    logic desOv;

    `uvm_object_utils_begin(seq_item_mon)
      `uvm_field_enum(opcode_e, op_code, UVM_ALL_ON)
      `uvm_field_int(src1, UVM_HEX)
      `uvm_field_int(src2, UVM_HEX)
      `uvm_field_int(src3, UVM_HEX)
      `uvm_field_int(srcAc, UVM_BIN)
      `uvm_field_int(srcCy, UVM_BIN)
      `uvm_field_int(bit_in, UVM_BIN)
      `uvm_field_int(rst, UVM_BIN)
      `uvm_field_int(des1, UVM_HEX)
      `uvm_field_int(des2, UVM_HEX)
      `uvm_field_int(des_acc, UVM_HEX)
      `uvm_field_int(sub_result, UVM_HEX)
      `uvm_field_int(desCy, UVM_BIN)
      `uvm_field_int(desAc, UVM_BIN)
      `uvm_field_int(desOv, UVM_BIN)
    `uvm_object_utils_end

    function new(string name = "seq_item_mon");
      super.new(name);
    endfunction

  endclass

endpackage
