#input string needs to be manuaully changed, used given example
#output stored in $v1 - for this example should be 6
.data	

input: .asciiz "Numbers are 0, 25 and 123 for this.\n"

.text
.globl		main
main:	
	#reads address for given input string
	la $a0, input

	addu $8, $0, $2  

	#intialise counting register and jump to function
	ori $13, $0, 0 
	jal CountNumbers
	addu $3, $0, $13

	ori $2, $0, 10 
	syscall
	


CountNumbers:

	add $t0, $0, $a0

	L1: 
		lbu $t1, 0($t0)
		beq $t1, $0, L3

		slti $t2, $t1, 0x30
		bne $t2, $0, L2 #compares for number lower than 0
		
		slti $t2, $t1, 0x39
		beq $t2, $0, L2 # compares for upper number 9
		
		add $t5, $t5, 1 # if valid number increment register
 
	L2:
		sb $t1, 0($t0)
		addi $t0, $t0, 1 #find next character and jump back to L1
		j L1 

	L3:
		jr $31 #once end of string is found return to main
		