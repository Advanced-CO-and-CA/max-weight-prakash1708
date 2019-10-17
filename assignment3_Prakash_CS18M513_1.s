


/******************************************************************************
* file: max_weight_find.s
* author: Prakash Tiwari
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/



  @ BSS section
      .bss

  @ DATA SECTION
      .data
data_start: .word 0x205A15E3
            .word 0x256C8700
            .word 0x375D9800
            .word 0x584D5601
            .word 0x495E7854
            .word 0x295468F2
data_end:   .word 0

array_len : .word (data_end - data_start)/4

output_num    : .word 0
output_max_wt : .word 0 

  @ TEXT section
      .text

.globl _main


_main:
   ldr r1, =array_len
   
   @temporary variable to save maximum weight
   mov     r3, #0
   str     r3, [sp, #-4]
   
   @temporary variable to save number with maximum weight
   mov     r3, #0
   str     r3, [sp, #-8]
   
   @temporary variable to save loop/array_index counter
   mov     r3, #0
   str     r3, [sp, #-12]
   
 @loop to iterate through list of numbers
 
 loop:
   
   @ load loop counter variable
   ldr     r3, [sp, #-12] 
   
   @ load array_len
   ldr     r2, [r1]       
  
   @ compare loop counter to length of the array to check end of list
   cmp     r2, r3
   bls     exit_loop
   
   @ load array index counter to r2 from stack to fetch the current number
   ldr         r2,[sp,#-12]
   movs        r3,#4
   
   @ Update r2 with array index * 4
   mul         r2,r3,r2
   
   @ get the location => array + r2 (next word position)
   ldr         r3,=data_start
   add         r3,r3,r2
   ldr         r3,[r3]  @ load the value from array

   @ save the current number to stack
   str     r3, [sp, #-16]
   
   @ variable to count number of bit set
   mov     r3, #0
   str     r3, [sp, #-20]
   
   @ loop to count number of bits set
 bit_count_loop:
   
   @get the number from stack
   ldr     r3, [sp, #-16]
   cmp     r3, #0
   
   @if number is not zero, count the number of remaining set bits
   beq     bit_count_loop_exit
   ldr     r3, [sp, #-16]
   
   @ and number with 1 to check if bit is set
   and     r2, r3, #1
   ldr     r3, [sp, #-20]
   
   @ update/increment the count of bits
   add     r3, r2, r3
   str     r3, [sp, #-20]
   
   @ right shift the current number by 1 for next iteration
   ldr     r3, [sp, #-16]
   lsr     r3, r3, #1
   
   @ update the number after right on stack for next iteration
   str     r3, [sp, #-16]
   b       bit_count_loop

 bit_count_loop_exit:
   
   @ update the maximum weight and number with maximum weight to stack variables
   ldr     r2, [sp, #-20] @ read the current value of maximum weight
   ldr     r3, [sp, #-4]  @ read the last maximum weight
   
   @ if count of bits is greater than previous count of bits then update the values
   cmp     r2, r3
   
   ble     loop_counter_incr
   ldr     r3, [sp, #-20] @ read the current value of maximum weight
   str     r3, [sp, #-4] @ update the last maximum weight
   
   
   @ update corresponding number with maximum weight to stack
   @ load loop/array index counter to r2 from stack
   ldr         r2,[sp,#-12]
   movs        r3,#4
   
   @ update r2 with array index * 4
   mul         r2,r3,r2
   @ get the location of current number => array + r2 (next word position)
   ldr         r3,=data_start
   add         r3,r3,r2
   ldr         r3,[r3]  @ load the value from array
   str     r3, [sp, #-8] @ update the number with maximum weight
   
 
 loop_counter_incr:
        @update loop counter variable for next iteration and same the variable onto stack
        ldr     r3, [sp, #-12]
        add     r3, r3, #1
        str     r3, [sp, #-12]
        b       loop
 
  exit_loop:
        @ save the result to global variables
        ldr         r3, [sp,#-8] @ read number with maximum weight from stack
		ldr         r2,=output_num
        str         r3,[r2] @ update the result
        ldr         r3, [sp,#-4] @ read maximum weight from stack	
		ldr         r2,=output_max_wt
        str         r3,[r2] @ update the result