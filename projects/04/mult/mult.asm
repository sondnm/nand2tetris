// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

	@R2
	M=0    // Set 0 as intial RAM[2] value (aka sum value)
(LOOP)
	@R1
	D=M    // Load current RAM[1] aka counter value
	@END
	D;JEQ  // Jump to END if count == 0
	@R2
	D=M    // Load current sum value
	@R0
	D=D+M  // Accumulate current sum value with RAM[0] value
	@R2
	M=D    // Store result in RAM[2]
	@R1
	M=M-1  // Decrement counter by 1
	@LOOP
	0;JMP  // Jump back to loop
(END)
	@END
	0;JMP  // Loop forever (a way to terminate program)
