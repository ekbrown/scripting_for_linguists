from time import time
import rs_helps_py_hashmap

def insert_into_dictionary_py(in_str):
    out_dict = {}
    for w in in_str.split(" "):
        out_dict[w] = out_dict.get(w, 0) + 1
    return out_dict

if __name__ == "__main__":

    with open("/pathway/to/big_badboy_alphanum.txt") as infile, open("/pathway/to/times.csv", "w") as outfile:
        txt_as_str: list = infile.read().upper().split(" ")

        outfile.write("lang,n_wds,iter,sec\n")

        for i in range(1000, 100_000_000, 1000):
            print(f"Working on {i} words")

            cur_txt_as_str: str = " ".join(txt_as_str[:i])

            for j in range(10):

                print(f"\ton iteration {j+1}")

                ### Python ###
                t0=time()
                py_dict = insert_into_dictionary_py(cur_txt_as_str)
                dur = time()-t0
                print("\t\tPython took", dur, "seconds")
                print("\t\tPython: THE = ", py_dict["THE"])
                print("\t\tPython: TREE = ", py_dict["TREE"])
                outfile.write(f"Python,{i},{j+1},{dur}\n")

                ### Rust ###
                t1 = time()
                rs_dict = rs_helps_py_hashmap.insert_into_dictionary_rs(cur_txt_as_str)
                dur = time()-t1
                print("\t\tRust took", dur, "seconds")
                print("\t\tRust: THE = ", rs_dict["THE"])
                print("\t\tRust: TREE = ", rs_dict["TREE"])
                outfile.write(f"Rust,{i},{j+1},{dur}\n")
