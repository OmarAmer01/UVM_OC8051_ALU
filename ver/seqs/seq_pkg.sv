/*
Sequence Package
*/

`include "uvm_macros.svh"
`include "op_seq_macro.svh"
package seq_pkg;
  import uvm_pkg::*;
  import seq_item::*;
  import opcode_pkg::*;


  `RAND_SEQ_CLASS(rst_seq, txn_to_send.rst == 1)
  `RAND_SEQ_CLASS(nop_seq, (txn_to_send.rst == 0) && (txn_to_send.op_code == NOP))
  `RAND_SEQ_CLASS(add_seq, (txn_to_send.rst == 0) && (txn_to_send.op_code == ADD))
  `RAND_SEQ_CLASS(sub_seq, (txn_to_send.rst == 0) && (txn_to_send.op_code == SUB))
  `RAND_SEQ_CLASS(mul_seq, (txn_to_send.rst == 0) && (txn_to_send.op_code == MUL))
  `RAND_SEQ_CLASS(div_seq, (txn_to_send.rst == 0) && (txn_to_send.op_code == DIV))
  `RAND_SEQ_CLASS(da_seq,  (txn_to_send.rst == 0) && (txn_to_send.op_code == DA))
  `RAND_SEQ_CLASS(not_seq, (txn_to_send.rst == 0) && (txn_to_send.op_code == NOT))
  `RAND_SEQ_CLASS(and_seq, (txn_to_send.rst == 0) && (txn_to_send.op_code == AND))
  `RAND_SEQ_CLASS(xor_seq, (txn_to_send.rst == 0) && (txn_to_send.op_code == XOR))
  `RAND_SEQ_CLASS(or_seq,  (txn_to_send.rst == 0) && (txn_to_send.op_code == OR))
  `RAND_SEQ_CLASS(rl_seq,  (txn_to_send.rst == 0) && (txn_to_send.op_code == RL))
  `RAND_SEQ_CLASS(rlc_seq, (txn_to_send.rst == 0) && (txn_to_send.op_code == RLC))
  `RAND_SEQ_CLASS(rr_seq,  (txn_to_send.rst == 0) && (txn_to_send.op_code == RR))
  `RAND_SEQ_CLASS(rrc_seq, (txn_to_send.rst == 0) && (txn_to_send.op_code == RRC))
  `RAND_SEQ_CLASS(inc_seq, (txn_to_send.rst == 0) && (txn_to_send.op_code == INC))
  `RAND_SEQ_CLASS(xch_seq, (txn_to_send.rst == 0) && (txn_to_send.op_code == XCH))

  class seq_lib extends uvm_sequence_library#(seq_item);
    `uvm_object_utils(seq_lib)
    `uvm_sequence_library_utils(seq_lib)
    nop_seq _nop_seq;
    function new(string name="seq_lib");
      super.new(name);

      add_typewide_sequence(nop_seq::get_type());
      add_typewide_sequence(add_seq::get_type());
      add_typewide_sequence(sub_seq::get_type());
      add_typewide_sequence(mul_seq::get_type());
      add_typewide_sequence(div_seq::get_type());
      add_typewide_sequence(da_seq::get_type());
      add_typewide_sequence(not_seq::get_type());
      add_typewide_sequence(and_seq::get_type());
      add_typewide_sequence(xor_seq::get_type());
      add_typewide_sequence(or_seq::get_type());
      add_typewide_sequence(rl_seq::get_type());
      add_typewide_sequence(rlc_seq::get_type());
      add_typewide_sequence(rr_seq::get_type());
      add_typewide_sequence(rrc_seq::get_type());
      add_typewide_sequence(inc_seq::get_type());
      add_typewide_sequence(xch_seq::get_type());

      min_random_count = 15;
      max_random_count = 30;
      sequence_count = 6000;
      init_sequence_library();
    endfunction
  endclass

endpackage
