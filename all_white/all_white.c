void io_hlt(voiid);
void write_mem8(int addr, int data);

void HairMain(void) {
    int i;
    for (i = 0xa0000, i <= 0xaffff; i++) {
        write_mem8(i, 0xff);
    }
    for (;;) {
        io_hlt();
    }
}