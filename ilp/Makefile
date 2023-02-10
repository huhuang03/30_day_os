ipl: ilp.asm
	nasm ilp.asm -o ilp.img

run_ipl: ipl.asm
	qemu-system-i386 -drive file=ilp.img,format=raw,if=floppy -boot a

run:
	qemu-system-i386 -drive file=load_floppy.img,format=raw,if=floppy -boot a
