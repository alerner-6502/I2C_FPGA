
module ALU(A, B, S, C, Z);
	input [7:0] A, B;         // Operands
	input [1:0] S;            // Opcode
	output reg [7:0] C;           // Result
	output reg Z;                 // Flag
	
	always @ (*) begin
		case(S)
			2'h0 : begin C = A; 
						 Z = (A > B); 
				   end
			2'h1 : begin C = B - A; 
						 Z = (A != B);
				   end
			2'h2 : begin C = {B[6:0],A[0]}; 
			             Z = (A <= B);
				   end
			2'h3 : begin C = A & B; 
			             Z = |(A & B);
				   end
		endcase
	end
	
endmodule
	