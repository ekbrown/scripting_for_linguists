"""Script to calculate word frequencies in a directory of TXT files using multithreading in Python
Earl Kjar Brown, ekbrown byu edu (add characters to create email)
"""

import os, re, time, threading
import numpy as np
from time import time
import statistics

def get_filenames(in_dir):
    filenames = []
    for root, dirs, files in os.walk(in_dir):
        for file in files:
            if file.endswith("txt"):
                filenames.append(os.path.join(root, file))
    return filenames

def add_to_dict(filenames, fdsa):
    # print("len of filenames: ", len(filenames))
    for filename in filenames:
        # print("in add_to_dict function: ", filename)
        with open(filename, mode="r", encoding="utf8") as infile:     
            txt = infile.read().upper()
            wds = re.findall(r"[-'’A-Z0-9]+", txt)
            for wd in wds:
                fdsa[wd] = fdsa.get(wd, 0) + 1
    # print("freqs at end of add_to_dict: ", fdsa)
    return 0

def get_freqs(in_dir, num_threads):

    filenames = get_filenames(in_dir)
    # print("filenames: ", filenames)
    # print(len(filenames))
    threads = [None] * num_threads
    # freqs = [{}] * num_threads  # this makes N references to the same dictionary in memory, so don't use
    freqs = [{} for x in range(num_threads)]  # this make N difference dictionaries in memory
    # for i in range(len(freqs)):
    #     print(id(freqs[i]))
    # raise Exception("hold it pal!")

    filenames_split = np.array_split(filenames, num_threads)

    # initialize threads
    for i in range(num_threads):
        # print("freqs before threading: ", freqs)
        threads[i] = threading.Thread(target = add_to_dict, args = (filenames_split[i], freqs[i]))
        threads[i].start()

    # join threads results back to main thread (this program)
    for i in range(num_threads):
        threads[i].join()

    # flatten the dictionaries into a single dictionary
    output = {}
    for f in freqs:
        for k, v in f.items():
            output[k] = output.get(k, 0) + v
      
    return output
    # return freqs[0]

if __name__ == "__main__":

    ### SPECIFY THE NUMBER OF THREADS TO USE ###
    num_threads = 8

    # in_dir = "/Users/ekb5/Corpora/Brown/"
    in_dir = "/Users/ekb5/Corpora/spotify-podcasts-2020/podcasts-transcripts/txt"
    # in_dir = "/Users/ekb5/Downloads/input"

    times = []
    for i in range(1):

        t0 = time()
        asdf = get_freqs(in_dir, num_threads)
        t1 = time()
        times.append(t1-t0)

    print(f"N word types: {len(asdf)}")
    print(f"N word tokens: {sum(v for v in asdf.values())}")
    print(f'THE = {asdf["THE"]}, TREE = {asdf["TREE"]}, JUSTICE = {asdf["JUSTICE"]}, VERY = {asdf["VERY"]}, BACKPACK = {asdf["BACKPACK"]}')
    print("Times:", times)
    print("Mean time:", statistics.mean(times))
    print("Median time:", statistics.median(times))