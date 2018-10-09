.data
.balign 4
	string: 	.asciz "\n x = %d"
.balign 4
	comment: 	.asciz "\n Limit = %d"
.balign 4
	x: 			.word 0
.balign 4
	limit: 		.word 15
	
	
.text
.balign 4
.global main
.extern printf

main:
	push {ip,lr}
	
	ldr 	r0, =x
	mov 	r1, #1
	str 	r1, [r0]
	
	ldr r0, =comment
	ldr r1, =limit
	ldr r1, [r1]
	bl printf
	
dooo:
	ldr		r0, =string
	ldr 	r1, =x
	ldr 	r1, [r1]
	bl printf
	
	ldr r0, =x
	ldr r1, [r0]
	add r1, r1,#1
	str r1, [r0]
	ldr r2,=limit
	ldr r2, [r2]
	cmp r1, r2
	blt dooo				@BLTs are an overrated sandwich :/

	
	pop {ip,pc}
