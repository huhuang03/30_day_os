ipl: ipl.asm
	nasm ipl.asm -o ipl.img

run_ipl: ipl
	qemu-system-i386 -drive file=ipl.img,format=raw,if=floppy -boot a

run:
	qemu-system-i386 -drive file=load_floppy.img,format=raw,if=floppy -boot a
