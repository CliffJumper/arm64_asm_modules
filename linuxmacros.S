//
// Assembler Macros for common Linux service routines
//

// Include the header for the Linux svc numbers
#include <asm/unistd.h>

// Some constants we'll need
.EQU    O_RDONLY,        0
.EQU    O_WRONLY,        1
.EQU    O_CREAT,         0100
.EQU    O_EXCL,          0200
.EQU    S_RDWR,          0666
.EQU    AT_FDCWD,       -100

// Macro for printing
// 
// arg1 - buffer - The buffer to print
//
// x0 - Linux File Handle; set to #1 for STDOUT
// x1 - The String to print
// x8 - Set to 64 for the Linux write() service routine
.MACRO  print   buffer
        mov x0, #1              // #1 is the Linux STDOUT file handle
        ldr x1, =\buffer        // x1 gets the buffer to be printed
        mov x8, #__NR_write     // #64 is the Linux write() service routine number
        svc 0                   // Call the Linux service routine
.ENDM


// Macro for exiting via Linux exit() routine
//
// arg1 - retcode - The Return code
//
// x0 - The return code
// x8 - Set to 93, the Linux exit() service routine number
.MACRO  exit    retcode
        mov x0, \retcode        // The code to return, should be 0 for success.
        mov x8, #__NR_exit      // The number for the Linux exit() routine
        svc 0                   // Call the Linux service routine
.ENDM

//
// Macro to open a file, returning the file descriptor
//
// arg1 - name - The name of the file to open
// arg2 - flags - The Flags (R,W,RW, etc.) to use when opening
// 
// x0 - Gets set to AT_FDCWD, a special code telling the openat() Linux service should use the current working directory
// x1 - Set to the file name to open
// x2 - Set to the flags used to set the mode the file is opened in (opened for reading, writing, etc.)
// x3 - Set to the MODE a file would be created with.  This sets the file permissions user - RWX, group - RWX, etc.
// x8 - Set to the openat() Linux routine number
// NOTE: The file descreptor is set in x0 on success or a negative number indicates failure
.MACRO  open    name,   flags
        mov     x0,     #AT_FDCWD       // Use PWD
        ldr     x1,     =\name          // Set filename to open
        mov     x2,     #\flags         // Set the open flags
        mov     x3,     #S_RDWR         // If creating the file, set permissions 0666
        mov     x8,     #__NR_openat    // Set Service number for openat()
        svc     0
.ENDM

// 
// Macro to read a file into a buffer
//
// arg1 - fd - file descriptor for the (already opened) file
// arg2 - buff - pointer to buffer to hold the data that is read
// arg3 - len - The length of data to read. Cannot be greater that SSIZE_MAX (see Linux man pages)
//
// x0 - Set to the file descriptor
// x1 - Set to the address of the buffer to read into
// x2 - Set to the number of bytes to read
// x8 - Set to the Linux svc number for read()
// NOTE: The number of bytes read is set in x0 on success or -1 on an error.  
.MACRO  read    fd,     buff,   len
        mov     x0,     \fd             // File descriptor set in x0
        ldr     x1,     =\buff          // Address of the buffer the read data will be placed in set in x1
        mov     x2,     #\len           // Number of bytes to read set in x2
        mov     x8,     #__NR_read      // Linux read() svc code set in X8
        svc     0                       // Call the service routine
.ENDM

//
// Macro to write a buffer to a file
//
// arg1 - fd - file descriptor for the (already opened) file
// arg2 - buff - pointer to buffer holding the data to be written
// arg3 - len - The length of data to write. Cannot be greater that SSIZE_MAX (see Linux man pages)
//
// x0 - set to the file descriptor
// x1 - Set to the address of the buffer holding the data to write
// x2 - Set to the number of bytes to write
// x8 - Set to the Linux svc nubmer for write()
// NOTE: The number of bytes written is set in x0 on success or -1 on an error.  
.MACRO  write   fd,     buff,   len
        mov     x0,     \fd             // File descriptor set in x0
        ldr     x1,     =\buff          // Address of the buffer holding the data to write set in x1
        mov     x2,     #\len           // Number of bytes to write set in x2
        mov     x8,     #__NR_write     // Linux write() svc code set in x8
        svc     0                       // Call the service routine
.ENDM
