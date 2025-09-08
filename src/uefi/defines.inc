%ifndef UEFI_UEFI_INC
%define UEFI_UEFI_INC

%define UEFI_SUCCESS 0

struc UEFI_GUID
    .DATA1 : resd 1
    .DATA2 : resw 1
    .DATA3 : resw 1
    .DATA4 : resb 8
    .SIZE  :
endstruc

struc UEFI_TABLE_HEADER
    .SIGNATURE  : resq 1
    .REVISION   : resd 1
    .TABLE_SIZE : resd 1
    .CRC32      : resd 1
                  resd 1
    .SIZE       :
endstruc

struc UEFI_SYSTEM_TABLE
    .HEADER                    : resb UEFI_TABLE_HEADER.SIZE
    .FIRMWARE_VENDOR           : resq 1
    .FIRMWARE_REVISION         : resd 1
                                 resd 1
    .CONSOLE_IN_HANDLE         : resq 1
    .CONSOLE_IN_PROTOCOL       : resq 1
    .CONSOLE_OUT_HANDLE        : resq 1
    .CONSOLE_OUT_PROTOCOL      : resq 1
    .CONSOLE_ERR_HANDLE        : resq 1
    .CONSOLE_ERR_PROTOCOL      : resq 1
    .RUNTIME_SERVICES          : resq 1
    .BOOT_SERVICES             : resq 1
    .CONFIGURATION_TABLE_COUNT : resq 1
    .CONFIGURATION_TABLES      : resq 1
    .SIZE                      :
endstruc

struc UEFI_BOOT_SERVICES
    .HEADER                                 : resb UEFI_TABLE_HEADER.SIZE
    .RAISE_TPL                              : resq 1
    .RESTORE_TPL                            : resq 1
    .ALLOCATE_PAGES                         : resq 1
    .FREE_PAGES                             : resq 1
    .GET_MEMORY_MAP                         : resq 1
    .ALLOCATE_POOL                          : resq 1
    .FREE_POOL                              : resq 1
    .CREATE_EVENT                           : resq 1
    .SET_TIMER                              : resq 1
    .WAIT_EVENT                             : resq 1
    .SIGNAL_EVENT                           : resq 1
    .CLOSE_EVENT                            : resq 1
    .CHECK_EVENT                            : resq 1
    .INSTALL_PROTOCOL_INTERFACES            : resq 1
    .REINSTALL_PROTOCOL_INTERFACES          : resq 1
    .UNINSTALL_PROTOCOL_INTERFACES          : resq 1
    .HANDLE_PROTOCOL                        : resq 1
                                              resq 1
    .REGISTER_PROTOCOL_NOTIFY               : resq 1
    .LOCATE_HANDLE                          : resq 1
    .LOCATE_DEVICE_PATH                     : resq 1
    .INSTALL_CONFIGURATION_TABLE            : resq 1
    .LOAD_IMAGE                             : resq 1
    .START_IMAGE                            : resq 1
    .EXIT_IMAGE                             : resq 1
    .UNLOAD_IMAGE                           : resq 1
    .EXIT_BOOT_SERVICES                     : resq 1
    .GET_NEXT_MONOTONIC_COUNT               : resq 1
    .STALL                                  : resq 1
    .SET_WATCHDOG_TIMER                     : resq 1
    .CONNECT_CONTROLLER                     : resq 1
    .DISCONNECT_CONTROLLER                  : resq 1
    .OPEN_PROTOCOL                          : resq 1
    .CLOSE_PROTOCOL                         : resq 1
    .OPEN_PROTOCOL_INFORMATION              : resq 1
    .PROTOCOLS_PER_HANDLE                   : resq 1
    .LOCATE_HANDLE_BUFFER                   : resq 1
    .LOCATE_PROTOCOL                        : resq 1
    .INSTALL_MULTIPLE_PROTOCOL_INTERFACES   : resq 1
    .UNINSTALL_MULTIPLE_PROTOCOL_INTERFACES : resq 1
    .CALCULATE_CRC32                        : resq 1
    .COPY_MEMORY                            : resq 1
    .SET_MEMORY                             : resq 1
    .SIZE                                   :
endstruc

struc UEFI_PIXEL_BITMASK
    .RED   : resd 1
    .GREEN : resd 1
    .BLUE  : resd 1
             resd 1
    .SIZE  :
endstruc

%define UEFI_BLT_VIDEO_FILL          0
%define UEFI_BLT_VIDEO_TO_BLT_BUFFER 1
%define UEFI_BLT_BUFFER_TO_VIDEO     2
%define UEFI_BLT_VIDEO_TO_VIDEO      3

struc UEFI_GRAPHICS_OUTPUT_PROTOCOL
    .QUERY_MODE : resq 1
    .SET_MODE   : resq 1
    .BLT        : resq 1
    .MODE       : resq 1
    .SIZE       :
endstruc

struc UEFI_GRAPHICS_OUTPUT_BLT_PIXEL
    .BLUE  : resb 1
    .GREEN : resb 1
    .RED   : resb 1
             resb 1
    .SIZE  :
endstruc

struc UEFI_GRAPHICS_OUTPUT_MODE_INFORMATION
    .VERSION               : resd 1
    .HORIZONTAL_RESOLUTION : resd 1
    .VERTICAL_RESOLUTION   : resd 1
    .PIXEL_FORMAT          : resq 1
    .PIXEL_INFORMATION     : resq 1
    .PIXELS_PER_SCAN_LINE  : resd 1
    .SIZE                  :
endstruc

struc UEFI_SIMPLE_TEXT_INPUT_PROTOCOL
    .RESET    : resq 1
    .READ_KEY : resq 1
    .WAIT_KEY : resq 1
    .SIZE     :
endstruc

struc UEFI_INPUT_KEY
    .SCAN_CODE    : resw 1
    .UNICODE_CHAR : resw 1
    .SIZE         :
endstruc

%define UEFI_SCANCODE_UARROW 0x01
%define UEFI_SCANCODE_DARROW 0x02
%define UEFI_SCANCODE_RARROW 0x03
%define UEFI_SCANCODE_LARROW 0x04
%define UEFI_SCANCODE_HOME   0x05
%define UEFI_SCANCODE_END    0x06
%define UEFI_SCANCODE_INSERT 0x07
%define UEFI_SCANCODE_DELETE 0x08
%define UEFI_SCANCODE_PAGEU  0x09
%define UEFI_SCANCODE_PAGED  0x0A
%define UEFI_SCANCODE_F1     0x0B
%define UEFI_SCANCODE_F2     0x0C
%define UEFI_SCANCODE_F3     0x0D
%define UEFI_SCANCODE_F4     0x0E
%define UEFI_SCANCODE_F5     0x0F
%define UEFI_SCANCODE_F6     0x10
%define UEFI_SCANCODE_F7     0x11
%define UEFI_SCANCODE_F8     0x12
%define UEFI_SCANCODE_F9     0x13
%define UEFI_SCANCODE_F10    0x14
%define UEFI_SCANCODE_ESC    0x17

%endif
