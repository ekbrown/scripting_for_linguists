import os, re
from multiprocessing import Pool
from itertools import repeat
import math
import pandas as pd
from time import time
import statistics

def get_collocates_one_file(pathway, node, span = 5):
    with open(pathway) as infile:
        txt = infile.read().upper()
        wds = re.findall(r"[-'’A-Z]+", txt)
        freqs_all, freqs_collocates = {}, {}
        for i in range(len(wds)):
            wd = wds[i]
            freqs_all[wd] = freqs_all.get(wd, 0) + 1
            if wd == node:
                for j in range(-span, span+1):
                    if j == 0:
                        continue
                    else:
                        try:
                            offset = i+j
                            if offset < 0:
                                continue
                            coll = wds[offset]
                            freqs_collocates[coll] = freqs_collocates.get(coll, 0) + 1
                        except IndexError:
                            continue
    return {"all": freqs_all, "coll": freqs_collocates}

def get_filenames(pathway):
    filenames = []
    for root, dirs, files in os.walk(pathway):
        for file in files:
            if file.lower().endswith("txt"):
                filenames.append(os.path.join(root, file))
    return filenames

def flatten_dicts(result):
    freqs_all, freqs_coll = {}, {}
    for r in result:
        for k, v in r["all"].items():
            freqs_all[k] = freqs_all.get(k, 0) + v
        for k, v in r["coll"].items():
            freqs_coll[k] = freqs_coll.get(k, 0) + v
    return {"all": freqs_all, "coll": freqs_coll}

def log_dice(N_collocation, N_node, N_collocate):
    return 14 + math.log2((2 * N_collocation) / (N_node + N_collocate))

def make_df(result, node):
    N_node = result["all"][node]
    list_collocate, list_N_collocation, list_N_node, list_N_collocate, list_ld = [], [], [], [], []
    for k, v in result["coll"].items():
        N_collocate = result["all"][k]
        ld = log_dice(v, N_node, N_collocate)
        list_collocate.append(k)
        list_N_collocation.append(v)
        list_N_node.append(N_node)
        list_N_collocate.append(N_collocate)
        list_ld.append(ld)
    
    df = pd.DataFrame.from_dict({"Collocate": list_collocate, "N_collocation": list_N_collocation, "N_node": list_N_node, "N_collocate": list_N_collocate, "log_dice": list_ld})
    df = df.sort_values(by=["log_dice", "Collocate"], ascending=False)
    
    return df

def get_collocates_dir(pathway, node, N_processes):
    filenames = get_filenames(pathway)
    print(f"Python: N processes = {N_processes}")
    with Pool(processes = N_processes) as p:
        result = p.starmap(get_collocates_one_file, zip(filenames, repeat(node)))

    result = make_df(flatten_dicts(result), node)
    return result

if __name__ == "__main__":
    
    N_processes = 1
    node = "episode".upper()
    in_dir = "/pathway/to/dir"

    times = []
    for i in range(10):
        print(f"Working on iteration {i+1}")
        t0 = time()
        result = get_collocates_dir(in_dir, node, N_processes)
        t1 = time()
        print(result) 
        times.append(t1-t0)
    print(f"All times: {times}")
    print(f"Mean time: {statistics.mean(times)}")
    print(f"Median time: {statistics.median(times)}")
