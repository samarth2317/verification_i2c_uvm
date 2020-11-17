class i2c_scoreboard_data extends uvm_scoreboard;
`uvm_component_utils(i2c_scoreboard_data)

uvm_tlm_analysis_fifo #(logic) fifo9;
uvm_tlm_analysis_fifo #(logic) fifo10;
uvm_tlm_analysis_fifo #(i2c_seq_item) fifo11;
uvm_tlm_analysis_fifo #(logic) fifo32;
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
    fifo9 = new("fifo9",this);
    fifo10 = new("fifo10",this);
    fifo11 = new("fifo11",this);
    fifo32 = new("fifo32",this);
    seq = i2c_seq_item::type_id::create("i2c_seq_item");
endfunction : build_phase

task run_phase(uvm_phase phase);
 fork
	forever begin
		 //fifo32.get(rwbit);
		 //if(rwbit == 0) begin
		 fifo9.get(start);
	 	 fifo10.get(cf);
                 fifo11.get(seq);
		if(seq.PSEL==1&&seq.PENABLE==1&&seq.PADDR==16)orig_data=seq.PWDATA;
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
		//end
	end
 join_none
endtask : run_phase

endclass : i2c_scoreboard_data
