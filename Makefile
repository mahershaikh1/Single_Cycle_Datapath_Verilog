EXE = main

SOURCES = \
		PcRegister.v \
		RegisterFile.v \
		DataMemory.v \
		InstructionMemory.v \
		Adder4.v \
		Alu.v \
		SignExtend.v \
		ShiftLeft.v \
		Adder.v \
		Mux.v \
		ControlUnit.v \
		Datapath.v \
		Main.v

$(EXE): $(SOURCES)
	iverilog -o $(EXE) $(SOURCES)

clean:
	rm -f $(EXE)



