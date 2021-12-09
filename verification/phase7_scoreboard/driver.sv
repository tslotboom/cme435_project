`ifndef _DRIVER_

// `define PRINT_DRIVER

`define _DRIVER_
class driver;
    virtual intf.driver vif_driver;

    mailbox gen2driv;

    function new(virtual intf.driver vif_driver, mailbox gen2driv);
        this.vif_driver = vif_driver;

        this.gen2driv = gen2driv;
    endfunction

    int packets_driven;

    task main();
        forever begin
            transaction trans;
            gen2driv.get(trans);
            trans.reset = vif_driver.reset;

            trans.data_rcv = vif_driver.driver_cb.data_rcv;

            trans.fifo_empty = vif_driver.driver_cb.fifo_empty;
            trans.fifo_full = vif_driver.driver_cb.fifo_full;
            trans.fifo_ae = vif_driver.driver_cb.fifo_ae;
            trans.fifo_af = vif_driver.driver_cb.fifo_af;

            trans.data_out = vif_driver.driver_cb.data_out;
            trans.addr_out = vif_driver.driver_cb.addr_out;
            trans.data_rdy = vif_driver.driver_cb.data_rdy;
            `ifdef PRINT_DRIVER
                trans.display("[Driver]");
            `endif
            vif_driver.driver_cb.data_in <= trans.data_in;
            vif_driver.driver_cb.addr_in <= trans.addr_in;
            vif_driver.driver_cb.wr_en <= trans.wr_en;
            vif_driver.driver_cb.rd_en <= trans.rd_en;

            vif_driver.driver_cb.prio_val <= trans.prio_val;
            vif_driver.driver_cb.prio_wr <= trans.prio_wr;

            vif_driver.driver_cb.port_en <= trans.port_en;
            vif_driver.driver_cb.port_wr <= trans.port_wr;
            vif_driver.driver_cb.port_sel <= trans.port_sel;
            vif_driver.driver_cb.port_addr <= trans.port_addr;

            packets_driven++;
        end
    endtask
endclass
`endif // _DRIVER_
