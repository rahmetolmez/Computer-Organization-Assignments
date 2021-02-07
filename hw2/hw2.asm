### CheckSumPossibility
### Author: Rahmet Ali Olmez
### November 2020

	.data
arr:		.space	400	#int arr[100]
arraySize:	.word	0	#int arraySize = 0
num:		.word	0	#int num = 0
txt_getInput:	.asciiz "Please enter arr size, target num and the elements of the array:\n"
txt_possible:	.asciiz "Possible!\n"
txt_notPossible:.asciiz "Not possible!\n"

	.text
	.globl main
main:
	#print user instructions
	li $v0, 4
	la $a0, txt_getInput
	syscall
	
	#cin >> arraySize
	li $v0, 5
	syscall
	sw $v0, arraySize
	
	#cin >> num
	li $v0, 5
	syscall
	sw $v0, num
	
	#read array elements in a loop
	add $s0, $s0, $zero	#int i = 0 (init counter)
	lw $t0, arraySize	#getting arraySize from memory
	la $s1, arr		#getting address of arr
	
loop:
	#for(int i = 0; i < arraySize; ++i) cin >> arr[i]
	li $v0, 5		#read element
	syscall
	sll $t1, $s0, 2		#multiply counter by 4 to find index
	add $t1, $t1, $s1	#adding the index*4 to arr address to find the element at index: arr[i]	
	sw $v0, 0($t1)		#storing scanned number to array
	addi $s0, $s0, 1	#incrementing counter by one
	bne $s0, $t0, loop	#branching if counter is not equal to arraySize
	
	#CheckSumPossibility(num, arr, arraySize)
	lw $a0, num		#setting num argument
	la $a1, arr		#setting arr argument
	lw $a2, arraySize	#setting arraySize argument
	jal CheckSumPossibility	#jumping to function
	
	#checking return value
	move $s2, $v0		#move the return value to s2 register
	bne $s2, 1, else	#if return value is 1
	li $v0, 4		#cout << "Possible!" << endl
	la $a0, txt_possible	
	syscall
	j exit			#if above code executed, dont enter else
	
else:
	li $v0, 4		#cout << "Not possible!" << endl
	la $a0, txt_notPossible	
	syscall
	
exit:
	#exit program
	li $v0, 10
	syscall

#a0: num, a1: arr, a2: size, a3: arr_mem
CheckSumPossibility:
	addi $sp, $sp, -12	#preparing stack pointer
	sw $a2, 8($sp)		#saving third argument to stack
	sw $a0, 4($sp)		#saving first argument to stack
	sw $ra, 0($sp)		#saving the return address to stack	
	
	bne $a0, 0, exit0	#if(num == 0)	
	addi $sp, $sp, 12	#pop stack
	addi $v0, $zero, 1	#set return value to 1	
	jr $ra			#return 1	
	
exit0:
	slt $t0, $a0, $zero	#if (num < 0)
	beq $t0, $zero, exit1
	addi $sp, $sp, 12	#pop stack
	addi $v0, $zero, 0	#set return value to 0
	jr $ra			#return 0

exit1:
	bne, $a2, 1, exit2	#if(size == 1)
	lw $t1, 0($a1)		#getting arr[0]
	bne $a0, $t1, else1	#if(num == arr[0])
	addi $sp, $sp, 12	#pop stack
	addi $v0, $zero, 1	#set return value to 1
	jr $ra			#return 1
	
else1:
	addi $sp, $sp, 12	#pop stack
	addi $v0, $zero, 0	#set return value to 0
	jr $ra			#return 0
	
exit2:	
	##if(CheckSumPossibility(num - arr[size - 1], arr, size - 1) == 1)
	#setting the arguments
	sub $t0, $a2, 1		#finding size - 1
	sll $t0, $t0, 2		#finding index*4
	add $t0, $a1, $t0	#finding address of arr[size - 1] = $t0
	lw $t0, 0($t0)		#get arr[size - 1]
	sub $a0, $a0, $t0	#find num - arr[size - 1] and set set a0			
	sub $a2, $a2, 1		#decrement size by 1 and set a2
	
	#recursive call
	jal CheckSumPossibility
	bne $v0, 1, exit3	#if function returned 1
	addi $v0, $zero, 1	#set return value to 1
	j return1
	
exit3:
	##if(CheckSumPossibility(num, arr, size - 1))
	lw $ra, 0($sp)		#restoring the return address
	lw $a0, 4($sp)
	lw $a2, 8($sp)
	
	#setting the arguments
	sub $a2, $a2, 1		#decrement size by 1 and set a2
	
	#recursive call
	jal CheckSumPossibility
	bne $v0, 1, return0
	addi $v0, $zero, 1	#set return value to 1
	j return1

return0:
	#restoring register values
	lw $ra, 0($sp)		#restoring the return address
	lw $a0, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12	#restoring stack pointer
	
	addi $v0, $zero, 0	#set return value to 0
	jr $ra			#return 0
	
return1:
	#restoring register values
	lw $ra, 0($sp)		#restoring the return address
	lw $a0, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12	#restoring stack pointer
	
	addi $v0, $zero, 1	#set return value to 1
	jr $ra			#return 1
	
	
	
	
