.text
.global main
main:
	mov r0, #4
	beq evenlessmain
	
lessmain:
	mov r0, #1
	bx lr
	
evenlessmain:
	mov r0, #2
	bx lr
	

