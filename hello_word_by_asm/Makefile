sys.img: hello_world_by_asm.nas
	nasm hello_world_by_asm.nas -o sys.img
run:
	qemu-system-i386 -fda sys.img