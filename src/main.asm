%include 'uefi/defines.inc'

extern uefi_gop_locate
extern uefi_gop_set
extern uefi_gop_rect
extern uefi_gop_clear

extern uefi_cip_locate
extern uefi_cip_read
extern uefi_cip_wait

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

        ; init graphics
        call uefi_gop_locate
        xor ecx, ecx
        call uefi_gop_set

        ; init input
        call uefi_cip_locate
        cmp al, 0
        je err

        ; clear screen to gray
        mov cl, 50
        mov dl, 50
        mov bl, 50
        call uefi_gop_clear

        ; draw boxes
        xor r12b, r12b
        .draw_box:
        mov eax, 50
        mul r12b

        mov ecx, eax
        mov edx, ecx
        mov ebx, 250
        mov esi, 250
        mov r8b, al
        add r8b, al
        mov r9b, al
        mov r10b, 0
        call uefi_gop_rect

        inc r12b
        cmp r12b, 10
        jne .draw_box

        ; look for key pressed
        .check_press:
            call uefi_cip_wait
            cmp ax, 'a'
            je err
            cmp ax, UEFI_SCANCODE_UARROW
            je err
            jmp .check_press

        ; infinite loop
        jmp $

    err:
        ; clear screen with red
        mov cl, 255
        mov dl, 0
        mov bl, 0
        call uefi_gop_clear

        ; infinite loop
        jmp $
