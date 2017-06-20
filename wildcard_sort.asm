# You can implement any sorting algorithm you choose.  You can really go two ways with this: implement the simplest algorithm you can think of in as few lines as possible or take on a faster, but more complex algorithm like heapsort.
# Input arguments:
#	$a0 - starting memory address of the array to be sorted
#	$a1 - number of elements in array
# A comparison of a number of sorting algorithms you might attempt can be found here:
# https://en.wikipedia.org/wiki/Sorting_algorithm#Comparison_of_algorithms

#----------------------------------------------------------------
# Author: Rudi Wever
# ASU - CST250
# FALL-A 2015
#----------------------------------------------------------------

wildcard_sort:
	addiu $a2, $a1, -1	#right is $a1-1
	lui $a1, 0		#left = 0
	push $ra
	jal quicksort
	nop
	pop $ra
	return

#QUICKSORT
#INPUT:	$a0 - starting address of the array
#	$a1 - left
#	$a2 - right
quicksort:
	push $ra

	move $t0, $a1	#i = left
	move $t1, $a2	#j = right
			# $t3 - reserved for temp
			# $t4 - pivot value
	# int pivot = arr[(left+right)/2]
	addu $t7, $t0, $t1	#left + right
	srl $t7, $t7, 1	#(left + right)/2
	sll $t7, $t7, 2	#words are 4 bytes
	addu $t6, $a0, $t7	#memory location of pivot
	lw $t4, 0($t6) 	#get pivot value
#	subu $t8, $a2, $a1	#if (len <= 1)
#	beq $t8, $0, partition_swap_1	#array size = 1
#	nop
#	li $t7, 1
#	bne $t8, $t7, partition_main_loop	# array size > 2
#	nop
#	sll $t8, $a1, 2	# left*4
#	addu $t8, $t8, $a0
#	lw $t7, 0($t8)	#get arr[left] into $t7
#	sll $t6, $a2, 2	# right*4
#	addu $t6, $t6, $a0
#	lw $t5, 0($t6)	#get arr[right] into $t4
#	slt $t3, $t7, $t5
#	bne $t3, $0, partition_swap_1 # left < right
#	nop
#	sw $t5, 0($t8)	# arr[right] into left
#	sw $t7, 0($t6)  	# arr[left] into right
#	j partition_swap_1
#	nop

partition_main_loop:
	addiu $t6, $t1, 1
	slt $t7, $t0, $t6	#(i<=j)
	beq $t7, $0, recursion	# while (i!<=j){
##	nop
# while (arr[i]<pivot), pivot is in $t4
#i++ , i is in $t0
partition_loop_1:
	sll $t6, $t0, 2	# i*4
	addu $t6, $t6, $a0
	lw $t7, 0($t6)	#get arr[i] into $t7
	slt $t6, $t7, $t4
	beq $t6, $0, partition_loop_2	# arr[i] is not less than pivot 
	nop

	j partition_loop_1
	addiu $t0, $t0, 1	# i++

# while (arr[j]>pivot), pivot is in $t4
#j-- , j is in $t1
partition_loop_2:
	sll $t6, $t1, 2	# j*4
	addu $t6, $t6, $a0
	lw $t7, 0($t6)	#get arr[j] into $t7
	slt $t6, $t4, $t7
	beq $t6, $0, partition_swap	# arr[j] is not less than pivot
	nop
#	addiu $t1, $t1, -1	# j--
	j partition_loop_2
	addiu $t1, $t1, -1	# j--
#nop
#if (i <= j) {
#	tmp = arr[i] 	# i is in $t0
#	arr[i] = arr[j]	# j is in $t1
#	arr[j] = tmp
#	i++
#	j--
#}
partition_swap:
	beq $t0, $t1, partition_swap_1
##	nop
	addiu $t6, $t1, 1	# $t6 = j+1
	slt $t7, $t0, $t6	#(i < $t6)
	beq $t7, $0, partition_main_loop	# while (i!<=j){
##	nop
	sll $t6, $t0, 2	# i*4
	addu $t6, $t6, $a0
	lw $t7, 0($t6)	#get arr[i] into temp($t7)
	sll $t5, $t1, 2	# j*4
	addu $t5, $t5, $a0
	lw $t3, 0($t5)	# get arr[j] into $t3
	sw $t3, 0($t6)	# arr[i] = arr[j]
	sw $t7, 0($t5)	# arr[j] = temp($t7)
partition_swap_1:
	addiu $t0, $t0, 1	# i++
	addiu $t1, $t1, -1	# j--


#partition_end_while:
	j partition_main_loop
#	nop

# if (left < j)		# left is in $a1, j is in $t1	
# quickSort(arr, left, j)	# arr in $a0
# if (i < right)		# i is in $t0, right is in $a2
# quickSort(arr, i, right)	# arr in $a0
recursion:	
	slt $t3, $a1, $t1
	beq $t3, $0, recursion_2	# left < j = false
	nop
	push $t0
	push $t1
	push $a2
	# $a0 has the array base
	# $a1 has left
	#move $a2, $t1 #move to after jal and omit nop
	jal quicksort
	move $a2, $t1
	pop $a2
	pop $t1
	pop $t0
recursion_2:
	slt $t3, $t0, $a2
	beq $t3, $0, recursion_end	# i < right = false
	nop
	push $t1
	push $t2
	push $a1
	# $a0 has the array base
	#move $a1, $t0 #move to after jal and omit nop
	# $a1 has right
	jal quicksort
	move $a1, $t0
	pop $a1
	pop $t2
	pop $t1
recursion_end:
	pop $ra
	jr $ra
#	nop
