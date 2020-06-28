
module CPU(D0, P0, D1, P1, clk);
	input [7:0] D0, D1;
	output reg [7:0] P0, P1;
	input clk;
	
	reg [7:0] ram[511:0], ram_out;
	reg [7:0] PC,X,A,IR;
	reg F,T;
	
	reg [7:0] address, data;
	reg bk, p, a, x, r, p0, p1, t;
	reg [1:0] dt;
	wire [7:0] alu;
	wire f;
	
	ALU myALU(ram_out, data, IR[7:6], alu, f);
	
	initial begin
		P0 = 8'hff;
		P1 = 8'hff;
		PC = 8'h00;                           //!!!!!!!!!!!!
		IR = 8'h00;
		X = 8'h00;
		A = 8'h00;
		T = 1'b1;
		F = 1'b0;
		ram_out = 8'h00;
		$readmemh("my_roms/cpu_rom.mem", ram);   //!!!!!!!!!!!!
	end
	
	
	always @ (*) begin                 // operands decoder
		case(IR[5:3])
			3'h0 : {bk,p,dt} = 4'b0000;
			3'h1 : {bk,p,dt} = 4'b0001;
			3'h2 : {bk,p,dt} = 4'b0010;
			3'h3 : {bk,p,dt} = 4'b0011;
			3'h4 : {bk,p,dt} = 4'b1101;
			3'h5 : {bk,p,dt} = 4'b0101;
			3'h6 : {bk,p,dt} = 4'b0110;
			3'h7 : {bk,p,dt} = 4'b1111;
		endcase

		case(IR[2:0])
			3'h0 : {a,x,r,p0,p1,t} = 6'b000000;
			3'h1 : {a,x,r,p0,p1,t} = 6'b100000;
			3'h2 : {a,x,r,p0,p1,t} = 6'b010000;
			3'h3 : {a,x,r,p0,p1,t} = 6'b001000;
			3'h4 : {a,x,r,p0,p1,t} = 6'b000100;
			3'h5 : {a,x,r,p0,p1,t} = 6'b000010;
			3'h6 : {a,x,r,p0,p1,t} = 6'b000001;
			3'h7 : {a,x,r,p0,p1,t} = {5'b00000,F};
		endcase

		case(dt)
			2'h0 : data = X;
			2'h1 : data = A;
			2'h2 : data = D0;
			2'h3 : data = D1;
		endcase
		
		address = (p ? X : PC); 
	end
	
	always @ (negedge clk) begin
		ram_out <= ram[{bk,address}];
	end
	
	always @ (posedge clk) begin          // RAM storage
		T <= ~T;

		IR <= (T ? 8'h00 : alu);

		if(T) F <= f;

		if(x)  X <= alu;

		if(a)  A <= alu;

		if(p0) P0 <= alu;

		if(p1) P1 <= alu;

		if(r) ram[{bk,address}] <= data;

		if(t) PC <= alu;
		else if(~p) PC <= PC + 8'h01;
	end 

endmodule










