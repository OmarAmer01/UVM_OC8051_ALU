/*
=====================================
ALU Interface

Date: 5/17/24
=====================================
*/

import opcode_pkg::*;
interface alu_if (
    input logic clk
);

  logic rst;

  opcode_e op_code;
  logic [7:0] src1, src2, src3;

  logic srcCy;
  logic srcAc;
  logic bit_in;

  logic [7:0] des1, des2, des_acc, sub_result;

  logic desCy;
  logic desAc;
  logic desOv;

  clocking drv @(posedge clk);
    default input #1step output negedge;
    output src1, src2, src3, op_code, srcCy, srcAc, bit_in, rst;
  endclocking

  clocking mon @(posedge clk);
    default input #1step output negedge;
    input
    rst,
    op_code,
    src1,
    src2,
    src3,
    srcCy,
    srcAc,
    bit_in,
    des1,
    des2,
    des_acc,
    desCy,
    desAc,
    desOv,
    sub_result;
  endclocking


  task automatic reset_alu();
    rst = 0;
    @(drv);
    drv.rst <= 1;
    @(drv);
    drv.rst <= 0;
  endtask

  task automatic init_inputs();
    // Init inputs at time 0
    src1 = '0;
    src2 = 0;
    src3 = 0;
    op_code = NOP;
    srcCy = 0;
    srcAc = 0;
    bit_in = 0;
    rst = 0;
  endtask

endinterface
