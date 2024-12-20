use std::fs::{self, File};
use std::io::{self, Read, Write};
use std::path::Path;

fn main() -> io::Result<()> {
    // 输入文件路径
    let file1_path = "file1.bin";
    let file2_path = "file2.bin";
    let output_path = "output.bin";

    // 打开输入文件并读取内容
    let mut file1 = File::open(file1_path)?;
    let mut file2 = File::open(file2_path)?;

    let mut buffer1 = Vec::new();
    let mut buffer2 = Vec::new();

    file1.read_to_end(&mut buffer1)?;
    file2.read_to_end(&mut buffer2)?;

    // 创建输出文件并写入合并的内容
    let mut output_file = File::create(output_path)?;
    output_file.write_all(&buffer1)?;
    output_file.write_all(&buffer2)?;

    // 检查输出文件大小
    let output_metadata = fs::metadata(output_path)?;
    let output_size = output_metadata.len();

    const EXPECTED_SIZE: u64 = 0x168000;

    if output_size < EXPECTED_SIZE {
        // 计算需要补充的字节数
        let padding_size = EXPECTED_SIZE - output_size;
        // 创建填充缓冲区
        let padding = vec![0u8; padding_size as usize];
        // 写入填充缓冲区到文件
        output_file.write_all(&padding)?;
    }

    Ok(())
}