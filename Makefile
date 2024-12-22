.SUFFIXS: .nas .bin

.nas.bin:
	nasm $< -o $@

naskfunc.obj: naskfunc.nas
	nasm naskfunc.nas -o naskfunc.obj

test_vga: set_vga.bin ilp/ilp.bin
	cargo script make_img.rs ilp/ilp.bin set_vga.bin test_vga.img
	qemu-system-i386 -fda test_vga.img -boot a
