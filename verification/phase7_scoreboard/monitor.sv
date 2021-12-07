`ifndef _MONITOR_
`define _MONITOR_
class monitor;
    virtual intf.monitor vif_monitor;

    mailbox mon2scb;

    function new (virtual intf.monitor vif_monitor, mailbox mon2scb);
        this.vif_monitor = vif_monitor;

        this.mon2scb = mon2scb;
    endfunction

    task main;
        forever begin
            transaction trans;
            trans = new();
            @(posedge vif_monitor.clk);

            trans.reset = vif_monitor.reset;

            trans.addr_in = vif_monitor.monitor_cb.addr_in;
            trans.addr_out = vif_monitor.monitor_cb.addr_out;
            trans.data_in = vif_monitor.monitor_cb.data_in;
            trans.data_out = vif_monitor.monitor_cb.data_out;

            trans.data_rcv = vif_monitor.monitor_cb.data_rcv;
            trans.data_rdy = vif_monitor.monitor_cb.data_rdy;
            trans.wr_en = vif_monitor.monitor_cb.wr_en;
            trans.rd_en = vif_monitor.monitor_cb.rd_en;

            trans.fifo_empty = vif_monitor.monitor_cb.fifo_empty;
            trans.fifo_full = vif_monitor.monitor_cb.fifo_full;
            trans.fifo_ae = vif_monitor.monitor_cb.fifo_ae;
            trans.fifo_af = vif_monitor.monitor_cb.fifo_af;

            trans.prio_val = vif_monitor.monitor_cb.prio_val;
            trans.prio_wr = vif_monitor.monitor_cb.prio_wr;
            trans.port_en = vif_monitor.monitor_cb.port_en;
            trans.port_wr = vif_monitor.monitor_cb.port_wr;
            trans.port_sel = vif_monitor.monitor_cb.port_sel;
            trans.port_addr = vif_monitor.monitor_cb.port_addr;

            mon2scb.put(trans);
            // trans.display("[Monitor]");
        end
    endtask

endclass
`endif // _MONITOR_
