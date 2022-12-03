//
// stackmacros.s
// 
// Macros to simplify dealing with stack registers
//

// pushstack - Push one register to the stack and update the stack pointer
//
// register - The Register to push to the stack
.MACRO  pushstack       register
        str     \register,      [sp, #-16]!     // Push register to the stack and move the stack pointer. SP must be 16-byte aligned.
.ENDM

// popstack - Pop top of stack to register and update the stack pointer
//
// register - The register that will get the value from the stack
.MACRO  popstack        register
        ldr     \register,      [sp],   #16     // Pops top of stack into register and updates SP
.ENDM

// pushdstack - Push 2 registers to the stack and update the Stack Pointer
//
// register1 - The first register to push to the stack
// register2 - The second register to push to the stack
.MACRO  pushdstack      register1,      register2
        stp     \register1,     \register2,     [SP, #-16]!     // Push registers to the stack.  SP must be 16-byte aligned.
.ENDM

// popdstack - Pop 2 register from the stack and update the stack pointer
//
// register1 - The first register that will get stack data
// register2 - The second register that will get stack data
.MACRO  popdstack       register1,      register2
        ldr     \register1,     \register2,     [SP], #16       // Pop 2 register from the stack. SP must be 16-byte aligned
.ENDM
