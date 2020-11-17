class i2c_seqr extends uvm_sequencer #(i2c_seq_item);
  `uvm_object_utils(i2c_seqr)
  
  function new(string name="i2c_seqr");
    super.new(name);
  endfunction : new

endclass : i2c_seqr


