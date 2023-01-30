# -boot a mens boot from floppy
# if
qemu-system-i386 -drive file=first_os.img,format=raw,if=floppy -boot a
