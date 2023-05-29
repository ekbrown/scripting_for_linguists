"""Python script to use parallel processing to calculate frequencies of words in text files in a directory and its subdirectories
Earl Kjar Brown, ekbrown byu edu (add characters to create email)"""

import os, re, statistics
from time import time
from multiprocessing import Pool

def get_filenames(in_dir):
    filenames = []
    for root, dirs, files in os.walk(in_dir):
        for file in files:
            if file.endswith("txt"):
                filenames.append(os.path.join(root, file))
    return filenames

def get_freqs_file(in_path):
    freqs = {}
    with open(in_path, mode="r", encoding="utf8") as infile:                    
        txt = infile.read().upper()
        wds = re.findall(r"[-'’A-Z]+", txt)
        for wd in wds:
            freqs[wd] = freqs.get(wd, 0) + 1
    return freqs

def get_freqs_dir(in_dir):
    filenames = get_filenames(in_dir)

    # parallel processing
    with Pool(processes = 8) as p:
        individual_freqs = p.map(get_freqs_file, filenames)  
    
    # flatten the many dictionaries into a single one
    freqs = {}
    for f in individual_freqs:
        for k, v in f.items():
            freqs[k] = freqs.get(k, 0) + v
    return freqs


if __name__ == "__main__":
    times = []
    for i in range(10):
        print("Working on iteration:", i+1)
        t0 = time()
        freqs = get_freqs_dir("/Users/ekb5/Corpora/spotify-podcasts-2020/podcasts-transcripts/txt")
        t1 = time()
        times.append(t1 - t0)

    print(f"N word types: {len(freqs)}")
    print(f"N word tokens: {sum(v for v in freqs.values())}")
    print(f'THE = {freqs["THE"]}, TREE = {freqs["TREE"]}, JUSTICE = {freqs["JUSTICE"]}, VERY = {freqs["VERY"]}, BACKPACK = {freqs["BACKPACK"]}')
    print("Times:", times)
    print("Mean time:", statistics.mean(times))
    print("Median time:", statistics.median(times))
