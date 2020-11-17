typedef enum logic [7:0] {trans,rec,writeReg,waitclk,waitNotBusy,waitActive, writestop,dummyread,sendData,readData} good;

class i2c_seq_item extends uvm_sequence_item;
`uvm_object_utils(i2c_seq_item)
   
// logic PRESET;
 logic [4:0] PADDR;
 logic PSEL;
 logic PENABLE;
 logic PWRITE;
 logic [31:0] PWDATA;
// logic SCL_result;
// logic SDA_result;

//logic PCLK;
logic PRESET;
//logic [4:0] PADDR;
//logic PSEL;
//logic PENABLE;
//logic PWRITE;
//logic [31:0] PWDATA;
logic PREADY;
logic [31:0] PRDATA;
logic PSLVERR;
logic Interrupt;
logic SCL_drive;
logic SCL_result;
logic SDA_drive;
logic SDA_result;

good god;
logic [31:0] addr,data;
int wtime;

function new(string name = "i2c_seq_item");
  super.new(name);
endfunction

endclass: i2c_seq_item
