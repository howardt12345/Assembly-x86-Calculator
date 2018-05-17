TITLE			Assembly x86 Calculator;											//The Title.

INCLUDE			Irvine32.inc;														//Includes the Irvine32 Library.

.data
;																					//Strings:
prompt_1		BYTE	"Operation: ",												0;	//Prompt for operation.
prompt_2		BYTE	"First Number:  ",											0;	//Prompt for first number.
prompt_3		BYTE	"Second Number: ",											0;	//Prompt for second number.
prompt_4		BYTE	"Number: ",													0;	//Prompt for prime number generation.
loop_prompt		BYTE	"Would you like to loop again? 1 for YES or 0 for NO: ",	0;	//Prompt for loop.
invalid			BYTE	"Invalid input.",											0;	//Invalid input.
cannotDivide	BYTE	"Numbers cannot be negative or zero.",						0;	//Cannot divide numbers error.
numberTooLarge	BYTE	"Inputted number too large.",								0;	//Number too large error.
goodbye			BYTE	"Goodbye.",													0;	//Goodbye message.

equals			BYTE	" = ",		0;													//String for equals symbol.
sum				BYTE	" + ",		0;													//String for addition symbol.
diff			BYTE	" - ",		0;													//String for subtraction symbol.
multi			BYTE	" * ",		0;													//String for multiplication symbol.
divi			BYTE	" / ",		0;													//String for division symbol.
dot				BYTE	"."	 ,		0;													//String for decimal point.

;																					//Predefined values:
totalOpts		DWORD	5			;													//The number of operations.
binaryOpts		DWORD	4			;													//The number of binary operations.
precision		DWORD	1000000		;													//The precision of the floating point number result.

;																					//For Prime number generation.
arraySize		EQU		100000				;										//The maximum anount of primes that can be generated.
array1			dd		arraySize	dup(0)	;										//The array of numbers to calculate primes.

;																					//User inputted data:
opt				DWORD	?			;													//The operator.
num				DWORD	?			;													//The number (unary operations).
firstNum		DWORD	?			;													//The first number (binary operations).
secondNum		DWORD	?			;													//The second number (binary operations).
;																					//Calculated results:
bigInt			DWORD	0			;													//The floating point number multiplied by precision.
result			DWORD	?			;													//The Result.
resultDiv		REAL4	?			;													//The Result of division.
firstPart		DWORD	?			;													//The part of the quotient before the decimal place.
secondPart		DWORD	?			;													//The part of the quotient after the decimal place.
remainder		DWORD	?			;													//The remainder of the first part of the quotient.
temp			DWORD	?			;													//Temporary value used in the calculation of the second part of the quotient.

.code

main	PROC;																		//The main procedure.
	
	ReadInput:;																		//Reading data:
	GetOperation:;																	//Read Operation:
		MOV		edx,				offset prompt_1;									//Move memory address of prompt_3 in register edx.
		CALL	WriteString;															//Writes the String in register edx.
		CALL	ReadInt;																//Reads an integer to register eax.
		MOV		opt,				eax;												//Stores value of eax in opt.	


	CheckOperator:;																	//Check the operator:
		MOV		eax,				opt;												//Move value of opt in register eax.
		MOV		ebx,				totalOpts;											//Move value of totalOpts in register ebx.
		MOV		ecx,				binaryOpts;											//Move value of binaryOpts in register ecx.
		MOV		edx,				offset invalid;										//Move memory address of invalid in register edx.
;																					//Check if opt is within bounds.
		CMP		eax,				0;													//Compare eax to 0.
		JLE		InvalidResponse;														//Jump to InvalidResponse if less than or equal to 0.
		CMP		eax,				ebx;												//Compare eax to ebx.
		JG		InvalidResponse;														//Jump to InvalidResponse if greater than ebx.
;																					//Checks if opt is binary or unary operation:
		CMP		eax,				ecx;												//Compare eax to ebx.
		JLE		BinaryOperations;														//Jump to BinaryOperations if less than or equal to ecx.
		JG		UnaryOperations;														//Jump to UnaryOperations if greater than ecx.

	UnaryOperations:;																//Unary calculator operations:
;																					//Get Number:
		MOV		edx,				offset prompt_4;									//Move memory address of prompt_1 in register edx.
		CALL	WriteString;															//Writes the String in register edx.
		CALL	ReadInt;																//Reads an integer to register eax.
		MOV		num,				eax;												//Stores value of eax in num.
;																					//Jump to operation:
		MOV		eax,				opt;												//Move value of opt in register eax.

		CMP		eax,				5;													//Compare eax to 5.
		JE		PrimeNumbers;															//Jump to PrimeNumbers if equal to 5.

	BinaryOperations:;																//Binary calculator operations:
;																					//Get first number:
		MOV		edx,				offset prompt_2;									//Move memory address of prompt_1 in register edx.
		CALL	WriteString;															//Writes the String in register edx.
		CALL	ReadInt;																//Reads an integer to register eax.
		MOV		firstNum,			eax;												//Stores value of eax in firstNum.
;																					//Get second number:
		MOV		edx,				offset prompt_3;									//Move memory address of prompt_2 in register edx.
		CALL	WriteString;															//Writes the String in register edx.
		CALL	ReadInt;																//Reads an integer to register eax.
		mov		secondNum,			eax;												//Stores value of eax in secondNum.
;																						//Jump to operation:
		MOV		eax,				opt;												//Move value of opt in register eax.

		CMP		eax,				1;													//Compare eax to 1.
		JE		Addition;																//Jump to Addition if equal to 1.
		CMP		eax,				2;													//Compare eax to 2.
		JE		Subtraction;															//Jump to Subtraction if equal to 2.
		CMP		eax,				3;													//Compare eax to 3.
		JE		Multiplication;															//Jump to Multiplication if equal to 3.
		CMP		eax,				4;													//Compare eax to 4.
		JE		Division;																//Jump to Division if equal to 4.

	Addition:;																		//Addition (1):
;																					//Calculation:
		MOV		eax,				firstNum;											//Move value of firstNum in register eax.
		ADD		eax,				secondNum;											//Adds the value of secondNum to register eax.
		MOV		result,				eax;												//Stores value of eax in result.
;																					//Print equation:
		MOV		eax,				firstNum;											//Move value of firstNum in register eax.
		CALL	WriteInt;																//Writes the integer in register eax.
		MOV		edx,				offset sum;											//Move memory address of sum in register edx.
		CALL	WriteString;															//Writes the String in register edx.
		MOV		eax,				secondNum;											//Move value of secondNum in register eax.
		CALL	WriteInt;																//Writes the integer in register eax.
		MOV		edx,				offset equals;										//Move memory address of equals in register edx.
		CALL	WriteString;															//Writes the String in register edx.
;																					//Print result:
		MOV		eax,				result;												//Move value of result in register eax.
		CALL	WriteInt;																//Writes the integer in register eax.
;																					//Jump to loop.
		CALL	CrLf;																	//New Line.
		JMP		JumpToLoop;																//Jump to JumpToLoop.

	Subtraction:;																	//Subtraction (2):
;																					//Calculation:
		MOV		eax,				firstNum;											//Move value of firstNum in register eax.
		SUB		eax,				secondNum;											//Subtracts the value of secondNum from register eax.
		MOV		result,				eax;												//Stores value of eax in result.
;																						//Print equation:
		MOV		eax,				firstNum;											//Move value of firstNum in register eax.
		CALL	WriteInt;																//Writes the integer in register eax.
		MOV		edx,				offset diff;										//Move memory address of diff in register edx.
		CALL	WriteString;															//Writes the String in register edx.
		MOV		eax,				secondNum;											//Move value of secondNum in register eax.
		CALL	WriteInt;																//Writes the integer in register eax.
		MOV		edx,				offset equals;										//Move memory address of equals in register edx.
		CALL	WriteString;															//Writes the String in register edx.
;																					//Print result:
		MOV		eax,				result;												//Move value of result in register eax.
		CALL	WriteInt;																//Writes the integer in register eax.
;																					//Jump to loop.
		CALL	CrLf;																	//New Line.
		JMP		JumpToLoop;																//Jump to JumpToLoop.

	Multiplication:;																//Multiplication (3):
;																					//Calculation:
		MOV		eax,				firstNum;											//Move value of firstNum in register eax.
		MOV		ebx,				secondNum;											//Move value of secondNum in register ebx.
		MUL		ebx;																	//Multiplies the value in eax with the value in ebx.
		MOV		result,				eax;												//Stores value of eax in result.
;																					//Print equation:
		MOV		eax,				firstNum;											//Move value of firstNum in register eax.
		CALL	WriteInt;																//Writes the integer in register eax.
		MOV		edx,				offset multi;										//Move memory address of multi in register edx.
		CALL	WriteString;															//Writes the String in register edx.
		MOV		eax,				secondNum;											//Move value of secondNum in register eax.
		CALL	WriteInt;																//Writes the integer in register eax.
		MOV		edx,				offset equals;										//Move memory address of equals in register edx.
		CALL	WriteString;															//Writes the String in register edx.
;																					//Print result:
		MOV		eax,				result;												//Move value of result in register eax.
		CALL	WriteInt;																//Writes the integer in register eax.
;																					//Jump to loop.
		CALL	CrLf;																	//New Line.
		JMP		JumpToLoop;																//Jump to JumpToLoop.

	Division:;																		//Division (4):
;																					//Checks if numbers can be divided:
		MOV		edx,				offset cannotDivide;								//Move memory address of cannotDivide in register edx.
		MOV		eax,				firstNum;											//Move value of firstNum in register eax.
		CMP		eax,				0;													//Compare eax with 0.
		JLE		InvalidResponse;														//Jump to InvalidResponse if less than or equal to 0.
		MOV		eax,				secondNum;											//Move value of secondNum in register eax.
		CMP		eax,				0;													//Compare eax with 0.
		JLE		InvalidResponse;														//Jump to InvalidResponse if less than or equal to 0.
;																					//Calculation:
		FLD		firstNum;																//Load firstNum into ST(0).
		FDIV	secondNum;																//Divide firstNum by secondNum.
		FIMUL	precision;																//Multiplies value by precision.
		FRNDINT;																		//Rounds the value in ST(0) to the nearest integral value.
		FIST	bigInt;																	//Stores integer in bigInt.
		FST		resultDiv;																//Stores value of ST(0) in resultDiv.
;																					//Print equation:
		MOV		eax,				firstNum;											//Move value of firstNum in register eax.
		CALL	WriteInt;																//Writes the integer in register eax.
		MOV		edx,				offset divi;										//Move memory address of divi in register edx.
		CALL	WriteString;															//Writes the String in register edx.
		MOV		eax,				secondNum;											//Move value of secondNum in register eax.
		CALL	WriteInt;																//Writes the integer in register eax.
		MOV		edx,				offset equals;										//Move memory address of equals in register edx.
		CALL	WriteString;															//Writes the String in register edx.
;																					//Calculate first part of result:
		MOV		edx,				0;													//Move 0 in register edx.
		MOV		eax,				bigInt;												//Move value of bigInt in register eax.
		CDQ;																			//Sign-extend eax to edx.
		MOV		ebx,				precision;											//Move value of precision in register ebx.
		CDQ;																			//Sign-extend eax to edx.
		DIV		ebx;																	//Divides eax by ebx.
		MOV		firstPart,			eax;												//Stores value of eax in firstPart.
		MOV		remainder,			edx;												//Stores value of edx in remainder.
;																					//Print first part of result:
		MOV		eax,				firstPart;											//Move value of firstPart in register eax.
		CALL	WriteInt;																//Writes the integer in register eax.
		MOV		edx,				offset dot;											//Move memory address of dot in register edx.					
		CALL	WriteString;															//Writes the String in register edx.
;																					//Calculate second part of result:
		MOV		eax,				firstPart;											//Move value of firstPart in register eax.
		MUL		precision;																//Multiply eax by precision.
		MOV		temp,				eax;												//Stores value of eax in temp.
		MOV		eax,				bigInt;												//Move value of bigInt in register eax.
		SUB		eax,				temp;												//Subtracts the value of temp from register eax.
;																					//Print second part of result:
		MOV		secondPart,			eax;												//Stores the value of eax in secondPart.
		CALL	WriteDec;																//Writes the integer in register eax.
;																					//Jump to loop.
		CALL	CrLf;																	//New Line.
		JMP		JumpToLoop;																//Jump to JumpToLoop.


	PrimeNumbers:;																	//Prime number generation (5):
		MOV		ecx,				num;												//Move value of num in register ecx.
		MOV		edx,				offset numberTooLarge;								//Move memory address of numberTooLarge in register edx.
		CMP		ecx,				arraySize;											//Compare ecx with arraySize.
		JG		InvalidResponse;														//Jump to InvalidResponse if greater than arraySize.

		CMP		ecx,				2;													//Compare ecx to 2.
		JLE		startPrime;																//Jump to startPrime if 
		SUB		ecx,				1;													//Subtracts the value of 1 from register ecx.
		MOV		num,				ecx;												//Stores value of ecx in num.

	startPrime:;																	//Start the Prime Number Generation:
		XOR		ecx,				ecx;												//Performs xor operation on ecx and ecx, zeroing it.

	fillArray:;																		//Fills the arrays with sequential values:
		MOV		eax,				ecx;												//Move value of ecx in register eax.
		ADD		eax,				2;													//Adds the value of 2 to register eax.
		MOV		[array1 + 4 * ecx], eax;												//Move value of eax in address [array1 + 4 * ecx].
		INC		ecx;																	//Increment ecx.
		CMP		ecx,				num;												//Compare ecx to num.
		JB		fillArray;																//Jump to fillArray if below num.
		XOR		ecx,				ecx;												//Performs xor operation on ecx and ecx, zeroing it.
;																					//Start calculating prime numbers:
	outerPrime:;;																	//The outer loop for prime number calculation:
		MOV		ebx,				ecx;												//Move value of ecx to register ebx.
		INC		ebx;																	//Increment ebx.
		CMP		[array1 + 4 * ecx], -1;													//Compare [array1 + 4 * ecx] to -1.
		JNE		innerPrime;																//Jump to innerPrime if less than -1.
	resumeOuter:;																	//Resume outerPrime:
		INC		ecx;																	//Increment ecx.
		CMP		ecx,				num;												//Compare ecx to num.
		JB		outerPrime;																//Jump to outerPrime if below num.
		JMP		endPrime;																//Jump to endPrime when complete.
	innerPrime:;																	//The inner loop for prime number calculation:	
		CMP		[array1 + 4 * ebx], -1;													//Compare [array1 + 4 * ebx] to -1.
		JNE		checkPrime;																//Jump to checkPrime if not equal.
	resumeInner:;																	//Resume innerPrime:
		INC		ebx;																	//Increment ebx.
		CMP		ebx,				num;												//Compare ebx to num.
		JB		innerPrime;																//Jump to innerPrime if below num.
		JMP		resumeOuter;															//Jump to resumeOuter when complete.
	checkPrime:;																	//Checks if number is a prime:
		XOR		edx,				edx;												//Performs xor operation on edx and edx, zeroing it.
		MOV		eax,				[array1 + 4 * ebx];									//Move value of [array1 + 4 * ebx] to eax.
		DIV		[array1 + 4 * ecx];														//Divide eax by [array1 + 4 * ecx].
		CMP		edx,				0;													//Compare the remainder to 0.
		JE		notPrime;																//Jump to notPrime if equal.
	resume3:;																		//Resume checkPrime:
		JMP		resumeInner;															//Jump to resumeInner.
	notPrime:;																		//Flags a number as not prime:
		MOV		[array1 + 4 * ebx], -1;													//Moves value of -1 in address [array1 + 4 * ebx].
		JMP		resume3;																//Jump to resume3.
	endPrime:;																		//End the prime number generation:
		XOR		ecx,				ecx;												//Performs xor operation on ecx and ecx, zeroing it.
	printArrayElement:;																//Prints the array element:
		MOV		eax,				[array1 + 4 * ecx];									//Move value of [array1 + 4 * ecx] in register eax.
		CALL	WriteDec;																//Writes the integer in register eax.
		CALL	CrLf;																	//New Line.
		JMP		resumePrint;															//Jump to resumePrint.
	printArray:;																	//Print the array:
		CMP		[array1 + 4 * ecx], -1;													//Compare [array1 + 4 * ecx] to -1.
		JNE		printArrayElement;														//Jump to printArrayElement if not equal to -1.
	resumePrint:;																	//Resumes the printing of the array:
		INC		ecx;																	//Increment ecx.
		CMP		ecx,				num;												//Compare ecx to num.
		JB		printArray;																//Jump to printArray if below num.
;																					//Jump to loop.
		CALL	CrLf;																	//New Line.
		JMP		JumpToLoop;																//Jump to JumpToLoop.


	JumpToLoop:;																	//Loops until user quits:
		MOV		edx,				offset loop_prompt;									//Move memory address of loop_response in register edx.
		CALL	WriteString;															//Writes the String in register edx.
		CALL	ReadInt;																//Reads an integer to register eax.

		MOV		edx,				offset invalid;										//Move memory address of invalid in register edx.

		CMP		eax,				0;													//Compares eax to 0.
		JE		ExitProgram;															//Jump to ExitProgram if equal to 0.
		JL		InvalidResponse;														//Jump to InvalidResponse if less than 0.

		CMP		eax,				1;													//Compares eax to 1.
		JE		ReadInput;																//Jump to ReadInput if equal to 1.
		JL		InvalidResponse;														//Jump to InvalidResponse if greater than 1.


	InvalidResponse:;																//Invalid response:
		CALL	WriteString;															//Writes the String in register edx.
		CALL	CrLf;																	//New Line.
		JMP		JumpToLoop;																//Jump to JumpToLoop.8


	ExitProgram:;																	//Exits the program:
		MOV		edx,				offset goodbye;										//Move memory address of goodbye in register edx.
		CALL	WriteString;															//Writes the String in register edx.
		CALL	CrLf;																	//New Line.
		exit;																			//Exits the program.


main	ENDP;																		//End main procedure.


END		main;																		//End program.