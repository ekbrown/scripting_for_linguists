# Mojo script to populate a Mojo dictionary with strings as keys and integers as values
# Written by Earl Kjar Brown
# using Mojo v24.2

from collections import Dict, List
from time import now
from pathlib import Path

# # create type for key in dictionary
# @value
# struct StringKey(KeyElement):
#     var s: String
#     fn __init__(inout self, owned s: String):
#         self.s = s ^
#     fn __init__(inout self, s: StringLiteral):
#         self.s = String(s)
#     fn __hash__(self) -> Int:
#         return hash(self.s)
#     fn __eq__(self, other: Self) -> Bool:
#         return self.s == other.s

# define function to read text in file and uppercase (v.) it
fn get_text(file_pathway: String) raises -> String:
	var cur_path: Path = Path(file_pathway)
	var txt: String = cur_path.read_text()
	return txt.upper()

# define function to populate a Mojo dictionary with words
fn get_freqs(in_path: String) raises -> String:
	var txt: String = get_text(in_path)
	var wds: List[String] = txt.split(" ")
	var t0 = now()
	# var freqs = Dict[StringKey, Int]()
	# var freqs = Dict[String, Int]()
	var freqs = Dict[String, UInt64]()
	for i in range(len(wds)):
		var wd: String = wds[i]
		if freqs.__contains__(wd):
			freqs[wd] = freqs.__getitem__(wd) + 1
		else:
			freqs.__setitem__(wd, 1)
		# freqs.put(wd, freqs.get(wd, 0) + 1)
	var t1 = now()
	print((t1-t0)/1_000_000_000)
	
	# return freqs.__getitem__("THE")
	return freqs.__getitem__("THE")

### main ###
fn main() raises:
    # var file_pathway: String = "/Users/ekb5/Downloads/input/0a0HuaT4Vm7FoYvccyRRQj.txt"
	var file_pathway: String = "/Users/ekb5/Downloads/big_badboy.txt"
    # var txt: String = get_text(file_pathway)
    # print(txt)

    # run trials for benchmarking purposes
	for i in range(1):
		print("Mojo is working on iteration", i + 1)
		var freq = get_freqs(file_pathway)
		print("THE: ", freq)
