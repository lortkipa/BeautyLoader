%include 'uefi/defines.inc'

extern uefi_bs

bits 64
default rel

section .data

    ; UEFI protocol ids
    global uefi_cip_guid
    uefi_cip_guid:
    istruc UEFI_GUID
        at UEFI_GUID.DATA1, dd 0x387477C1
        at UEFI_GUID.DATA2, dw 0x69C7
        at UEFI_GUID.DATA3, dw 0x11D2
        at UEFI_GUID.DATA4, db 0x8E, 0x39, 0x00,  0xA0, 0xC9, 0x69, 0x72, 0x3B
    iend

section .bss

    ; UEFI structures
    global uefi_cip
    uefi_cip : resq 1
    key      : resb UEFI_INPUT_KEY.SIZE

section .text

    ; OUT al - status
    global uefi_cip_locate
    uefi_cip_locate:
        ; call UEFI function to find CIP
        mov rax, [uefi_bs]
        mov rcx, uefi_cip_guid
        xor rdx, rdx
        mov r8, uefi_cip
        sub rsp, 32
        call [rax + UEFI_BOOT_SERVICES.LOCATE_PROTOCOL]
        add rsp, 32
        
        ; output status
        cmp rax, UEFI_SUCCESS
        jne .failure
        .success:
        mov al, 1
        ret
        .failure:
        xor al, al
        ret

    ; OUT ax - printable character, UEFI unicode character or 0 (if not pressed)
    global uefi_cip_read
    uefi_cip_read:
        ; call UEFI function to find CIP
        mov rcx, [uefi_cip]
        mov rdx, key
        sub rsp, 32
        call [rcx + UEFI_SIMPLE_TEXT_INPUT_PROTOCOL.READ_KEY]
        add rsp, 32
        
        ; output 0 if no key is pressed
        cmp rax, UEFI_SUCCESS
        je .key_pressed
        xor ax, ax
        ret
        .key_pressed:

        ; find out if printable char or UEFI unicode char is pressed and output it
        cmp word [key + UEFI_INPUT_KEY.UNICODE_CHAR], 0
        je .not_printable
        mov ax, [key + UEFI_INPUT_KEY.UNICODE_CHAR]
        ret
        .not_printable:
        mov ax, [key + UEFI_INPUT_KEY.SCAN_CODE]
        ret

    ; OUT ax - printable character or UEFI unicode character
    global uefi_cip_wait
    uefi_cip_wait:
        
        ; align stack to 16-byte + shadow space for UEFI functions
        sub rsp, 40

        ; call UEFI function to wait for key press
        mov rcx, 1
        mov rdx, [uefi_cip]
        mov rdx, [rdx + UEFI_SIMPLE_TEXT_INPUT_PROTOCOL.WAIT_KEY]
        mov r8, rsp
        add r8, 32
        mov rax, [uefi_bs]
        call [rax + UEFI_BOOT_SERVICES.WAIT_EVENT]

        ; get pressed key
        call uefi_cip_read

        ; deallign stack
        add rsp, 40

        ret
