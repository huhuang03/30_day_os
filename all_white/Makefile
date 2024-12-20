ipl.bin: ../ipl/ipl.nas
	nasm ../ipl/ipl.nas -o ipl.bin -l ipl.lst

naskfunc.o: ../naskfunc.nas
	nasm -f elf ../naskfunc.nas -o naskfunc.o -l naskfunc.lst

all_white.o: all_white.c
	gcc -m32 -ffreestanding --oformat binary -c all_white.c -o all_white.o 
 
sys.img: all_white.o naskfunc.o
	ld -o sys.img naskfunc.o all_white.o
	cargo script ../make_img.rs ../ipl/ipl.bin sys_content.img

clean:
	rm ../*.o *.o