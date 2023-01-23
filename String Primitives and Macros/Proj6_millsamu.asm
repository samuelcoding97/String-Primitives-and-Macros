TITLE Project 6		(Proj6_millsamu.asm)

; Author: Samuel Miller
; Last Modified: November 25th, 2022
; OSU email address: millsamu@oregonstate.edu
; Course number/section:   CS271 Section 16919
; Project Number:   6      Due Date: December 4th, 2022
; Description: This is project 6. It prompts the user to enter 10 unsigned integers that can fit
; in a 32-bit register. If the input doesn't match, it reprompts the user for a number. When 10 numbers
; have been entered it displays a list of the valid numbers, the sum, and the average
; followed by a farewell message

INCLUDE Irvine32.inc

; --------------------------------------------------------------------------------- 
; Name: mDisplayString
; 
; prints an array or string
; 
; Preconditions: do not use eax, ecx, esi as arguments 
; 
; Receives: 
; string = array address 
; --------------------------------------------------------------------------------- 
mDisplayString	MACRO	string
	PUSH	EDX				;Save EDX register
	MOV		EDX,  OFFSET string
	CALL	WriteString
	POP		EDX				;Restore EDX
ENDM

; --------------------------------------------------------------------------------- 
; Name: mGetString
; 
; Gets user input and stores that input as a string 
; 
; Preconditions: do not use eax, ecx, esi as arguments 
; 
; Receives: 
; prompt = string to get user input
; input = string to store user input
; stringLimit = the length of characters to store
; length = the actual length of the string
; 
; returns: input = generated string address 
; --------------------------------------------------------------------------------- 
mGetString	MACRO		prompt, input, stringLimit, length
	PUSH	EDX
	PUSH	ECX
	PUSH	EAX
	MOV		EDX, prompt
	CALL	WriteString
	MOV		EDX, input
	MOV		ECX, stringLimit
	CALL	ReadString
	MOV		length, EAX
	POP		EAX
	POP		ECX
	POP		EDX
ENDM

MAX_LENGTH = 12 ; create a max length long enough to set overflow flag and filter out large numbers
COUNT = 10

.data
intro1			BYTE	"Project 6: Data validation the hard way with MACROs and string primitives.",13,10
				BYTE	"Written by Samuel Miller.",13,10,13,10
				BYTE	"Please enter 10 signed decimal integers.",13,10
				BYTE	"Every number must fit in a 32-bit register.",13,10
				BYTE	"After the numbers are entered the list, sum, and average value will be displayed.",13,10,13,10,0
prompt1			BYTE	"Enter a signed decimal integer: ",0
error1			BYTE	"Invalid input. Please enter a signed number that fits in a 32-bit register",13,10
				BYTE	"Try again: ",0
list1			BYTE	"These are the valid numbers you entered:",13,10,0
comma			BYTE	", ",0
sum1			BYTE	"The sum: ",0
average1		BYTE	"The truncated average: ",0
farewell		BYTE	"Thank you, goodbye.",13,10,0
numList			DWORD	COUNT DUP(?)	; list to hold the ten values
numString		BYTE	MAX_LENGTH DUP(?) ;array to hold the reversed integer as a string
numStringRev	BYTE	MAX_LENGTH DUP(?) ;array to reverse the reversed string
numInput		BYTE	MAX_LENGTH DUP(?) 
lengthInput		DWORD	0
sign			DWORD	?
sumString		BYTE	MAX_LENGTH DUP (?)
sumStringRev	BYTE	MAX_LENGTH DUP (?)
sumInt			DWORD	?
avgString		BYTE	MAX_LENGTH DUP (?)
avgStringRev	BYTE	MAX_LENGTH DUP (?)
avgInt			DWORD	?

.code
main PROC

; display intro message
mDisplayString		intro1

; loop to fill numList with 10 valid signed 32-bit integers
MOV ECX,	COUNT
MOV EDI,	OFFSET numList
_fillLoop:
	PUSH	ECX

	PUSH	OFFSET numList
	PUSH	OFFSET sign
	PUSH	OFFSET error1
	PUSH	OFFSET lengthInput
	PUSH	OFFSET numInput
	PUSH	OFFSET prompt1
	CALL	ReadVal

	ADD		EDI, 4
	POP		ECX
	LOOP	_fillLoop

; display string announcing the valid nums
CALL	CrLf
mDisplayString		list1

; display the valid nums with a loop
MOV		ECX, COUNT
MOV		ESI, OFFSET numList
MOV		EDI, OFFSET numString
_displayNums:
	PUSH	ECX

	PUSH	OFFSET numStringRev
	PUSH	OFFSET numString
	PUSH	OFFSET numList
	CALL	WriteVal
	; display valid numString followed by a comma and a space
	mDisplayString		numStringRev
	mDisplayString		comma
	; empty the numString array so a new value can be inputted
	XOR		EAX, EAX
	MOV		EDI, OFFSET numString 
	MOV		ECX, LENGTH numString
	CLD
	REP		STOSB
	; empty the numStringRev array so a new value can be inputted
	XOR		EAX, EAX
	MOV		EDI, OFFSET numStringRev 
	MOV		ECX, LENGTH numStringRev
	CLD
	REP		STOSB
	
	POP		ECX
	DEC		ECX
	CMP		ECX, 2
	JGE		_displayNums
		
; write the last value in the array with no comma
PUSH	OFFSET numStringRev
PUSH	OFFSET numString
PUSH	OFFSET numList
CALL	WriteVal

mDisplayString		numStringRev
CALL	CrLf

; Add the values of the array
MOV		ESI, OFFSET numList
MOV		EAX, 0
MOV		ECX, COUNT
_sum:
	MOV		EBX, [ESI]
	ADD		EAX, EBX
	ADD		ESI, 4
	DEC		ECX
	CMP		ECX, 0
	JG		_sum

MOV		sumInt, EAX
MOV		ESI, offset sumInt

; turn the sum into a string
PUSH	OFFSET sumStringRev
PUSH	OFFSET sumString
PUSH	OFFSET sumInt
CALL	WriteVal

; display the sum
mDisplayString		sum1
mDisplayString		sumStringRev
CALL	CrLf

; get the average. If the sum is negative, temporarily changes to positive to avoid complications
; with division before it is changed back to negative in order to be passed to WriteVal
MOV		EAX, sumInt
CMP		EAX, 0
JL		_negativeSum
JMP		_positiveSum

; temporarily changes sum to positive to make division work properly
_negativeSum:
	MOV		EBX, -1
	MUL		EBX
	MOV		ECX, -1
	JMP		_getAverage

_positiveSum:
	MOV		ECX, 0
	JMP		_getAverage

_getAverage:
	PUSH	ECX
	MOV		ECX, 0
	MOV		EBX, COUNT
	MOV		EDX, 0
	DIV		EBX
	POP		ECX
	CMP		ECX, -1
	JE		_negativeResult
	JMP		_positiveResult

; if sum was negative, changes the average back to negative
_negativeResult:
	MUL		ECX

_positiveResult:
	MOV		avgInt, EAX
	MOV		ESI, OFFSET avgInt

PUSH	OFFSET avgStringRev
PUSH	OFFSET avgString
PUSH	OFFSET avgInt
Call WriteVal

; display the average
mDisplayString		average1
mDisplayString		avgStringRev
CALL	CrLf

; display closing message
CALL	CrLf
mDisplayString		farewell
	Invoke ExitProcess,0	; exit to operating system
main ENDP

; --------------------------------------------------------------------------------- 
; Name: ReadVal
;  
; invokes the mGetString macro to get the user to enter a string and then checks if
; that string can be stored as an integer of 32-bits. if so it stores the value in an
; array and if not it tells the user it is invalid input
;
; Preconditions: the parameters need to be defined, and the macro needs to be created
;
; Postconditions: EDI is maintained so iterating through the list can happen
; 
; Receives: 
;	[EBP+28] numList - an array that stores the integer values
;	[EBP+24] sign - stores the sign of the number as 1 or -1
;	[EBP+20] error1 - an error message when input is inccorect
;	[EBP+16] lengthInput - counts the length of the string
;	[EBP+12] numInput - user entered input as a string
;	[EBP+8] prompt1 - message to enter a number
; 
; Returns: a new value will be stored in the array of integer numbers
; ---------------------------------------------------------------------------------
ReadVal PROC
PUSH	EBP
MOV		EBP, ESP
PUSHAD
mGetString		[EBP+8], [EBP+12], MAX_LENGTH, [EBP+16]

; first character we check for a sign "+" or "-" as well as integers
_firstCharacter:
	MOV		ECX, [EBP+16]
	MOV		ESI, [EBP+12]
	XOR		EAX, EAX
	CLD
	LODSB
	CMP		AL, 0
	JE		_invalid
	CMP		AL, 45
	JE		_validateString
	CMP		AL, 43
	JE		_validateString
	CMP		AL, 48
	JL		_invalid
	CMP		AL, 57
	JG		_invalid

_validateString:
	LODSB
	CMP		AL, 0
	JE		_stringToInt
	CMP		AL, 48
	JL		_invalid
	CMP		AL, 57
	JG		_invalid
	LOOP	_validateString
_invalidPop:
	POP		EAX ; EAX needs to be popped before moving to _invalid
	JMP		_invalid
_invalid:
	mGetString		[EBP+20], [EBP+12], MAX_LENGTH, [EBP+16]
	JMP		_firstCharacter

_stringToInt:
	MOV		ECX, [EBP+16]
	MOV		ESI, [EBP+12]
	MOV		EBX, 0
	CLD
	LODSB
	CMP		AL, 45
	JE		_negativeSign
	CMP		AL, 43
	JE		_positiveSign
	SUB		EAX, 48
	PUSH	EAX
	MOV		EAX, EBX
	MOV		EDX, 10
	MUL		EDX
	MOV		EBX, EAX
	POP		EAX
	ADD		EBX, EAX
	DEC		ECX
	PUSH	EAX ; save eax value so the register can be used to save the sign
	MOV		EAX, 1
	MOV		[EBP+24], EAX
	POP		EAX		
	CMP		ECX, 0
	JE		_storeNum
	JMP		_conversion

_negativeSign:
	MOV		EAX, -1 ; sets the sign to -1
	MOV		[EBP+24], EAX
	DEC		ECX
	MOV		ESI, [EBP+12] ; reload the string but load the first byte so it doesn't convert "-"
	XOR		EAX, EAX
	LODSB
	JMP		_conversion

_positiveSign:
	MOV		EAX, 1
	MOV		[EBP+24], EAX
	DEC		ECX
	JMP		_conversion

_conversion:
	LODSB
	SUB		EAX, 48 ; get the numerical value of each string byte
	PUSH	EAX
	MOV		EAX, EBX
	MOV		EDX, 10
	MUL		EDX
	JO		_invalidPop ; if overflow flag is set, it's invalid. 
	MOV		EBX, EAX
	POP		EAX
	ADD		EBX, EAX
	LOOP	_conversion

_storeNum:
	MOV		EAX, EBX
	MOV		EBX, [EBP+24]
	MUL		EBX
	CLD
	STOSD ;stores 32-bits from eax in edi and incrememnts edi by 4

POPAD
POP		EBP
RET		24
ReadVal ENDP

; --------------------------------------------------------------------------------- 
; Name: WriteVal
;  
; Loads an integer from the numList array and converts it to a string, but backwards.
; subsequently reverses the string for printing. This is used to display the sum, average
; and all of the valid input, so receives changes based on what process is being invoked
; 
; Preconditions: there must be a value in numList to convert, and it must be verified
; to be an integer
; 
; Receives: 
;	[EBP+16] numStringRev (for example) - the reversed backwards string (the right one)
;										  gets printed
;	[EBP+12] numString (for example) - the string of that integer, but it's backwards
;	[EBP+8]	numList (for example) - the integer value to be converted 
;
; Returns: Returns the backwards and the forwards string. numStringRev is printed but
; numString never is. these arrays need to be cleared before the procedure can be called 
; again.
; ---------------------------------------------------------------------------------
WriteVal PROC

PUSH	EBP
MOV		EBP, ESP
MOV		EDI, [EBP+12] ; where the string value will be stored
MOV		ECX, 0

LODSD ;load current array value into eax
PUSH	EAX ; for comparison after writing the string backwards
CMP		EAX, 0
JL		_negativeException
JMP		_intToString

_negativeException:
	MOV		EBX, -1 ; temporarily make int positive to make it easier to convert
	MUL		EBX
	INC		ECX

_intToString:
	CLD
	MOV		EBX, 10
	MOV		EDX, 0
	DIV		EBX ; get the least significant digit in edx
	PUSH	EAX ; save the rest of the int
	MOV		EAX, EDX
	ADD		EAX, 48 ; change the digit to ascii and store in edi
	STOSB
	POP		EAX
	INC		ECX ; to know string length to reverse it later
	CMP		EAX, 0
	JG		_intToString

POP		EAX
CMP		EAX, 0
JL		_negativebyte
JMP		_terminator

_negativebyte:
	MOV		EAX, "-" ; if integer was negative put a "-" at the end of the backwards string
	CLD
	STOSB

_terminator:
	CLD
	MOV		AL, 0 ; null terminator for string
	STOSB

PUSH	ESI
MOV		ESI, [EBP+12] ; change what was in edi to esi
ADD		ESI, ECX
DEC		ESI
MOV		EDI, [EBP+16] ; empty string in edi

;reverse the string to get the accurate one
_reverseBackwardsString:
	STD
	LODSB
	CLD
	STOSB
loop _reverseBackwardsString

POP		ESI
POP		EBP
RET		12
WriteVal ENDP

END main