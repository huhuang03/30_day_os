ipl: load_floppy.asm
	nasm load_floppy.asm -o load_floppy.img

run:
	qemu-system-i386 -drive file=load_floppy.img,format=raw,if=floppy -boot a
