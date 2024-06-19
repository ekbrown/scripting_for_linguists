# Python 3 script to create a deeply nested dictionary
# Python v3.12.4

import os, re
from time import time

def get_words_by_file(in_dir: str, n_files: int) -> dict:
    os.chdir(in_dir)
    filenames = sorted([f for f in os.listdir() if f.lower().endswith("txt")])[:n_files]
    all_wds_by_file = {}
    n_wds_corpus = 0
    for f in filenames:
        all_wds_by_file[f] = {}
        with open(f) as infile:
            txt = infile.read().upper()
            wds = re.findall(r"[-'’a-z]+", txt, flags=re.I)
            n_wds_file = len(wds)
            n_wds_corpus += n_wds_file
            for i in range(n_wds_file):
                node = wds[i]
                if node not in all_wds_by_file[f].keys():
                    all_wds_by_file[f][node] = {"pre": {}, "post": {}}
                if i == 0:
                    pre_wd = "<s>"
                else:
                    pre_wd = wds[i-1]
                if i == len(wds) - 1:
                    post_wd = "<s>"
                else:
                    post_wd = wds[i+1]
                all_wds_by_file[f][node]["pre"][pre_wd] = all_wds_by_file[f][node]["pre"].get(pre_wd, 0) + 1
                all_wds_by_file[f][node]["post"][post_wd] = all_wds_by_file[f][node]["post"].get(post_wd, 0) + 1
    print("\tPython: N words in corpus = ", n_wds_corpus)
    return all_wds_by_file

if __name__ == "__main__":
    in_dir = "/path/to/dir"
    with open("/path/to/times.csv", "w") as outfile:
        outfile.write(f"lang,n_files,iter,sec\n")
        for i in range(1000, 6000, 1000):
            print(f"Working on {i} files...")
            for j in range(10):
                print("\tWorking on iteration", j+1)
                t0=time()
                result = get_words_by_file(in_dir, i)
                duration = time()-t0
                print("\tPython took", duration, "seconds")
                outfile.write(f"python_v3.12.4,{i},{j+1},{duration}\n")
                print("\t", result["06vTDY97DIwqHxQSMMxZLq.txt"]["DAY"])
