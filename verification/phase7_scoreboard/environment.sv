`ifndef _ENVIRONMENT_
`define _ENVIRONMENT_
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;

    virtual intf.generator vif_gen;
    virtual intf.driver vif_driver;
    virtual intf.monitor vif_monitor;

    generator gen;
    driver driv;
    monitor mon;
    scoreboard scb;

    mailbox gen2driv;
    mailbox mon2scb;
    semaphore scb2gen;

    function new(virtual intf.generator vif_gen,
            virtual intf.driver vif_driver,
            virtual intf.monitor vif_monitor);

        this.vif_gen = vif_gen;
        this.vif_driver = vif_driver;
        this.vif_monitor = vif_monitor;

        gen2driv = new();
        mon2scb = new();
        scb2gen = new();

        gen = new(vif_gen, gen2driv, scb2gen);
        driv = new(vif_driver, gen2driv);
        mon = new(vif_monitor, mon2scb);
        scb = new(mon2scb, scb2gen);
    endfunction

    task pre_test();
        $display("[Environment]: Start of pre_test() at %0d", $time);
        reset();

        $display("[Environment]: End of pre_test() at %0d", $time);
    endtask

    task test();
        $display("[Environment]: Start of test() at %0d", $time);
        fork
            gen.main();
            driv.main();
            mon.main();
            scb.main();
        join_any
        wait(gen.ended.triggered);
        wait(driv.packets_driven == gen.packets_generated);
        wait(scb.packets_checked == gen.packets_generated);
        $display("[Environment]: End of test() at %0d", $time);
    endtask

    task post_test();
        $display("[Environment]: Start of post_test() at %0d", $time);
        $display("[Environment]: End of post_test() at %0d", $time);
    endtask

    task run;
      $display("[Environment]: Start of run() at %0d", $time);
      pre_test();
      test();
      post_test();
      $display("[Environment]: End of run() at %0d", $time);
      $finish;
    endtask

    task reset();
        -> tbench_top.reset_trigger;
        $display("[Environment]: Reset started at %0d", $time);
    endtask

endclass
`endif //_ENVIRONMENT_
