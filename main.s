#current state: front end finished
#	strncmp says "hi" and "hello" are the same up to 5 letters 
#
#

.data
	_strcat:		.asciiz 	"strcat\n"		#dest, src
	_strncat: 	.asciiz 	"strncat\n"		#dest, src, n
	_strlen:		.asciiz 	"strlen\n"		#src
	_strpbrk:	.asciiz 	"strpbrk\n"		#src, char
	_strcspn: 	.asciiz 	"strcspn\n"		#src, char
	_strcmp: 	.asciiz 	"strcmp\n"		#str1, str2
	_strncmp:	.asciiz 	"strncmp\n"		#str1, str2, n
	_strchr:		.asciiz 	"strchr\n"		#src, char
	_strrchr:	.asciiz 	"strrchr\n"		#src, char

	_strcat_usage:		.asciiz 	"\nstrcat: concatenate arg2 onto the end of arg1"					#dest, src
	_strncat_usage: 	.asciiz 	"\nstrncat: concatenate arg3 many characters of arg2 onto the end of arg1"		#dest, src, n
	_strlen_usage:		.asciiz 	"\nstrlen: return length of string in arg1"							#src
	_strpbrk_usage:	.asciiz 	"\nstrpbrk: return index of any character in arg2, found in arg1"			#str, chars
	_strcspn_usage: 	.asciiz 	"\nstrcspn: return number of characters in arg1 before first character in arg2 is seen"	#src, char
	_strcmp_usage: 	.asciiz 	"\nstrcmp: return comparison of arg1 and arg2"					#str1, str2
	_strncmp_usage:	.asciiz 	"\nstrncmp: return comparison of first arg3 characters of arg1 and arg2"		#str1, str2, n
	_strchr_usage:		.asciiz 	"\nstrchr: return first location of arg2's first character in arg1"				#str, char
	_strrchr_usage:	.asciiz	"\nstrrchr: return last location of arg2's first character in arg1"				#str, char

	_arg1:			.asciiz 	"\nplease input arg1:"
	_arg2:			.asciiz 	"\nplease input arg2:"
	_arg3:			.asciiz 	"\nplease input arg3:"

	introduction:	.asciiz "please enter one of the following, or 'help' for usage"
	introduction_2:	.asciiz "\nstrcat, strncat, strlen, strpbrk, strcspn, strcmp, strncmp, strchr, strrchr\n"
	_help:		.asciiz "help\n" 
	newline:	.asciiz "\n"

	str1:	.space 140	#we're dealing strictly with tweetable strings here
	str2:	.space 140

.text
.globl main
main:
	#read first argument: check that it's an accepted command, jump back here if not.
	#based on argument, query for more commands
	#receive the required arguments and call the function with these arguments
	#receive return value from function, print it, and exit
	la $a0, introduction
	jal print_string
	la $a0, introduction_2
	jal print_string #tell them what they can do, and ask for response

	jal read_string #read response

	la $a0, ($v0)	#put the return value into $a0
	la $s0, ($v0)	#but also save it, as $a0 will be destroyed
	la $a1, _help	
	jal strcmp 	#compare it to 'help'

	beqz $v0, print_usages #if the user input 'help' execute the usages routine.  This ends in a rerun of main, so this control flow is done.

	#$s0 still contains the command string.
	#now we go through all the possible commands, and execute whichever one the user asked for

	la $a0, ($s0) #copy query string into arg1
	la $a1, _strcat
	jal strcmp
	beqz $v0, call_strcat

	la $a0, ($s0) #copy query string into arg1
	la $a1, _strncat
	jal strcmp
	beqz $v0, call_strncat

	la $a0, ($s0) #copy query string into arg1
	la $a1, _strlen
	jal strcmp
	beqz $v0, call_strlen

	la $a0, ($s0) #copy query string into arg1
	la $a1, _strpbrk
	jal strcmp
	beqz $v0, call_strpbrk

	la $a0, ($s0) #copy query string into arg1
	la $a1, _strcspn
	jal strcmp
	beqz $v0, call_strcspn

	la $a0, ($s0) #copy query string into arg1
	la $a1, _strcmp
	jal strcmp
	beqz $v0, call_strcmp

	la $a0, ($s0) #copy query string into arg1
	la $a1, _strncmp
	jal strcmp
	beqz $v0, call_strncmp

	la $a0, ($s0) #copy query string into arg1
	la $a1, _strchr
	jal strcmp
	beqz $v0, call_strchr

	la $a0, ($s0) #copy query string into arg1
	la $a1, _strrchr
	jal strcmp
	beqz $v0, call_strrchr

	j print_usages #uh-oh, they didn't give us a valid string. print usages and restart
#end of main method.


print_usages:

	la $a0, _strcat_usage
	jal print_string
	la $a0, _strncat_usage
	jal print_string
	la $a0, _strlen_usage
	jal print_string
	la $a0, _strpbrk_usage
	jal print_string
	la $a0, _strcspn_usage
	jal print_string
	la $a0, _strcmp_usage
	jal print_string
	la $a0, _strncmp_usage
	jal print_string
	la $a0, introduction
	jal print_string
	j main


#---------------- I/O utils ----------------
print_string:
	#$a0 already contains address of string to print
	li $v0, 4        # system call code for print_str
	syscall          # print the string
	jr $ra

print_int:
	# la $a0, int      #integer to print
	li $v0, 1        # system call code for print_int
	syscall
	jr $ra

read_string:		#str1 will contain contents after this block is executed.
	li $v0, 8	#system call code for read_string
	li $a0, 140	#length of string to read
	la $a0, str1	#where to read string into
	move $t0,$a0  #save string to t0
	syscall
	la $v0, str1 	#reload byte space to primary address
    	move $v0,$t0   # primary address = t0 address (load pointer)
	jr $ra

read_string_2:
	li $v0, 8	#system call code for read_string
	li $a0, 140	#length of string to read
	la $a0, str2	#where to read string into
	move $t0,$a0  #save string to t0
	syscall
	la $v0, str2 	#reload byte space to primary address
    	move $v0,$t0   # primary address = t0 address (load pointer)
	jr $ra

read_int:
	li $v0, 5        # system call code for read_int
	syscall
	jr $ra 		#return value is in $v0

terminate:
	li $v0, 10        # system call code for exit
	syscall
	#no point in jumping, control flow is terminated.



#---------------- intermediate functions ----------------
# 	_strcat:		#dest, src
# 	_strncat: 	#dest, src, n
# 	_strlen:		#src
# 	_strpbrk:	#src, char
# 	_strcspn: 	#src, char
# 	_strcmp: 	#str1, str2
# 	_strncmp:	#str1, str2, n
# 	_strchr:		#src, char
# 	_strrchr:	#src, char


call_strcat:
	la $a0, _strcat_usage
	jal print_string

	la $a0, _arg1
	jal print_string
	jal read_string
	la $s0, ($v0)	#save the input

	la $a0, _arg2
	jal print_string
	jal read_string_2
	la $a1, ($v0)	#second input goes straight to argument for strcat

	la $a0, ($s0)	#first input gets taken from its save location to the argument

	jal  strcat 	#call the actual function

	la $a0, ($v0)	#take the input, and load it straight into the print_string argument
	jal print_string

	j terminate 	#exit.
#end of call_strcat


call_strncat:
	la $a0, _strncat_usage
	jal print_string

	la $a0, _arg1
	jal print_string
	jal read_string
	la $s0, ($v0)	#save the first input

	la $a0, _arg2
	jal print_string
	jal read_string_2
	la $s1, ($v0)	#save the second input

	la $a0, _arg3
	jal print_string
	jal read_int
	move $a2, $v0#third input goes straight to argument for strncat

	la $a0, ($s0)	#first input gets taken from its save location to the argument
	la $a1, ($s1)

	jal  strncat 	#call the actual function

	la $a0, ($v0)	#take the input, and load it straight into the print_string argument
	jal print_string

	j terminate 	#exit.
#end of call_strncat


call_strlen:
	la $a0, _strlen_usage
	jal print_string

	la $a0, _arg1
	jal print_string
	jal read_string
	la $a0, ($v0)	#save the input straight to the argument for strlen

	jal  strlen	#call the actual function

	move $a0, $v0	#take the input, and load it straight into the print_string argument
	addi $a0, $a0, -1	#a '\n' character is added in qtspim, so we subtract 1 to account for that.
	jal print_int

	j terminate 	#exit.
#end of call_strlen


call_strpbrk:
	la $a0, _strpbrk_usage
	jal print_string

	la $a0, _arg1
	jal print_string
	jal read_string
	la $s0, ($v0)	#save the input

	la $a0, _arg2
	jal print_string
	jal read_string_2
	la $a1, ($v0)	#second input goes straight to argument

	la $a0, ($s0)	#first input gets taken from its save location to the argument

	jal  strpbrk 	#call the actual function

	la $a0, ($v0)	#take the input, and load it straight into the print_string argument
	jal print_string

	j terminate 	#exit.
#end of call_strpbrk


call_strcspn:
	la $a0, _strcspn_usage
	jal print_string

	la $a0, _arg1
	jal print_string
	jal read_string
	la $s0, ($v0)	#save the input

	la $a0, _arg2
	jal print_string
	jal read_string_2
	la $a1, ($v0)	#second input goes straight to argument

	la $a0, ($s0)	#first input gets taken from its save location to the argument

	jal  strcspn 	#call the actual function

	move $a0,  $v0	#take the input, and load it straight into the print_string argument
	jal print_int

	j terminate 	#exit.
#end of call_strpbrk


call_strcmp:
	la $a0, _strcmp_usage
	jal print_string

	la $a0, _arg1
	jal print_string
	jal read_string
	la $s0, ($v0)	#save the input

	la $a0, _arg2
	jal print_string
	jal read_string_2
	la $a1, ($v0)	#second input goes straight to argument

	la $a0, ($s0)	#first input gets taken from its save location to the argument

	jal  strcmp 	#call the actual function

	move $a0, $v0	#take the input, and load it straight into the print_string argument
	jal print_int

	j terminate 	#exit.
#end of call_strcmp

call_strncmp:
	la $a0, _strncmp_usage
	jal print_string

	la $a0, _arg1
	jal print_string
	jal read_string
	la $s0, ($v0)	#save the first input

	la $a0, _arg2
	jal print_string
	jal read_string_2
	la $s1, ($v0)	#save the second input

	la $a0, _arg3
	jal print_string
	jal read_int
	move $a2, $v0#third input goes straight to argument

	la $a0, ($s0)	#first input gets taken from its save location to the argument
	la $a1, ($s1)

	jal  strncmp 	#call the actual function

	move $a0, $v0	#take the input, and load it straight into the print_string argument
	jal print_int

	j terminate 	#exit.
#end of call_strncmp


call_strchr:
	la $a0, _strchr_usage
	jal print_string

	la $a0, _arg1
	jal print_string
	jal read_string
	la $s0, ($v0)	#save the input

	la $a0, _arg2
	jal print_string
	jal read_string_2
	la $a1, ($v0)	#second input goes straight to argument

	la $a0, ($s0)	#first input gets taken from its save location to the argument

	jal  strchr 	#call the actual function

	move $a0, $v0	#take the input, and load it straight into the print_string argument
	jal print_int

	j terminate 	#exit.
#end of call_strchr


call_strrchr:
	la $a0, _strrchr_usage
	jal print_string

	la $a0, _arg1
	jal print_string
	jal read_string
	la $s0, ($v0)	#save the input

	la $a0, _arg2
	jal print_string
	jal read_string_2
	la $a1, ($v0)	#second input goes straight to argument

	la $a0, ($s0)	#first input gets taken from its save location to the argument

	jal  strrchr 	#call the actual function

	move $a0, $v0	#take the input, and load it straight into the print_string argument
	jal print_int

	j terminate 	#exit.
#end of call_strrchr






#——————————————————-strcmp————————————-——————
# Compare the two strings
# $a0 stores the address of the first string
# $a1 stores the address of the second string
# returns -1, 0, or +1 

.text
.ent strcmp         				#make strcmp an entry point

strcmp:
	lbu $t0, 0($a0) 			#Loads byte from first string
	lbu $t1, 0($a1) 			#Loads byte from second string
	
# Compare characters loaded
	blt $t0, $t1, Minus 			#Return -1 if first char is < second char
	bgt $t0, $t1, Plus 			#Return +1 if first char is > second char
	beqz $t1,Zero 				#Return 0 if both are equal or null
continue:
	addi $a0,$a0,1
	addi $a1,$a1,1
	b strcmp

#return if s1 < s2
Minus:
	li $v0,-1
	jr $ra

#return if s1 > s2
Plus:
	li $v0,1
	jr $ra

#returned if s1 == s2
Zero:
	li $v0,0
	jr $ra
#end of strcmp


#——————————————————-strchr————————————-——————
#strchr finds the index of the first instance of a given char in a given string

strchr:
					#$a0 contains string to search
					#$a1 contains character to search for
					#$v0 will contain return value, index of a1 in a0, or -1 if not found
					#$s1 will contain the current search depth

	li $v0, 0			#clear return variable and counter
	li $s1, 0		
strchrloop:
	lbu	$t0, 0($a0)		#load a byte from the string
	lbu	$t1, 0($a1)		#load the comparison char
	beqz	$t0,  strchrend 	#last character in the string. base case end
	beq	$t0, $t1, strchrfnd 	#found
	addi	$a0, $a0, 1		#increment character
	addi	$s1, $s1, 1		#increment counter
	b 	strchrloop		#not found or end, repeat loop

strchrfnd:				#found, return index of location
	move	$v0, $s1
	jr	$ra

strchrend:				#not found, return -1
	li	$v0, -1
	jr	$ra


#——————————————————-strrchr————————————-——————
#strrchr finds the index of the last instance of a given char in a given string

strrchr:
					#$a0 contains string to search
					#$a1 contains character to search for
					#$v0 will contain return value, last index of a1 in a0, or -1 if not found
					#$s0 will contain length of string in $a0
					#$s1 will contain the current search depth


	li $v0, -1			#default the return variable to unfound
	li $t2,  0			#counter to keep track of the current location in the string
	move $s0, $v0			#$v0 is for return values, and this is internal. we copy it to $s0

strrchrloop:
	lb	$t0, 0($a0)   		#loading value
	lb	$t1, 0($a1)		#load the comparison char
	beqz	$t0, strrchrend	#last character in the string. base case end.
	beq	$t0, $t1, strrchrfnd 	#found
	addi	$t2, $t2, 1		#increment the counter to keep track of the location
	addi 	$a0, $a0, 1		#move forward one character
	b 	strrchrloop

strrchrfnd:				#found, return index of location
	move	$v0, $t2		#say this location is the final answer
	addi	$t2, $t2, 1		#increment the counter to keep track of the location
	addi 	$a0, $a0, 1		#move forward one character
	b strrchrloop			#continue doing this until the end of the string
					#that way when the string is done, our last answer is correct

strrchrend:	
	jr	$ra
#end of strrchr



#—————————————————————strcat————————————————————
# Add the second string to the end of the first
# $a0 stores the address of the first string
# $a1 stores the address of the second string
# returns nothing


strcat:

endSecondString:
	lbu $t1, 0($a0)			# Get first char from the second string
	beq $t1, $0, secondEnd		# If NULL, exit
	addi $a0, $a0, 1
	b endSecondString

secondEnd:

append:
	lbu $t1, 0($a1)			# get first char of the first string
	sb $t1, 0($a0)			# add it to rhe end of the second string
	beq $t1, $0, catExit		# When null, goto exit
	addi $a0, $a0, 1		# Increment the first string
	addi $a1, $a1, 1		# Increment the second string
	b append			# Loop

catExit:
	j $ra				#Return
	.end
	
#—————————————————————strncat————————————————————
# Add up to n chars of the second string to the end of the first
# $a0 stores the address of the first string
# $a1 stores the address of the second string
# $a3 stores the address of n
# returns nothing
strncat:
	sw $ra, 0($sp)			# Move the 
	sub $sp, $sp, 4  

	add $t6, $a2, 0

append:
	beq $t6, 0,  ncatExit
	beq $a0, 0, ncatExit
	beq $a1, 0, ncatExit
	sub $t6, $t6, 1

	lbu $t4, 0($a0)
	sb $t1, 0($a1)
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	b append

ncatExit:
	add $sp, $sp, 4
	j $ra
	.end

#—————————————————————strlen————————————————————
# Find the length of the string at the address $a0 up to a max length of $a1
#
# $a0 stores the address of the string
# $a1 is the max length of the string in address $a0
#
# Registers:
# $s0 counts characters
# $s1 holds the current character being counted
#

strlen:

	addi $sp, $sp,  -4 			#Store registers on the stack
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)

	li $s0 0 				#Set current count to 0
	lb $s1 0($a0) 				#Load first character

strlenLoop:					#end loop if current character is 0
	beq $s1, $zero, strlen_done
	beq $s0, $a1, strlen_done

	addi $s0, $s0, 1 			#increment character count
	addi $a0, $a0, 1 			#increment address

	lb $s1, 0($a0) 				#load next character
	j strlenLoop

strlen_done:					# restore registers from the stack
	move $v0, $s0
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
#end of strlen

#—————————————————————strpbrk————————————————————
# Find the first occurence of a letter in each of string one and two
# $a0 stores the addres of the first string
# $a1 stores the address of the second string
# Returns the index of the first occurence of chars, else -1

strpbrk:
	li $v0, 0				#clear output
	li $s1, 0				#clear counter

findChar:
	lbu $t1, 0($a1)				# Get first char in string 2
	beqz $t1, strend			# Worst case, no string found
	bge $t1, $0, charInString		# While there is a char, goto charInString
	addi $a1, $a1, 1			# Increment second string char
	b findChar					# Loop

charInString:
	lbu $t0, 0($a0)				# Get first char in string 1
	beq $t0, $t1, strFound 			# Found char
	addi $a0, $a0, 1			# Increment first string
	addi $s1, $s1, 1			# Increment counter
	b charInString				# Loop

strFound:
	move $v0, $s1				# Retrun index location
	jr $ra

strend:
	li $v0, -1				# Index location not found
	jr $ra					# retrun -1

#—————————————————————strcspn————————————————————
# Find the first occurence of a letter in each of string one and two or else find the length of string one
# $a0 stores the addres of the first string
# $a1 stores the address of the second string
# Returns the index of the first occurence of chars, else Return the length of string one

strcspn:
	li $v0, 0				# Clear output
	li $s2, 0				# Clear second counter

findChar:
	li $s1, 0				# Clear first counter
	lbu $t1, 0($a1)				# Get first char of second string
	beqz $t1, stringLength			# If not found, get length of string 1
	bne $t1, $0, charInString		# While there is still a char in string 2,
						# goto charInString
	addi $a1, $a1, 1			# Increment the second string
	b findChar				# Loop

charInString:
	lbu $t0, 0($a0)				# Get first char of string 1
	beq $t0, $t1, strFound 			# If char in string 1 equals char in string 2,
				 		# goto strFound
	addi $a0, $a0, 1			# Increment first string
	addi $s1, $s1, 1			# Increment second counter
	b charInString				# Loop

strfound:
	move $v0, $s1				# Retrun index location
	jr $ra

stringLength:
	lbu $t0, 0($a0)				# Get first char of string 1
	beqz $t0, exit 				# When no more string, goto exit
	addi $a0, $a0, 1			# Increment the first string
	addi $s2, $s2, 1			# Increment the second counter
	b stringLength				# Loop
exit: 
	move $v0, $s2				# Retrun first string length
	jr $ra


#—————————————strncmp————————————
# Compare the characters of two strings, s1 and s2
# if the s1 char = the s2 char, $v0 is 0 (or equal)
# if the s1 char > the s2 char, $v0 is positive
# if the s1 char < the s2 char, $v0 is negative
# $v0 holds the comparison result (s1 char - s2 char)

strncmp:
	sw $ra, 0($sp)
	sub $sp, $sp, 4  			#decrement stack pointer

	and $v0, $v0, 0  			#init result to 0
	add $t4, $a0, 0  			#place s1 in $t4
	add $t5, $a1, 0	 			#place s2 in $t5
	add $t6, $a2, 0				#place length in $t6

strncmp_nxtchr:
	beq $t6, 0, strncmp_fin
	sub $t6, $t6, 1   			#decrement $t6
	lb $t1, ($t4)     			#load char from s1 to $t1
	lb $t2, ($t5)	  			#load char from s2 to $t2
	
	add $v0, $t1, 0
	sub $v0, $v0, $t2 			#places ($t1 - $t2) in $v0
	
	beq $t6, 0, strncmp_fin 		#if counter is 0, exit
	beq $t1, 0, strncmp_fin			#if char in s1 is 0, exit
	beq $t2, 0, strncmp_fin			#if char in s2 is 0, exit
	add $t4, $t4, 1				#increment s1 pointer
	add $t5, $t5, 1				#increment s2 pointer

	beq $v0, 0, strncmp_nxtchr		#check result from subtraction

strncmp_fin:
	add $sp, $sp, 4				#increment stack pointer
	lw $ra, 0($sp)		
	jr $ra					#return to caller

#end of strncmp
