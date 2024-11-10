from math import log2, log
from collections import defaultdict
import os, re, time, pandas as pd
from time import perf_counter

start = time.time()

def get_num_wds_freqs(pathway):
    """Helper function to retrieve the number of words and the frequencies of those words in a directory"""
    os.chdir(pathway)
    files = [file for file in os.listdir() if re.search(r"\.txt", file, flags=re.I)]
    freqs = defaultdict(int)
    num_wds = 0
    for file in files:
        with open(file) as infile:
            whole_file_as_str = infile.read()
            wds = re.split(r"[^-'a-záéíóúüñ]+", whole_file_as_str, flags=re.I)
            wds = [wd.upper() for wd in wds if len(wd) > 0]
            num_wds += len(wds)
            for wd in wds:
                freqs[wd] += 1
    print("There are " + "{:,}".format(num_wds) + f" words in {pathway}")
    return (num_wds, freqs)

def get_keywords(target_dir, ref_dir, num_keywords, min_freq):
    """Get keywords in .txt files within a target directory, comparing them with words in .txt files within a reference directory.
    param: target_dir - the directory with the target corpus in .txt files
    param: ref_dir - the directory with the reference corpus in .txt files
    param: num_keywords - number of keywords desired
    param: min_freq - the minimum frequency of keywords in the target corpus
    return value: a pandas DataFrame with three columns: (1) keyword, (2) frequency in target corpus, (3) keyness score
    """

    # get number of words and freqs in target and reference directories
    target_num_wds, target_freqs = get_num_wds_freqs(target_dir)
    ref_num_wds, ref_freqs = get_num_wds_freqs(ref_dir)

    # calculate frequency ratio between target corpus and reference corpus
    rel_freq = target_num_wds / ref_num_wds

    # # calculate keyness (original metric written by Adam Davies)
    # keywords = {}
    # for wd in sorted(target_freqs, key = lambda x:target_freqs[x], reverse = True):
    #     if target_freqs[wd] >= min_freq:
    #         if wd in ref_freqs:
    #             keywords[wd] = log2((target_freqs[wd] * rel_freq) / ref_freqs[wd])

    # calculate keyness (log likelihood as given Brezina 2018 stats book p. 82)
    n_wds_in_both = target_num_wds + ref_num_wds
    keywords = {}
    for wd in [k for k, v in sorted(target_freqs.items(), key = lambda x: x[1], reverse = True)]:
        if target_freqs[wd] >= min_freq:
            if wd in ref_freqs:
                freq_wd_in_both = target_freqs[wd] + ref_freqs[wd]
                expected_freq_in_target = (target_num_wds * freq_wd_in_both) / n_wds_in_both
                expected_freq_in_ref = (ref_num_wds * freq_wd_in_both) / n_wds_in_both
                log_likelihood_score = 2 * ((target_freqs[wd] * log(target_freqs[wd] / expected_freq_in_target)) + ((ref_freqs[wd] * log(ref_freqs[wd] / expected_freq_in_ref))))
                keywords[wd] = log_likelihood_score


    # sort keywords and limit to number desired by user
    top_keywords = [kw for kw in sorted(keywords, key = lambda x:keywords[x], reverse = True)][:num_keywords]

    # push keywords to pandas DataFrame
    df = pd.DataFrame(columns = ["keyword", "freq", "keyness"])
    for kw in top_keywords:
        df = df._append({'keyword': kw, "freq": target_freqs[kw], "keyness": "{:.4}".format(keywords[kw])}, ignore_index=True)

    return df


### test the function
target_dir = "/pathway/to/target/dir/"
ref_dir = "/pathway/to/reference/dir/"
num_keywords = 25
min_freq = 3

with open("/pathway/to/times_py.csv", "w") as outfile:
    outfile.write("lang,iter,dur\n")
    for i in range(10):
        print("Python's working on iteration", i+1)
        t0=perf_counter()
        results = get_keywords(target_dir, ref_dir, num_keywords, min_freq)
        dur = perf_counter()-t0
        outfile.write(f"Python_3.13.0,{i+1},{dur}\n")
        print(results)
        print("Python took:", dur, "seconds")
    

