

class count_trans;

	rand bit rst;
	rand bit mode;
	rand bit load;
	rand bit [3:0]data_in;
	
	logic [3:0]count;
	
	static int trans_id;
	static int no_of_mode_trans;
	static int no_of_load_trans;
	
	constraint VALID_RESET{rst dist{0 := 95, 1 := 5};}
	constraint VALID_MODE{mode dist{0 := 50, 1 := 50};}
	constraint VALID_LOAD{load dist{0 := 20, 1 := 80};}
	constraint VALID_DATA{data_in inside{[0:12]};}
	
	function void display(input string message);
		$display("\n");
		$display("%s", message);
		$display("\tTransaction Number: %d", trans_id);
		$display("\tReset = %d", rst);
		$display("\tMode  = %d", mode);
		$display("\tLoad  = %d", load);
		$display("\tData  = %d", data_in);
		$display("\tCount = %d", count);
		$display("\tNo. of Load trans : %d",no_of_load_trans);
		$display("\tNo. of Mode trans : %d",no_of_mode_trans);
	endfunction
	
	function void post_randomize();
		if (this.mode == 1)
			no_of_mode_trans++;
		if (this.load == 1)
			no_of_load_trans++;
		this.display("\tRANDOMIZED DATA");
	endfunction
	
endclass: count_trans

