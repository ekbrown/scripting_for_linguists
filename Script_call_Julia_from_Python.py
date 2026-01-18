import os
import re
import sys
from time import perf_counter
#region
sys.path.append("/Users/ekb5/Documents/Youtube_channel/py_jl_help_each_other/")
#endregion
# sys.path.append("pathway/filename.py")
import my_py_module

from juliacall import Main as jl
# jl.include("pathway/filename.jl")
#region
jl.include("/Users/ekb5/Documents/Youtube_channel/scripting_for_linguists/Script_call_Python_from_Julia.jl")
#endregion

def main():
    #region
    inpath = "/Users/ekb5/Downloads/war_and_peace.txt"
    outpath = "/Users/ekb5/Downloads/times_py.csv"
    #endregion
    with open(inpath) as infile, open(outpath, mode="w") as outfile:
        wds = re.findall(r"[-'’A-Z]+", infile.read().upper())

        outfile.write("iter,lang,task,sec\n")

        for i in range(10):
            print(f"iteration {i+1}")

            # freqs
            t0 = perf_counter()
            freqs_py = my_py_module.get_freqs(wds)
            dur = perf_counter() - t0
            outfile.write(f"{i+1},Python,freqs,{dur}\n")
            print("\tpy freq of 'THE':", freqs_py["THE"])

            t0 = perf_counter()
            freqs_jl = jl.get_freqs(wds)
            dur = perf_counter() - t0
            outfile.write(f"{i+1},Python-Julia,freqs,{dur}\n")
            print("\tpy-jl freq of 'THE':", freqs_jl["THE"])

            # mattr
            t0 = perf_counter()
            mattr_py = my_py_module.get_mattr(wds)
            dur = perf_counter() - t0
            outfile.write(f"{i+1},Python,MATTR,{dur}\n")
            print("\tpy MATTR:", mattr_py)

            t0 = perf_counter()
            mattr_jl = jl.get_mattr(wds)
            dur = perf_counter() - t0
            outfile.write(f"{i+1},Python-Julia,MATTR,{dur}\n")
            print("\tpy-jl MATTR:", mattr_jl)

            # mtld-w
            t0 = perf_counter()
            mtld_w_py = my_py_module.get_mtld_wrap(wds)
            dur = perf_counter() - t0
            outfile.write(f"{i+1},Python,MTLD-W,{dur}\n")
            print("\tpy MTLD-W:", mtld_w_py)

            t0 = perf_counter()
            mtld_w_jl = jl.get_mtld_w(wds)
            dur = perf_counter() - t0
            outfile.write(f"{i+1},Python-Julia,MTLD-W,{dur}\n")
            print("\tpy-jl MTLD-W:", mtld_w_jl)

if __name__ == "__main__":
    main()