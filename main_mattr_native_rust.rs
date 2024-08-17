use std::path::{Path, PathBuf};
use std::fs::{File};
use std::io::{Read, Result, Write};
use std::collections::HashSet;
use std::time::Instant;

fn get_ttr(in_slice: &[&str]) -> f64 {
    let the_set = in_slice.iter().collect::<HashSet<_>>();
    the_set.len() as f64 / in_slice.len() as f64
}

fn get_txt_from_file(in_path: impl AsRef<Path>) -> Result<String> {
    let path = in_path.as_ref();
    let display_filename = path.display();
    println!("Working on {}", display_filename);
    let mut file = File::open(&path)?;  //like a Python file handle
    let mut txt = String::new();
    file.read_to_string(&mut txt)?;  // have to specify reference with & to push characters in the file onto the String (which is a vector of characters)
    Ok(txt)  // because this line is the last line of this function, Rust assumes it's the return value from function
}

fn get_mattr(in_vector: &[&str], window_span: usize) -> f64 {
    let n_wds = in_vector.len();
    let output: f64;
    if n_wds <= 50 {
        output = get_ttr(in_vector);
    } else {
        let mut numerator = 0.0;
        let n_window = n_wds - window_span + 1;
        for cur_window in in_vector.windows(window_span) {
            numerator += get_ttr(cur_window)
        }
        output = numerator / n_window as f64;
    }
    output
}

fn main() {
    let in_path = "/pathway/to/0a0HuaT4Vm7FoYvccyRRQj.txt";
    let txt = get_txt_from_file(in_path).unwrap().to_uppercase();
    let tokens: Vec<_> = txt.split_whitespace().collect();
    println!("Rust N tokens = {}", tokens.len());
    let mut outfile = File::create("/pathway/to/times_rs.csv").unwrap();
    writeln!(&mut outfile, "n_wds,lang,sec").unwrap();
    for i in (50..=10000).step_by(50) {
        println!("Rust is using {} words...", i);
        let t0 = Instant::now();
        let mattr = get_mattr(&tokens[..i], 50);
        let dur_rs = Instant::now() - t0;
        println!("\tRust took {} seconds and got mattr = {}", dur_rs.as_secs_f64(), mattr);
        writeln!(&mut outfile, "{},Rust,{}", i, dur_rs.as_secs_f64()).unwrap();
    }
}
