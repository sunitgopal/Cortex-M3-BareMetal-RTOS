/* kernel.s - The OS Data Structures */


.syntax unified
.cpu cortex-m3
.thumb

.section .data
.p2align 2

/* -------------------------------------------------------------------------
   GLOBAL KERNEL POINTER
   ------------------------------------------------------------------------- */
.global current_tcb
current_tcb:
    .word tcb0          // Pointer to the TCB of the running task

/* -------------------------------------------------------------------------
   TASK CONTROL BLOCKS (Linked List)
   Structure:
     Offset 0: SP
     Offset 4: Next TCB
   ------------------------------------------------------------------------- */
.global tcb0
tcb0:
    .word stack0        // Initial SP
    .word tcb1          // Points to Task 1

.global tcb1
tcb1:
    .word stack1
    .word tcb2          // Points to Task 2

.global tcb2
tcb2:
    .word stack2
    .word tcb3          // Points to Task 3

.global tcb3
tcb3:
    .word stack3
    .word tcb0          // Points back to Task 0 (Circular!)



.section .text
.p2align 2
.type os_kernel_launch, %function   // tells the assembler to treat this as a function

.global os_kernel_launch
os_kernel_launch:

    /* 1. Load the Address of the Current TCB */
    ldr r0, =current_tcb
    ldr r1, [r0]            // R1 = &tcb0 (The first task)

    /* 2. Load Task 0's Stack Pointer */
    ldr sp, [r1]            // SP = stack0 (Point SP to top of Task 0 stack)

    /* 3. Discard/Restore the Software Stack Frame (R4-R11) */
    ldmia sp!, {r4-r11}     // Pop R4-R11. We don't need them for the first launch.

    /* 4. Discard/Restore the Hardware Stack Frame (R0-R3, R12, LR, PC, xPSR)
        Note: This is to mimic/simulate what the hardware usually does automatically
                i.e., exception-return behavior! */
    ldmia sp!, {r0-r3}      // Pop R0-R3
    ldmia sp!, {r12}        // Pop R12
    add sp, sp, #4          // Skip LR (We don't need to return anywhere)
    ldmia sp!, {lr}         // Pop PC into LR (We use LR as a temp holder for the address)
    add sp, sp, #4          // Skip xPSR

    /* 5. Copy current SP into PSP */
    mov r0, sp              // Since <msr psp, sp> is not allowed
    msr psp, r0             // Move to Special Register from Register

    /* 6. Reset MSP to top-of-RAM */
    ldr r0, =0x20002000
    msr msp, r0

    /* 7. Flip the switch: MSP -> PSP */
    mov r0, #2
    msr control, r0

    /* 8. Flush instrn-pipeline */
    isb                     // Instruction Synchrnzn Barrier

    /* 9. Enable Interrupts */
    cpsie i                 // PRIMASK = 0 (Enable Interrupts globally)

    /* 10. Launch! */
    bx lr                   /* Branch to the address we popped into LR (Task 0 entry)
                                i.e., Jump to task0    */
