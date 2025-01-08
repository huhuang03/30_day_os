foo.o: foo.asm
	nasm -f elf32 -o foo.o foo.asm

bar.o: bar.asm
	nasm -f elf32 -o bar.o bar.asm
	
content.bin: foo.o bar.o
	ld -m elf_i386 -o content.bin foo.o bar.o

final_content.bin: content.bin
	objcopy -O binary content.bin final_content.bin