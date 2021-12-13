`ifndef _TEST_
`define _TEST_
`include "environment.sv"
program test(intf.generator intf_gen, intf.driver intf_driv, intf.monitor intf_mon);
    environment env;

    initial begin
        env = new(intf_gen, intf_driv, intf_mon);
        env.gen.init_DUT();
        // basic port address change
        env.gen.generate_transaction(
                , // data_in
                , // addr_in
                4'b0000, // wr_en
                4'b0000, // rd_en
                8'h00, // prio_val
                1'b0, // prio_wr
                1'b1, // port_en
                1'b1, // port_wr
                2'b00, // port_sel
                16'h0005 // port_addr
        );
        env.gen.generate_transaction(
                64'h0003_0002_0001_0000, // data_in
                64'h0005_0002_0001_0000, // addr_in
                4'b1000, // wr_en
                4'b0000, // rd_en
                , // prio_val
                , // prio_wr
                , // port_en
                , // port_wr
                , // port_sel
                 // port_addr
        );
        env.gen.generate_transaction(
                , // data_in
                , // addr_in
                , // wr_en
                4'b0001, // rd_en
                , // prio_val
                , // prio_wr
                , // port_en
                , // port_wr
                , // port_sel
                 // port_addr
        );
        // test what happens when port change and data write happens simultaneously
        env.gen.generate_transaction(
                64'h0003_0002_AAAA_0000, // data_in
                64'h0003_0002_0006_0000, // addr_in
                4'b0010, // wr_en
                4'b0000, // rd_en
                8'h00, // prio_val
                1'b0, // prio_wr
                1'b1, // port_en
                1'b1, // port_wr
                2'b01, // port_sel
                16'h0006 // port_addr
        );
        env.gen.generate_transaction(
                , // data_in
                , // addr_in
                4'b0000, // wr_en
                4'b0010, // rd_en
                , // prio_val
                , // prio_wr
                , // port_en
                , // port_wr
                , // port_sel
                 // port_addr
        );
        env.gen.init_params(1'b0, env.gen.transaction_queue.size());
        $display("[Testbench]: Start of testcase(s) at %0d", $time);

        env.run();
    end

    final
        $display("[Testbench]: End of testcase(s) at %0d", $time);
endprogram : test
`endif // _TEST_
