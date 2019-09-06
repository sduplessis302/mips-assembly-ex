main:
	.data
	text1: .asciiz "Enter int 'n' for Fibonacci Sequence (0 < n):\n"
	text2: .asciiz "Fibonacci Sequence:\n"
	space: .asciiz ", "

	.text
	# Print "desired itterations" - text1
	ori $2, $0, 4
	la $a0, text1
	syscall

	# String Read
	ori $2, $0, 5
	syscall

	beq $v0, 2, SKIP
              
	ori $20, $0, 0          
	ori $24, $0, 1            
	ori $25, $0, 3 

	addu $27, $0, $2

	# Print "Summation" - text2
	ori $2, $0, 4
	la $a0, text2
	syscall

	addu $2, $0, $27 

	# Fibonacci Called
	addu $4, $0, $2 
	jal fibonacci
	addu $5, $0, $2 # save return value to a1

	# Exit
	ori $2, $0, 10
	syscall


## fibonacci (int n) - function to be called
fibonacci:
	# Setup
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	addu $16, $0, $4
	slt $28, $24, $25         #; 56: bge $t8, $t9, INITIAL 
	beq $28, $0, INITIAL
		addi $t8, $t8, 1
		jal printOne
		jal newline
	INITIAL:

	ori $2, $0, 1 # return value for end of function
	slti $28, $16, 3
	bne $28, $0, fibonacciExit # check return condition
	addi $a0, $s0, -1 #f(n-1)
	jal fibonacci # Calls fibonacci function

	addu $17, $0, $2 # store result of f(n-1) to s1

	addi $a0, $s0, -2 #f(n-2)
	jal fibonacci # Calls fibonacci

	add $2, $17, $2 # add result of f(n-1) to it
	slt $28, $20, $2           
	beq $28, $0, PRINT
		addu $20, $0, $2 
		jal print
		jal newline
	PRINT: 



fibonacciExit:

	lw $ra, 8($sp)
	lw $s0, 4($sp)
	lw $s1, 0($sp)
	addi $sp, $sp, 12

	jr $31 

print:

	addu $27, $0, $2         
	addu $26, $0, $20 

	ori $2, $0, 1
	addu $4, $0, $27
	syscall
	
	addu $2, $0, $27
	
	jr $31

printOne: 
	addu $27, $0, $2

	ori $2, $0, 1          
	ori $4, $0, 1
	syscall
	
	addu $2, $0, $27
	jr $31


newline:

	addu $27, $0, $2

	ori $2, $0, 4        # you can call it your way as well with addi 
	la $a0, space       # load address of the string
	syscall

	addu $2, $0, $27
	
	jr $31

SKIP:
	ori $2, $0, 4
	la $a0, text2
	syscall

	jal printOne 
	jal newline
	jal printOne
	jal newline

	# Exit
	ori $2, $0, 10
	syscall