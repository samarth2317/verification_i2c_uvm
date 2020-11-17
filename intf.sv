
interface intf;

logic PCLK;
logic PRESET;
logic [4:0] PADDR;
logic PSEL;
logic PENABLE;
logic PWRITE;
logic [31:0] PWDATA;
logic PREADY;
logic [31:0] PRDATA;
logic PSLVERR;
logic Interrupt;
logic SCL_drive;
logic SCL_result;
logic SDA_drive;
logic SDA_result;

modport i2c_mod(input PCLK, input PRESET, input PADDR, input PSEL, input PENABLE, input PWRITE, input PWDATA, output PREADY, output PRDATA, output PSLVERR, 
	output Interrupt, output SCL_drive, input SCL_result, output SDA_drive, input SDA_result);

endinterface: intf

interface intf2;

logic test_SCL;
logic test_SDA;

modport i2c_mod2(output test_SCL, output test_SDA);

endinterface: intf2
