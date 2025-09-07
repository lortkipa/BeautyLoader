%include 'uefi/structs.inc'

extern uefi_gop_locate
extern uefi_gop_set
extern uefi_gop_rect
extern uefi_gop_clear

bits 64
default rel

section .bss
    
    ; UEFI structures
    global uefi_bs
    uefi_bs : resq 1
    global uefi_rs
    uefi_rs : resq 1

section .text

    ; IN rcx - UEFI image handle
    ; IN rdx - UEFI system table
    global main
    main:
        ; align stack to 16-byte
        sub rsp, 8

        ; store UEFI info
        mov rax, [rdx + UEFI_SYSTEM_TABLE.BOOT_SERVICES]
        mov [uefi_bs], rax
        mov rax, [rdx + UEFI_SYSTEM_TABLE.RUNTIME_SERVICES]
        mov [uefi_rs], rax

        ; init UEFI GOP
        call uefi_gop_locate
        xor ecx, ecx
        call uefi_gop_set

        ; clear screen to gray
        mov cl, 50
        mov dl, 50
        mov bl, 50
        call uefi_gop_clear

        ; draw box1
        mov ecx, 25
        mov edx, ecx
        mov ebx, 100
        mov esi, 100
        mov r8b, 255
        mov r9b, 0
        mov r10b, 0
        call uefi_gop_rect

        ; draw box2
        mov ecx, 50
        mov edx, ecx
        mov ebx, 100
        mov esi, 100
        mov r8b, 0
        mov r9b, 255
        mov r10b, 0
        call uefi_gop_rect

        ; draw box3
        mov ecx, 75
        mov edx, ecx
        mov esi, 100
        mov r8b, 0
        mov r9b, 0
        mov r10b, 255
        call uefi_gop_rect

        ; infinite loop
        jmp $
