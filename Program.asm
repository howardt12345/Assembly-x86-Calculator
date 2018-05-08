TITLE			Assembly x86 Calculator;					//The Title.

INCLUDE			Irvine32.inc;								//Includes the Irvine32 Library.

.data
;															//Strings:
prompt_1		BYTE	"Operation (1 for add, 2 for subtract, 3 for multiply, 4 for divide): ", 0;	//Prompt for operation.
prompt_2		BYTE	"First Number:  ",		0;				//Prompt for first number.
prompt_3		BYTE	"Second Number: ",		0;				//Prompt for second number.
prompt_4		BYTE	"Number: ",				0;				//Prompt for prime number generation.
loop_prompt		BYTE	"Would you like to perform another calculation? 1 for YES or 0 for NO: ",	0;	//Prompt for loop.
invalid			BYTE	"Invalid input.",		0;				//Invalid input.
cannotDivide	BYTE	"Numbers cannot be negative or zero.",		0;									//Cannot divide numbers error.
goodbye			BYTE	"Goodbye.",				0;				//Goodbye message.

equals			BYTE	" = ", 0;								//String for equals symbol.
sum				BYTE	" + ", 0;								//String for addition symbol.
diff			BYTE	" - ", 0;								//String for subtraction symbol.
multi			BYTE	" * ", 0;								//String for multiplication symbol.
divi			BYTE	" / ", 0;								//String for division symbol.
dot				BYTE	"."	 , 0;								//String for decimal point.

;															//Predefined values:
totalOpts		DWORD	5		;								//The number of operations.
binaryOpts		DWORD	4		;								//The number of binary operations.
precision		DWORD	1000000	;								//The precision of the floating point number result.

;															//User inputted data:
opt				DWORD	?		;								//The operator.
num				DWORD	?		;								//The number (unary operations).
firstNum		DWORD	?		;								//The first number (binary operations).
secondNum		DWORD	?		;								//The second number (binary operations).
;															//Calculated results:
bigInt			DWORD	0		;								//The floating point number multiplied by precision.
result			DWORD	?		;								//The Result.
resultDiv		REAL4	?		;								//The Result of division.
firstPart		DWORD	?		;								//The part of the quotient before the decimal place.
secondPart		DWORD	?		;								//The part of the quotient after the decimal place.
remainder		DWORD	?		;								//The remainder of the first part of the quotient.
temp			DWORD	?		;								//Temporary value used in the calculation of the second part of the quotient.

.code

main	PROC;												//The main procedure.
	
	ReadInput:;												//Reading data:
	GetOperation:;											//Read Operation:
		MOV		edx,			offset prompt_1;				//Puts memory address of prompt_3 in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		CALL	ReadInt;										//Reads an integer to register eax.
		MOV		opt,			eax;							//Stores value of eax in opt.	


	CheckOperator:;										//Check the operator:
		MOV		eax,			opt;							//Puts value of opt in register eax.
		MOV		ebx,			totalOpts;						//Puts value of totalOpts in register ebx.
		MOV		ecx,			binaryOpts;						//Puts value of binaryOpts in register ecx.
		MOV		edx,			offset invalid;					//Puts memory address of invalid in register edx.
;		//Check if opt is within bounds.
		CMP		eax,			0;								//Compare eax to 0.
		JLE		InvalidResponse;								//Jumps to InvalidResponse if less than or equal to 0.
		CMP		eax,			ebx;							//Compare eax to ebx.
		JG		InvalidResponse;								//Jumps to InvalidResponse if greater than ebx.
;		//Checks if opt is binary or unary operation:
		CMP		eax,			ecx;							//Compare eax to ebx.
		JLE		BinaryOperations;								//Jumps to BinaryOperations if less than or equal to ecx.
		JG		UnaryOperations;								//Jumps to UnaryOperations if greater than ecx.

	UnaryOperations:;										//Unary calculator operations:
;		//Get Number:
		MOV		edx,			offset prompt_4;				//Puts memory address of prompt_1 in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		CALL	ReadInt;										//Reads an integer to register eax.
		MOV		num,			eax;							//Stores value of eax in num.
;		//Jump to operation:
		MOV		eax,			opt;							//Puts value of opt in register eax.

		CMP		eax,			5;								//Compare eax to 5.
		JE		PrimeGeneration;								//Jump to PrimeGeneration if equal to 5.

	BinaryOperations:;										//Binary calculator operations:
;		//Get first number:
		MOV		edx,			offset prompt_2;				//Puts memory address of prompt_1 in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		CALL	ReadInt;										//Reads an integer to register eax.
		MOV		firstNum,		eax;							//Stores value of eax in firstNum.
;		//Get second number:
		MOV		edx,			offset prompt_3;				//Puts memory address of prompt_2 in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		CALL	ReadInt;										//Reads an integer to register eax.
		mov		secondNum,		eax;							//Stores value of eax in secondNum.
;		//Jump to operation:
		MOV		eax,			opt;							//Puts value of opt in register eax.

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
;		//Print equation:
		MOV		eax,			firstNum;						//Puts value of firstNum in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
		MOV		edx,			offset sum;						//Puts memory address of sum in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		MOV		eax,			secondNum;						//Puts value of secondNum in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
		MOV		edx,			offset equals;					//Puts memory address of equals in register edx.
		CALL	WriteString;									//Writes the String in register edx.
;		//Print result:
		MOV		eax,			result;							//Puts value of result in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
;		//Jump to loop.
		CALL	CrLf;											//New Line.
		JMP		JumpToLoop;										//Jump to JumpToLoop.

	Subtraction:;											//Subtraction:
;		//Calculation:
		MOV		eax,			firstNum;						//Puts value of firstNum in register eax.
		SUB		eax,			secondNum;						//Subtracts the value of secondNum from register eax.
		MOV		result,			eax;							//Stores value of eax in result.
;		//Print equation:
		MOV		eax,			 firstNum;						//Puts value of firstNum in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
		MOV		edx,			offset diff;					//Puts memory address of diff in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		MOV		eax,			secondNum;						//Puts value of secondNum in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
		MOV		edx,			offset equals;					//Puts memory address of equals in register edx.
		CALL	WriteString;									//Writes the String in register edx.
;		//Print result:
		MOV		eax,			result;							//Puts value of result in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
;		//Jump to loop.
		CALL	CrLf;											//New Line.
		JMP		JumpToLoop;										//Jump to JumpToLoop.

	Multiplication:;										//Multiplication:
;		//Calculation:
		MOV		eax,			firstNum;						//Puts value of firstNum in register eax.
		MOV		ebx,			secondNum;						//Puts value of secondNum in register ebx.
		MUL		ebx;											//Multiplies the value in eax with the value in ebx.
		MOV		result,			eax;							//Stores value of eax in result.
;		//Print equation:
		MOV		eax,			firstNum;						//Puts value of firstNum in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
		MOV		edx,			offset multi;					//Puts memory address of multi in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		MOV		eax,			secondNum;						//Puts value of secondNum in register eax.
		CALL	WriteInt;										//Writes the integer.
		MOV		edx,			offset equals;					//Puts memory address of equals in register edx.
		CALL	WriteString;									//Writes the String in register edx.
;		//Print result:
		MOV		eax,			result;							//Puts value of result in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
;		//Jump to loop.
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
;		//Print equation:
		MOV		eax,			firstNum;						//Puts value of firstNum in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
		MOV		edx,			offset divi;					//Puts memory address of divi in register edx.
		CALL	WriteString;									//Writes the String in register edx.
		MOV		eax,			secondNum;						//Puts value of secondNum in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
		MOV		edx,			offset equals;					//Puts memory address of equals in register edx.
		CALL	WriteString;									//Writes the String in register edx.
;		//Calculate first part of result:
		MOV		edx,			0;								//Puts 0 in register edx.
		MOV		eax,			bigInt;							//Puts value of bigInt in register eax.
		CDQ;													//Sign-extend eax to edx.
		MOV		ebx,			precision;						//Puts value of precision in register ebx.
		CDQ;													//Sign-extend eax to edx.
		DIV		ebx;											//Divides eax by ebx.
		MOV		firstPart,		eax;							//Stores value of eax in firstPart.
		MOV		remainder,		edx;							//Stores value of edx in remainder.
;		//Print first part of result:
		MOV		eax,			firstPart;						//Puts value of firstPart in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
		MOV		edx,			offset dot;						//Puts memory address of dot in register edx.					
		CALL	WriteString;									//Writes the String in register edx.
;		//Calculate second part of result:
		MOV		eax,			firstPart;						//Puts value of firstPart in register eax.
		MUL		precision;										//Multiply eax by precision.
		MOV		temp,			eax;							//Stores value of eax in temp.
		MOV		eax,			bigInt;							//Puts value of bigInt in register eax.
		SUB		eax,			temp;							//Subtracts the value of temp from register eax.
;		//Print second part of result:
		MOV		secondPart,		eax;							//Stores the value of eax in secondPart.
		CALL	WriteDec;										//Writes the integer in register eax.
;		//Jump to loop.
		CALL	CrLf;											//New Line.
		JMP		JumpToLoop;										//Jump to JumpToLoop.


	PrimeGeneration:;										//Prime number generation:
		MOV		eax,			num;							//Puts value of num in register eax.
		CALL	WriteInt;										//Writes the integer in register eax.
;		//Jump to loop.
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