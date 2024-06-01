# Python script to benchmark accessing progressively larger dictionaries
# Python v3.12.3

from time import time
import re

def get_wds(in_path: str) -> list:
	with open(in_path) as infile:
		txt = infile.read().upper()
		wds = re.findall(r"[-'’A-Z]+", txt)
		return wds

def limit_wds(in_wds: list, n_wds: int) -> list:
	out_wds = [None]*n_wds
	for i in range(n_wds):
		out_wds[i] = in_wds[i]
	return out_wds

def run():
	in_file: str = "/pathway/to/big_badboy.txt"
	all_wds: list = get_wds(in_file)
	with open("/pathway/to/times_access_py.csv", "w") as outfile:
		outfile.write("n_wds,n_keys,the,sec\n")
		for i in range(1000, 230_000_000, 1000):
			print("i =", i)
			freqs = dict[str, int]()
			wds: list = limit_wds(all_wds, i)
			print(len(wds), "words")
			for wd in wds:
				freqs[wd] = freqs.get(wd, 0) + 1
			t0 = time()
			for k, v in freqs.items():
				pass
			t1 = time()
			dur = t1-t0
			print(f"Duration for {i} tokens: {dur} seconds")
			outfile.write(f"{i},{len(freqs)},{freqs['THE']},{dur}\n")


if __name__ == "__main__":
	run()