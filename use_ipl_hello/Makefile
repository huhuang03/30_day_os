run: use_ipl_hello.img
	qemu-system-i386 -drive file=use_ipl_hello.img,format=raw,if=floppy -boot a

use_ipl_hello.img: hello.asm ../ipl/ipl.asm ../make_floppy.py
	python3 ../make_floppy.py ../ipl/ipl.asm hello.asm use_ipl_hello.img