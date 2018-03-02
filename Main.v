// This is the test-bench for the single-cycle datapath supporting instructions
// add, sub, slt, and, or, lw, sw, beq. When sequential logic components are
// sent an asynchronous reset signal (clear), their content is set to the
// following values:
//
// * The initial value of register PC is 0x400000.
//
// * The initial value of all registers are 0, except for the following
//   registers:
//
//	$1 = 1
//	$2 = 2
//	#3 = 0x10010000 (base address of data segment)
//
// * The data memory is initialized with the following words:
//
//	[0x10010000] = 100
//	[0x10010004] = 200
//
// * The instruction memory has been initialized to contain the following
//   program:
//
//	main:
// 		add $3, $1, $2		# $3 = 1 + 2 = 3
// 		sub $3, $1, $2		# $3 = 1 - 2 = -1
// 		and $3, $1, $2		# $3 = 1 & 2 = 0
// 		or $3, $1, $2		# $3 = 1 | 2 = 3
// 		slt $3, $1, $2		# $3 = 1 < 2 = 1 (true)
// 		slt $3, $2, $1		# $3 = 2 < 1 = 0 (false)
// 		beq $10, $zero, main	# Doesn't jump, $10 is 0x10010000
// 		lw $3, 0($10)		# $3 = Mem[0x10010000] = 100
// 		lw $3, 4($10)		# $3 = Mem[0x10010004] = 200
// 		sw $3, 8($10)		# Mem[0x10010008] = 200
// 		beq $zero, $zero, main	# Jumps to main
// 
module Main;

	// The datapath
	reg clock;
	reg clear;
	Datapath datapath(clock, clear);

	// Initial pulse for 'clear'
	initial begin
		clear = 1;
		#5 clear = 0;
	end

	// Clock signal
	initial begin
		clock = 1;
		forever #5 clock = ~clock;
	end

	// Run for 3 cycles
	initial begin
		#30 $finish;
	end
endmodule
