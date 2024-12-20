ipl.bin: ../ipl/ipl.nas
	nasm ../ipl/ipl.nas -o ipl.bin -l ipl.lst

all_white.o:
	pass

naskfunc.obj: ../naskfunc.nas
	nasm ../naskfunc.nas -o naskfunc.obj -l naskfunc.lst


sys.img:
	link all_white.o naskfunc.obj -o sys_content.img
	cargo script ../make_img.rs ../ipl/ipl.bin sys_content.img
