.data
.balign 4
   string:  .asciz "\n A[%d] = : %d"
.balign 4
   string1: .asciz "\n ::l=%d::::r=%d::::m=%d::"
.balign 4
   arrstring:  .asciz "\n A[%d] = : %d"
.balign 4
   string3: .asciz "\n A[%d] = %d"
.balign 4
   string4: .asciz "\n\n\n\nSorted Array:"
.balign 4
   stringR: .asciz "\n R[%d]: %d"
.balign 4
   stringL: .asciz "\n L[%d]: %d"
.balign 4
   stringCheck: .asciz "\n|\n n1: %d, n2: %d \n|"
.balign 4
   A:       .skip 512 @128*4
.balign 4
   N:  .word 128
.balign 4
   bigN: .word 64
.balign 4
   R:		.skip 256 @128*4
.balign 4
   L:		.skip 256 @128*4

/* CODE SECTION */
.text
.balign 4
.global main
.extern printf
.extern rand

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@ MAKEARRAY MAKEARRAY MAKEARRAY ARRAY @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

makearray: push {LR}
    mov r5,#0           @ Initialize 128 elements in the array
    ldr r4,=A
loop1:
    ldr r0,=N
    ldr r0,[r0]
    cmp r5, r0
    bge end1
    bl      rand
    and r0,r0,#255
    str r0, [r4], #4
    add r5, r5, #1
    b loop1                  /* Go to the beginning of the loop */
end1:

    mov r5,#0           @ Print out the array
    ldr r4,=A
loop2:
    ldr r0,=N
    ldr r0,[r0]
    cmp r5, r0
    beq end2
    push {r0,r1,r2,r3,r4}  @ we can save and restore the registers on the stack!!
    ldr r0,=string
    mov r1,r5
    ldr r2,[r4]
    bl printf
    pop {r0,r1,r2,r3,r4}
    add r5, r5, #1
    add r4,r4,#4
    b loop2                  /* Go to the beginning of the loop */
end2:
	pop {LR}
	mov pc, LR

	
	
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@ MERGE MERGE MERGE MERGE MERGE MERGE @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@merge(int arr[], int l, int m, int r)
merge:  push {r1,r2,r3,LR} @r0=arr[], r1=l, r2=r, r3=m

	
		
		arr .req r0
		l	.req r1
		r	.req r2
		m	.req r3
		i	.req r4
		j	.req r5
		k	.req r6
		n1	.req r7
		n2	.req r8		
		
		@pop {l,r,m}
		
		sub n1, m,l
		add n1, m,#1
						
		sub n2, r,m		
		
		push {r0,r,m,n1,n2} @L: %d, R: %d, M: %d, n1: %d, n2: %d		
		ldr r0,=stringCheck
		mov r1, n1
		mov r2, n2
		bl printf
		pop {r0,r,m,n1,n2}		
		
		mov i, #0
		mov j, #0
		mov k, l
		push {k}
		@push {l,r,m}
		@CREATE TEMP ARRAYS		
		

@COPY DATA TO TEMP ARRAYS L[] AND R[]		
for1:	
	cmp i,n1
	bge for1end	

		@l[i] = arr[l + i]
	add  r6, l,i	

	ldr r0, =A
	ldr  r11,[r0,r6,lsl #2]	@load arr[l+i] into r11
	ldr r0, =L
	str  r11,[r0,i,lsl #2]		@store arr with L[i]	
	
	add i, i,#1
	b for1
for1end:
	mov i, #0
	mov j, #0
	mov r6, #0
	pop {k}
	push {k}

for2:
	cmp j,n2
	bge for2end	
		
		@r[j] = arr[m+1+j]
	add r6, m,#1
	add r6, r6,j
	
	ldr r0, =A
	ldr r11,[r0,r6,lsl #2]		@stor arr[m+1+j] into R[j]
	ldr r0, =R
	str r11,[r0,j,lsl #2]	@load r11 with R[j]	
	
	add j, j,#1
	b for2
for2end:
	mov i, #0
	mov j, #0
	pop {k}
	push {k}

while1:	
	cmp i,n1
	bge while1end
	cmp j,n2
	bge while1end
	
		@if (L[i] <= r[j])
	ldr r0, =R
	ldr r11,[r0,j,lsl #2]		@R[j]
	ldr r0, =L
	ldr r12,[r0,i,lsl #2]		@L[i]
	
	cmp r12,r11	
		@	arr[k] = L[i];
	ldrle r0, =L
	ldrle r11, [r0,i,lsl #2]
	ldrle r0, =A
	strle r11, [r0,k,lsl #2]

	addle i, i,#1
		
		@else
		@arr[k] = R[j]
	ldrgt r0, =R
	ldrgt r11, [r0,j,lsl #2]
	ldrgt r0, =A
	strgt r11, [r0,k,lsl #2]

	addgt j, j,#1
	
	add k, k,#1
	
	b while1	
while1end:
	mov i, #0
	mov j, #0
	pop {k}
	push {k}

while2:
	cmp i,n1
	bge while2end
	
	@arr[k] = L[i]
	ldr r0, =A
	ldr r11,[r0,k,lsl #2]		 @store arr[k] in L[i]
	ldr r0, =L
	str r11,[r0,i,lsl #2]		@L[i]

	
	add i, i,#1
	add k, k,#1
	
	b while2
while2end:
	mov i, #0
	mov j, #0
	pop {k}
	push {k}

while3:
	cmp j,n2
	bge while3end
	
	@arr[k] = R[j]
	ldr r0, =A
	ldr r11,[r0,k,lsl #2]		@store arr[k] in R[j]
	ldr r0, =R
	str r11,[r0,j,lsl #2]		@R[j]

	
	add j, j,#1
	add k, k,#1
	
	b while3
while3end:
	mov i, #0
	mov j, #0
	pop {k}	
	pop {r1,r2,r3}
	pop {LR}
	mov pc, LR



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@ MERGE SORT MERGE SORT MERGE SORT @@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@mergeSort(int arr[], int l, int r)
mergeSort: push {r0,r1,r2,LR}
@    {
     push {r0,r1,r2,r3}
     ldr r0,=string1
     bl printf
     pop {r0,r1,r2,r3}

@    if (l < r)
     cmp r1,r2
     bge mergeSortEnd
@    {
@        // Same as (l+r)/2, but avoids overflow for
@        // large l and h
         push {r1,r2}   @ save L and R
@        int m = l+(r-l)/2;
         sub r2,r2,r1  @ This was a bug (was a 1) int the morning and afternoon versions
         lsr r2,r2,#1
         add r2,r2,r1
         push {r2}  @ save m
@        // Sort first and second halves

@        mergeSort(arr, l, m);   // Remember l is R1, R2 is r=m
         bl mergeSort
         pop {r3}   @ put m into r3
         pop  {r1,r2}  @restored l and r
         push {r1,r2}
         push {r3}
         add  r1,r3,#1
         
@        mergeSort(arr, m+1, r);
         bl mergeSort
         pop  {r3}
         pop  {r1,r2}
         
@        //  merge(arr, l, m, r);
		 
		 @push {r1,r2,r3,LR}
		 
		 push {r1,r2}
		 push {r3}
         bl merge       
         pop {r1,r2}
         pop {r3}
     

@   >>>>>    Note the formal params are r0=arr,r1=l,r3=m,r2=r <<<<<<<<<<<<<<<<<
@    }

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

mergeEnd:
mergeSortEnd: pop {r0,r1,r2,PC}  @ notice put LR into PC to force return

@}


main:
    push    {ip,lr}     @ This is needed to return to the Operating System
	
	bl makearray

    ldr     r0,=A
    mov     r1,#0	
    ldr     r2,=N
    ldr     r2,[r2]
	
	@push lr at mergesort	
    bl mergeSort


FinalPrint:
	mov r5, #0	
	mov r6, #128
	ldr r4, =A
		
	ldr r0, =string4
	bl printf    
    
FinalPrant:
	cmp r5,r6
	movge r5, #0
	movge r6, #64
	ldrge r4, =R
	bge printr
	
	ldr r0,=string3
	mov r1, r5
    ldr r2,[r4]	
       
    bl  printf
	
	add r5, r5,#1
	add r4, r4,#4
	b FinalPrant
printr:
	cmp r5,r6
	movge r5, #0
	movge r6, #64
	ldrge r4, =L
	bge printl
	
	ldr r0,=stringR
	mov r1, r5
    ldr r2,[r4]	
       
    bl  printf
	
	add r5, r5,#1
	add r4, r4,#4
	b printr

printl:
	cmp r5,r6
	bge FinalEnd
	
	ldr r0,=stringL
	mov r1, r5
    ldr r2,[r4]	
       
    bl  printf
	
	add r5, r5,#1
	add r4, r4,#4
	b printl

FinalEnd:
    mov     r0,#0

    pop     {ip, pc}    @ This is the return to the operating system
