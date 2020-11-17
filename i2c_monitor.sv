class i2c_monitor extends uvm_monitor;

`uvm_component_utils(i2c_monitor)

uvm_analysis_port #(i2c_seq_item) port1;
//uvm_analysis_port #(integer) port13;

i2c_seq_item seq;
int count = 0;
logic flag_SCL = 0;

virtual intf it;

function new(string name = "i2c_monitor", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
   seq = new();
   port1 = new("port1",this);
endfunction : build_phase

function void connect_phase(uvm_phase phase);
      if (!uvm_config_db #(virtual intf)::get(null, "interface","intf", this.it)) begin
          `uvm_error("connect", "interface not found")
      end 
endfunction: connect_phase;

task run_phase(uvm_phase phase);
	fork
	forever begin
	@(posedge(it.PCLK))begin
	if(!it.PRESET) begin
	 seq.PADDR=it.PADDR;
	 seq.PSEL=it.PSEL;
	 seq.PENABLE=it.PENABLE;
	 seq.PWRITE=it.PWRITE;
	 seq.PWDATA=it.PWDATA;
	 seq.PREADY=it.PREADY;
	 seq.PRDATA=it.PRDATA;
	 seq.PSLVERR=it.PSLVERR;
	 seq.Interrupt=it.Interrupt;
	 seq.SCL_drive=it.SCL_drive;
	 seq.SCL_result=it.SCL_result;
	 seq.SDA_drive=it.SDA_drive;
	 seq.SDA_result=it.SDA_result;
	 port1.write(seq);
	end
	end
	end
	forever begin
	if(it.SCL_result == 0 && flag_SCL == 0) flag_SCL = 1;
	else if(it.SCL_result == 1 && flag_SCL == 1) begin
	@(posedge it.PCLK)begin		
		count = count + 1;
		$display("%b",count);
	end
	flag_SCL = 0;
	end
	end
	
endtask : run_phase

endclass : i2c_monitor


