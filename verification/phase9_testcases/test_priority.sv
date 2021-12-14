`ifndef _TEST_
`define _TEST_
`include "environment.sv"
program test(intf.generator intf_gen, intf.driver intf_driv, intf.monitor intf_mon);
    environment env;

    no_port_change trans;

    initial begin
        env = new(intf_gen, intf_driv, intf_mon);
        env.gen.init_DUT();

        env.gen.init_params(1000);
        trans = new();
        env.gen.trans = trans;
        $display("[Testbench]: Start of testcase(s) at %0d", $time);

        env.run();
    end

    initial forever begin
        #1ns;
        if (env.gen.transaction_queue.size() == 1'b0) begin
            trans = new();
            env.gen.trans = trans;
        end
        wait(env.gen.transaction_queue.size() > 1'b0);
    end

    final
        $display("[Testbench]: End of testcase(s) at %0d", $time);
endprogram : test
`endif // _TEST_
