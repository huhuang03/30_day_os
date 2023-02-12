run: ipl
	qemu-system-i386 -drive file=ipl.img,format=raw,if=floppy -boot a

ipl: ipl.asm
	rm ipl.img
	nasm ipl.asm -o ipl.img