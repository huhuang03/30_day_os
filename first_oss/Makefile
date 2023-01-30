by_assembly: first_os_by_assembly.asm
	nasm first_os_by_assembly.asm -o first_os.img

run:
# -boot a mens boot from floppy
# if
	qemu-system-i386 -drive file=first_os.img,format=raw,if=floppy -boot a
