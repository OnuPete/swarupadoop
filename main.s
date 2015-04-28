#current state: writing front end
#	
#
#
#
#
#

.data
	_strcat:		.asciiz 	"strcat"		#dest, src
	_strncat: 	.asciiz 	"strncat"	#dest, src, n
	_strlen:		.asciiz 	"strlen"		#src
	_strpbrk:	.asciiz 	"strpbrk"	#src, char
	_strcspn: 	.asciiz 	"strcspn"	#src, char
	_strcmp: 	.asciiz 	"strcmp"	#str1, str2
	_strncmp:	.asciiz 	"strncmp"	#str1, str2, n
	_strchr:		.asciiz 	"strchr"		#src, char
	_strrchr:	.asciiz 	"strrchr"	#src, char

	_strcat_usage:		.asciiz 	"strcat: concatenate arg2 onto the end of arg1"					#dest, src
	_strncat_usage: 	.asciiz 	"strncat: concatenate arg3 many characters of arg2 onto the end of arg1"		#dest, src, n
	_strlen_usage:		.asciiz 	"strlen: return length of string in arg1"							#src
	_strpbrk_usage:	.asciiz 	"strpbrk: return index of any character in arg2, found in arg1"			#str, chars
	_strcspn_usage: 	.asciiz 	"strcspn: return number of characters in arg1 before first character in arg2 is seen"	#src, char
	_strcmp_usage: 	.asciiz 	"strcmp: return comparison of arg1 and arg2"					#str1, str2
	_strncmp_usage:	.asciiz 	"strncmp: return comparison of first arg3 characters of arg1 and arg2"		#str1, str2, n
	_strchr_usage:		.asciiz 	"strchr: return first location of arg2's first character in arg1"				#str, char
	_strrchr_usage:	.asciiz	"strrchr: return last location of arg2's first character in arg1"				#str, char

	_arg1:			.asciiz 	"please input arg1:"
	_arg2:			.asciiz 	"please input arg2:"
	_arg3:			.asciiz 	"please input arg3:"

	introduction:	.asciiz "please enter one of the following, or 'help' for usage"
	introduction_2	.asciiz "strcat, strncat, strlen, strpbrk, strcspn, strcmp, strncmp"
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
	jal print_string #tell them what they can do, and ask for response

	jal read_string #read response

	la $a0, $v0	#put the return value into $a0
	la $s0, $v0	#but also save it, as $a0 will be destroyed
	la $a1, _help	
	jal strcmp 	#compare it to 'help'

	beqz $v0, print_usages #if the user input 'help' execute the usages routine.  This ends in a rerun of main, so this control flow is done.

	#$s0 still contains the command string.
	#now we go through all the possible commands, and execute witchever one the user asked for

	la $a0, $s0 #copy query string into arg1
	la $a1, _strcat
	jal strcmp
	beqz $v0, call_strcat

	la $a0, $s0 #copy query string into arg1
	la $a1, _strncat
	jal strcmp
	beqz $v0, call_strncat

	la $a0, $s0 #copy query string into arg1
	la $a1, _strlen
	jal strcmp
	beqz $v0, call_strlen

	la $a0, $s0 #copy query string into arg1
	la $a1, _strpbrk
	jal strcmp
	beqz $v0, call_strpbrk

	la $a0, $s0 #copy query string into arg1
	la $a1, _strcspn
	jal strcmp
	beqz $v0, call_strcspn

	la $a0, $s0 #copy query string into arg1
	la $a1, _strcmp
	jal strcmp
	beqz $v0, call_strcmp

	la $a0, $s0 #copy query string into arg1
	la $a1, _strncmp
	jal strcmp
	beqz $v0, call_strncmp

	la $a0, $s0 #copy query string into arg1
	la $a1, _strchr
	jal strcmp
	beqz $v0, call_strchr

	la $a0, $s0 #copy query string into arg1
	la $a1, _strrchr
	jal strcmp
	beqz $v0, call_strrchr

	j print_usages #uh-oh, they didn't give us a valid string. print usages and restart
#end of main method.


print_usages:

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
	print_string

	la $a0, _arg1
	print_string
	read_string
	la $s0, $v0	#save the input

	la $a0, _arg2
	print_string
	read_string
	la $a1, $v0	#second input goes straight to argument for strcat

	la $a0, $s0	#first input gets taken from its save location to the argument

	jal  strcat 	#call the actual function

	la $a0, $v0	#take the input, and load it straight into the print_string argument
	print_string

	j terminate 	#exit.
#end of call_strcat


call_strncat:
	la $a0, _strncat_usage
	print_string

	la $a0, _arg1
	print_string
	read_string
	la $s0, $v0	#save the first input

	la $a0, _arg2
	print_string
	read_string
	la $s1, $v0	#save the second input

	la $a0, _arg3
	print_string
	read_int
	move $a2, $v0#third input goes straight to argument for strncat

	la $a0, $s0	#first input gets taken from its save location to the argument
	la $a1, $s1

	jal  strncat 	#call the actual function

	la $a0, $v0	#take the input, and load it straight into the print_string argument
	print_string

	j terminate 	#exit.
#end of call_strncat


call_strlen:
	la $a0, _strlen_usage
	print_string

	la $a0, _arg1
	print_string
	read_string
	la $a0, $v0	#save the input straight to the argument for strlen

	jal  strlen	#call the actual function

	move $a0, $v0	#take the input, and load it straight into the print_string argument
	print_int

	j terminate 	#exit.
#end of call_strlen


call_strpbrk:
	la $a0, _strpbrk_usage
	print_string

	la $a0, _arg1
	print_string
	read_string
	la $s0, $v0	#save the input

	la $a0, _arg2
	print_string
	read_string
	la $a1, $v0	#second input goes straight to argument for strcat

	la $a0, $s0	#first input gets taken from its save location to the argument

	jal  strpbrk 	#call the actual function

	la $a0, $v0	#take the input, and load it straight into the print_string argument
	print_string

	j terminate 	#exit.
#end of call_strpbrk


call_strcspn:
	la $a0, _strcspn_usage
	print_string

	la $a0, _arg1
	print_string
	read_string
	la $s0, $v0	#save the input

	la $a0, _arg2
	print_string
	read_string
	la $a1, $v0	#second input goes straight to argument for strcat

	la $a0, $s0	#first input gets taken from its save location to the argument

	jal  strcspn 	#call the actual function

	move $a0, $v0	#take the input, and load it straight into the print_string argument
	print_int

	j terminate 	#exit.
#end of call_strpbrk


call_strcmp:
	la $a0, _strcmp_usage
	print_string

	la $a0, _arg1
	print_string
	read_string
	la $s0, $v0	#save the input

	la $a0, _arg2
	print_string
	read_string
	la $a1, $v0	#second input goes straight to argument for strcat

	la $a0, $s0	#first input gets taken from its save location to the argument

	jal  strcmp 	#call the actual function

	move $a0, $v0	#take the input, and load it straight into the print_string argument
	print_int

	j terminate 	#exit.
#end of call_strcmp

call_strncmp:
	la $a0, _strncmp_usage
	print_string

	la $a0, _arg1
	print_string
	read_string
	la $s0, $v0	#save the first input

	la $a0, _arg2
	print_string
	read_string
	la $s1, $v0	#save the second input

	la $a0, _arg3
	print_string
	read_int
	move $a2, $v0#third input goes straight to argument for strncat

	la $a0, $s0	#first input gets taken from its save location to the argument
	la $a1, $s1

	jal  strncmp 	#call the actual function

	move $a0, $v0	#take the input, and load it straight into the print_string argument
	print_int

	j terminate 	#exit.
#end of call_strncmp


call_strchr:
	la $a0, _strchr_usage
	print_string

	la $a0, _arg1
	print_string
	read_string
	la $s0, $v0	#save the input

	la $a0, _arg2
	print_string
	read_string
	la $a1, $v0	#second input goes straight to argument for strcat

	la $a0, $s0	#first input gets taken from its save location to the argument

	jal  strchr 	#call the actual function

	move $a0, $v0	#take the input, and load it straight into the print_string argument
	print_int

	j terminate 	#exit.
#end of call_strchr


call_strrchr:
	la $a0, _strrchr_usage
	print_string

	la $a0, _arg1
	print_string
	read_string
	la $s0, $v0	#save the input

	la $a0, _arg2
	print_string
	read_string
	la $a1, $v0	#second input goes straight to argument for strcat

	la $a0, $s0	#first input gets taken from its save location to the argument

	jal  strrchr 	#call the actual function

	move $a0, $v0	#take the input, and load it straight into the print_string argument
	print_int

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
.end
