# this can simulator write content to a floppy
# usage make_floppy.py ilp.asm os.asm
import os
import subprocess
import sys
import tempfile


def _check_nasm():
    subprocess.call(['nasm'])


def _nasm(path):
    """
    :return: nasm byte result, throw exception if nasm failed
    """
    out_file = os.path.join(tempfile.gettempdir(), '{}.bin'.format(hash(os.times())))
    subprocess.call(['nasm', path, out_file])
    return open(out_file, 'rb').read()


def main():
    _check_nasm()
    if len(sys.argv) < 3:
        print(f"Usage {sys.argv} ipl_file [boot_file] output")
        exit(1)
    ipl_path = sys.argv[0]
    os_path = sys.argv[1]
    with open(sys.argv[2], 'wb') as f:
        f.write(_nasm(ipl_path))
        f.write(_nasm(os_path))
    print('done!')


if __name__ == "__main__":
    main()
