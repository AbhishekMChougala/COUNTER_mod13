

module count_top();

    import count_pkg::*;

    parameter cycle = 10;
    
    reg clk;

    count_if DUV_IF(clk);

    count_test test_h;

    mod13_updown_counter DUT(.clk(clk), 
			     .rst(DUV_IF.rst),
			     .mode(DUV_IF.mode),
			     .load(DUV_IF.load), 					 
			     .data_in(DUV_IF.data_in), 
			     .count(DUV_IF.count)
			    );

    initial begin
		clk = 1'b0;
		forever #(cycle/2) clk = ~clk;
	end

    initial begin
		if($test$plusargs("TEST1"))
			begin
				test_h = new(DUV_IF, DUV_IF, DUV_IF);
				number_of_transactions = 100;
				test_h.build();
				test_h.run();
				$finish;
			end
	end
	
endmodule: count_top

