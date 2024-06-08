# Mojo script to benchmark inserting items into a dictionary

from os import listdir
from collections import List, Dict
from pathlib.path import Path
from time import now

fn get_wds(in_path: StringLiteral) raises -> List[String]:
    return Path(in_path).read_text().upper().split(" ")

fn get_freqs(wds: List[String]) raises -> Dict[String, UInt64]:
    var freqs = Dict[String, UInt64]()
    var n_wds = wds.__len__()
    print(n_wds, "words")
    for wd in wds:
        if freqs.__contains__(wd[]):
            freqs[wd[]] = freqs.__getitem__(wd[]) + 1
        else:
            freqs.__setitem__(wd[], 1)
    return freqs

fn main() raises:
    var version = "v24.4"
    var in_path: StringLiteral = "/pathway/to/big_badboy_alphanum.txt"
    var wds: List[String] = get_wds(in_path)
    var n_wds = wds.__len__()

    var out_path = "/pathway/to/times_4.csv"
    var outfile: FileHandle = open(out_path, "w")
    outfile.write(str("version,n_wds,n_keys,the,sec\n"))
    for i in range(10):
        print("Working on iteration", i+1)
        var t0 = now()
        var freqs = get_freqs(wds)
        var t1 = now()
        var duration = (t1-t0)/1_000_000_000
        print("Seconds =", duration)
        var the = freqs.__getitem__("THE")
        print("THE =", the)
        var n_keys = len(freqs.keys())
        print("N of keys =", n_keys)
        var out_str = str(version).__add__(",").__add__(str(n_wds)).__add__(",").__add__(str(n_keys)).__add__(",").__add__(str(the)).__add__(",").__add__(str(duration)).__add__("\n")
        outfile.write(out_str)

    outfile.close()



    

