class i2c_scoreboard_add extends uvm_scoreboard;
`uvm_component_utils(i2c_scoreboard_add)

uvm_tlm_analysis_fifo #(logic) fifo29;
uvm_tlm_analysis_fifo #(i2c_seq_item) fifo30;

uvm_analysis_port #(logic) port12;

i2c_seq_item seq;
logic start;
integer count=0,i;
logic temp;
logic [7:0] data=0;
logic [7:0] orig_data=0;
logic scl_old;
logic scl_new;

function new(string name = "i2c_scoreboard_data", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    fifo29 = new("fifo29",this);
    fifo30 = new("fifo30",this);
    port12 = new("port12",this);
    seq = i2c_seq_item::type_id::create("i2c_seq_item");
endfunction : build_phase

task run_phase(uvm_phase phase);
 fork
	forever begin
		 fifo29.get(start);
		 if(start)begin
			fifo30.get(seq);
			scl_old = seq.SCL_drive;
			fifo30.get(seq);
			scl_new = seq.SCL_drive;
			for(i=0;i<8;i++)begin
			if(scl_old == 0 && scl_new == 1)begin
				fifo30.get(seq);
				orig_data=seq.PWDATA;
				temp = seq.SDA_drive;				
				data = data + temp;
				if(count<9)begin
					data = data << 1;
					count = count + 1;
				end
			end
			count = 0;
			$display("%b",orig_data);
			if(orig_data==data) 
			`uvm_info("Data", $sformatf("Address is correct"),UVM_MEDIUM)
			else 
			`uvm_error("Data", $sformatf("Address is incorrect"))
			port12.write(data[0]);
		 end
			
	end
 join_none
endtask : run_phase

endclass : i2c_scoreboard_add
