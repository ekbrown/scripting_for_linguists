# Python script to benchmark three ways to access items in a dictionary
# Python v3.12.4

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

def access_dict_items(in_dict):
	for k, v in in_dict.items():
		pass

def access_dict_keys(in_dict):
	for k in in_dict.keys():
		v = in_dict[k]
		pass

def access_dict(in_dict):
	for k in in_dict:
		v = in_dict[k]
		pass

def run():
	in_file: str = "/pathway/to/bigbadboy.txt"
	all_wds: list = get_wds(in_file)
	with open("/pathway/to/times_access_py.csv", "w") as outfile:
		outfile.write("n_wds,n_keys,the,sec_items,sec_keys,sec_dict\n")
		for i in range(1000, 230_000_000, 1000):
			print("i =", i)
			freqs = dict[str, int]()
			wds: list = limit_wds(all_wds, i)
			print(len(wds), "words")
			for wd in wds:
				freqs[wd] = freqs.get(wd, 0) + 1
			t0 = time()
			access_dict_items(freqs)
			dur_items = time() - t0
			t1 = time()
			access_dict_keys(freqs)
			dur_keys = time() - t1
			t2=time()
			access_dict(freqs)
			dur_dict = time()-t2
			outfile.write(f"{i},{len(freqs)},{freqs['THE']},{dur_items},{dur_keys},{dur_dict}\n")


if __name__ == "__main__":
	run()