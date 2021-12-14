`ifndef _TEST_
`define _TEST_
`include "environment.sv"
program test(intf.generator intf_gen, intf.driver intf_driv, intf.monitor intf_mon);
    environment env;

    initial begin
        env = new(intf_gen, intf_driv, intf_mon);
        env.gen.init_DUT();
        // change priority order
        env.gen.generate_transaction(
                , // data_in
                , // addr_in
                4'b0000, // wr_en
                4'b0000, // rd_en
                8'h00, // prio_val
                1'b1, // prio_wr
                1'b0, ,
                2'd0, // port_sel
        );
        env.gen.generate_transaction(
                , // data_in
                , // addr_in
                4'b0000, // wr_en
                4'b0000, // rd_en
                8'h00, // prio_val
                1'b1, // prio_wr
                1'b0, ,
                2'd1, // port_sel
        );
        env.gen.generate_transaction(
                , // data_in
                , // addr_in
                4'b0000, // wr_en
                4'b0000, // rd_en
                8'h00, // prio_val
                1'b1, // prio_wr
                1'b0, ,
                2'd2, // port_sel
        );
        env.gen.generate_transaction(
                , // data_in
                , // addr_in
                4'b0000, // wr_en
                4'b0000, // rd_en
                8'h03, // prio_val
                1'b1, // prio_wr
                1'b0, ,
                2'd3, // port_sel
        );
        // feed data in
        env.gen.generate_transaction(
                64'h3333_2222_1111_0000, // data_in
                64'h0000_0000_0000_0000, // addr_in
                4'b1111, // wr_en
                4'b0000, // rd_en
                , , , , ,
                );
        // read data out
        env.gen.generate_transaction(
                64'h3333_2222_1111_0000, // data_in
                64'h0000_0000_0000_0000, // addr_in
                4'b0000, // wr_en
                4'b0001, // rd_en
                , , , , ,
                );
        env.gen.generate_transaction(
                64'h3333_2222_1111_0000, // data_in
                64'h0000_0000_0000_0000, // addr_in
                4'b0000, // wr_en
                4'b0001, // rd_en
                , , , , ,
                );
        env.gen.generate_transaction(
                64'h3333_2222_1111_0000, // data_in
                64'h0000_0000_0000_0000, // addr_in
                4'b0000, // wr_en
                4'b0001, // rd_en
                , , , , ,
                );
        env.gen.generate_transaction(
                64'h3333_2222_1111_0000, // data_in
                64'h0000_0000_0000_0000, // addr_in
                4'b0000, // wr_en
                4'b0001, // rd_en
                , , , , ,
                );
        env.gen.init_params(1'b0, env.gen.transaction_queue.size());
        $display("[Testbench]: Start of testcase(s) at %0d", $time);

        env.run();
    end

    final
        $display("[Testbench]: End of testcase(s) at %0d", $time);
endprogram : test
`endif // _TEST_
