`ifndef _TEST_TRANSACTION_
`define _TEST_TRANSACTION_
`include "transaction.sv"
program test_transaction_class;
    transaction trans;

    initial begin
        trans = new();
        repeat(10) begin
            trans.randomize();
            // trans.data_in = $random();
            // trans.addr_in = $random();
            trans.data_rcv = 4'hF;
            // trans.wr_en = $random();

            trans.fifo_empty = 4'hF;
            trans.fifo_full = 4'hF;
            trans.fifo_ae = 4'hF;
            trans.fifo_af = 4'hF;

            trans.data_out = 64'hFFFF_FFFF_FFFF_FFFF;
            trans.addr_out = 64'hFFFF_FFFF_FFFF_FFFF;
            // trans.rd_en = $random();
            trans.data_rdy = 4'hF;

            // trans.prio_val = $random();
            // trans.prio_wr = $random();

            // trans.port_en = $random();
            // trans.port_wr = $random();
            // trans.port_sel = $random();
            // trans.port_addr = $random();

            trans.display("[test_transaction_class]");
        end
    end
endprogram : test_transaction_class
`endif //_TEST_TRANSACTION_
