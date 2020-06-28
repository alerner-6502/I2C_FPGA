`timescale 10ns/100ps

module MAIN();


	//================================== I2C ROM =======================================

	
	reg i2c_clk, i2c_data;

	reg [7:0] i2c_rom [14881:0];          // 16K i2c rom
	reg [16:0] rom_cnt;                   // 14 bits needed to address the 16K rom
	
	
	initial begin
		$readmemh("my_roms/cleaner.mem", i2c_rom);      // loading the i2c rom
		rom_cnt = 0;
	end
	
	
	integer counter_data;                                                 // for saving counter-data on file
	initial begin                                                         // open csv-file for writing
		counter_data = $fopen("my_logs/my_log.csv");                      // open file
		$fmonitor(counter_data, "i2c_clk,i2c_data,master_data0,master_data1,master_clk");
	end
	
	
	//================================= MAIN CLOCK =====================================
	
	reg clk;
	
	initial begin
		clk = 1'b0;
	end
	
	//================================== CIRCUIT =======================================

	
	wire d_wired, s_data, s_clk;
	wire [7:0] o_port, i_port, master_data;
	
	assign d_wired = s_data & i2c_data;                               // wired AND gate
	
	
	SLAVE_MODULE mySLAVE(.d_in(i2c_data), 
	                     .d_out(s_data),
						 .c_in(i2c_clk),
						 .c_out(s_clk),
						 .clk(clk),
						 .o_port(o_port),
						 .i_port(i_port)	 
	);
				
	CPU myCPU(.D0(o_port), 
			  .P0(i_port), 
			  .D1(8'h00), 
			  .P1(master_data), 
			  .clk(clk)
	);
	 
	 
	
	//=========================== SIMULATION AND LOGGING ===============================
	
	always begin
		clk = ~clk;
		#1;
	end
	
	always begin
		{i2c_data, i2c_clk} = i2c_rom[rom_cnt];
		#25; rom_cnt = rom_cnt+1;
		
		$fmonitor( counter_data,"%b,%b,%b,%b,%b",
				   i2c_clk,
				   i2c_data,
				   master_data[0],
				   master_data[1],
				   i_port[7]
				 );
		
		if(rom_cnt == 14880) begin  //8424
			$fclose(counter_data);                      // close the file
			$stop;
		end
	end
	
	
	//================================== END =======================================

	
endmodule