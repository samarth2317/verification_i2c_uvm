class i2c_scoreboard_dv extends uvm_scoreboard;
`uvm_component_utils(i2c_scoreboard_dv)

uvm_tlm_analysis_fifo #(logic) fifo16;
uvm_tlm_analysis_fifo #(logic) fifo17;
uvm_tlm_analysis_fifo #(logic) fifo18;
uvm_tlm_analysis_fifo #(i2c_seq_item) fifo19;
uvm_tlm_analysis_fifo #(logic) fifo25;

i2c_seq_item seq;
logic active;
logic start;
logic cr,cf;
logic [8:0] count1=0;
logic [8:0] count2=0;
logic data1=0;
logic data2=0;
logic stop;

function new(string name = "i2c_scoreboard_dv", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    fifo16 = new("fifo16",this);
    fifo17 = new("fifo17",this);
    fifo18 = new("fifo18",this);
    fifo19 = new("fifo19",this);
    fifo25 = new("fifo25",this);
    seq = i2c_seq_item::type_id::create("i2c_seq_item");
endfunction : build_phase

task run_phase(uvm_phase phase);
 fork
	forever begin
		 fifo16.get(start);
		 fifo17.get(cf);
	 	 fifo18.get(cr);
                 fifo19.get(seq);
	         fifo25.get(stop);
		/*if(start)begin
			active=1;
		end*/
		if(stop) begin
			count1=0;
			count2=0;
		end
		if(cr)count1=count1+1;
		if(cf)count2=count2+1;
		//if(count1==9)count1=0;
		//if(count2==10)count2=1;
		if(count2>0) begin
			if(cr)data1=seq.SDA_result;
			if(cf)begin
				data2=seq.SDA_result;
				if(data1!=data2)`uvm_error("Data Validity", $sformatf("Data is invalid"))
				else `uvm_info("Data Validity", $sformatf("Data is Valid"),UVM_MEDIUM)
			end
		end
	end
 join_none
endtask : run_phase

endclass : i2c_scoreboard_dv
