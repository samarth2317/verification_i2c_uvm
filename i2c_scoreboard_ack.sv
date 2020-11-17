class i2c_scoreboard_ack extends uvm_scoreboard;
`uvm_component_utils(i2c_scoreboard_ack)

uvm_tlm_analysis_fifo #(logic) fifo12;
uvm_tlm_analysis_fifo #(logic) fifo13;
uvm_tlm_analysis_fifo #(i2c_seq_item) fifo15;

uvm_analysis_port #(logic) port7;
//uvm_analysis_port #(logic) port10;

i2c_seq_item seq;

logic cf=0;
logic start=0;
logic ack=0;
logic krish=0;
logic [4:0] count=0;
logic c10=0;


function new(string name = "i2c_scoreboard_ack", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    fifo12 = new("fifo12",this);
    fifo13 = new("fifo13",this);
    port7 = new("port7",this);
    //port10= new("port10",this);
    fifo15= new("fifo15",this);
    seq = i2c_seq_item::type_id::create("i2c_seq_item");
endfunction : build_phase

task run_phase(uvm_phase phase);
 fork
	forever begin
		 fifo12.get(cf);
		 fifo13.get(start);
		 fifo15.get(seq);

		if(start) begin 
			krish = 1;
			count = 0;
		end
		
		if(krish) begin
		 	if(cf) count = count + 1;	
		end
		if(count==9) ack=1;
		if(count==10) begin ack=0; end
		if(cf==1&&count==10&&seq.SDA_result==0) `uvm_info("Acknowledgement", $sformatf("Acknowledgement Recieved"),UVM_MEDIUM)
		port7.write(ack);
		if(count==10)count=1;
	end
 join_none
endtask : run_phase

endclass : i2c_scoreboard_ack

