`ifndef _TEST_
`define _TEST_
`include "environment.sv"
program test(intf.generator intf_gen, intf.driver intf_driv, intf.monitor intf_mon);
    environment env;

    initial begin
        env = new(intf_gen, intf_driv, intf_mon);
        env.gen.randomize_flag = 1'b0;
        // env.gen.push_trans_queue(
        env.gen.initialize();
        env.gen.generate_transaction(
                64'hAAAA_BBBB_CCCC_DDDD, // data_in
                64'h0003_0002_0001_0000, // addr_in
                4'b1111, // wr_en
                4'b0000, // rd_en
                8'h00, // prio_val
                1'b0, // prio_wr
                1'b0, // port_en
                1'b0, // port_wr
                2'b00, // port_sel
                16'h0000 // port_addr
        );
        env.gen.transactions_to_create = env.gen.transaction_queue.size();
        $display("[Testbench]: Start of testcase(s) at %0d", $time);

        env.run();
    end

    final
        $display("[Testbench]: End of testcase(s) at %0d", $time);
endprogram : test
`endif // _TEST_
