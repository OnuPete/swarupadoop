#current state: writing front end
#	
#
#
#
#
#

.data
	_strcpy:	.asciiz	"strcpy"		#dest, src
	_strncpy:	.asciiz 	"strncpy"	#dest, src, n
	_strcat:		.asciiz 	"strcat"		#dest, src
	_strncat: 	.asciiz 	"strncat"	#dest, src, n
	_strlen:		.asciiz 	"strlen"		#src
	_strpbrk:	.asciiz 	"strpbrk"	#src, char
	_strcspn: 	.asciiz 	"strcspn"	#src, char
	_strcmp: 	.asciiz 	"strcmp"	#str1, str2
	_strncmp:	.asciiz 	"strncmp"	#str1, str2, n
	_strchr:		.asciiz 	"strchr"		#src, char
	_strrchr:	.asciiz 	"strrchr"	#src, char

	_strcpy_usage:		.asciiz	"strcpy: copy contents of arg2 into arg1"						#dest, src
	_strncpy_usage:	.asciiz 	"strncpy: copy arg3 many characters of arg2 into arg1"				#dest, src, n
	_strcat_usage:		.asciiz 	"strcat: concatenate arg2 onto the end of arg1"					#dest, src
	_strncat_usage: 	.asciiz 	"strncat: concatenate arg3 many characters of arg2 onto the end of arg1"		#dest, src, n
	_strlen_usage:		.asciiz 	"strlen: return length of string in arg1"							#src
	_strpbrk_usage:	.asciiz 	"strpbrk: return index of any character in arg2, found in arg1"			#str, chars
	_strcspn_usage: 	.asciiz 	"strcspn: return number of characters in arg1 before first character in arg2 is seen"	#src, char
	_strcmp_usage: 	.asciiz 	"strcmp: return comparison of arg1 and arg2"					#str1, str2
	_strncmp_usage:	.asciiz 	"strncmp: return comparison of first arg3 characters of arg1 and arg2"		#str1, str2, n
	_strchr_usage:		.asciiz 	"strchr: return first location of arg2's first character in arg1"				#str, char
	_strrchr_usage:	.asciiz	"strrchr: return last location of arg2's first character in arg1"				#str, char

	introduction:	.asciiz "please enter one of the following, or 'help' for usage"
	introduction_2	.asciiz "strcpy, strncpy, strcat, strncat, strlen, strpbrk, strcspn, strcmp, strncmp"
	_help:		.asciiz "help" 

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
	jal print_string
	#if help, branch to print_usages







print_usages:
	la $a0, _strcpy_usage
	print_string
	la $a0, _strcnpy_usage
	print_string
	la $a0, _strcat_usage
	print_string
	la $a0, _strncat_usage
	print_string
	la $a0, _strlen_usage
	print_string
	la $a0, _strpbrk_usage
	print_string
	la $a0, _strcspn_usage
	print_string
	la $a0, _strcmp_usage
	print_string
	la $a0, _strncmp_usage
	print_string
	la $a0, introduction
	print_string
	j main

print_string:
	# la $a0, str      # address of string to print
	#$a0 already contains string to print
	li $v0, 4        # system call code for print_str
	syscall          # print the string
	jr

print_int:
	# la $a0, int      #integer to print
	li $v0, 1        # system call code for print_int
	syscall
	jr

read_string:		#str1 will contain contents after this block is executed.
	li $v0, 8	#system call code for read_string
	li $a0, 140	#length of string to read
	la $a0, str1	#where to read string into
	syscall
	jr




#——————————————————-strcmp————————————-——————
# Compare the two strings
# $a0 stores the address of the first string
# $a1 stores the address of the second string
# returns -1, 0, or +1 

.text
.ent strcmp         				#make strcpy an entry point

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
	j $ra

#return if s1 > s2
Plus:
	li $v0,1
	j $ra

#returned if s1 == s2
Zero:
	li $v0,0
	j $ra
	.end
