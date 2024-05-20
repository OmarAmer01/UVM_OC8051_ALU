/*
  Operation Checkers.
*/

`include "uvm_macros.svh"

package checker_functions_pkg;
  import seq_item::*;
  import uvm_pkg::*;
  function automatic void check_nop(seq_item_mon txn);
    `uvm_info("PASS NOP", "NOP. ", UVM_HIGH)
  endfunction

  function automatic bit has_overflown(byte a, byte b, byte res);
    return (a[7] == b[7]) && (a[7] != res[7]);
  endfunction

  function automatic void check_add(seq_item_mon txn);

    bit comp = {txn.desCy, txn.des_acc} == 9'(txn.src1 + txn.src2 + txn.srcCy);
    if (comp) `uvm_info("PASS ADD", "ADDITION", UVM_HIGH)
    else begin : test_add
      txn.print();
      `uvm_fatal("FAIL ADD", $sformatf(
                 "ADDITION: Found %h Expected %h",
                 {
                   txn.desCy, txn.src1 + txn.src2 + txn.srcCy
                 },
                 {
                   txn.desCy, txn.des_acc
                 }
                 ))
    end

    if (has_overflown(txn.src1, txn.src2, txn.des_acc) != txn.desOv) begin : test_ovf
      txn.print();
      `uvm_fatal("FAIL ADD OVERFLOW", "OVERFLOW BAD")
    end
    if (((txn.src1[3:0] + txn.src2[3:0] + txn.srcCy) > 5'h0f) != txn.desAc) begin
      txn.print();
      `uvm_fatal("FAIL ADD AUX Carry", $sformatf("FOUND %b", txn.desOv))
    end
  endfunction

  function automatic void check_sub(seq_item_mon txn);
    bit ovf = (txn.src1[7] != txn.src2[7]) && (txn.des_acc[7] == txn.src2[7]);
    bit aux;
    if ((txn.src1[3:0] == txn.src2[3:0])) begin
      if (txn.srcCy) aux = 1;
      else aux = 0;
    end else if (txn.src1[3:0] == 0) aux = 1;
    else aux = 4'(txn.src1 - txn.srcCy) < txn.src2[3:0];  // Risky truncation
    if (9'(txn.src1 - txn.src2 - txn.srcCy) != {txn.desCy, txn.des_acc}) begin
      txn.print();
      `uvm_fatal("FAIL SUB", $sformatf("FOUND %h Expected %h", txn.des_acc,
                                       (txn.src1 - txn.src2 - txn.srcCy)))
    end else `uvm_info("PASS SUB", "SUBTRACTION", UVM_HIGH)

    if (aux != txn.desAc) begin
      txn.print();
      `uvm_fatal("FAIL SUB AUX", "AUX BAD")

    end

    if (ovf != txn.desOv) begin : test_ovf
      txn.print();
      `uvm_fatal("FAIL SUB OVERFLOW", "OVERFLOW BAD")
    end

  endfunction

  function automatic void check_mul(seq_item_mon txn);
    bit ovf = (txn.src1 * txn.src2) > 16'hff;
    if ((txn.src1 * txn.src2) != {txn.des_acc, txn.des2}) begin
      txn.print();
      `uvm_fatal("FAIL MUL", $sformatf("FOUND %h Expected %h", {txn.des_acc, txn.des2},
                                       txn.src1 * txn.src2))

    end else `uvm_info("PASS MUL", "MULTIPLICATION", UVM_HIGH)

    if (ovf != txn.desOv) begin
      txn.print();
      `uvm_fatal("FAIL MUL OVF", "BAD OVF")
    end
  endfunction

  function automatic void check_div(seq_item_mon txn);
    // rem = desac
    // quo = des2
    logic [7:0] rem = (txn.src1) % (txn.src2);
    logic [7:0] quo = (txn.src1) / (txn.src2);
    if ((txn.src2 == 0) && ~txn.desOv) begin
      txn.print();
      `uvm_fatal("FAIL OVF DIV", "BAD OVF")
    end

    if (quo != txn.des2) begin
      txn.print();
      `uvm_fatal("FAIL QUOTIENT", $sformatf("FOUND %h Expected %h", txn.des2, quo))
    end

    if (rem != txn.des_acc) begin
      txn.print();
      `uvm_fatal("FAIL REMAINDER", $sformatf("FOUND %h Expected %h", txn.des_acc, rem))
    end

    `uvm_info("PASS DIV", "DIVISION", UVM_HIGH)
  endfunction

  function automatic void check_da(seq_item_mon txn);
    logic [3:0] lo, hi;
    logic [8:0] expected = txn.src1;
    bit add_six = 0;
    bit exp_carry = 0;
    lo = txn.src1[3:0];
    hi = txn.src1[7:4];

    if (txn.srcAc || (lo > 9)) begin
      expected += 6;
      add_six = (5'(lo) + 5'(6)) > 5'h0f;
    end

    if (txn.srcCy || add_six || (hi > 9)) expected += 8'h60;

    exp_carry = expected[7:0] > 8'h99;
    if (exp_carry != txn.desCy) begin
      txn.print();
      `uvm_error("expected_2_fail FAIL DA CARRY", "BAD CARRY")
    end
    if (expected[7:0] != txn.des_acc) begin
      txn.print();
      `uvm_fatal("FAIL DA", $sformatf("FOUND %h EXPECTED %h", txn.des_acc, expected[7:0]))
    end else `uvm_info("PASS DA", "DECIMAL ADJUST", UVM_HIGH)
  endfunction

  function automatic void check_not(seq_item_mon txn);

    if (~txn.srcCy != txn.desCy) begin
      txn.print();
      `uvm_fatal("FAIL NOT CARRY", $sformatf("FOUND %h EXP %h", txn.desCy, ~txn.srcCy));
    end

    if (~txn.src1 != txn.des_acc) begin
      txn.print();
      `uvm_fatal("FAIL NOT", $sformatf("FOUND %h EXP %h", txn.des_acc, ~txn.src1));
    end else `uvm_info("PASS NOT", "NOT", UVM_HIGH)

  endfunction

  function automatic void check_and(seq_item_mon txn);
    logic [7:0] expected = txn.src1 & txn.src2;
    bit exp_carry = (txn.srcCy & txn.bit_in);
    if (exp_carry != txn.desCy) begin
      txn.print();
      `uvm_fatal("FAIL AND CARRY", $sformatf("FOUND %h EXP %h", txn.desCy, exp_carry));
    end

    if (expected != txn.des_acc) begin
      txn.print();
      `uvm_fatal("FAIL AND", $sformatf("FOUND %h EXP %h", txn.des_acc, expected));
    end else `uvm_info("PASS AND", "AND", UVM_HIGH)

  endfunction

  function automatic void check_xor(seq_item_mon txn);
    bit exp_carry = txn.bit_in ^ txn.srcCy;
    logic [7:0] expected = txn.src1 ^ txn.src2;
    if (exp_carry != txn.desCy) begin
      txn.print();
      `uvm_fatal("FAIL XOR CARRY", $sformatf("FOUND %h EXP %h", txn.desCy, exp_carry));
    end

    if (expected != txn.des_acc) begin
      txn.print();
      `uvm_fatal("FAIL XOR", $sformatf("FOUND %h EXP %h", txn.des_acc, expected));
    end else `uvm_info("PASS XOR", "XOR", UVM_HIGH)

  endfunction

  function automatic void check_or(seq_item_mon txn);
    bit exp_carry = txn.bit_in | txn.srcCy;
    logic [7:0] expected = txn.src1 | txn.src2;
    if (exp_carry != txn.desCy) begin
      txn.print();
      `uvm_fatal("FAIL OR CARRY", $sformatf("FOUND %h EXP %h", txn.desCy, exp_carry));
    end

    if (expected != txn.des_acc) begin
      txn.print();
      `uvm_fatal("FAIL OR", $sformatf("FOUND %h EXP %h", txn.des_acc, expected));
    end else `uvm_info("PASS OR", "OR", UVM_HIGH)

  endfunction

  function automatic void check_rl(seq_item_mon txn);
    logic [7:0] expected = (txn.src1 << 1) | txn.src1[7];

    if (expected != txn.des_acc) begin
      txn.print();
      `uvm_fatal("FAIL RL", $sformatf("FOUND %h EXP %h", txn.des_acc, expected));
    end else `uvm_info("PASS RL", "RL", UVM_HIGH)
  endfunction

  function automatic void check_rlc(seq_item_mon txn);
    logic [7:0] expected = (txn.src1 << 1) | txn.srcCy;
    logic exp_carry = txn.src1[7];

    if (exp_carry != txn.desCy) begin
      txn.print();
      `uvm_fatal("FAIL RLC CARRY", $sformatf("FOUND %h EXP %h", txn.desCy, exp_carry));
    end


    if (expected != txn.des_acc) begin
      txn.print();
      `uvm_fatal("FAIL RLC", $sformatf("FOUND %h EXP %h", txn.des_acc, expected));
    end else `uvm_info("PASS RLC", "RLC", UVM_HIGH)
  endfunction

  function automatic void check_rr(seq_item_mon txn);
    logic [7:0] expected = (txn.src1 >> 1) | (txn.src1[0] << 7);

    if (expected != txn.des_acc) begin
      txn.print();
      `uvm_fatal("FAIL RR", $sformatf("FOUND %h EXP %h", txn.des_acc, expected));
    end else `uvm_info("PASS RR", "RR", UVM_HIGH)
  endfunction

  function automatic void check_rrc(seq_item_mon txn);
    logic [7:0] expected = (txn.src1 >> 1) | (txn.srcCy << 7);
    logic exp_carry = txn.src1[0];

    if (exp_carry != txn.desCy) begin
      txn.print();
      `uvm_fatal("FAIL RRC CARRY", $sformatf("FOUND %h EXP %h", txn.desCy, exp_carry));
    end

    if (expected != txn.des_acc) begin
      txn.print();
      `uvm_fatal("FAIL RRC", $sformatf("FOUND %h EXP %h", txn.des_acc, expected));
    end else `uvm_info("PASS RRC", "RRC", UVM_HIGH)
  endfunction

  function automatic void check_inc(seq_item_mon txn);

    // inc or dec based on srcCy
    if (~txn.srcCy) begin
      if ((txn.src1 + 8'h1) != txn.des_acc) begin
        txn.print();
        `uvm_fatal("FAIL INC", $sformatf("FOUND %h EXP %h", txn.des_acc, txn.src1 + 8'h1));
      end else `uvm_info("PASS INC", "INC", UVM_HIGH)
    end else begin
      if ((txn.src1 - 8'h1) != txn.des_acc) begin
        txn.print();
        `uvm_fatal("FAIL DEC", $sformatf("FOUND %h EXP %h", txn.des_acc, ~txn.src1));
      end else `uvm_info("PASS DEC", "DEC", UVM_HIGH)
    end
  endfunction

  function automatic void check_xch(seq_item_mon txn);
    logic [7:0] xp1, xp2;
    if (~txn.srcCy) begin : xchg_nibbles
      // xp1 = (txn.src2 >> 4) | (txn.src1 << 4);
      // xp2 = (txn.src1 >> 4) | (txn.src2 << 4);
      txn.des1 = {txn.src1[7:4], txn.src2[3:0]};
      txn.des2 = {txn.src2[7:4], txn.src1[3:0]};
      if ((xp1 != txn.des1) | (xp2 != txn.des2)) begin
        txn.print();
        `uvm_fatal("FAIL XCHG NIBBLE", $sformatf("FOUND S1 %h S2 %h EXPECTED %h %h", txn.des1,
                                                 txn.des2, xp1, xp2))
      end else begin
        `uvm_info("PASS XCHG NIBBLE", "XCHG NIBBLE", UVM_HIGH)
      end
    end else begin : xchg_bytes
      xp1 = txn.src2;
      xp2 = txn.src1;
      if ((xp1 != txn.des1) | (xp2 != txn.des2)) begin
        txn.print();
        `uvm_fatal("FAIL XCHG BYTE", $sformatf("FOUND S1 %h S2 %h EXPECTED %h %h", txn.des1,
                                               txn.des2, xp1, xp2))
      end else begin
        `uvm_info("PASS XCHG BYTE", "XCHG BYTE", UVM_HIGH)
      end
    end
  endfunction


endpackage
