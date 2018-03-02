module Alu(input[31:0] op1,
		input[31:0] op2,
		input[2:0] f,
		output reg[31:0] result,
		output zero);

	always @(op1, op2, f)
		case (f)
			3'b000: result = op1 & op2;
			3'b001: result = op1 | op2;
			3'b010: result = op1 + op2;
			3'b011: result = 32'hxxxxxxxx;
			3'b100: result = op1 & ~op2;
			3'b101: result = op1 | ~op2;
			3'b110: result = op1 - op2;
			3'b111: result = op1 < op2;
		endcase
	
	assign zero = result == 0;
endmodule

