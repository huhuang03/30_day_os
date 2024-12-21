ilp.bin: ilp.nas
	nasm ilp.nas -o ilp.bin

test.bin: test.nas
	nasm test.nas -o test.bin

test_sys.img: ilp.bin test.bin
	cargo script ../make_img.rs ilp.bin test.bin test_sys.img

test: test_sys.img
	qemu-system-i386 -fda test_sys.img -boot a

clean:
	rm *.img
