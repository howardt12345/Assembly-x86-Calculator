TITLE			Assembly x86 Calculator;					//The Title.

INCLUDE			Irvine32.inc;								//Includes the Irvine32 Library.

.data
;															//Strings:
prompt_1		BYTE	"First Number:  ",		0;				//Prompt for first number.
prompt_2		BYTE	"Second Number: ",		0;				//Prompt for second number.
prompt_3		BYTE	"Operator (1 for add, 2 for subtract, 3 for multiply, 4 for divide): ",		0;	//Prompt for operator.
loop_prompt		BYTE	"Would you like to perform another calculation? 1 for YES or 0 for NO: ",	0;	//Prompt for loop.
invalid			BYTE	"Invalid input.",		0;				//Invalid input.
cannotDivide	BYTE	"Numbers cannot be negative or zero.",		0;									//Cannot divide numbers error.
goodbye			BYTE	"Goodbye.",				0;				//Goodbye message.

equals			BYTE	" = ", 0;								//Equals String.
sum				BYTE	" + ", 0;								//String for addition symbol.
diff			BYTE	" - ", 0;								//String for subtraction symbol.
multi			BYTE	" * ", 0;								//String for multiplication symbol.
divi			BYTE	" / ", 0;								//String for division symbol.
dot				BYTE	"."	 , 0;								//String for decimal point.

;															//Predefined values:
Operations		DWORD	4		;								//The number of operations.
precision		DWORD	1000000	;								//The precision of the floating point number result.

;															//User inputted data:
firstNum		DWORD	?		;								//The first number.
secondNum		DWORD	?		;								//The second number.
opt				DWORD	?		;								//The operator.
bigInt			DWORD	0		;								//represents the floating point number multiplied by precision
;															//Calculated results:
result			DWORD	?		;								//The Result.
resultDiv		REAL4	?		;								//The Result of division.
firstPart		DWORD	?		;								//The part of the quotient before the decimal place.
secondPart		DWORD	?		;								//The part of the quotient after the decimal place.
remainder		DWORD	?		;
temp			DWORD	?		;

.code

main	PROC;												//The main procedure.
	
	ReadInput:;												//Reading data:
		MOV		edx,			offset prompt_1;				//Puts memory address of prompt_1 in register edx.
		CALL	WriteString;									//Writes the String in register edx.

		CALL	ReadInt;										//Reads an integer to register eax.
		MOV		firstNum,		eax;							//Stores read integer in firstNum.

		MOV		edx,			offset prompt_2;				//Puts memory address of prompt_2 in register edx.
		CALL	WriteString;									//Writes the String in register edx.

		CALL	ReadInt;										//Reads an integer to register eax.
		mov		secondNum,		eax;							//Stores read integer in secondNum.

		MOV		edx,			offset prompt_3;				//Puts memory address of prompt_3 in register edx.
		CALL	WriteString;									//Writes the String in register edx.

		CALL	ReadInt;										//Reads an integer to register eax.
		MOV		opt,			eax;							//Stores read integer in opt.


	ConditionalJumps:;										//Conditional jumps:
		MOV		eax,			opt;							//Puts value of opt in register eax.
		MOV		ecx,			Operations;						//Puts value of Operations in register ecx.
		MOV		edx,			offset invalid;					//Puts memory address of invalid in register edx.
;		//Check if opt is within bounds.
		CMP		eax,			0;								//Compare eax to 0.
		JLE		InvalidResponse;								//Jumps to InvalidResponse if less than or equal to 0.
		CMP		eax,			ecx;							//Compare eax to ecx.
		JG		InvalidResponse;								//Jumps to InvalidResponse if greater than ecx.

		CMP		eax,			1;								//Compare eax to 1.
		JE		Addition;										//Jump to Addition if equal to 1.

		CMP		eax,			2;								//Compare eax to 2.
		JE		Subtraction;									//Jump to Subtraction if equal to 2.

		CMP		eax,			3;								//Compare eax to 3.
		JE		Multiplication;									//Jump to Multiplication if equal.

		CMP		eax,			4;								//Compare eax to 4.
		JE		Division;										//Jump to Division if equal.


	Addition:;												//Addition:
;		//Calculation:
		MOV		eax,			firstNum;						//Puts value of firstNum in register eax.
		ADD		eax,			secondNum;						//Adds the value of secondNum to register eax.
		MOV		result,			eax;							//Stores value of eax in result.
;		//Print result.
		MOV		eax,			firstNum;						//Puts value of firstNum in register eax.
		CALL	WriteInt;										//Writes the integer.
		MOV		edx,			offset sum;						//Puts memory address of sum in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		MOV		eax,			secondNum;						//Puts value of secondNum in register eax.
		CALL	WriteInt;										//Writes the integer.
		MOV		edx,			offset equals;					//Puts memory address of equals in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		MOV		eax,			result;							//Puts value of result in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.

		CALL	CrLf;											//New Line.
		JMP		JumpToLoop;										//Jump to JumpToLoop.


	Subtraction:;											//Subtraction:
;		//Calculation:
		MOV		eax,			firstNum;						//Puts value of firstNum in register eax.
		SUB		eax,			secondNum;						//Subtracts the value of secondNum from register eax.
		MOV		result,			eax;							//Stores value of eax in result.
;		//Print result.
		MOV		eax,			 firstNum;						//Puts value of firstNum in register eax.
		CALL	WriteInt;										//Writes the integer.
		MOV		edx,			offset diff;					//Puts memory address of diff in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		MOV		eax,			secondNum;						//Puts value of secondNum in register eax.
		CALL	WriteInt;										//Writes the integer.
		MOV		edx,			offset equals;					//Puts memory address of equals in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		MOV		eax,			result;							//Puts value of result in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.

		CALL	CrLf;											//New Line.
		JMP		JumpToLoop;										//Jump to JumpToLoop.


	Multiplication:;										//Multiplication:
;		//Calculation:
		MOV		eax,			firstNum;						//Puts value of firstNum in register eax.
		MOV		ebx,			secondNum;						//Puts value of secondNum in register ebx.
		MUL		ebx;											//Multiplies the value in eax with the value in ebx.
		MOV		result,			eax;							//Stores value of eax in result.
;		//Print result.
		MOV		eax,			firstNum;						//Puts value of firstNum in register eax.
		CALL	WriteInt;										//Writes the integer.
		MOV		edx,			offset multi;					//Puts memory address of multi in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		MOV		eax,			secondNum;						//Puts value of secondNum in register eax.
		CALL	WriteInt;										//Writes the integer.
		MOV		edx,			offset equals;					//Puts memory address of equals in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		MOV		eax,			result;							//Puts value of result in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.

		CALL	CrLf;											//New Line.
		JMP		JumpToLoop;										//Jump to JumpToLoop.


	Division:;												//Division:
;		//Checks if numbers can be divided:
		MOV		edx,			offset cannotDivide;			//Puts memory address of cannotDivide in register edx.
		MOV		eax,			firstNum;						//Puts value of firstNum in register eax.
		CMP		eax,			0;								//Compare eax with 0.
		JLE		InvalidResponse;								//Jumps to InvalidResponse if less than or equal to 0.
		MOV		eax,			secondNum;						//Puts value of secondNum in register eax.
		CMP		eax,			0;								//Compare eax with 0.
		JLE		InvalidResponse;								//Jumps to InvalidResponse if less than or equal to 0.
;		//Calculation:
		FLD		firstNum;										//Load firstNum into ST(0).
		FDIV	secondNum;										//Divide firstNum by secondNum.
		FIMUL	precision;										//Multiplies value by precision.
		FRNDINT;												//Rounds the value in ST(0) to the nearest integral value.
		FIST	bigInt;											//Stores integer in bigInt.
		FST		resultDiv;										//Stores value of ST(0) in resultDiv.
;		//Print result.
		MOV		eax,			firstNum;						//Puts value of firstNum in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
		MOV		edx,			offset divi;					//Puts memory address of divi in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		MOV		eax,			secondNum;						//Puts value of secondNum in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
		MOV		edx,			offset equals;					//Puts memory address of equals in register edx.
		CALL	WriteString;									//Writes the String in register edx.

		MOV		edx,			0;								//Puts 0 in register edx.
		MOV		eax,			bigInt;							//Puts value of bigInt in register eax.
		CDQ;													//Sign-extend eax to edx.
		MOV		ebx,			precision;						//Puts value of precision in register ebx.
		CDQ;													//Sign-extend eax to edx.
		DIV		ebx;											//Divides eax by ebx.
		MOV		firstPart,		eax;							//Stores value of eax in firstPart.
		MOV		remainder,		edx;							//Stores value of edx in remainder.

		MOV		eax,			firstPart;						//Puts value of firstPart in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
		MOV		edx,			offset dot;						//Puts memory address of dot in register edx.					
		CALL	WriteString;									//Writes the String in register edx.

		MOV		eax,			firstPart;						//Puts value of firstPart in register eax.
		MUL		precision;										//Multiply eax by precision.
		MOV		temp,			eax;							//Stores value of eax in temp.
		MOV		eax,			bigInt;							//Puts value of bigInt in register eax.
		SUB		eax,			temp;							//Subtracts the value of temp from register eax.
		MOV		secondPart,		eax;							//Stores the value of eax in secondPart.
		CALL	WriteDec;										//Writes the integer in register eax.

		CALL	CrLf;											//New Line.
		JMP		JumpToLoop;										//Jump to JumpToLoop.


	JumpToLoop:;											//Loops until user quits:
		MOV		edx,			offset loop_prompt;				//Puts memory address of loop_response in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		CALL	ReadInt;										//Reads an integer to register eax.

		MOV		edx,			offset invalid;					//Puts memory address of invalid in register edx.

		CMP		eax,			0;								//Compares eax to 0.
		JE		ExitProgram;									//Jumps to ExitProgram if equal to 0.
		JL		InvalidResponse;								//Jumps to InvalidResponse if less than 0.

		CMP		eax,			1;								//Compares eax to 1.
		JE		ReadInput;										//Jump to ReadInput if equal to 1.
		JL		InvalidResponse;								//Jumps to InvalidResponse if greater than 1.


	InvalidResponse:;										//Invalid response:
		CALL	WriteString;									//Writes the String in register edx.
		CALL	CrLf;											//New Line.
		JMP		JumpToLoop;										//Jump to JumpToLoop.


	ExitProgram:;											//Exits the program:
		MOV		edx,			offset goodbye;					//Puts memory address of goodbye in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		CALL	CrLf;											//New Line.
		exit;													//Exits the program.


main	ENDP;												//End main procedure.


END		main;											//End program.