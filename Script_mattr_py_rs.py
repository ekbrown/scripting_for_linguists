import sys, re
from time import time

#region
sys.path.append("/Users/ekb5/Documents/lex_div_operationalizations")
#endregion
from lexical_diversity_modern import LexDivModern

#region
in_path = "/Users/ekb5/Downloads/input/0a0HuaT4Vm7FoYvccyRRQj.txt"
out_path = "/Users/ekb5/Downloads/times_py_rs.csv"
#endregion
with open(in_path) as infile, open(out_path, "w") as outfile:
    outfile.write("n_wds,lang,sec\n")
    txt = infile.read()
    wds = txt.upper().split()
    for i in range(50, 10001, 50):
        print(f"Working on {i} words")
        lex_div_obj = LexDivModern(wds[:i])
        t0=time()
        mattr_py = lex_div_obj.get_mattr()
        dur_py = time()-t0
        print("\tPy took", dur_py, "seconds and got", mattr_py)
        outfile.write(f"{i},Python,{dur_py}\n")
        t1=time()
        mattr_rs = lex_div_obj.get_mattr_rs()
        dur_rs = time()-t1
        print("\tRs took", dur_rs, "seconds and got", mattr_rs)
        outfile.write(f"{i},Rust,{dur_rs}\n")
