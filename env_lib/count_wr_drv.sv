

class count_wr_drv;

	virtual count_if.WR_DRV_MP wr_drv_if;

	count_trans data2duv;

	mailbox #(count_trans) gen2wr;

	function new(virtual count_if.WR_DRV_MP wr_drv_if,
		     mailbox #(count_trans) gen2wr);
		this.wr_drv_if = wr_drv_if;
		this.gen2wr = gen2wr;
	endfunction

	virtual task drive();

		@(wr_drv_if.WR_DRV_CB);
			wr_drv_if.WR_DRV_CB.data_in <= data2duv.data_in;
      		wr_drv_if.WR_DRV_CB.rst     <= data2duv.rst;
      		wr_drv_if.WR_DRV_CB.mode    <= data2duv.mode;
      		wr_drv_if.WR_DRV_CB.load    <= data2duv.load;
                       
   	endtask: drive
  
   	virtual task start();
      		fork
         	    forever
            		begin
 	                	gen2wr.get(data2duv);
               			drive();
            		end
      		join_none
   	endtask

endclass: count_wr_drv

