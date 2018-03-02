module PcRegister(input clock,
		input clear,
		input[31:0] in,
		output reg[31:0] out);

	// The initial value for the PC register is 0x400000;
	always @(posedge clear, negedge clock)
		if (clear)
			out = 32'h00400000;
		else
			out = in;
endmodule

