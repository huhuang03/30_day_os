test.out: foo.asm bar.asm
	nasm -f elf32 -o foo.o foo.asm
	nasm -f elf32 -o bar.o bar.asm
	ld -m elf_i386 -o test.out foo.o bar.o