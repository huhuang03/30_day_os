hello_world.out: hello_world.asm
# this output 32 bit so
	nasm -f elf32 hello_world.asm
# -s stirp all symbols
	ld -m elf_i386 -s -o hello_world.out hello_world.o