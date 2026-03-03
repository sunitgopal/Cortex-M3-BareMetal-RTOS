# ARM Cortex-M3 Bare-Metal RTOS ⚙️

A preemptive, deterministic Real-Time Operating System kernel built entirely from scratch for the ARMv7-M architecture. 

This project bypasses all vendor Hardware Abstraction Layers (HALs) and standard C libraries (`-ffreestanding`) to interface directly with the silicon. It demonstrates exact control over the execution pipeline, memory bus arbitration, and hardware exception state machines.

## 🧠 Architectural Highlights

* **Hardware-Offloaded Context Switching:** Leverages the ARM core's Nested Vectored Interrupt Controller (NVIC) by artificially pending the `PendSV` exception. This forces the silicon state machine to stack `R0-R3`, `R12`, `LR`, `PC`, and `xPSR` in zero software clock cycles, minimizing context switch latency.
* **Strict Memory Isolation:** Implements dual-stack execution. User threads are isolated on the Process Stack Pointer (`PSP`), while OS and hardware interrupts are protected on the Main Stack Pointer (`MSP`).
* **Deterministic $O(1)$ Memory Management:** Absolutely no dynamic allocation (`malloc`/`free`) to guarantee zero heap fragmentation. Utilizes pre-allocated static pools with $O(1)$ node-linking algorithms.
* **Lock-Free DMA Synergy:** Implements bitwise (`&`) wrapped circular buffers designed for lock-free, single-producer/single-consumer data pipelines, allowing DMA controllers to saturate RAM without fighting the CPU.
* **C & Assembly Unification:** A custom GNU Make build system that seamlessly links high-level C data structures with pure Thumb-2 assembly core handlers using a custom `.ld` linker script.

## 🚀 Quick Start (Docker / QEMU)
This project is fully containerized using a VS Code .devcontainer to ensure identical toolchain execution across all host machines.

1. Clone and open in VS Code (Requires Dev Containers extension)

2. Build the ELF binary:
`make`

3. Launch the QEMU ARM Emulator:
`make qemu`

4. Attach the GDB Debugger (in a new terminal):
`make gdb`

## 📂 Directory Structure

```text
├── kernel/                # The OS Core (Thumb-2 Assembly)
│   ├── reset_handler.s    # Bare-metal boot and SysTick configuration
│   ├── vector_table.s     # Silicon exception mapping
│   ├── pendsv_handler.s   # The Register swap logic (Context Switch)
│   └── kernel.s           # Task Control Block (TCB) definitions
├── lib/                   # Hardware-Agnostic Data Structures (Freestanding C)
│   ├── circular_buffer.c  # ISR-safe queueing
│   └── static_pool.c      # O(1) memory allocator
├── app/                   # User Space
│   └── tasks.s            # Concurrent application threads
├── Makefile               # Custom GCC/LD build pipeline
└── linker.ld              # SRAM and Flash physical memory boundaries
