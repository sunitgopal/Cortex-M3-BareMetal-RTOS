.syntax unified     /* Use modern Thumb-2 syntax */
.cpu cortex-m3
.thumb

.equ ICSR, 0xE000ED04
.equ PENDSVSET, 0X10000000

.section .text
.p2align 1              // align next label (systick_Handler) to 2-byte boundary for correct instruction fetch
.type systick_Handler, %function   // tells the assembler to treat this as a function

.global systick_Handler
systick_Handler:

   ldr r0, =ICSR
   ldr r1, =PENDSVSET
   str r1, [r0]         // Trigger PendSV
   bx lr                // Return immediately
