/*
==================
* Base Test
* Date 5/6/24
==================
*/

`include "uvm_macros.svh"
package main_test;
  import uvm_pkg::*;
  import main_env::*;
  import seq_pkg::*;

  class main_test extends uvm_test;
    `uvm_component_utils(main_test)

    main_env m_env;
    seq_lib  m_seq_lib;
    rst_seq  _rst_seq;
    // TODO: Cfg Object


    function new(string name = "main_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      m_env = main_env::type_id::create("m_env", this);
      _rst_seq = rst_seq::type_id::create("_rst_seq");
      m_seq_lib = seq_lib::type_id::create("m_seq_lib");
      m_seq_lib.selection_mode=UVM_SEQ_LIB_RAND;
      // TODO: Build cfg object.

      // TODO: Give cfg object to everyone down in the hierarchy.
    endfunction



    virtual function void end_of_elaboration_phase(uvm_phase phase);
      uvm_top.print_topology();
      m_seq_lib.print();
    endfunction

    virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(this);
      _rst_seq.start(m_env._agnt.seqr);
      m_seq_lib.start(m_env._agnt.seqr);
      phase.drop_objection(this);

    endtask

  endclass

endpackage
