# Python script to populate a Python dictionary with strings as keys and integers as values
# Written by Earl Kjar Brown
# using Python 3.12.3

from time import time

def get_wds(file_pathway):
	with open(file_pathway) as infile:
          return infile.read().upper().split(" ")

def get_freqs(wds):
    freqs = {}
    n_wds = len(wds)
    print(n_wds, "words")
    for wd in wds:
        if wd in freqs:
            freqs[wd] = freqs[wd] + 1
        else:
            freqs[wd] = 1
    return freqs

### main ###
if __name__ == "__main__":
    version = "v3.12.3"

    in_path = "/pathway/to/big_badboy_alphanum.txt"
    wds = get_wds(in_path)
    n_wds = len(wds)

    out_path = "/pathway/to/times_py.csv"
    with open(out_path, "w") as outfile:
        outfile.write("version,n_wds,n_keys,the,sec\n")
        for i in range(10):
            print("Working on iteration", i+1)
            t0 = time()
            freqs = get_freqs(wds)
            t1 = time()
            duration = t1-t0
            print("Seconds =", duration)
            the = freqs["THE"]
            print("THE =", the)
            n_keys = len(freqs.keys())
            print("N of keys =", n_keys)
            out_str = f"{version},{n_wds},{n_keys},{the},{duration}\n"
            outfile.write(out_str)
