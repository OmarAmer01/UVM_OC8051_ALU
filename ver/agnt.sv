/*
=================================
* Controller Interface Agent.
* Date: 5/6/24
=================================
*/

`include "uvm_macros.svh"
package agnt;
  import uvm_pkg::*;

  import seq_item::*;
  import drv::*;
  import mon::*;

  class agnt extends uvm_agent;
    `uvm_component_utils(agnt)

    drv _drv;
    mon _mon;
    uvm_sequencer #(seq_item) seqr;

    function new(string name = "agnt", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      seqr = uvm_sequencer#(seq_item)::type_id::create("seqr", this);
      _drv  = drv::type_id::create("_drv", this);
      _mon  = mon::type_id::create("_mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      _drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction

  endclass
endpackage
