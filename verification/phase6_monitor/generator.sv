`ifndef _GENERATOR_
`define _GENERATOR_
`include "transaction.sv"
class generator;
    virtual intf.generator vif_gen;

    transaction trans;

    transaction transaction_queue[$] = {};

    transaction initialization_queue[$] = {};

    int transactions_to_create = 0;

    bit randomize_flag = 0;

    int packets_generated;

    mailbox gen2driv;

    event ended;

    function new(virtual intf.generator vif_gen, mailbox gen2driv);
        trans = new();
        this.vif_gen = vif_gen;
        this.gen2driv = gen2driv;
    endfunction

    task initialize(); // set port addresses
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
        generate_transaction(
                , // data_in
                , // addr_in
                , // wr_en
                , // rd_en
                , // prio_val
                1'b0, // prio_wr
                1'b1, // port_en
                1'b1, // port_wr
                2'b01, // port_sel
                16'h0001 // port_addr
        );
        generate_transaction(
                , // data_in
                , // addr_in
                , // wr_en
                , // rd_en
                , // prio_val
                1'b0, // prio_wr
                1'b1, // port_en
                1'b1, // port_wr
                2'b10, // port_sel
                16'h0002 // port_addr
        );
        generate_transaction(
                , // data_in
                , // addr_in
                , // wr_en
                , // rd_en
                , // prio_val
                1'b0, // prio_wr
                1'b1, // port_en
                1'b1, // port_wr
                2'b11, // port_sel
                16'h0003 // port_addr
        );
        // trans.data_in <= 64'hFFFF_FFFF_FFFF_FFFF;
        // trans.addr_in <= 64'hFFFF_FFFF_FFFF_FFFF;
        // trans.wr_en <= 4'b1111;
        // trans.rd_en <= 4'b0000;
        // trans.prio_val <= 4'h0A08;
        // trans.prio_wr <= 4'h0A08;
        // trans.port_en <= 4'h0A08;
        // trans.port_wr <= 4'h0A08;
        // trans.port_sel <= 4'h0A08;
        // trans.port_addr <= 4'h0A08;
    endtask


    task main();
        while(transactions_to_create > 0) begin
            if (randomize_flag) begin
                trans = new();
                if( !trans.randomize() )
                    $fatal("[Generator]: trans randomization failed");
            end
            else begin
                trans = transaction_queue.pop_back();
            end
            trans.display("[Generator]");
            gen2driv.put(trans);
            packets_generated++;
            transactions_to_create--;
        end
    -> ended;
    endtask

    // function void push_trans_queue(transaction trans_a);
    // endfunction
    //
    // function void push_trans_init(transaction trans_a);
    //     initialization_queue.push_front(trans_a);
    // endfunction

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

endclass
`endif // _GENERATOR_
