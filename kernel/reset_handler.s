.syntax unified     /* Use modern Thumb-2 syntax */

// SysTick register equates (Cortex-M system timer)
    .equ CSR,     0xE000E010    // Control and status
    .equ RVR,     0xE000E014    // Reload value
    .equ CVR,     0xE000E018    // Current value
    .equ CALIB,   0xE000E01C    // Calibration (not used yet)

// SysTick reload value: max 24-bit count -> slow, visible ticks
    .equ timeout, 0x00FFFFFF


/* Reset Handler */

.section .text
.p2align 1                  // Halfword-align reset_Handler for valid Thumb fetch
.type reset_Handler, %function   // Mark symbol as a function for tools

.global reset_Handler
reset_Handler:

    /* 1. DISABLE INTERRUPTS (The "Lock") */
    cpsid i                 // PRIMASK = 1 (Disable Interrupts)

    /* 2. Configure SysTick */
    ldr r0, =CSR
    ldr r1, =RVR
    ldr r2, =CVR
    ldr r3, =timeout

    str r3, [r1]            // RVR <- timeout
    str r3, [r2]            // Clear CVR
    mov r3, #0x07           // CLKSOURCE=core, TICKINT=1, ENABLE=1
    str r3, [r0]            // CSR <- enable (Counter starts, but interrupt is blocked by PRIMASK!)

    /* 3. Launch the Kernel (Never Return) */
    bl os_kernel_launch
