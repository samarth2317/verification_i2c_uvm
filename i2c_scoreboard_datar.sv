class i2c_scoreboard_datar extends uvm_scoreboard;
`uvm_component_utils(i2c_scoreboard_datar)

uvm_tlm_analysis_fifo #(logic) fifo33;
uvm_tlm_analysis_fifo #(logic) fifo34;
uvm_tlm_analysis_fifo #(i2c_seq_item) fifo35;
uvm_tlm_analysis_fifo #(logic) fifo36;

i2c_seq_item seq;
logic rwbit;
logic active;
logic start;
logic cf;
logic [4:0] count=0;
logic temp;
logic [7:0] data=0;
logic [7:0] orig_data=0;

function new(string name = "i2c_scoreboard_data", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    fifo33 = new("fifo33",this);
    fifo34 = new("fifo34",this);
    fifo35 = new("fifo35",this);
    fifo36 = new("fifo36",this);
    seq = i2c_seq_item::type_id::create("i2c_seq_item");
endfunction : build_phase

task run_phase(uvm_phase phase);
 fork
	forever begin
		 fifo36.get(rwbit);
		if(rwbit == 1) begin
		 fifo33.get(start);
	 	 fifo34.get(cf);
                 fifo35.get(seq);
		if(seq.PSEL==1&&seq.PENABLE==1&&seq.PADDR==16)orig_data=seq.PRDATA;
		if(start)begin
			active=1;
		end
		if(cf)count=count+1;
		if(count>1&&count<10) begin
			if(cf) begin
				temp = seq.SDA_result;				
				data = data + temp;
				if(count<9)data = data << 1;
			end
		end
		if(count==10) begin
			if(orig_data==data) `uvm_info("Data", $sformatf("Data is correct"),UVM_MEDIUM)
			else `uvm_error("Data", $sformatf("Data is incorrect"))
                        count=1;
		end
		end
	end
 join_none
endtask : run_phase

endclass : i2c_scoreboard_datar
