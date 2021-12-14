`ifndef _TEST_
`define _TEST_
`include "environment.sv"
program test(intf.generator intf_gen, intf.driver intf_driv, intf.monitor intf_mon);
    environment env;
    bit [1:0] prio_vals [4] = {2'h0, 2'h1, 2'h2, 2'h3};
    // test with each port as the highest priority, each all fed into the DUT
    logic [63:0] address_in;
    initial begin
        env = new(intf_gen, intf_driv, intf_mon);
        env.gen.init_DUT();
        // default priority for all ports
        // feed data in
        for (logic [15:0] addr_in=0; addr_in<4; addr_in++) begin
            // address_in = addr_in << 12 + addr_in << 8 + addr_in << 4 + addr_in;
            address_in = {addr_in, addr_in, addr_in, addr_in};
            env.gen.generate_transaction(
                    64'h3333_2222_1111_0000, // data_in
                    address_in, // addr_in
                    4'b1111, // wr_en
                    4'b0000, // rd_en
                    , , , , ,
                    );
            // read data out
            env.gen.generate_transaction(
                    , // data_in
                    address_in, // addr_in
                    4'b0000, // wr_en
                    1'b1 << addr_in, // rd_en
                    , , , , ,
                    );
            env.gen.generate_transaction(
                    , // data_in
                    address_in, // addr_in
                    4'b0000, // wr_en
                    1'b1 << addr_in, // rd_en
                    , , , , ,
                    );
            env.gen.generate_transaction(
                    , // data_in
                    address_in, // addr_in
                    4'b0000, // wr_en
                    1'b1 << addr_in, // rd_en
                    , , , , ,
                    );
            env.gen.generate_transaction(
                    , // data_in
                    address_in, // addr_in
                    4'b0000, // wr_en
                    1'b1 << addr_in, // rd_en
                    , , , , ,
                    );
        end
        // change priority order
        for (logic [15:0] addr_in=0; addr_in<4; addr_in++) begin
            for (int priority_config=0; priority_config<4; priority_config++) begin
                for (int port=0; port<4; port++) begin
                    env.gen.generate_transaction(
                            , // data_in
                            , // addr_in
                            4'b0000, // wr_en
                            4'b0000, // rd_en
                            prio_vals[port], // prio_val
                            1'b1, // prio_wr
                            1'b0, ,
                            port, // port_sel
                    );
                    // make sure that each port gets a turn being highest priority
                    prio_vals[port]++;
                end
                // feed data in
                address_in = {addr_in, addr_in, addr_in, addr_in};
                env.gen.generate_transaction(
                        64'h3333_2222_1111_0000, // data_in
                        address_in, // addr_in
                        4'b1111, // wr_en
                        4'b0000, // rd_en
                        , , , , ,
                        );
                // read packets out
                env.gen.generate_transaction(
                        , // data_in
                        address_in, // addr_in
                        4'b0000, // wr_en
                        1'b1 << addr_in, // rd_en
                        , , , , ,
                        );
                env.gen.generate_transaction(
                        , // data_in
                        address_in, // addr_in
                        4'b0000, // wr_en
                        1'b1 << addr_in, // rd_en
                        , , , , ,
                        );
                env.gen.generate_transaction(
                        , // data_in
                        address_in, // addr_in
                        4'b0000, // wr_en
                        1'b1 << addr_in, // rd_en
                        , , , , ,
                        );
                env.gen.generate_transaction(
                        , // data_in
                        address_in, // addr_in
                        4'b0000, // wr_en
                        1'b1 << addr_in, // rd_en
                        , , , , ,
                        );
            end
        end
        env.gen.init_params(1'b0, env.gen.transaction_queue.size());
        $display("[Testbench]: Start of testcase(s) at %0d", $time);

        env.run();
    end

    final
        $display("[Testbench]: End of testcase(s) at %0d", $time);
endprogram : test
`endif // _TEST_
