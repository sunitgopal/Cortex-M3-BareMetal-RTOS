.syntax unified     /* Use modern Thumb-2 syntax */


.section .vectors
vector_table:                 // Vector table base (goes at start of FLASH)
    .word 0x20002000          // Initial MSP: top of 8 KB SRAM at 0x20000000
    .word reset_Handler       // Reset vector (entry point)

    .org 0x38                 // Offset to PendSV vector slot (0x38 (58) from table base)
    .word PendSV_Handler
    .word systick_Handler     // SysTick ISR entry

    .zero 336                 // Reserve space for remaining vectors (kept zero for now)
