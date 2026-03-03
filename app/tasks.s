/* tasks.s - The User Application */

.syntax unified     /* Use modern Thumb-2 syntax */

// task0
.section .text
    .p2align 1
    .type task0, %function

.global task0
task0:
    add r0, r0, #0x01
    b task0


// task1
.section .text
    .p2align 1
    .type task1, %function

.global task1
task1:
    add r1, r1, #0x01
    b task1


// task2
.section .text
    .p2align 1
    .type task2, %function

.global task2
task2:
    add r2, r2, #0x01
    b task2


// task3
.section .text
    .p2align 1
    .type task3, %function

.global task3
task3:
    add r3, r3, #0x01
    b task3


// Task-stacks

.section .data
    .p2align 3

.global stack0
stack0:
    /* Low Addresses (Top of Stack) -> High Addresses */
    .word 0x04, 0x05, 0x06, 0x07        // R4, R5, R6, R7  (Now at SP+0)
    .word 0x08, 0x09, 0x0a, 0x0b        // R8, R9, R10, R11 (Now at SP+16)
    .word 0x00, 0x01, 0x02, 0x03        // R0-R3 (Hardware Saved)
    .word 0x0c
    .word 0xaa1          // LR
    .word task0          // PC
    .word 0x01000000     // xPSR
    .zero 100



.section .data
    .p2align 3

.global stack1
stack1:
    /* Low Addresses (Top of Stack) -> High Addresses */
    .word 0x14, 0x15, 0x16, 0x17        // R4, R5, R6, R7  (Now at SP+0)
    .word 0x18, 0x19, 0x1a, 0x1b        // R8, R9, R10, R11 (Now at SP+16)
    .word 0x10, 0x11, 0x12, 0x13        // R0-R3 (Hardware Saved)
    .word 0x1c
    .word 0xaa1          // LR
    .word task1          // PC
    .word 0x01000000     // xPSR
    .zero 100



.section .data
    .p2align 3

.global stack2
stack2:
    /* Low Addresses (Top of Stack) -> High Addresses */
    .word 0x24, 0x25, 0x26, 0x27        // R4, R5, R6, R7  (Now at SP+0)
    .word 0x28, 0x29, 0x2a, 0x2b        // R8, R9, R10, R11 (Now at SP+16)
    .word 0x20, 0x21, 0x22, 0x23        // R0-R3 (Hardware Saved)
    .word 0x2c
    .word 0xaa1          // LR
    .word task2          // PC
    .word 0x01000000     // xPSR
    .zero 100



.section .data
    .p2align 3

.global stack3
stack3:
    /* Low Addresses (Top of Stack) -> High Addresses */
    .word 0x34, 0x35, 0x36, 0x37        // R4, R5, R6, R7  (Now at SP+0)
    .word 0x38, 0x39, 0x3a, 0x3b        // R8, R9, R10, R11 (Now at SP+16)
    .word 0x30, 0x31, 0x32, 0x33        // R0-R3 (Hardware Saved)
    .word 0x3c
    .word 0xaa1          // LR
    .word task3          // PC
    .word 0x01000000     // xPSR
    .zero 100
