;;;Assembly Project 4th Year SETU Cybersecurity & IT Security © 2024 by David Williams is licensed under Attribution-NonCommercial-NoDerivatives 4.0 International. 
;;; To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/
;;; C00263768

;;; Turn into an executable with the following two commands
;;; 1. nasm -f elf64 <filename>.asm
;;; 2. ld <filename>.o
;;; 1 assembles to code to produce the object file <filename>".o"
;;; 2 links to produce the executable "a.out"

	SYS_READ   equ     0            ; read text from stdin
	SYS_WRITE  equ     1            ; write text to stdout
	SYS_EXIT   equ     60           ; terminate the program
	STDIN      equ     0            ; standard input
	STDOUT     equ     1            ; standard output
; --------------------------------
section .bss
    MaxLength equ     24            ; 24 bytes for user input
    UserInput     resb    MaxLength ; buffer for user input
; --------------------------------
section .data
    prompt          db      "Please input some text (max 23 characters): ", 0
    prompt_len      equ     $ - prompt   ; prompt length of users input
    text_len        equ     23           ; Maximum length of the input string
    output          db      text_len + 1 dup(0)    ; Buffer to store the output string 
    swapcase_msg    db      "The swapcase string looks like this: ", 0
    swapcase_msg_len equ     $ - swapcase_msg
    rot47_msg       db      "The ROT47 string looks like this: ", 0
    rot47_msg_len   equ     $ - rot47_msg
; --------------------------------
section .text                       ; Start of the code section
    global _start                   ; Entry point for the program
; --------------------------------
_start:
    ;; Output a prompt to user
    mov     rdx, prompt_len         ; move prompt_len to rdx
    mov     rsi, prompt             ; move prompt to rsi
    mov     rdi, STDOUT             ; File descriptor (stdout)
    mov     rax, SYS_WRITE          ; syscall number for write
    syscall                         ; Call kernel

    ;; Read a string from console into UserInput
    mov     rdx, text_len           ; Maximum length of the input string
    lea     rsi, [output]           ; Address of the output buffer
    mov     rdi, STDIN              ; File descriptor (stdin)
    mov     rax, SYS_READ           ; syscall number for read
    syscall                         ; Call kernel

    ;; Call procedure to swap the string case
    mov     rdi, output             ; Pass address of the output buffer
    mov     rsi, text_len           ; Pass length of the input string
    call    swapcase

    ;; Print the message for swapcase output
    ;; I use this to check if the swapcase procedure works even if not needed
    mov     rdx, swapcase_msg_len   ; Length of the message
    mov     rsi, swapcase_msg       ; Address of the swapcase output message
    mov     rdi, STDOUT             ; File descriptor (stdout)
    mov     rax, SYS_WRITE          ; syscall number for write
    syscall                         ; Call kernel

    ;; Print swapped string
    mov     rdx, text_len           ; Length of the swapped string 
    mov     rsi, output             ; Address of the swapped string
    mov     rdi, STDOUT             ; File descriptor (stdout)
    mov     rax, SYS_WRITE          ; syscall number for write
    syscall                         ; Call kernel

    ;; Call procedure to ROT47 the string
    mov     rdi, output             ; Pass address of the output buffer
    call    rot47                   ; Call method to ROT47 the string

    ;; Print the message for ROT47 output
    mov     rdx, rot47_msg_len      ; Length of the message
    mov     rsi, rot47_msg          ; Address of the ROT47 output message
    mov     rdi, STDOUT             ; File descriptor (stdout)
    mov     rax, SYS_WRITE          ; syscall number for write
    syscall                         ; Call kernel

    ;; Print ROT47 output string
    mov     rdx, text_len           ; Length of the ROT47 output string
    mov     rsi, output             ; Address of the ROT47 output string
    mov     rdi, STDOUT             ; File descriptor (stdout)
    mov     rax, SYS_WRITE          ; syscall number for write
    syscall                         ; Call kernel

    ;; Exit the program with exit code 0
    xor     edi, edi                ; successful exit
    mov     rax, SYS_EXIT           ; syscall number for exit
    syscall                         ; Call kernel

;;; Method to swap case in a string
;;; Parameters:
;;; RDI: address of the input string
;;; RSI: length of the input string
swapcase:
    xor     rax, rax                ; Clear RAX to use it as a counter
.loop:
    movzx   edx, byte [rdi + rax]   ; Load the next character into EDX
    test    dl, dl                  ; Check if we've reached the end of the string
    jz      .done                   ; If it's the end, exit the loop

    cmp     dl, 'A'                 ; Compare with 'A' (uppercase start)
    jl      .not_letter             ; If less than 'A', not a letter, skip
    cmp     dl, 'Z'                 ; Compare with 'Z' (uppercase end)
    jle     .uppercase              ; If less than or equal to 'Z', it's uppercase

    cmp     dl, 'a'                 ; Compare with 'a' (lowercase start)
    jl      .not_letter             ; If less than 'a', not a letter, skip
    cmp     dl, 'z'                 ; Compare with 'z' (lowercase end)
    jle     .lowercase              ; If less than or equal to 'z', it's lowercase
    jmp     .not_letter             ; If not in either range, it's not a letter

.uppercase:
    add     dl, 32                  ; Convert uppercase to lowercase
    mov     [rdi + rax], dl         ; Update the character in the string
    inc     rax                     ; Move to the next character
    jmp     .loop                   ; Repeat for the next character

.lowercase:
    sub     dl, 32                  ; Convert lowercase to uppercase
    mov     [rdi + rax], dl         ; Update the character in the string
    inc     rax                     ; Move to the next character
    jmp     .loop                   ; Repeat for the next character

.not_letter:
    inc     rax                     ; Move to the next character
    jmp     .loop                   ; Repeat for the next character

.done:
    ret                             ;Return from the method

;;; Method to perform ROT47 encryption/decryption
;;; Parameter passed in:
;;; RDI: address of the input string
rot47:
    xor     rax, rax                ; Clear RAX to use it as a counter
.loop:
    movzx   edx, byte [rdi + rax]   ; Load the next character into EDX
    test    dl, dl                  ; Check if we've reached the end of the string
    jz      .done                   ; If it's the end, exit the loop

    add     dl, 47                  ; Apply ROT47 transformation
    cmp     dl, 127                 ; Check if the character exceeds printable ASCII range
    jbe     .store                  ; If not, store it
    sub     dl, 94                  ; Otherwise, wraparound

.store:
    mov     [rdi + rax], dl         ; Update the character in the string
    inc     rax                     ; Move to the next character
    jmp     .loop                   ; Repeat for the next character

.done:
    ret                             ; Return from the method
