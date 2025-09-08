%include 'uefi/defines.inc'

extern uefi_bs

bits 64
default rel

section .data

    ; UEFI protocol ids
    global uefi_gop_guid
    uefi_gop_guid:
    istruc UEFI_GUID
        at UEFI_GUID.DATA1, dd 0x9042A9DE
        at UEFI_GUID.DATA2, dw 0x23DC
        at UEFI_GUID.DATA3, dw 0x4A38
        at UEFI_GUID.DATA4, db 0x96, 0xFB, 0x7A, 0xDE, 0xD0, 0x80, 0x51, 0x6A
    iend

section .bss

    ; UEFI structures
    global uefi_gop
    uefi_gop : resq 1
    gop_info : resq 1

    ; framebuffer info
    global uefi_gop_width
    uefi_gop_width  : resd 1
    global uefi_gop_height
    uefi_gop_height : resd 1

    ; temporary variables
    color: resb UEFI_GRAPHICS_OUTPUT_BLT_PIXEL.SIZE

section .text

    global uefi_gop_locate
    uefi_gop_locate:
        ; call UEFI function to find GOP
        mov rax, [uefi_bs]
        mov rcx, uefi_gop_guid
        xor rdx, rdx
        mov r8, uefi_gop
        sub rsp, 32
        call [rax + UEFI_BOOT_SERVICES.LOCATE_PROTOCOL]
        add rsp, 32

        ret

    ; IN ecx - mode index
    global uefi_gop_set
    uefi_gop_set:
        ; align stack to 16-byte
        sub rsp, 8
        mov r13, rsp

        ; store mode index into nonvolatile register
        mov r12d, ecx

        ; call UEFI function to set provided mode
        mov rcx, [uefi_gop]
        mov edx, r12d
        sub rsp, 32
        call [rcx + UEFI_GRAPHICS_OUTPUT_PROTOCOL.SET_MODE]
        add rsp, 32

        ; call UEFI function to get info about current mode
        mov rcx, [uefi_gop]
        mov edx, r12d
        mov r8, r13
        mov r9, gop_info
        sub rsp, 32
        call [rcx + UEFI_GRAPHICS_OUTPUT_PROTOCOL.QUERY_MODE]
        add rsp, 32

        ; store framebuffer info
        mov rax, [gop_info]
        mov edx, [rax + UEFI_GRAPHICS_OUTPUT_MODE_INFORMATION.HORIZONTAL_RESOLUTION]
        mov [uefi_gop_width], edx
        mov edx, [rax + UEFI_GRAPHICS_OUTPUT_MODE_INFORMATION.VERTICAL_RESOLUTION]
        mov [uefi_gop_height], edx

        ; dealign stack
        add rsp, 8

        ret

    ; IN ecx - x position
    ; IN edx - y position
    ; IN ebx - width
    ; IN esi - height
    ; IN r8b - red color value
    ; IN r9b - green color value
    ; IN r10b - blue color value
    global uefi_gop_rect
    uefi_gop_rect:
        ; update temporary pixel structure
        mov [color + UEFI_GRAPHICS_OUTPUT_BLT_PIXEL.RED], r8b
        mov [color + UEFI_GRAPHICS_OUTPUT_BLT_PIXEL.GREEN], r9b
        mov [color + UEFI_GRAPHICS_OUTPUT_BLT_PIXEL.BLUE], r10b

        ; call UEFI function to draw rectangle
        sub rsp, 40 + 6 * 8
        mov [rsp + 1 * 8 + 32], rcx
        mov [rsp + 2 * 8 + 32], rdx
        mov [rsp + 3 * 8 + 32], rbx
        mov [rsp + 4 * 8 + 32], rsi
        mov rcx, [uefi_gop]
        mov r8, UEFI_BLT_VIDEO_FILL
        mov rdx, color
        call [rcx + UEFI_GRAPHICS_OUTPUT_PROTOCOL.BLT]
        add rsp, 40 + 6 * 8

        ret

    ; IN cl - red color value
    ; IN dl - green color value
    ; IN bl - blue color value
    global uefi_gop_clear
    uefi_gop_clear:
        ; clear screen as whole rectangle
        mov r8b, cl
        mov r9b, dl
        mov r10b, bl
        xor ecx, ecx
        mov edx, ecx
        mov ebx, [uefi_gop_width]
        mov esi, [uefi_gop_height]
        sub rsp, 40
        call uefi_gop_rect
        add rsp, 40

        ret
