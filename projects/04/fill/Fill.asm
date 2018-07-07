// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed.
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

	@8192 // total pixels (512 * 32) + (256 / 16)
	D=A
	@count // set count = 8192
	M=D
(LOOP)
	@index // set index = 0 as initial value
	M=0
(CHECK)
	@KBD // compare value in keyboard address, if equal to 0 then jump to white
	D=M
	@WHITE
	D;JEQ
(BLACK)
	@index
	D=M
	@SCREEN // access value in address {index}th from screen
	A=A+D
	M=-1 // set value to -1 which equal 1111111111111111
	@END
	0;JMP
(WHITE)
	@index
	D=M
	@SCREEN
	A=A+D
	M=0 // set value to 0
(END)
	@index // increment index
	MD=M+1
	@count
	D=D-M
	@LOOP // if index == count, jumpt to loop
	D;JEQ
	@CHECK // else check again
	0;JMP
