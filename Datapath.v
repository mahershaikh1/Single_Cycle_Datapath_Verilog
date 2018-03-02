module Datapath(input clock,
		input clear);

	// PC register
	wire[31:0] pc_in;
	wire[31:0] pc_out;
	PcRegister pc_register(
			clock,
			clear,
			pc_in,
			pc_out);

	// Instruction memory
	wire[31:0] instruction_memory_address;
	wire[31:0] instruction_memory_instr;
	InstructionMemory instruction_memory(
			clock,
			clear,
			instruction_memory_address,
			instruction_memory_instr);
	
	// Connections for instruction memory
	assign instruction_memory_address = pc_out;
	
	// Adder4
	wire[31:0] adder4_in;
	wire[31:0] adder4_out;
	Adder4 adder4(adder4_in,
			adder4_out);
	
	// Connections for Adder4
	assign adder4_in = pc_out;
	
	// PC MUX
	wire[31:0] pc_mux_in0;
	wire[31:0] pc_mux_in1;
	wire[31:0] pc_mux_out;
	wire pc_mux_sel;
	Mux32Bit2To1 pc_mux(pc_mux_in0,
			pc_mux_in1,
			pc_mux_sel,
			pc_mux_out);
	
	// Connections for PC MUX
	assign pc_in = pc_mux_out;
	assign pc_mux_in0 = adder4_out;

	// Register file MUX
	wire[4:0] register_file_mux_in0;
	wire[4:0] register_file_mux_in1;
	wire[4:0] register_file_mux_out;
	wire register_file_mux_sel;
	Mux5Bit2To1 register_file_mux(
			register_file_mux_in0,
			register_file_mux_in1,
			register_file_mux_sel,
			register_file_mux_out);
	
	// Connections for register file MUX
	assign register_file_mux_in0 = instruction_memory_instr[20:16];
	assign register_file_mux_in1 = instruction_memory_instr[15:11];

	// Register file
	wire[4:0] register_file_read_index1;
	wire[31:0] register_file_read_data1;
	wire[4:0] register_file_read_index2;
	wire[31:0] register_file_read_data2;
	wire register_file_write;
	wire[4:0] register_file_write_index;
	wire[31:0] register_file_write_data;
	RegisterFile register_file(
			clock,
			clear,
			register_file_read_index1,
			register_file_read_data1,
			register_file_read_index2,
			register_file_read_data2,
			register_file_write,
			register_file_write_index,
			register_file_write_data);
	
	// Connections for register file
	assign register_file_read_index1 = instruction_memory_instr[25:21];
	assign register_file_read_index2 = instruction_memory_instr[20:16];
	assign register_file_write_index = register_file_mux_out;

	// ALU MUX
	wire[31:0] alu_mux_in0;
	wire[31:0] alu_mux_in1;
	wire[31:0] alu_mux_out;
	wire alu_mux_sel;
	Mux32Bit2To1 alu_mux(
			alu_mux_in0,
			alu_mux_in1,
			alu_mux_sel,
			alu_mux_out);
	
	// Connections for ALU MUX
	assign alu_mux_in0 = register_file_read_data2;

	// ALU
	wire[31:0] alu_op1;
	wire[31:0] alu_op2;
	wire[2:0] alu_f;
	wire[31:0] alu_result;
	wire alu_zero;
	Alu alu(alu_op1,
			alu_op2,
			alu_f,
			alu_result,
			alu_zero);
	
	// Connections for ALU
	assign alu_op1 = register_file_read_data1;
	assign alu_op2 = alu_mux_out;

	// Data memory
	wire[31:0] data_memory_address;
	wire data_memory_write;
	wire[31:0] data_memory_write_data;
	wire[31:0] data_memory_read_data;
	DataMemory data_memory(
			clock,
			clear,
			data_memory_address,
			data_memory_write,
			data_memory_write_data,
			data_memory_read_data);

	// Connections for data memory
	assign data_memory_address = alu_result;
	assign data_memory_write_data = register_file_read_data2;

	// Data memory MUX
	wire[31:0] data_memory_mux_in0;
	wire[31:0] data_memory_mux_in1;
	wire data_memory_mux_sel;
	wire[31:0] data_memory_mux_out;
	Mux32Bit2To1 data_memory_mux(
			data_memory_mux_in0,
			data_memory_mux_in1,
			data_memory_mux_sel,
			data_memory_mux_out);
	
	// Connections for data memory MUX
	assign data_memory_mux_in0 = alu_result;
	assign data_memory_mux_in1 = data_memory_read_data;
	assign register_file_write_data = data_memory_mux_out;

	// SignExtend
	wire[15:0] sign_extend_in;
	wire[31:0] sign_extend_out;
	SignExtend sign_extend(
			sign_extend_in,
			sign_extend_out);
	
	// Connections for SignExtend
	assign sign_extend_in = instruction_memory_instr[15:0];
	
	// ZeroExtend
	wire[15:0] zero_extend_in;
	write[31:0] zero_extend_out;
	ZeroExtend zero_extend(
			zero_extend_in,
			zero_extend_out);

	// Connections for ZeroExtend
	assign zero_extend_in = instruction_memory_instr[15:0];

	// Extend MUX
	wire[31:0] extend_mux_in0;
	wire[31:0] extend_mux_in1;
	wire[31:0] extend_mux_out;
	wire extend_mux_sel;
	Mux32Bit2To1 extend_mux(
			extend_mux_in0,
			extend_mux_in1,
			extend_mux_sel,
			extend_mux_out);
	
	// Connections for Extend MUX
	assign extend_mux_in0 = sign_extend_out;
	assign extend_mux_in1 = zero_extend_out;
	assign alu_mux_in1 = extend_mux_out;
	
	// ShiftLeft
	wire[31:0] shift_left_in;
	wire[31:0] shift_left_out;
	ShiftLeft shift_left(
			shift_left_in,
			shift_left_out);
	
	// Connections for ShiftLeft
	assign shift_left_in = sign_extend_out;

	// Adder
	wire[31:0] adder_op1;
	wire[31:0] adder_op2;
	wire[31:0] adder_result;
	Adder adder(adder_op1,
			adder_op2,
			adder_result);
	
	// Connections for adder
	assign adder_op1 = shift_left_out;
	assign adder_op2 = adder4_out;
	assign pc_mux_in1 = adder_result;

	// And gate
	wire and_gate_in1;
	wire and_gate_in2;
	wire and_gate_out;
	and and_gate(and_gate_out,
			and_gate_in1,
			and_gate_in2);
	
	// Connections for and gate
	assign and_gate_in2 = alu_zero;
	assign pc_mux_sel = and_gate_out;

	// Control unit
	wire[5:0] control_unit_opcode;
	wire[5:0] control_unit_funct;
	wire control_unit_reg_dst;
	wire control_unit_reg_write;
	wire control_unit_alu_src;
	wire[2:0] control_unit_alu_op;
	wire control_unit_branch;
	wire control_unit_mem_write;
	wire control_unit_mem_to_reg;
	wire control_unit_imm_extend;
	ControlUnit control_unit(
			control_unit_opcode,
			control_unit_funct,
			control_unit_reg_dst,
			control_unit_reg_write,
			control_unit_alu_src,
			control_unit_alu_op,
			control_unit_branch,
			control_unit_mem_write,
			control_unit_mem_to_reg,
			control_unit_imm_extend);
	
	// Connections for control unit
	assign control_unit_opcode = instruction_memory_instr[31:26];
	assign control_unit_funct = instruction_memory_instr[5:0];
	assign register_file_mux_sel = control_unit_reg_dst;
	assign register_file_write = control_unit_reg_write;
	assign alu_mux_sel = control_unit_alu_src;
	assign extend_mux_sel = control_unit_imm_extend;
	assign alu_f = control_unit_alu_op;
	assign and_gate_in1 = control_unit_branch;
	assign data_memory_write = control_unit_mem_write;
	assign data_memory_mux_sel = control_unit_mem_to_reg;

endmodule

