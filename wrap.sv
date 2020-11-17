module wrap(intf.i2c_mod i);

i2c i2(i.PCLK,i.PRESET,i.PADDR,i.PSEL,i.PENABLE,i.PWRITE,i.PWDATA,i.PREADY,i.PRDATA,i.PSLVERR,i.Interrupt,i.SCL_drive,i.SCL_result,i.SDA_drive,i.SDA_result);


endmodule : wrap
