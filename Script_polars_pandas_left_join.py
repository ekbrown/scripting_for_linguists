import os, pandas as pd, polars as pl
from time import time

os.chdir("/pathway/to/dir/")

with open("times.csv", 'w') as outfile:
    outfile.write("package,iter,sec\n")

    for i in range(100):

        print(f"Working on iteration {i+1}")

        ### pandas ###
        freqs_pd = pd.read_csv("freqs.csv")
        concord_pd = pd.read_csv("concordances.csv")
        t0=time()
        both_pd = pd.merge(concord_pd, freqs_pd, left_on='match', right_on="wd", how='left')
        dur_pd = time()-t0
        print(both_pd)
        print("Pandas took", dur_pd, "seconds\n")
        outfile.write(f"Pandas,{i+1},{dur_pd}\n")

        ### polars ###
        freqs_pl = pl.read_csv("freqs.csv")
        concord_pl = pl.read_csv("concordances.csv")
        t1=time()
        both_pl = concord_pl.join(freqs_pl, left_on="match", right_on="wd", how = "left")
        dur_pl = time()-t1
        print(both_pl)
        print("Polars took", dur_pl, "seconds\n")
        outfile.write(f"Polars,{i+1},{dur_pl}\n")
