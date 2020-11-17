`timescale 1ns/10ps

`include "intf.sv"
`include "i2c_defs.sv"
`include "i2c.sv"
`include "wrap.sv"

module top;
import uvm_pkg::*;
`include "pkg.sv"

intf it();
intf2 it2();

initial begin
it.PCLK=1;
it.PRESET=1;
#20 it.PRESET=0;
end

initial begin
 repeat(500000000*2) begin
  #5 it.PCLK=~it.PCLK;
 end
 $display("Ran out of clocks...............");
 $finish;
end

initial begin
uvm_config_db #(virtual intf)::set(null,"interface","intf",it);
uvm_config_db #(virtual intf2)::set(null,"interface","intf2",it2);
run_test("i2c_test");
end

wrap wr (it.i2c_mod);

always@(*) begin
 it.SCL_result = it2.test_SCL & it.SCL_drive; 
 it.SDA_result = it2.test_SDA & it.SDA_drive;
end

initial begin
  $dumpfile("i2c.vpd");
  $dumpvars(0,top);
end

endmodule:top
