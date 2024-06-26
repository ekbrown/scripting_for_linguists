# Mojo script to populate a Mojo dictionary with strings as keys and integers as values
# Written by Earl Kjar Brown
# using Mojo v. 0.7.0

from collections.dict import Dict, KeyElement
from time import now
from hashmap import HashMapDict
from fnv1a import fnv1a64


# create type for key in dictionary
@value
struct StringKey(KeyElement):
    var s: String
    fn __init__(inout self, owned s: String):
        self.s = s ^
    fn __init__(inout self, s: StringLiteral):
        self.s = String(s)
    fn __hash__(self) -> Int:
        return hash(self.s)
    fn __eq__(self, other: Self) -> Bool:
        return self.s == other.s

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
	# var freqs = Dict[StringKey, Int]()
	var freqs = HashMapDict[Int, fnv1a64]()
	for i in range(len(wds)):
		let wd: String = wds[i]
		# if freqs.__contains__(wd):
		# 	freqs[wd] = freqs.__getitem__(wd) + 1
		# else:
		# 	freqs.__setitem__(wd, 1)
		freqs.put(wd, freqs.get(wd, 0) + 1)
	let t1 = now()
	print((t1-t0)/1_000_000_000)
	
	# return freqs.__getitem__("THE")
	return freqs.get("THE", 0)

### main ###
fn main() raises:
    # let file_pathway: String = "/Users/ekb5/Downloads/input/0a0HuaT4Vm7FoYvccyRRQj.txt"
    let file_pathway: String = "/Users/ekb5/Downloads/big_badboy.txt"
    
    # run trials for benchmarking purposes
    for i in range(5):
        print("Mojo is working on iteration", i + 1)
        let freq = get_freqs(file_pathway)
        print("THE: ", freq)
