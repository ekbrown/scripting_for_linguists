# Mojo script to populate a Mojo HashMapDict with strings as keys and integers as values
# Written by Earl Kjar Brown
# using Mojo v. 0.7.0

from time import now
from hashmap import HashMapDict
from fnv1a import fnv1a64

# define function to read text in file and uppercase (v.) it
fn get_text(file_pathway: String) raises -> String:
	let cur_path: Path = Path(file_pathway)
	let txt: String = cur_path.read_text()
	return txt.toupper()

# define function to populate a Mojo dictionary with words
fn get_freqs(in_path: String) raises -> String:
	let txt: String = get_text(in_path)
	let wds: DynamicVector[String] = txt.split(" ")
	let t0 = now()
	var freqs = HashMapDict[Int, fnv1a64]()
	for i in range(len(wds)):
		let wd: String = wds[i]
		freqs.put(wd, freqs.get(wd, 0) + 1)
	let t1 = now()
	print((t1-t0)/1_000_000_000)
	
	return freqs.get("THE", 0)

### main ###
fn main() raises:
    let file_pathway: String = "/pathway/to/filename.txt"
    
    # run trials for benchmarking purposes
    for i in range(5):
        print("Mojo is working on iteration", i + 1)
        let freq = get_freqs(file_pathway)
        print("THE: ", freq)
