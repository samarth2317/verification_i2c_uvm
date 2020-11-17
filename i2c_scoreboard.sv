class i2c_scoreboard_freq extends uvm_scoreboard;
`uvm_component_utils(i2c_scoreboard_freq)

uvm_tlm_analysis_fifo #(i2c_seq_item) fifo26;

uvm_analysis_port #(logic[31:0]) port11;

i2c_seq_item seq;
logic [31:0] IC, freq;

function new(string name = "i2c_scoreboard_freq", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    fifo26 = new("fifo26",this);
    port11 = new("port11",this);
    seq = i2c_seq_item::type_id::create("i2c_seq_item");
endfunction : build_phase

task run_phase(uvm_phase phase);
fork
forever begin
fifo26.get(seq);
if(seq.PADDR==4) begin 
	IC = seq.PWDATA; 
	case(IC[7:0])
		32'h21: freq = 24;
		32'h23: freq = 28;
		32'h24: freq = 32;
		32'h25: freq = 36;
		32'h26: freq = 40;
		32'h27: freq = 44;
		32'h28: freq = 48;
	endcase
 	`uvm_info("IC Value", $sformatf("IC value = %h",IC),UVM_MEDIUM)
	`uvm_info("Frequency", $sformatf("Frequency = %d",freq),UVM_MEDIUM)
end
port11.write(freq);
end
join_none
endtask : run_phase

endclass : i2c_scoreboard_freq

//-------------------------------------------------------------------------------------------------------

class i2c_scoreboard_tr extends uvm_scoreboard;
`uvm_component_utils(i2c_scoreboard_tr)

uvm_tlm_analysis_fifo #(i2c_seq_item) fifo28;

uvm_analysis_port #(logic) port12;

i2c_seq_item seq;

logic [7:0] temp;
logic trans=1;
function new(string name = "i2c_scoreboard_tr", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    fifo28 = new("fifo28",this);
    port12 = new("port12",this);
    seq = i2c_seq_item::type_id::create("i2c_seq_item");
endfunction : build_phase

task run_phase(uvm_phase phase);
fork
forever begin
fifo28.get(seq);
if(seq.PADDR==8&&seq.PENABLE==1&&seq.PWRITE==1) begin
	temp = seq.PWDATA;
	if(temp[4] == 1) trans = 1;
	else trans =0;
end
//port12.write(trans);
end
join_none
endtask : run_phase

endclass : i2c_scoreboard_tr

//-----------------------------------------------------------------------------------------------------------

/*
class i2c_scoreboard_nd extends uvm_scoreboard;
`uvm_component_utils(i2c_scoreboard_nd)

uvm_tlm_analysis_fifo #(logic) fifo20;
uvm_tlm_analysis_fifo #(logic) fifo21;

//uvm_analysis_port #(int) port8;
//uvm_analysis_port #(int) port9;

//logic active;
//logic start;
//logic cf;
//logic [5:0] count=0;
//int data=0;
//int register=0;

function new(string name = "i2c_scoreboard_nd", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    fifo20 = new("fifo20",this);
    fifo21 = new("fifo21",this);
    //port8 = new("port8",this);
    //port9 = new("port9",this);
endfunction : build_phase

task run_phase(uvm_phase phase);
 fork
	forever begin
		 fifo20.get(start);
		 fifo21.get(cf);
		if(start)begin
			active=1;
		end
		if(cf)count=count+1;
		if(cf==1&&count==10) begin
			data=32'hffff_ffe7; 
			register = 16;
		end
		else if(cf==1&&count==19) begin
			data=32'hffff_ffd0; 
			register = 8;
		end
		else begin
			data=0;
			register=0;
		end
		port8.write(data);
		port9.write(register);
	end
 join_none
endtask : run_phase

endclass : i2c_scoreboard_nd*/


