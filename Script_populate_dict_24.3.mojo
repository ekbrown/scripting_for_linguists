# Mojo script to populate a Mojo dictionary with strings as keys and integers as values
# Written by Earl Kjar Brown
# using Mojo v24.3

from python import Python
from collections import Dict, List
from time import now
from pathlib import Path
from os import listdir

fn get_filenames(in_dir: String) raises -> List[String]:
    var temp = listdir(in_dir)
    var output = List[String]()
    for t in temp:
        if t[].lower().endswith("txt"):
            output.append(t[])
    return output

# define function to read text in file
fn get_text(file_pathway: String) raises -> String:
	var cur_path: Path = Path(file_pathway)
	var txt: String = cur_path.read_text()
	return txt

fn get_wds(in_str: String) raises -> PythonObject:
    var re: PythonObject = Python.import_module("re")
    var wds = re.findall(r"[-'’A-Z]+", in_str.upper())
    return wds

# define function to populate a Mojo dictionary with words
fn get_freqs(in_dir: String) raises -> Dict[String, UInt64]:
    var filenames = get_filenames(in_dir)
    var freqs = Dict[String, UInt64]()
    var t0 = now()
    for filename in filenames:
        print(filename[])
        var txt: String = get_text(filename[])
        var wds = get_wds(txt)
        for i in range(len(wds)):
            var wd: String = wds[i]
            if freqs.__contains__(wd):
                freqs[wd] = freqs.__getitem__(wd) + 1
            else:
                freqs.__setitem__(wd, 1)
    var t1 = now()
    
    print((t1-t0)/1_000_000_000)

    return freqs

### main ###
fn main() raises:
    var in_dir = "/Users/ekb5/Downloads/input"
    var os_py = Python.import_module("os")
    os_py.chdir(in_dir)

    # run trials for benchmarking purposes
    for i in range(1):
        print("Mojo is working on iteration", i + 1)
        var freq = get_freqs(in_dir)
        print("THE: ", freq.__getitem__("THE"))
