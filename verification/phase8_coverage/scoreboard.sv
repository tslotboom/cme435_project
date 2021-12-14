`ifndef _SCOREBOARD_
`define _SCOREBOARD_

// `define PRINT_SUCCESS
`define STOP_ON_ERROR

`define EMPTY 9'd0
`define ALMOST_EMPTY 9'd64
`define ALMOST_FULL 9'd192
`define FULL 9'd256
`include "phase8_coverage.sv"
`include "transaction.sv"
class scoreboard;

    mailbox mon2scb;

    mailbox scb2gen;

    function new(mailbox mon2scb, mailbox scb2gen);
        this.mon2scb = mon2scb;
        this.scb2gen = scb2gen;
    endfunction


    int packets_checked;

    int error_count;
    int error_time_queue[$] = {};

    string error_message;

    bit reset_flag = 1'b1;

    // prev values of DUT
    logic [3:0] prev_fifo_empty = 4'b1111;
    logic [3:0] prev_fifo_full = 4'b1111;

    // expected values within DUT:
    typedef struct {
        logic [63:0] data;
        logic [63:0] addr;
        bit can_be_popped; // packets take 1 clock cycle to go from input to output
    } data_struct;

    transaction trans;
    coverage cov = new();
    data_struct ds;

    data_struct data_fifo [4][$];
    logic [15:0] port_addresses [4];
    // internal priorities of each port
    logic [7:0] port_priorities [4];
    // order in which ports should be accessed, based on priority. 0th index
    // gets accessed first
    logic [1:0] priority_order [4];
    logic [1:0] priority_order_position;
    bit address_valid;

    logic [63:0] expected_data_out;
    logic [63:0] expected_addr_out;
    logic [3:0] expected_data_rdy;
    logic [3:0] expected_data_rcv;
    logic [3:0] expected_fifo_empty;
    logic [3:0] expected_fifo_ae;
    logic [3:0] expected_fifo_af;
    logic [3:0] expected_fifo_full;

    task main;
        forever begin
            mon2scb.get(trans);
            cov.sample(trans);
            packets_checked++;

            if (reset_flag)
                set_reset_values();
            else begin
                set_internal_values();
                get_expected_outputs();
            end

            trans.display("[Scoreboard]");

            check_expected_vs_actual();

            for (int port=0; port<4; port++) begin
                if (data_fifo[port].size() > 0)
                    data_fifo[port][0].can_be_popped = 1'b1;
            end
            prev_fifo_empty = trans.fifo_empty;
            prev_fifo_full = trans.fifo_full;
            scb2gen.put(port_addresses);
        end
    endtask

    task wait_for_reset;
        forever begin
            wait(tbench_top.reset == 1'b1);
            $display("[Scoreboard]: Reset caught at %0d", $time);
            reset_flag = 1'b1;
            wait(reset_flag == 1'b0);
        end
    endtask

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
        for (int port=0; port<4; port++)
            while (data_fifo[port].size() > 0)
                data_fifo[port].pop_front();
        reset_flag = 1'b0;
    endfunction

    function void set_internal_values();
        // changing of port addresses
        if (trans.port_en) begin
            if (trans.port_wr) begin
                port_addresses[trans.port_sel] = trans.port_addr;
            end
        end
        trans.port_addresses = port_addresses;

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

        // adding to data_fifo
        for (int port = 0; port < 4; port++) begin
            logic [1:0] input_port = priority_order[port];
            if (trans.wr_en[input_port]) begin
                // TODO: what if there are two of the same address in the port's addresses?
                for (int output_port = 0; output_port < 4; output_port++) begin
                    if (port_addresses[output_port] == trans.addr_in[input_port * 16 +:16] &&
                            data_fifo[output_port].size() != `FULL) begin
                        ds = '{trans.data_in[input_port * 16 +:16], input_port, 1'b0};
                        // $display("THERE, %0h, %0h", ds.data, ds.addr);
                        data_fifo[output_port].push_back(ds);
                        // $display("input port %0d output port %0d", port, output_port);
                        break;
                    end
                end
            end
        end
    endfunction

    function void get_expected_outputs();
        // data_out, addr_out
        for (int output_port = 0; output_port < 4; output_port++) begin
            if (trans.rd_en[output_port] && trans.data_rdy[output_port] &&
                    data_fifo[output_port].size() > 0 &&
                    data_fifo[output_port][0].can_be_popped) begin
                ds = data_fifo[output_port].pop_front();
                // $display("HERE, %0h, %0h", ds.data, ds.addr);
                expected_data_out[output_port * 16 +:16] = ds.data;
                expected_addr_out[output_port * 16 +:16] = ds.addr;
            end
        end

        // data_rcv
        for (int input_port = 0; input_port < 4; input_port++) begin
            address_valid = 1'b1;
            for (int port=0; port<4; port++) begin
                if (trans.addr_in[port] == port_addresses[port])
                    address_valid = 1'b1;
            if (!address_valid)
                expected_data_rcv[port] = 1'b0;
            else
                if (trans.wr_en[port])
                    if (trans.fifo_full[port] && prev_fifo_full[port])
                        expected_data_rcv[port] = 1'b0;
                    else
                        expected_data_rcv[port] = 1'b1;
                end
        end

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
            // if (!trans.fifo_empty[output_port])
            //     expected_data_rdy[output_port] = 1'b1;
            if (trans.fifo_empty[output_port] && !prev_fifo_empty[output_port])
                expected_data_rdy[output_port] = 1'b1;
            else
                expected_data_rdy[output_port] = ~expected_fifo_empty[output_port];
        end
    endfunction

    function void check_expected_vs_actual();
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
    endfunction

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
            `ifdef STOP_ON_ERROR
                $stop;
            `endif
        end
        `ifdef PRINT_SUCCESS
            $display("[Scoreboard]: %s - expected %s[%0d] = %1h, actual %s[%0d] = %1h",
                result_string, name, port, expected, name, port, result);
        `endif
    endfunction

endclass
`endif // _SCOREBOARD_
