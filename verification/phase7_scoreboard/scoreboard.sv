`ifndef _SCOREBOARD_
`define _SCOREBOARD_

// `define PRINT_SUCCESS

`define EMPTY 9'd0
`define ALMOST_EMPTY 9'd64
`define ALMOST_FULL 9'd192
`define FULL 9'd256

`include "transaction.sv"
class scoreboard;

    mailbox mon2scb;

    semaphore scb2gen;

    function new(mailbox mon2scb, semaphore scb2gen);
        this.mon2scb = mon2scb;
        this.scb2gen = scb2gen;
    endfunction

    int packets_checked;

    int error_count;
    int error_time_queue[$] = {};

    string error_message;

    // prev values of DUT
    logic [3:0] prev_fifo_empty = 4'b1111;

    // expected values within DUT:

    typedef struct {
        logic [63:0] data;
        logic [63:0] addr;
        bit can_be_popped; // packets take 1 clock cycle to go from input to output
    } data_struct;

    // TODO: typedef struct for expected outputs at a port, then you can have an
    // array of those structs and iterate over them for max efficiency printing
    // results

    data_struct data_fifo [4][$];
    logic [15:0] port_addresses [4];
    // internal priorities of each port
    logic [7:0] port_priorities [4];
    // order in which ports should be accessed, based on priority. 0th index
    // gets accessed first
    logic [1:0] priority_order [4];
    logic [1:0] priority_order_position;

    logic [63:0] expected_data_out;
    logic [63:0] expected_addr_out;
    logic [3:0] expected_data_rdy;
    logic [3:0] expected_data_rcv;
    logic [3:0] expected_fifo_empty;
    logic [3:0] expected_fifo_ae;
    logic [3:0] expected_fifo_af;
    logic [3:0] expected_fifo_full;

    task main;
        transaction trans;
        data_struct ds;
        set_reset_values();
        forever begin
            mon2scb.get(trans);
            trans.display("[Scoreboard]");
            packets_checked++;

            // changing of port addresses
            if (trans.port_en) begin
                if (trans.port_wr) begin
                    port_addresses[trans.port_sel] = trans.port_addr;
                end
            end

            // changing of port priorities
            if (trans.prio_wr)
                port_priorities[trans.port_sel] = trans.prio_val;

            // determination of port priority order
            for (int cur_port=0; cur_port<4; cur_port++) begin
                priority_order_position = 2'd0;
                for (int port=0; port<4; port++) begin
                    if (cur_port == port)
                        continue;
                    if ((port_priorities[cur_port] == port_priorities[port]
                            && cur_port > port) ||
                            (port_priorities[cur_port] < port_priorities[port])) begin
                        priority_order_position++;
                        // $display("HERE, cur_port %0d port %0d priority_order_position %0d", cur_port, port, priority_order_position);
                    end
                end
                priority_order[priority_order_position] = cur_port;
            end
            // for (int cur_port=0; cur_port<4; cur_port++) begin
            //     $display("----------- port_addresses[%0d] %0d ------", cur_port, port_addresses[cur_port]);
            //     $display("----------- priorities[%0d] %0d ------", cur_port, port_priorities[cur_port]);
            //     $display("----------- priority_order[%0d] %0d ------", cur_port, priority_order[cur_port]);
            //
            // end
            // $display("----------- port_addresses %p ------", port_addresses);
            // $display("----------- port priorities %p ------", port_priorities);
            // $display("----------- priority order %p ------", priority_order);

            // //display port_addresses
            // for (int i = 0; i < 4; i++) begin
            //     $display("port %0d: %0d", i, port_addresses[i]);
            // end

            // adding to data_fifo
            for (int port = 0; port < 4; port++) begin
                logic [1:0] input_port = priority_order[port];
                if (trans.wr_en[input_port]) begin
                    // TODO: what if there are two of the same address in the port's addresses?
                    for (int output_port = 0; output_port < 4; output_port++) begin
                        if (port_addresses[output_port] == trans.addr_in[input_port * 16 +:16]) begin
                            ds = '{trans.data_in[input_port * 16 +:16], input_port, 1'b0};
                            // $display("THERE, %0h, %0h", ds.data, ds.addr);
                            data_fifo[output_port].push_back(ds);
                            // $display("input port %0d output port %0d", port, output_port);
                            break;
                        end
                    end
                end
            end

            ////////////////////////////////////////////////////////////////////
            // getting expected values
            ////////////////////////////////////////////////////////////////////

            // data_out, addr_out
            for (int output_port = 0; output_port < 4; output_port++) begin
                if (trans.rd_en[output_port] && trans.data_rdy[output_port] &&
                        data_fifo[output_port][0].can_be_popped) begin
                    ds = data_fifo[output_port].pop_front();
                    // $display("HERE, %0h, %0h", ds.data, ds.addr);
                    expected_data_out[output_port * 16 +:16] = ds.data;
                    expected_addr_out[output_port * 16 +:16] = ds.addr;
                end
            end




            // // checking data_rcv
            // for (int input_port = 0; input_port < 4; input_port++) begin
            //
            // end

            // checking fifos
            for (int port = 0; port < 4; port++) begin
                if (data_fifo[port].size() == `EMPTY) begin
                    expected_fifo_empty[port] = 1'b1;
                end
                else if (data_fifo[port].size() < `ALMOST_EMPTY) begin
                    expected_fifo_empty[port] = 1'b0;
                    expected_fifo_ae[port] = 1'b1;

                end
                else if (data_fifo[port].size() >= `ALMOST_EMPTY &&
                        data_fifo[port].size() <= `ALMOST_FULL) begin
                    expected_fifo_ae[port] = 1'b0;
                    expected_fifo_af[port] = 1'b0;
                end
                else if (data_fifo[port].size() > `ALMOST_FULL &&
                        data_fifo[port].size() < `FULL) begin
                    expected_fifo_af[port] = 1'b1;
                    expected_fifo_full[port] = 1'b0;
                end
                else begin // FULL
                    expected_fifo_full[port] = 1'b1;
                end
            end

            // data_rdy
            for (int output_port = 0; output_port < 4; output_port++) begin
                // if (trans.rd_en[output_port] && prev_data_rdy[output_port])
                //     expected_data_rdy[output_port] = 1'b0;
                if (trans.fifo_empty[output_port] && !prev_fifo_empty[output_port])
                    expected_data_rdy[output_port] = 1'b1;
                else
                    expected_data_rdy[output_port] = ~expected_fifo_empty[output_port];
            end

            ////////////////////////////////////////////////////////////////////
                        // checking expected values
            ////////////////////////////////////////////////////////////////////

            for (int port=0; port<4; port++) begin
                display_results("data_out", port, expected_data_out[port * 16 +:16],
                    trans.data_out[port * 16 +:16]);
                display_results("addr_out", port, expected_addr_out[port * 16 +:16],
                    trans.addr_out[port * 16 +:16]);
                display_results("data_rdy", port, expected_data_rdy[port],
                    trans.data_rdy[port]);
                display_results("data_rcv", port, expected_data_rcv[port],
                    trans.data_rcv[port]);
                display_results("fifo_empty", port, expected_fifo_empty[port],
                    trans.fifo_empty[port]);
                display_results("fifo_ae", port, expected_fifo_ae[port],
                    trans.fifo_ae[port]);
                display_results("fifo_af", port, expected_fifo_af[port],
                    trans.fifo_af[port]);
                display_results("fifo_full", port, expected_fifo_full[port],
                    trans.fifo_full[port]);
            end



            // check addr_out and data_out


            // display_results("fifo_empty", port, 1'b0, trans.fifo_empty[port]);
            // display_results("fifo_ae", port, 1'b0, trans.fifo_ae[port]);
            // display_results("fifo_af", port, 1'b1, trans.fifo_af[port]);
            // display_results("fifo_full", port, 1'b0, trans.fifo_full[port]);
            for (int port=0; port<4; port++) begin
                if (data_fifo[port].size() > 0)
                    data_fifo[port][0].can_be_popped = 1'b1;
            end
            prev_fifo_empty = trans.fifo_empty;
            scb2gen.put();
        end
    endtask

    function void display_results(string name, int port, int expected, int result);
        string result_string;
        if (expected == result)
            result_string = "SUCCESS";
        else begin
            result_string = "FAILURE";
            error_count++;
            error_time_queue.push_front($time);
            `ifndef PRINT_SUCCESS
                $display("[Scoreboard]: %s - expected %s[%0d] = %1h, actual %s[%0d] = %1h",
                    result_string, name, port, expected, name, port, result);
            `endif
        end
        `ifdef PRINT_SUCCESS
            $display("[Scoreboard]: %s - expected %s[%0d] = %1h, actual %s[%0d] = %1h",
                result_string, name, port, expected, name, port, result);
        `endif
    endfunction

    function void set_reset_values();
        port_addresses[0] = 16'h0000;
        port_addresses[1] = 16'h0000;
        port_addresses[2] = 16'h0000;
        port_addresses[3] = 16'h0000;
        port_priorities[0] = 8'd0;
        port_priorities[1] = 8'd0;
        port_priorities[2] = 8'd0;
        port_priorities[3] = 8'd0;

        expected_data_out = 64'hZZZZ_ZZZZ_ZZZZ_ZZZZ;
        expected_addr_out = 64'hZZZZ_ZZZZ_ZZZZ_ZZZZ;
        expected_data_rdy = 4'b0000;
        expected_data_rcv = 4'b1111;
        expected_fifo_empty = 4'b1111;
        expected_fifo_ae = 4'b1111;
        expected_fifo_af = 4'b0000;
        expected_fifo_full = 4'b0000;
    endfunction

endclass
`endif // _SCOREBOARD_
