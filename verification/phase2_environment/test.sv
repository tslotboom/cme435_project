`ifndef _TEST_
`define _TEST_
`include "phase2_environment.sv"
program test(intf i_intf);
    environment env;

    initial begin
        env = new(i_intf);

        $display("[Testbench]: Start of testcase(s) at %0d", $time);

        env.run();
    end

    final
        $display("[Testbench]: End of testcase(s) at %0d", $time);
endprogram : test
`endif // _TEST_
