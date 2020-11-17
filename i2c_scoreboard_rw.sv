class i2c_scoreboard_rw extends uvm_scoreboard;
`uvm_component_utils(i2c_scoreboard_rw)

uvm_tlm_analysis_fifo #(logic) fifo31;

logic rwbit;

function new(string name = "i2c_scoreboard_data", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    fifo31 = new("fifo31",this);
endfunction : build_phase

task run_phase(uvm_phase phase);
 fork
	forever begin
		        fifo31.get(rwbit);
			if(rwbit == 1)
			`uvm_info("Mode", $sformatf("Read Mode"),UVM_MEDIUM)
			else if(rwbit == 0)
			`uvm_info("Mode", $sformatf("Write Mode"),UVM_MEDIUM)
		 end
 join_none
endtask : run_phase

endclass : i2c_scoreboard_rw
