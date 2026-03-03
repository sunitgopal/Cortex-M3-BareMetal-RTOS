.syntax unified     /* Use modern Thumb-2 syntax */
.cpu cortex-m3
.thumb

.section .text
.p2align 1              // align next label (PendSV_Handler) to 2-byte boundary for correct instruction fetch
.type PendSV_Handler, %function   // tells the assembler to treat this as a function

.global PendSV_Handler
PendSV_Handler:

    /* 1. Extract the physical PSP into R0 */
    mrs r0, psp         // Move to Register from Special register

    /* 2. Save Context (R4-R11) onto Task's Stack */
    stmdb r0!, {r4-r11}   // Notice we use R0, Not sp!

    /* 3. Save the new PSP value to current TCB */
    ldr r1, =current_tcb
    ldr r2, [r1]            // R2 = current TCB
    str r0, [r2]            // current_tcb->sp = R0

    /* 4. CHOOSE NEXT TASK (Linked List Traversal) */
    ldr r3, [r2, #4]        // R3 = current_tcb->next
    str r3, [r1]            // current_tcb = next tcb

    /* 5. Load the new PSP value from the next TCB */
    ldr r0, [r3]            // R0 = current_tcb->sp

    /* 6. Restore Context (R4-R11) from the new Task's Stack */
    ldmia r0!, {r4-r11}

    /* 7. Update the physical PSP shadow register */
    msr psp, r0             // CPU will use this PSP when it returns to Thread Mode

    /* 8. Return
        Note: HW takes care of return to Thread mode here */
    bx lr
