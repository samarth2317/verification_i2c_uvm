class i2c_scoreboard_start extends uvm_scoreboard;
`uvm_component_utils(i2c_scoreboard_start)

uvm_tlm_analysis_fifo #(logic) fifo2;
uvm_tlm_analysis_fifo #(logic) fifo3;
uvm_tlm_analysis_fifo #(logic) fifo4;
uvm_tlm_analysis_fifo #(logic) fifo5;
uvm_tlm_analysis_fifo #(logic) fifo28;
uvm_tlm_analysis_fifo #(i2c_seq_item) fifo6;

uvm_analysis_port #(logic) port6;

i2c_seq_item seq;
logic cr,dr,df,cf;
logic start;
logic stopflag;
logic flagfirst=0;

enum logic[1:0] {first,second,third,fourth} statevar;

function new(string name = "i2c_scoreboard_start", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    fifo2 = new("fifo2",this);
    fifo3 = new("fifo3",this);
    fifo4 = new("fifo4",this);
    fifo5 = new("fifo5",this);
    fifo6 = new("fifo6",this);
    fifo28 = new("fifo28",this);
    port6 = new("port6",this);
    seq = i2c_seq_item::type_id::create("i2c_seq_item");
endfunction : build_phase

task run_phase(uvm_phase phase);
 fork
	forever begin
		 fifo2.get(cr);
		 fifo3.get(dr);
		 fifo4.get(cf);
		 fifo5.get(df);
	 	 fifo6.get(seq);
		 fifo28.get(stopflag);
		 if(df == 1 && seq.SCL_result == 1 /*&& (stopflag == 1 || flagfirst == 0)*/) begin
			`uvm_info("Start", $sformatf("Start Detected"),UVM_MEDIUM)
			start = 1;
			flagfirst = 1;
		 end
		 else 
		start = 0;
		port6.write(start);
		//if(stopflag == 1 && start == 0)
			//`uvm_error("Start", $sformatf("Start was expected"))
	end
 join_none
endtask : run_phase

endclass : i2c_scoreboard_start

