

interface count_if(input bit clk);

	logic rst, mode, load;
	logic [3:0] data_in, count;
	
	parameter tsetup = 1,
			  thold  = 1;

	clocking WR_DRV_CB @(posedge clk);
		default input #(tsetup) output #(thold);
		output rst;
		output mode;
		output load;
		output data_in;
	endclocking

	clocking WR_MON_CB @(posedge clk);
		default input #(tsetup) output #(thold);
		input rst;
		input mode;
		input load;
		input data_in;
	endclocking

	clocking RD_MON_CB @(posedge clk);
		default input #(tsetup) output #(thold);
		input count;
	endclocking
	
	modport WR_DRV_MP(clocking WR_DRV_CB);	
	modport WR_MON_MP(clocking WR_MON_CB);	
	modport RD_MON_MP(clocking RD_MON_CB);	

endinterface: count_if

    
