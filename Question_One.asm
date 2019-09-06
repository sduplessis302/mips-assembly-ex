#debugged using register values to see if operations were successfull 

.data	
input: .word 1540000, 2400000, 100000, 400000
output: .word 0, 0, 0, 0


.text
.globl		main
main:	
	#reads address for given input string
	la $t0, input
	la $t2, output
	ori $13, $0, 0      
	ori $21, $0, 0
	ori $t3, $0, 0
	ori $t4, $0, 2048

	jal swapEndian

	ori $2, $0, 10  
	syscall

swapEndian:
	loop: 
	L1: 
		beq $t3, $t4, L3 
		lbu $t1, 0($t0)
		beq $t1, $0, L3
		addi $13, $13, 1 # if valid number increment register
		
		#shift and mask bits
		lw $t7, 0($t0)
		and $s1, $t7, 0x000000FF
		sll $s1, $s1, 24
		and $s2, $t7, 0x0000FF00
		sll $s2, $s2, 8
		and $s3, $t7, 0x00FF0000
		srl $s3, $s3, 8
		and $s4, $t7, 0xFF000000
		srl $s4, $s4, 24

		#concetenating into one register after endianess swap
		or $s6, $s6, $s1
		or $s6, $s6, $s2
		or $s6, $s6, $s3
		or $s6, $s6, $s4
		
		#dividing by 16
		srl $s6, $s6, 4
		
		#storing final value in output array					
		sb $s6, 0($t0)
	L2:
		
		addi $t0, $t0, 4 #find next character and jump back to L1
		addi $t2, $t2, 4
		addi $t3, $t3, 1
		j loop 

	L3:
		jr $31 #once end of string is found return to main
	


		