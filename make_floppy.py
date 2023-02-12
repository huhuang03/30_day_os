# write name to 0x2600
# write content to 0x4200
import os
import subprocess
import sys
import tempfile

_POS_NAME = 0x2600
_POS_CONTENT = 0x4200


def _check_nasm():
    return True


def _nasm(path):
    """
    :return: nasm byte result, throw exception if nasm failed
    """
    out_file = os.path.join(tempfile.gettempdir(), '{}.bin'.format(hash(os.times())))
    subprocess.call(['nasm', path, '-o', out_file])
    return open(out_file, 'rb').read()


def main():
    _check_nasm()
    if len(sys.argv) < 4:
        print(f"Usage {sys.argv} ipl_file [boot_file] output")
        exit(1)
    ipl_path = sys.argv[1]
    os_path = sys.argv[2]
    # ok, get name.
    os_name = os.path.basename(os_path)
    with open(sys.argv[3], 'wb') as f:
        ipl_content = _nasm(ipl_path)
        print('ipl_content: ', len(ipl_content))
        f.write(ipl_content)
        f.seek(_POS_NAME)
        f.write(os_name.encode())
        f.seek(_POS_CONTENT)
        os_content = _nasm(os_path)
        print('os_content: ', len(os_content))
        f.write(os_content)
    print('done!')


if __name__ == "__main__":
    main()
