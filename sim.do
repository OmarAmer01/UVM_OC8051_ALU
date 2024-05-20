add wave -position end  sim:/tb_top/dut/intf/clk
add wave -position end  sim:/tb_top/dut/intf/rst
add wave -position end  sim:/tb_top/dut/intf/op_code
add wave -position end  sim:/tb_top/dut/intf/src1
add wave -position end  sim:/tb_top/dut/intf/src2
add wave -position end  sim:/tb_top/dut/intf/src3
add wave -position end  sim:/tb_top/dut/intf/srcCy
add wave -position end  sim:/tb_top/dut/intf/srcAc
add wave -position end  sim:/tb_top/dut/intf/bit_in
add wave -position end  sim:/tb_top/dut/intf/des1
add wave -position end  sim:/tb_top/dut/intf/des2
add wave -position end  sim:/tb_top/dut/intf/des_acc
add wave -position end  sim:/tb_top/dut/intf/sub_result
add wave -position end  sim:/tb_top/dut/intf/desCy
add wave -position end  sim:/tb_top/dut/intf/desAc
add wave -position end  sim:/tb_top/dut/intf/desOv

coverage save -onexit cov_db.ucdb
log -r /*
run -all
