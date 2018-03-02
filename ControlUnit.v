module ControlUnit(input[5:0] opcode,
		input[5:0] funct,
		output reg reg_dst,
		output reg reg_write,
		output reg alu_src,
		output reg[2:0] alu_op,
		output reg branch,
		output reg mem_write,
		output reg mem_to_reg
		output reg imm_extend);

	always @(opcode, funct) begin
		
		// Make sure that all output have an initial value assigned in
		// order to prevent synthesis of sequential logic.
		reg_dst = 1'bx;
		reg_write = 1'bx;
		alu_src = 1'bx;
		alu_op = 3'bxxx;
		branch = 1'bx;
		mem_write = 1'bx;
		mem_to_reg = 1'bx;
		imm_extend = 1'bx;

		// Check opcode
		case (opcode)

			// If opcode is 0, check funct
			6'h00: begin

				// Common signals
				reg_dst = 1;
				reg_write = 1;
				alu_src = 0;
				branch = 0;
				mem_write = 0;
				mem_to_reg = 0;
				imm_extend = 0;
			
				// ALU operation depends on funct
				case (funct)

					// add
					6'h20: begin
						alu_op = 3'b010;
						$display("\tInstruction 'add'");
					end

					// sub
					6'h22: begin
						alu_op = 3'b110;
						$display("\tInstruction 'sub'");
					end

					// slt
					6'h2a: begin
						alu_op = 3'b111;
						$display("\tInstruction 'slt'");
					end

					// and
					6'h24: begin
						alu_op = 3'b000;
						$display("\tInstruction 'and'");
					end

					// or
					6'h25: begin
						alu_op = 3'b001;
						$display("\tInstruction 'or'");
					end
				endcase
			end

			// lw
			6'h23: begin
				reg_dst = 0;
				reg_write = 1;
				alu_src = 1;
				alu_op = 3'b010;
				branch = 0;
				mem_write = 0;
				mem_to_reg = 1;
				imm_extend = 0;
				$display("\tInstruction 'lw'");
			end

			// sw
			6'h2b: begin
				reg_write = 0;
				alu_src = 1;
				alu_op = 3'b010;
				branch = 0;
				mem_write = 1;
				imm_extend = 0;
				$display("\tInstruction 'sw'");
			end

			// beq
			6'h04: begin
				reg_write = 0;
				alu_src = 0;
				alu_op = 3'b110;
				branch = 1;
				mem_write = 0;
				imm_extend = 0;
				$display("\tInstruction 'beq'");
			end

			// addi
			6'h09: begin
				reg_dst = 0;
				reg_write = 1;
				alu_src = 1;
				alu_op = 3'b010;
				branch = 0;
				mem_write = ;
				mem_to_reg = 0;
				imm_extend = 0;
			end

			// ori
			6'h0d: begin
				reg_dst = 0;
				reg_write = 1;
				alu_src = 1;
				alu_op = 3'b001;
				branch = 0;
				mem_write = 0;
				mem_to_reg = 0;
				imm_extend = 1;
			end

		endcase
	end
endmodule

