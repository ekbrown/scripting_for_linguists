# Python script to calculate the MTLD (Measure of Textual Lexical Diversity) metric in a file

from lexicalrichness import LexicalRichness
from time import time
import statistics

# read in text from file
# in_path = "/pathway/to/filename.txt"
in_path = "/Users/ekb5/Downloads/input/0a0HuaT4Vm7FoYvccyRRQj.txt"
with open(in_path) as infile:
    txt = infile.read()

# do ten trials to benchmark the algorithm
n_iter = 10
times = []
for i in range(n_iter):
    t0 = time()
    lex = LexicalRichness(txt)  # create object
    mtld = lex.mtld()  # get MTLD lexical diversity metric
    elapsed_time = time() - t0
    print(f"Lexical Richness in Python: MTLD = {mtld}, which took {elapsed_time} seconds.")
    times.append(elapsed_time)

print(f"\nOver {n_iter} iterations, Python: mean = {statistics.mean(times)}, median = {statistics.median(times)}\n")
