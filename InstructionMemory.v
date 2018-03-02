module InstructionMemory(input clock,
		input clear,
		input[31:0] address,
		output [31:0] instr);

	reg[31:0] content[255:0];
	integer i;
	
	always @(posedge clear, negedge clock)
		if (clear) begin

			// Reset content
			for (i = 0; i < 256; i = i + 1)
				content[i] = 0;

			// Initial values
			content[0] = 32'h22000001;	// addi $s0, $zero, 0x1
			content[1] = 32'h22108000;	// ori $s0, $s0, 0x8000
			content[2] = 32'h22100001;	// addi $s0, $s0, 1
		end

	// Read instruction
	assign instr = address >= 32'h400000 && address < 32'h4001000 ?
			content[(address - 32'h400000) >> 2] : 0;

	// Display current instruction
	always @(instr)
		$display("Fetch at PC %08x: instruction %08x", address, instr);
	
endmodule

