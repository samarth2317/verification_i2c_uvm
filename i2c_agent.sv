class i2c_agent extends uvm_agent;
  `uvm_component_utils(i2c_agent)  
  
  function new(string name = "i2c_agent", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  i2c_seq seq;
  i2c_seqr seqr;
  i2c_driver driver;
  i2c_driver_test driver_test;
  //i2c_driver_nd driver_nd;
  i2c_monitor mon;
  i2c_scoreboard_rs score_rs;
  i2c_scoreboard_start score_start;
  i2c_scoreboard_stop score_stop;
  i2c_scoreboard_data score_data;
  i2c_scoreboard_datar score_datar;
  i2c_scoreboard_ack score_ack;
  i2c_scoreboard_dv score_dv;
  //i2c_scoreboard_nd score_nd;
  i2c_scoreboard_freq score_freq;
  i2c_scoreboard_add score_add;
  i2c_scoreboard_rw score_rw;

  function void build_phase(uvm_phase phase);
    seq = i2c_seq::type_id::create("seq",this);
    seqr = i2c_seqr::type_id::create("seqr",this);
    driver = i2c_driver::type_id::create("driver",this);
    driver_test = i2c_driver_test::type_id::create("driver_test",this);
    //driver_nd = i2c_driver_nd::type_id::create("driver_nd",this);
    mon = i2c_monitor::type_id::create("monitor",this);
    score_rs = i2c_scoreboard_rs::type_id::create("scoreboard_rs",this);
    score_start = i2c_scoreboard_start::type_id::create("scoreboard_start",this);
    score_stop = i2c_scoreboard_stop::type_id::create("scoreboard_stop",this);
    score_data = i2c_scoreboard_data::type_id::create("scoreboard_data",this);
    score_datar = i2c_scoreboard_datar::type_id::create("scoreboard_datar",this);
    score_ack = i2c_scoreboard_ack::type_id::create("scoreboard_ack",this);
    score_dv = i2c_scoreboard_dv::type_id::create("scoreboard_dv",this);
    //score_nd = i2c_scoreboard_nd::type_id::create("scoreboard_nd",this);
    score_freq = i2c_scoreboard_freq::type_id::create("scoreboard_freq",this);
    score_add = i2c_scoreboard_add::type_id::create("scoreboard_add",this);
    score_rw = i2c_scoreboard_rw::type_id::create("scoreboard_rw",this);
   endfunction: build_phase;


  function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(seqr.seq_item_export);
    mon.port1.connect(score_rs.fifo1.analysis_export);
    mon.port1.connect(score_start.fifo6.analysis_export);
    score_rs.port2.connect(score_start.fifo2.analysis_export);
    score_rs.port3.connect(score_start.fifo3.analysis_export);
    score_rs.port4.connect(score_start.fifo4.analysis_export);
    score_rs.port5.connect(score_start.fifo5.analysis_export);
    score_rs.port3.connect(score_stop.fifo7.analysis_export);
    mon.port1.connect(score_stop.fifo8.analysis_export);
    score_start.port6.connect(score_data.fifo9.analysis_export);
    score_rs.port4.connect(score_data.fifo10.analysis_export);
    mon.port1.connect(score_data.fifo11.analysis_export);
    score_rs.port4.connect(score_ack.fifo12.analysis_export);
    score_start.port6.connect(score_ack.fifo13.analysis_export);
    score_ack.port7.connect(driver_test.fifo14.analysis_export);
    mon.port1.connect(score_ack.fifo15.analysis_export);
    score_start.port6.connect(score_dv.fifo16.analysis_export);
    score_rs.port4.connect(score_dv.fifo17.analysis_export);
    score_rs.port2.connect(score_dv.fifo18.analysis_export);
    mon.port1.connect(score_dv.fifo19.analysis_export);
    //score_start.port6.connect(score_nd.fifo20.analysis_export);
    //score_rs.port4.connect(score_nd.fifo21.analysis_export);
    //score_nd.port8.connect(driver_nd.fifo22.analysis_export);
    //score_nd.port9.connect(driver_nd.fifo23.analysis_export);
    //score_ack.port10.connect(driver.fifo24.analysis_export);
    score_stop.port10.connect(score_dv.fifo25.analysis_export);
    mon.port1.connect(score_freq.fifo26.analysis_export);
    score_freq.port11.connect(driver_test.fifo27.analysis_export);
    score_stop.port10.connect(score_start.fifo28.analysis_export);
    score_start.port6.connect(score_add.fifo29.analysis_export);
    score_add.port12.connect(score_rw.fifo31.analysis_export);
    score_add.port12.connect(score_data.fifo32.analysis_export);
    score_add.port12.connect(score_datar.fifo36.analysis_export);
    mon.port1.connect(score_add.fifo30.analysis_export);
    score_start.port6.connect(score_datar.fifo33.analysis_export);
    score_rs.port4.connect(score_datar.fifo34.analysis_export);
    mon.port1.connect(score_datar.fifo35.analysis_export);
  endfunction: connect_phase;

endclass: i2c_agent
