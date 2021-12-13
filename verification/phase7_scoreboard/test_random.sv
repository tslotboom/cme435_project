`ifndef _TEST_
`define _TEST_
`include "environment.sv"
program test(intf.generator intf_gen, intf.driver intf_driv, intf.monitor intf_mon);
    environment env;

    initial
        forever begin
            int some_rand_delay;
            std::randomize(some_rand_delay) with {
              some_rand_delay <= 1024; // max wait 1024 clock cycles
              some_rand_delay >= 32; // min wait 32 clock cycles
            };
            # (some_rand_delay * 10ns - 1ns); // make sure that the reset is applied before a clock edge
            env.reset();
            env.gen.init_DUT();
            # 1ns;
        end

    initial begin
        env = new(intf_gen, intf_driv, intf_mon);
        env.gen.init_DUT();
        env.gen.init_params(1'b1, 1000000);
        $display("[Testbench]: Start of testcase(s) at %0d", $time);

        env.run();
    end

    final
        $display("[Testbench]: End of testcase(s) at %0d", $time);
endprogram : test
`endif // _TEST_
