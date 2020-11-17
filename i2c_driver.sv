class i2c_driver extends uvm_driver #(i2c_seq_item);
`uvm_component_utils(i2c_driver)

i2c_seq_item seq;
virtual intf it;
virtual intf2 it2;

logic c10;

uvm_tlm_analysis_fifo #(logic) fifo24;

function new(string name = "i2c_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction


function void connect_phase(uvm_phase phase);
      if (!uvm_config_db #(virtual intf)::get(null, "interface","intf", this.it)) begin
          `uvm_error("connect", "interface not found")
	end
	if (!uvm_config_db #(virtual intf2)::get(null, "interface","intf2", this.it2)) begin
          `uvm_error("connect", "interface not found")
      end
endfunction: connect_phase;

function void build_phase(uvm_phase phase);
    fifo24 = new("fifo24",this);
endfunction : build_phase

task write_register(i2c_seq_item bob);
	it.PADDR=bob.addr;
	it.PWRITE=1;
	it.PENABLE=0;
	it.PSEL=1;
	it.PWDATA=bob.data;
	@(posedge(it.PCLK)) #1;
	it.PENABLE=1;
	@(posedge(it.PCLK)) #1;
	it.PENABLE=0;
	it.PSEL=0;	
endtask : write_register

task read_register(input logic [4:0] addr,output logic[31:0] dout);
	it.PADDR=addr;
	it.PWRITE=0;
	it.PENABLE=0;
	it.PSEL=1;
	it.PWDATA=32'hdeadbeef;
	@(posedge(it.PCLK)) #1 ;
	it.PENABLE=1;
	@(posedge(it.PCLK)) dout=it.PRDATA;
	 #1 ;
	it.PENABLE=0;
	it.PSEL=0;	
endtask : read_register

task wait_not_busy;
	logic [31:0] rdat;
	rdat=8'h00;
	while(rdat[7]==0) read_register(5'hc,rdat);
endtask : wait_not_busy

task wait_active;
	logic [31:0] rdat;
	rdat=8'h00;
	while(rdat[5]==0) read_register(5'hc,rdat);
endtask : wait_active

task dummyRead;
	logic [31:0] rdat;
	rdat=8'h00;
	read_register(5'h10,rdat);
endtask : dummyRead

task send_data(i2c_seq_item bob);
	logic [4:0] count=8;
	logic [9:0] fcount=0;
	logic [7:0] krish;
	krish = bob.data;
	while(count>=1) begin
		fcount=0;
		$display(krish);
		while(fcount<24) begin
			it2.test_SDA = krish[count-1];
			@(posedge(it.PCLK))fcount=fcount+1;
		end
		count = count - 1;
	end
endtask : send_data


task run_phase(uvm_phase phase);
it.PRESET=0;
it.PADDR=0;
it.PSEL=0;
it.PENABLE=0;
it.PWRITE=0;
it.PWDATA=0;
@(posedge(it.PCLK))#1;
  fork
  forever begin
	seq_item_port.get_next_item(seq);
		case(seq.god)
			writeReg: begin
				write_register(seq);
			end
			waitNotBusy: begin
				wait_not_busy;
			end
			waitActive: begin
				wait_active;
			end
			waitclk: begin
				repeat(seq.wtime) @(posedge(it.PCLK)) #1;
			end
			writestop: begin
				//fifo24.get(c10);
				write_register(seq);
			end
			dummyread: begin
				dummyRead;
			end
			sendData: begin
				send_data(seq);
			end
			readData: begin
				dummyRead;
			end
			/*trans:begin
				@(posedge (it.PCLK))begin
						it.PRESET=seq.PRESET;
						it.PADDR=seq.PADDR;
						it.PSEL=seq.PSEL;
						it.PENABLE=seq.PENABLE;
						it.PWRITE=seq.PWRITE;
						it.PWDATA=seq.PWDATA;
				end
			end*/
			/*rec:begin	
				//fifo24.get(stop);
				@(posedge (it.PCLK))begin
						it.PRESET=seq.PRESET;
						it.PADDR=seq.PADDR;
						it.PSEL=seq.PSEL;
						it.PENABLE=seq.PENABLE;
						it.PWRITE=seq.PWRITE;
						it.PWDATA=seq.PWDATA;
				end
			end*/
		endcase
	seq_item_port.item_done();
	
	end
  join_none
endtask: run_phase

endclass: i2c_driver


class i2c_driver_test extends uvm_driver #(i2c_seq_item);
`uvm_component_utils(i2c_driver_test)

uvm_tlm_analysis_fifo #(logic) fifo14;
//uvm_tlm_analysis_fifo #(logic) fifo15;
uvm_tlm_analysis_fifo #(logic[31:0]) fifo27;

virtual intf2 it2;
logic ack=0;
logic ackd=0;
logic [31:0] freq;
logic [31:0] delay;

function new(string name = "i2c_driver_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
fifo14 = new("fifo14",this);
fifo27 = new("fifo27",this);
endfunction : build_phase;

function void connect_phase(uvm_phase phase);
      if (!uvm_config_db #(virtual intf2)::get(null, "interface","intf2", this.it2)) begin
          `uvm_error("connect", "interface not found")
      end 
endfunction: connect_phase;

task run_phase(uvm_phase phase);
it2.test_SCL=1;
it2.test_SDA=1;
  fork
  forever begin
	fifo14.get(ack);
	fifo27.get(freq);
  end
  forever begin
	delay = freq/4;
	ackd = #delay ack;
	 	@(posedge (it.PCLK))begin
			if(ackd==1) begin
				it2.test_SCL=1;
				it2.test_SDA=0;
			end
			else begin
				it2.test_SCL=1;
				it2.test_SDA=1;
			end
	end
	end
  join_none
endtask: run_phase

endclass: i2c_driver_test

