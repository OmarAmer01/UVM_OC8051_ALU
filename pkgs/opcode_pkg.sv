/*
===============
Opcodes Pacakge
Date: 5/17/24
===============
*/

`include "./hdl/oc8051_defines.v"

package opcode_pkg;

  typedef enum logic [3:0] {
    NOP = `OC8051_ALU_NOP,
    ADD = `OC8051_ALU_ADD,
    SUB = `OC8051_ALU_SUB,
    MUL = `OC8051_ALU_MUL,
    DIV = `OC8051_ALU_DIV,
    DA  = `OC8051_ALU_DA,
    NOT = `OC8051_ALU_NOT,
    AND = `OC8051_ALU_AND,
    XOR = `OC8051_ALU_XOR,
    OR  = `OC8051_ALU_OR,
    RL  = `OC8051_ALU_RL,
    RLC = `OC8051_ALU_RLC,
    RR  = `OC8051_ALU_RR,
    RRC = `OC8051_ALU_RRC,
    INC = `OC8051_ALU_INC,
    XCH = `OC8051_ALU_XCH
  } opcode_e;
endpackage
