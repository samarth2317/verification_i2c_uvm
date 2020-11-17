class i2c_scoreboard_rs extends uvm_scoreboard;
`uvm_component_utils(i2c_scoreboard_rs)

uvm_tlm_analysis_fifo #(i2c_seq_item) fifo1;

uvm_analysis_port #(logic) port2;
uvm_analysis_port #(logic) port3;
uvm_analysis_port #(logic) port4;
uvm_analysis_port #(logic) port5;

i2c_seq_item seq;

logic last_scl, last_sda;
logic cr,dr,cf,df;


function new(string name = "i2c_scoreboard_rs", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    fifo1 = new("fifo1",this);
    port2 = new("port2",this);
    port3 = new("port3",this);
    port4 = new("port4",this);
    port5 = new("port5",this);
    seq = i2c_seq_item::type_id::create("i2c_seq_item");
endfunction : build_phase

task run_phase(uvm_phase phase);
 cr=0;dr=0;cf=0;df=0;
 fork
 forever begin
 fifo1.get(seq);
 if(seq.SCL_result==1&&last_scl==0) cr=1;  else cr=0;
 if(seq.SDA_result==1&&last_sda==0) dr=1;  else dr=0;
 if(seq.SCL_result==0&&last_scl==1) cf=1;  else cf=0;
 if(seq.SDA_result==0&&last_sda==1) df=1;  else df=0;
 last_scl=seq.SCL_result;
 last_sda=seq.SDA_result;
 port2.write(cr);
 port3.write(dr);
 port4.write(cf); 
 port5.write(df);
 end
 join_none
endtask : run_phase

endclass : i2c_scoreboard_rs


