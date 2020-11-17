class i2c_env extends uvm_env;
`uvm_component_utils(i2c_env)
  i2c_agent agnt;

  function new(string name="i2c_env", uvm_component parent=null);
    super.new(name,parent);
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agnt = i2c_agent::type_id::create("agnt",this); 
  endfunction: build_phase;
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase;

endclass : i2c_env
