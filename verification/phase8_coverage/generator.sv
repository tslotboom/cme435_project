`ifndef _GENERATOR_
`define _GENERATOR_

// `define PRINT_GENERATOR

`include "transaction.sv"
class generator;
    virtual intf.generator vif_gen;

    transaction trans;

    transaction transaction_queue[$] = {};

    transaction initialization_queue[$] = {};

    int transactions_to_create = 0;

    int packets_generated;

    bit randomize_flag = 1'b0;
    bit randomize_this_packet = 1'b0;
    event ended;

    mailbox gen2driv;
    mailbox scb2gen;

    logic [15:0] port_addresses [4];

    function new(virtual intf.generator vif_gen,
            mailbox gen2driv,
            mailbox scb2gen);
        trans = new();
        this.vif_gen = vif_gen;
        this.gen2driv = gen2driv;
        this.scb2gen = scb2gen;
    endfunction

    function init_params(bit randomize_flag, int num_transactions);
        this.randomize_flag = randomize_flag;
        this.transactions_to_create = num_transactions;
    endfunction

    task init_DUT(); // set port addresses
        generate_transaction(
                , // data_in
                , // addr_in
                , // wr_en
                , // rd_en
                , // prio_val
                1'b0, // prio_wr
                1'b1, // port_en
                1'b1, // port_wr
                2'b00, // port_sel
                16'h0000 // port_addr
        );
        generate_transaction( , , , , ,
                1'b0, // prio_wr
                1'b1, // port_en
                1'b1, // port_wr
                2'b01, // port_sel
                16'h0001 // port_addr
        );
        generate_transaction( , , , , ,
                1'b0, // prio_wr
                1'b1, // port_en
                1'b1, // port_wr
                2'b10, // port_sel
                16'h0002 // port_addr
        );
        generate_transaction( , , , ,
                2'b0,
                1'b0, // prio_wr
                1'b1, // port_en
                1'b1, // port_wr
                2'b11, // port_sel
                16'h0003 // port_addr
        );
        // set priorities
        generate_transaction( , , , ,
                2'b0, // prio_val
                1'b1, // prio_wr
                1'b0, // port_en
                , // port_wr
                2'b00, // port_sel
                 // port_addr
        );
        generate_transaction( , , , ,
                2'b0, // prio_val
                1'b1, // prio_wr
                1'b0, // port_en
                , // port_wr
                2'b01, // port_sel
                 // port_addr
        );
        generate_transaction( , , , ,
                2'b0, // prio_val
                1'b1, // prio_wr
                1'b0, // port_en
                , // port_wr
                2'b10, // port_sel
                // port_addr
        );
        generate_transaction( , , , ,
                2'b0, // prio_val
                1'b1, // prio_wr
                1'b0, // port_en
                , // port_wr
                2'b11, // port_sel
                 // port_addr
        );
    endtask


    task main();
        while(transactions_to_create > 0) begin
            // if (!randomize_flag)
            if (randomize_flag && transaction_queue.size() == 0) begin
                trans = new();
                transaction_queue.push_front(trans);
                randomize_this_packet = 1'b1;
            end
            trans = transaction_queue.pop_back();
            // else
                // trans = new();
            trans.reset = vif_gen.reset;

            trans.data_rcv = vif_gen.data_rcv;

            trans.fifo_empty = vif_gen.fifo_empty;
            trans.fifo_full = vif_gen.fifo_full;
            trans.fifo_ae = vif_gen.fifo_ae;
            trans.fifo_af = vif_gen.fifo_af;

            trans.data_out = vif_gen.data_out;
            trans.addr_out = vif_gen.addr_out;
            trans.data_rdy = vif_gen.data_rdy;

            trans.port_addresses = port_addresses;

            if (randomize_this_packet) begin
                trans.randomize();
                randomize_this_packet = 1'b0;
            end
            `ifdef PRINT_GENERATOR
                trans.display("[Generator]");
            `endif
            gen2driv.put(trans);
            packets_generated++;
            transactions_to_create--;
            scb2gen.get(port_addresses);
        end
    -> ended;
    endtask

    function void generate_transaction(
            logic [63:0]   data_in=64'h0000_0000_0000_0000,
            logic [63:0]   addr_in=64'h0000_0000_0000_0000,
            logic [3:0]    wr_en=4'b0000,
            logic [3:0]    rd_en=4'b0000,
            logic [7:0]    prio_val=8'h00,
            logic          prio_wr=1'b0,
            logic          port_en=1'b0,
            logic          port_wr=1'b0,
            logic [1:0]    port_sel=2'b00,
            logic [15:0]   port_addr=16'h0000
        );
        trans = new();
        trans.data_in = data_in;
        trans.addr_in = addr_in;
        trans.wr_en = wr_en;
        trans.rd_en = rd_en;
        trans.prio_val = prio_val;
        trans.prio_wr = prio_wr;
        trans.port_en = port_en;
        trans.port_wr = port_wr;
        trans.port_sel = port_sel;
        trans.port_addr = port_addr;
        transaction_queue.push_front(trans);
    endfunction

    function void generate_random_transaction();
        trans = new();
        if( !trans.randomize() )
            $fatal("[Generator]: trans randomization failed");
        transaction_queue.push_front(trans);
    endfunction

endclass
`endif // _GENERATOR_
