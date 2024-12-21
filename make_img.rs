use std::fs::{self, File};
use std::io::{self, Read, Write};
use std::path::Path;
use std::env;
use std::process;

fn main() -> io::Result<()> {
    let args: Vec<String> = env::args().collect();
    if args.len() < 4 {
        eprintln!("Usage: {} ilp_path content_path out_path", args[1]);
        process::exit(1);
    }

    let file1_path = args[1].clone();
    let file2_path = args[2].clone();
    let output_path = args[3].clone();


    // 打开输入文件并读取内容
    let mut file1 = File::open(file1_path)?;
    let mut file2 = File::open(file2_path)?;

    let mut buffer1 = Vec::new();
    let mut buffer2 = Vec::new();

    file1.read_to_end(&mut buffer1)?;
    file2.read_to_end(&mut buffer2)?;

    // 创建输出文件并写入合并的内容
    let mut output_file = File::create(output_path.clone())?;
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
