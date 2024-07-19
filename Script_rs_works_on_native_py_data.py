import rs_helps_py_hashmap
import os, re
from time import time

def get_freqs(in_list, in_dict):
    for wd in in_list:
        in_dict[wd] = in_dict.get(wd, 0) + 1

if __name__ == "__main__":

    os.chdir("/pathway/to/dir")

    with open("big_badboy_alphanum.txt") as infile, open("times.csv", "w") as outfile:
        txt = infile.read().upper()
        wds = re.findall(r"[-'A-Z]+", txt)

        outfile.write("lang,n_wds,iter,sec\n")

        # N of words
        for i in range(1000, 10_000_000, 1000):
            print(f"Working on {i} words")

            # N of trials
            for j in range(10):
                print("\ton iteration", j+1)

                ### Python ###
                t0 = time()
                freqs_py = {}
                get_freqs(wds[:i], freqs_py)
                dur_py = time() - t0
                print(f"\t\tPython: THE = {freqs_py["THE"]}, TREE = {freqs_py["TREE"]}, FOOD = {freqs_py["FOOD"]}")
                print("\t\t\tPython took", dur_py, "seconds")
                outfile.write(f"Python,{i},{j+1},{dur_py}\n")

                ### Rust ###
                t1 = time()
                freqs_rs = {}
                rs_helps_py_hashmap.get_freqs_py_native_types(wds[:i], freqs_rs)
                dur_rs = time() - t1
                print(f"\t\tRust: THE = {freqs_rs["THE"]}, TREE = {freqs_rs["TREE"]}, FOOD = {freqs_rs["FOOD"]}")
                print("\t\t\tRust took", dur_rs, "seconds")
                outfile.write(f"Rust,{i},{j+1},{dur_rs}\n")
