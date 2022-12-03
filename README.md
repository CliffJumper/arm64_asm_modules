# arm64_asm_modules
ARM 64 ASM modules; useful helpers for programming ARM64 assembly

## Intended for ARM64 Linux
Many of these will only work on ARM64 and in Linux, especially `linuxmacros.S`.  Since they're using some of the Linux headers, they have to use gcc to assemble, so that those headers can be included.
