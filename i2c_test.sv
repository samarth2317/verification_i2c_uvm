class i2c_test extends uvm_test;
`uvm_component_utils(i2c_test)

i2c_seq seq;
i2c_env env;
 
function new(string name = "i2c_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  env = i2c_env::type_id::create("env",this);
  seq = i2c_seq::type_id::create("seq");
endfunction: build_phase

task run_phase(uvm_phase phase);
    phase.raise_objection(this,"-------starting-----------");
    seq.start(env.agnt.seqr);
	#12_000;	
    phase.drop_objection(this,"--------ending--------------");
endtask : run_phase

endclass: i2c_test
