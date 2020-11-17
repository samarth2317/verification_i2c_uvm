class i2c_scoreboard_stop extends uvm_scoreboard;
`uvm_component_utils(i2c_scoreboard_stop)

uvm_tlm_analysis_fifo #(logic) fifo7;
uvm_tlm_analysis_fifo #(i2c_seq_item) fifo8;

uvm_analysis_port #(logic) port10;

i2c_seq_item seq;
logic dr;
logic stop;

function new(string name = "i2c_scoreboard_stop", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    fifo7 = new("fifo7",this);
    fifo8 = new("fifo8",this);
    port10 = new("port10",this);
    seq = i2c_seq_item::type_id::create("i2c_seq_item");
endfunction : build_phase

task run_phase(uvm_phase phase);
 fork
	forever begin
		 fifo7.get(dr);
	 	 fifo8.get(seq);
		 if(dr==1 && seq.SCL_result==1) begin
			`uvm_info("Stop", $sformatf("Stop is Detected"),UVM_MEDIUM)
			stop = 1;
		 end
		 else begin
			stop = 0;
		end
		port10.write(stop);
	end
 join_none
endtask : run_phase

endclass : i2c_scoreboard_stop
