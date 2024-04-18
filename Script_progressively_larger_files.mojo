# Mojo v24.2 script to benchmark populating a dictionary with progressively larger numbers of words

from os import listdir
from collections import List
from pathlib import Path
from time import now

fn get_wds(in_path: String) raises -> List[String]:
	return Path(in_path).read_text().upper().split(" ")

fn limit_wds(in_wds: List[String], n_wds: Int) raises -> List[String]:
	var out_wds = List[String]()
	out_wds.reserve(n_wds)
	for i in range(n_wds):
		out_wds.append(in_wds[i])
	return out_wds

fn main() raises:
	var in_file: StringLiteral = "/pathway/to/big_badboy.txt"
	var all_wds: List[String] = get_wds(in_file)
	var outfile: FileHandle = open("/pathway/to/times.csv", "w")
	outfile.write("n_wds,n_keys,the,sec\n")
	for i in range(100, 230_000_000, 100):
		print("i =", i)
		var freqs = Dict[String, UInt64]()
		var wds: List[String] = limit_wds(all_wds, i)
		print(wds.__len__(), "words")
		var t0 = now()
		for wd in wds:
			if freqs.__contains__(wd[]):
				freqs[wd[]] = freqs.__getitem__(wd[]) + 1
			else:
				freqs.__setitem__(wd[], 1)
		var t1 = now()
		var duration = (t1-t0)/1_000_000_000
		print("Seconds =", duration)
		var the = freqs.__getitem__("THE")
		print("THE =", the)
		var n_keys = len(freqs.keys())
		print("N of keys =", n_keys)
		var out_str = str(i).__add__(",").__add__(n_keys).__add__(",").__add__(the).__add__(",").__add__(duration).__add__("\n")
		outfile.write(out_str)
	outfile.close()

