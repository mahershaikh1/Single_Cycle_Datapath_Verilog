module Mux32Bit2To1(input[31:0] in0,
		input[31:0] in1,
		input sel,
		output[31:0] out);

	assign out = sel ? in1 : in0;

endmodule

module Mux5Bit2To1(input[4:0] in0,
		input[4:0] in1,
		input sel,
		output[4:0] out);

	assign out = sel ? in1 : in0;

endmodule

