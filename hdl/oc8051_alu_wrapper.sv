/*
  Wrapper to use the interface
*/

module oc8051_alu_wrapper (
    alu_if intf
);

  oc8051_alu alu(
      .clk(intf.clk),
      .rst(intf.rst),
      .op_code(intf.op_code),
      .src1(intf.src1),
      .src2(intf.src2),
      .src3(intf.src3),
      .srcCy(intf.srcCy),
      .srcAc(intf.srcAc),
      .bit_in(intf.bit_in),
      .des1(intf.des1),
      .des2(intf.des2),
      .des_acc(intf.des_acc),
      .desCy(intf.desCy),
      .desAc(intf.desAc),
      .desOv(intf.desOv),
      .sub_result(intf.sub_result)
  );

endmodule
