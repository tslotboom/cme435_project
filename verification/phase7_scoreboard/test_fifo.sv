`ifndef _TEST_
`define _TEST_
`include "environment.sv"
program test(intf.generator intf_gen, intf.driver intf_driv, intf.monitor intf_mon);
    environment env;

    initial begin
        env = new(intf_gen, intf_driv, intf_mon);
        env.gen.init_DUT();
        for (int port=0; port<4; port++) begin
            repeat(256) // fill FIFO
                env.gen.generate_transaction(
                        {$random, $random}, // data_in
                        64'h0003_0002_0001_0000, // addr_in
                        4'b1<<port, // wr_en
                        4'b0000, // rd_en
                        , , , , ,
                );
            repeat(256) // empty FIFO
                env.gen.generate_transaction(
                        {$random, $random}, // data_in
                        64'h0003_0002_0001_0000, // addr_in
                        4'b0000, // wr_en
                        4'b1<<port, // rd_en
                        , , , , ,
                );
        end
        env.gen.init_params(1'b0, env.gen.transaction_queue.size());
        $display("[Testbench]: Start of testcase(s) at %0d", $time);
        env.run();
    end

    final
        $display("[Testbench]: End of testcase(s) at %0d", $time);
endprogram : test
`endif // _TEST_
