/*
==================
* Environment
* Date 5/6/24
==================
*/

`include "uvm_macros.svh"

package main_env;
  import uvm_pkg::*;
  import agnt::*;
  import scb::*;
  import sub::*;
  // import base_vseqr::*;
  class main_env extends uvm_env;
    `uvm_component_utils(main_env);

    agnt _agnt;
    scb _scb;
    cov _cov;

    function new(string name = "main_env", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      _agnt = agnt::type_id::create("_agnt", this);
      _scb = scb::type_id::create("_scb", this);
      _cov = cov::type_id::create("_cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      _agnt._mon.mon2score.connect(_scb.ap_imp);
      _agnt._mon.mon2cov.connect(_cov.analysis_export);
    endfunction

  endclass
endpackage
