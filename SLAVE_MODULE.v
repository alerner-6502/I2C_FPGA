
module SLAVE_MODULE(d_in, d_out, c_in, c_out, clk, o_port, i_port);
	input d_in, c_in, clk;
	output reg d_out, c_out;
	input [7:0] i_port;
	output [7:0] o_port;
	
	reg [1:0] s0, s1;
	reg [4:0] pc;
	reg [7:0] rom[511:0], rom_out;

	
	initial begin
		s0 = 2'h3;
		s1 = 2'h3;
		pc = 5'h0;
		rom_out = 8'h0;
		$readmemh("my_roms/i2c_rom.mem", rom);
	end
	
	
	assign o_port = {4'h0, rom_out[2:1], s1};
	
	always @ (posedge clk) begin
		c_out <= ~(i_port[1] & rom_out[2] & ~rom_out[1]);
		case(rom_out[1:0])
			2'h0 : d_out <= 1'b1;
			2'h1 : d_out <= 1'b0;
			2'h2 : d_out <= i_port[0];
			2'h3 : d_out <= 1'b1;
		endcase
	end
	
	
	always @(negedge clk) begin
		rom_out <= rom[{pc,s1,s0}];
	end
	
	
	always @(posedge clk) begin
		pc <= rom_out[7:3];
		s1 <= s0;
		s0 <= {c_in,d_in};
		
	end
	
endmodule



