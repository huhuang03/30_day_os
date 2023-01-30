# -boot a mens boot from floppy
# -fda use 'file' as floppy disk 0/1 image
qemu-system-i386 -fda first_os.img -boot a


-drive file=helloos.img,format=raw,index=0,media=disk
