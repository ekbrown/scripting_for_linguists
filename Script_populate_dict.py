# Python script to populate a Python dictionary with strings as keys and integers as values
# Written by Earl Kjar Brown
# using Python 3.12.1

from time import time

def get_text(file_pathway):
	with open(file_pathway) as infile:
          return infile.read().upper()

def get_freqs(in_path):
    txt = get_text(in_path)
    # with open(in_path, mode="r", encoding="utf8") as infile:
    #     txt = infile.read().upper()
    wds = txt.split(" ")
    t0 = time()
    freqs = {}
    for i in range(len(wds)):
        wd = wds[i]
        if wd in freqs:
            freqs[wd] = freqs[wd] + 1
        else:
            freqs[wd] = 1
    t1 = time()
    print(t1 - t0)
    return freqs["THE"]

### main ###
if __name__ == "__main__":
    in_path = "/pathway/filename.txt"
    t0 = time()
    for i in range(5):
        print("Python is working on iteration", i + 1)
        freq = get_freqs(in_path)
        print("THE: ", freq)
