

class count_wr_mon;

	virtual count_if.WR_MON_MP wr_mon_if;

	count_trans data2rm;
	count_trans wrdata;

	mailbox #(count_trans) wr2rm;

   	function new(virtual count_if.WR_MON_MP wr_mon_if,
                 mailbox #(count_trans) wr2rm);
      		this.wr_mon_if = wr_mon_if;
      		this.wr2rm     = wr2rm;
      		this.wrdata    = new;
   	endfunction

   	virtual task monitor();

       		@(wr_mon_if.WR_MON_CB);
      		begin
         		wrdata.rst      = wr_mon_if.WR_MON_CB.rst;
         		wrdata.mode     = wr_mon_if.WR_MON_CB.mode;
				wrdata.load     = wr_mon_if.WR_MON_CB.load;
         		wrdata.data_in  = wr_mon_if.WR_MON_CB.data_in;
         		wrdata.display("\tDATA FROM WRITE MONITOR");
      		end
   	endtask: monitor
        
   	virtual task start();
      		fork
         	    forever
            		begin
               			monitor(); 
               			data2rm = new wrdata;
               			wr2rm.put(data2rm);
            		end
      		join_none
   	endtask: start

endclass: count_wr_mon

