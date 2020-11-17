class i2c_seq extends uvm_sequence #(i2c_seq_item);
`uvm_object_utils(i2c_seq)

 i2c_seq_item item;

function new(string name = "i2c_seq");
  super.new(name);
endfunction

task body;
	item=i2c_seq_item::type_id::create("item");
//-----------Transmitting-------------------------//
	waitclks(10);
	writereg(4,32'h0021_0021);
	writereg(8,32'hfffc_fff0);
	waitclks(5);
	waitactive;
	writereg(16,32'hffff_ffaa);
	wait_not_busy;
	waitclks(180);
	wait_not_busy;
	writereg(16,32'hffff_ffa8);
	waitclks(180);
	wait_not_busy;
	writeStop(8,32'hffff_ff80);
//--------------------------------------------------//
	 waitclks(10);
	 writereg(8,32'hfffc_fff0);
	 waitclks(5);
	 waitactive;
	 writereg(16,32'hffff_ff8b);
	 wait_not_busy;
	 waitclks(180);
	 wait_not_busy;
	 writereg(16,32'hffff_ff77);
	 waitclks(180);
	 wait_not_busy;
	 writeStop(8,32'hffff_ff80);
//-------------------------------------------------//
	waitclks(10);
	writereg(4,32'h0021_0023);
	writereg(8,32'hfffc_fff0);
	waitclks(5);
	waitactive;
	writereg(16,32'hffff_ffaa);
	wait_not_busy;
	waitclks(180);
	wait_not_busy;
	writeStop(8,32'hffff_ff80);
//-------------Receiving---------------------------//
	/*waitclks(20);
	writereg(8,32'hfffc_ffb0);
	waitclks(5);
	waitactive;
	writereg(16,32'hffff_ffa3);
	waitclks(180);
	wait_not_busy;

	writereg(8,32'hfffc_ffa0);
	waitclks(5);
	waitactive;
	dummy_read;
	send_data(32'hffff_ffaa);
	//waitclks(180);
	wait_not_busy;
	//dummy_read;
	read_data;
	writeStop(8,32'hffff_ff80);*/
endtask: body

task writeStop(input int register, input int data);
	start_item(item);
	item.god=writestop;
	item.addr=register;
	item.data=data;
	finish_item(item);
endtask : writeStop

task waitclks(input int nwait);
	start_item(item);
	item.god=waitclk;
	item.wtime=nwait;
	finish_item(item);
endtask : waitclks

task wait_not_busy;
	start_item(item);
	item.god=waitNotBusy;
	finish_item(item);
endtask : wait_not_busy;

task waitactive;
	start_item(item);
	item.god=waitActive;
	finish_item(item);
endtask : waitactive;

task writereg(input int register, input int data);
	start_item(item);
	item.god=writeReg;
	item.addr=register;
	item.data=data;
	finish_item(item);
endtask: writereg

task dummy_read;
	start_item(item);
	item.god=dummyread;
	finish_item(item);
endtask : dummy_read

task send_data(input int data);
	start_item(item);
	item.god = sendData;
	item.data = data;
	finish_item(item);
endtask : send_data

task read_data;
	start_item(item);
	item.god = readData;
	finish_item(item);
endtask : read_data

endclass: i2c_seq




