module DataMemory(input clock,
		input clear,
		input[31:0] address,
		input write,
		input[31:0] write_data,
		output[31:0] read_data);

	// We model 1KB of data memory
	reg[31:0] content[255:0];
	integer i;
	
	always @(posedge clear, negedge clock)
		if (clear) begin

			// Reset memory
			for (i = 0; i < 256; i = i + 1)
				content[i] = 0;

			// Initial values
			// Mem[0x10010000] = 100
			// Mem[0x10010004] = 200
			content[0] = 100;
			content[1] = 200;

		end else if (write
				&& address >= 32'h10010000
				&& address < 32'h10011000)
		begin

			// Valid addresses
			content[(address - 32'h10001000) >> 2] = write_data;
			$display("\tM[%x] = %x (hex)", address, write_data);
		end

	// Return 0 if address is not valid
	assign read_data = address >= 32'h10010000
			&& address < 32'h10011000 ?
			content[(address - 32'h10010000) >> 2] : 0;
	
endmodule

