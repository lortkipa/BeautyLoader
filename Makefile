
# project
name := BeautyLoader

# folders
srcdir := src
bindir := bin
odir := $(bindir)/obj

# files
asfiles := $(shell find $(srcdir) -name '*.asm')
ofiles := $(patsubst $(srcdir)/%.asm, $(odir)/%.o, $(asfiles))

# assembly
as := nasm
asflags := -f win64 -I$(srcdir) -O3

# linker
entry := main
ld := lld-link
ldflags := /subsystem:efi_application /entry:$(entry) /out:$(bindir)/$(name).efi $(ofiles)

# virtual machine
vm := qemu-system-x86_64
vmram := 4096
vmflags := -bios /usr/share/ovmf/x64/OVMF.4m.fd -drive format=raw,file=$(bindir)/$(name).img -m $(vmram)

run: img
	@echo '   ==> Running "$(vm)" With $(vmram) RAM'
	@$(vm) $(vmflags)

# generate disk image of os
.PHONY: img
img: link
	@dd if=/dev/zero of=$(bindir)/$(name).img bs=512 count=93750
	@echo '   ==> File Created: $(bindir)/$(name).img'
	@parted $(bindir)/$(name).img -s -a minimal mklabel gpt
	@parted $(bindir)/$(name).img -s -a minimal mkpart EFI FAT16 2048s 93716s
	@parted $(bindir)/$(name).img -s -a minimal toggle 1 boot
	@dd if=/dev/zero of=$(bindir)/tmp.img bs=512 count=91669
	@echo '   ==> File Created: $(bindir)/tmp.img'
	@mformat -i $(bindir)/tmp.img -h 32 -t 32 -n 64 -c 1
	@mmd -i $(bindir)/tmp.img ::/EFI
	@mmd -i $(bindir)/tmp.img ::/EFI/BOOT
	@mcopy -i $(bindir)/tmp.img $(bindir)/$(name).efi ::/EFI/BOOT/BOOTx64.EFI
	@dd if=$(bindir)/tmp.img of=$(bindir)/$(name).img bs=512 count=91669 seek=2048 conv=notrunc

# link all .o files as single .efi executable
.PHONY: link
link: $(ofiles)
	@$(ld) $(ldflags)
	@echo '   ==> File Created: $(bindir)/$(name).efi'

# compile each .asm file as .o
$(odir)/%.o: $(srcdir)/%.asm | bin
	@mkdir -p $(dir $@)
	@$(as) $(asflags) $< -o $@
	@echo '   ==> File Created: $@'

# create binaries folder
.PHONY: bin
bin:
	@mkdir -p $(bindir)
	@echo '   ==> Folder Created: $(bindir)'

# destroy binaries folder
.PHONY: clean
clean:
	@rm -rf $(bindir)
	@echo '   ==> Folder Destroyed: $(bindir)'
