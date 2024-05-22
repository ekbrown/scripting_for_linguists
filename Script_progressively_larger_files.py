# Python v3.12.3 script to benchmark populating a dictionary with progressively larger numbers of words

from time import time

def get_wds(in_path: str) -> list:
	with open(in_path) as infile:
		return infile.read().upper().split(" ")

def limit_wds(in_wds: list, n_wds: int) -> list:
	out_wds = [None]*n_wds
	for i in range(n_wds):
		out_wds[i] = in_wds[i]
	return out_wds

def main():
	in_file: str = "/pathway/to/big_badboy.txt"
	all_wds: list = get_wds(in_file)
	with open("/pathway/to/times_py.csv", "w") as outfile:
		outfile.write("n_wds,n_keys,the,sec\n")
		for i in range(100, 230_000_000, 100):
			print("i =", i)
			freqs = dict[str, int]()
			wds: list = limit_wds(all_wds, i)
			print(len(wds), "words")
			t0 = time()
			for wd in wds:
				freqs[wd] = freqs.get(wd, 0) + 1
			t1 = time()
			duration = t1-t0
			print("Seconds =", duration)
			the = freqs["THE"]
			print("THE =", the)
			n_keys = len(freqs.keys())
			print("N of keys =", n_keys)
			out_str = f"{i},{n_keys},{the},{duration}\n"
			outfile.write(out_str)

if __name__ == "__main__":
	main()