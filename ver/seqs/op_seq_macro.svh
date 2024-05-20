`define RAND_SEQ_CLASS(CLASS_NAME, CONSTRAINT) \
class CLASS_NAME extends uvm_sequence #(seq_item); \
  `uvm_object_utils(CLASS_NAME) \
  function new(string name = "CLASS_NAME"); \
    super.new(name); \
  endfunction \
  task body(); \
    seq_item txn_to_send = new; \
    start_item(txn_to_send); \
    assert (txn_to_send.randomize() with {CONSTRAINT;}); \
    finish_item(txn_to_send); \
  endtask \
endclass
