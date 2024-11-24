import os, re
from time import perf_counter
import pandas as pd
import polars as pl

def get_freqs_line_by_line(in_path):
    freqs = {}
    with open(in_path) as infile:
        for line in infile:
            wds = re.findall(r"[-'’a-zA-Z]+", line.upper())
            for wd in wds:
                freqs[wd] = freqs.get(wd, 0) + 1
        return freqs

def get_freqs_slurp(in_path):
    freqs = {}
    with open(in_path) as infile:
        txt = infile.read().upper()
        wds = re.findall(r"[-'’a-zA-Z]+", txt)
        for wd in wds:
            freqs[wd] = freqs.get(wd, 0) + 1
        return freqs

def get_freqs_counter(in_path):
    from collections import Counter
    with open(in_path) as infile:
        txt = infile.read().upper()
        wds = re.findall(r"[-'’a-zA-Z]+", txt)
        freqs = Counter(wds)
        return freqs

def get_freqs_pandas(in_path):
    with open(in_path) as infile:
        txt = infile.read().upper()
        wds = re.findall(r"[-'’a-zA-Z]+", txt)
        s = pd.Series(data=wds)
        return s.value_counts()

def get_freqs_polars(in_path):
    with open(in_path) as infile:
        txt = infile.read().upper()
        wds = re.findall(r"[-'’a-zA-Z]+", txt)
        s = pl.Series(wds)
        return s.value_counts()

if __name__ == "__main__":
    os.chdir("/pathway/to/input_counter")
    filenames = [f for f in os.listdir() if f.endswith("txt")]

    with open("/pathway/to/times_counter.csv", "w") as outfile:
        outfile.write("iter,N_wds,Manner,Seconds\n")
        for filename in filenames:
            print(filename)
            n_wds = re.search(r"[0123]+", filename).group(0)
            for i in range(5):
                print('\ttrial:', i+1)

                for func in ["line_by_line", "slurp", "counter", "pandas", "polars"]:
                    print("\t\t", func)
                    t0 = perf_counter()
                    eval(f"get_freqs_{func}(filename)")
                    dur = perf_counter() - t0
                    outfile.write(f"{i},{n_wds},{func},{dur}\n")
