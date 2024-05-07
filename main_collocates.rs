use std::{collections::HashMap, fs, time::Instant};

use glob::glob;
use polars::{chunked_array::ops::SortMultipleOptions, df, frame::DataFrame};
use rayon::{iter::{IntoParallelIterator, ParallelIterator}, ThreadPoolBuilder};
use regex::Regex;

fn get_collocates_for_file(
    path: &str,
    node: &str,
    span: usize,
    word_regex: &Regex,
) -> (HashMap<String, u64>, HashMap<String, u64>) {
    let file_contents: String = fs::read_to_string(path).unwrap().to_uppercase();
    let words: Vec<&str> = word_regex
        .find_iter(&file_contents)
        .map(|word| word.as_str())
        .collect();

    let mut freq_all = HashMap::new();
    let mut freq_collocates = HashMap::new();
    for (word_idx, &word) in words.iter().enumerate() {
        *freq_all.entry(word.to_string()).or_insert(0) += 1;
        if word == node {
            for collocate_idx in
                word_idx.saturating_sub(span)..=(word_idx + span).min(words.len() - 1)
            {
                if word_idx == collocate_idx {
                    continue;
                }
                *freq_collocates
                    .entry(words[collocate_idx].to_string())
                    .or_insert(0) += 1;
            }
        }
    }

    (freq_all, freq_collocates)
}

fn get_files(in_dir: &str) -> Vec<String> {
    glob(&(format!("{}/**/*.[tT][xX][tT]", in_dir))) // returns a Result object
        .unwrap() // unwrap the Result object to get the iterator
        .map(|res| res.unwrap().to_str().unwrap().to_string()) // unwrap each Result object to get at the PathBuf, and then convert them to a borrowed str(ing), element to get the PathBuf objects, and return an iterator
        .collect() // takes the iterator and returns a Vector of PathBuf objects
}

fn merge_dictionaries(
    local_dicts: Vec<(HashMap<String, u64>, HashMap<String, u64>)>,
) -> (HashMap<String, u64>, HashMap<String, u64>) {
    let mut freq_all = HashMap::new();
    let mut freq_collocates = HashMap::new();
    for (local_freq_all, local_freq_collocates) in local_dicts {
        for (word, freq) in local_freq_all {
            *freq_all.entry(word).or_insert(0) += freq;
        }
        for (word, freq) in local_freq_collocates {
            *freq_collocates.entry(word).or_insert(0) += freq;
        }
    }
    return (freq_all, freq_collocates)
}

fn log_dice(n_collocation: u64, n_node: u64, n_collocate: u64) -> f64{
    let n_collocation = n_collocation as f64;
    let n_node = n_node as f64;
    let n_collocate: f64 = n_collocate as f64;
    let output = 14.0 + ((2.0 * n_collocation) / (n_node + n_collocate)).log2();
    return output
}

fn make_df(freqs_all: HashMap<String, u64>, freqs_coll: HashMap<String, u64>, node: &str) -> DataFrame {
    let n_node = freqs_all[node];
    let (mut list_collocate, mut list_n_collocation, mut list_n_node, mut list_n_collocate, mut list_ld) = (Vec::new(), Vec::new(), Vec::new(), Vec::new(), Vec::new());

    for (k, v) in freqs_coll {
        let n_collocate = freqs_all[&k];
        let ld = log_dice(v, n_node, n_collocate);
        
        list_collocate.push(k);
        list_n_collocation.push(v);
        list_n_node.push(n_node);
        list_n_collocate.push(n_collocate);
        list_ld.push(ld);
    }
    let mut df = df! {
        "Collocate" => list_collocate,
        "N_collocation" => list_n_collocation,
        "N_node" => list_n_node,
        "N_collocate" => list_n_collocate,
        "log_dice" => list_ld
    }.unwrap();

    df.sort_in_place(
        ["log_dice", "Collocate"], 
        SortMultipleOptions::new()
            .with_order_descendings([true, false])
    ).unwrap();
    return df
}

fn get_collocates_dir(pathway: &str, node: &str, n_threads: usize, word_regex: &Regex) -> DataFrame {
    let filenames = get_files(pathway);
    // println!("{filenames:?}");
    println!("Rust: N threads = {n_threads}");
    let pool = ThreadPoolBuilder::new().num_threads(n_threads).build().unwrap();
    let local_dicts: Vec<_> = pool.install(move || filenames
        .into_par_iter()
        .map(|file| get_collocates_for_file(&file, node, 5, &word_regex))
        .collect());
    let (freq_all, freq_collocates) = merge_dictionaries(local_dicts);
    // println!("{freq_all:?}");
    // println!("{freq_collocates:?}");
    let result = make_df(freq_all, freq_collocates,  node);
    return result;

}

fn get_median(mut times: Vec<f64>, n_trials: usize) -> f64 {
    
        times.sort_unstable_by(|a, b| a.total_cmp(b));
        let mid = n_trials / 2;
        if n_trials % 2 == 0 {
            return (times[mid - 1] + times[mid]) / 2.0
        } else {
            return times[mid]
        }
}

fn main() {
    let pathway = "/pathway/to/dir";

    let word_regex = Regex::new(r"[\-'’A-Z]+").unwrap();
    let node = "episode".to_uppercase();
    let n_threads = 4;

    let mut times = Vec::new();
    let n_times: usize = 10;
    for i in 1..=n_times {
        let t0 = Instant::now();
        let result = get_collocates_dir(pathway, &node, n_threads, &word_regex);
        let t1 = Instant::now();
        let dur = t1.duration_since(t0).as_secs_f64();
        println!("Rust took {dur} seconds in iteration {i}");
        times.push(dur);
        println!("{result}")
    }
    println!("{times:?}");
    let our_mean = times.iter().sum::<f64>() / n_times as f64;
    let our_median = get_median(times, n_times);
    println!("Rust mean = {our_mean}");
    println!("Rust median = {our_median}");
    
}
