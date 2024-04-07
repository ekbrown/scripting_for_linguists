# Mojo script to calculate MTLD (Measure of Textual Lexical Diversity) in one file_pathway
# Earl Kjar Brown
# using Mojo v.24.2

from collections import Set, List
from pathlib import Path
from time import now

# remove Arabic numerals and dashes
fn preprocess(inout txt: String) raises:
    txt = txt.lower().replace("0", "")
    txt = txt.replace("1", "")
    txt = txt.replace("2", "")
    txt = txt.replace("3", "")
    txt = txt.replace("4", "")
    txt = txt.replace("5", "")
    txt = txt.replace("6", "")
    txt = txt.replace("7", "")
    txt = txt.replace("8", "")
    txt = txt.replace("9", "")
    txt = txt.replace("–", "")
    txt = txt.replace("—", "")
    txt = txt.replace("-", "")

fn remove_empty_elements(borrowed in_vec: List[String]) raises -> List[String]:
    var out_vec = List[String]()
    for x in in_vec:
        if x[] != "":
            out_vec.append(x[])
    return out_vec

fn tokenize(inout txt: String) raises -> List[String]:
    preprocess(txt)
    txt = txt.replace("!", " ")
    txt = txt.replace('"', " ")
    txt = txt.replace("#", " ")
    txt = txt.replace("$", " ")
    txt = txt.replace("%", " ")
    txt = txt.replace("&", " ")
    txt = txt.replace("'", " ")
    txt = txt.replace("(", " ")
    txt = txt.replace(")", " ")
    txt = txt.replace("*", " ")
    txt = txt.replace("+", " ")
    txt = txt.replace(",", " ")
    txt = txt.replace("-", " ")
    txt = txt.replace(".", " ")
    txt = txt.replace("/", " ")
    txt = txt.replace(":", " ")
    txt = txt.replace(";", " ")
    txt = txt.replace("<", " ")
    txt = txt.replace("=", " ")
    txt = txt.replace(">", " ")
    txt = txt.replace("?", " ")
    txt = txt.replace("@", " ")
    txt = txt.replace("[", " ")
    txt = txt.replace("\\", " ")
    txt = txt.replace("]", " ")
    txt = txt.replace("^", " ")
    txt = txt.replace("_", " ")
    txt = txt.replace("`", " ")
    txt = txt.replace("{", " ")
    txt = txt.replace("|", " ")
    txt = txt.replace("}", " ")
    txt = txt.replace("~", " ")
    var wds: List[String] = remove_empty_elements(txt.split(" "))
    return wds

# fn convert_vec2set(borrowed in_vec: DynamicVector[String], inout out_set: Set[String]) raises:
#     for w in in_vec:
#         out_set.add(w[])

fn sub_mtld(inout wds: List[String], borrowed threshold: Float64, borrowed reversed: Bool) raises -> Float64:
    if reversed:
        wds.reverse()
    var n_wds: Int = len(wds)
    var terms = Set[String]()
    var word_counter: Int = 0
    var factor_count: Float64 = 0.0
    var ttr: Float64 = 1.0
    for w in wds:
        word_counter += 1
        terms.add(w[])
        ttr = len(terms) / word_counter
        if ttr <= threshold:
            word_counter = 0
            for i in range(len(terms)):
                _ = terms.pop()
            # terms = Set[String]()
            # print("len(terms): ", len(terms))
            factor_count += 1
    if word_counter > 0:
        factor_count += (1 - ttr) / (1 - threshold)
    if factor_count == 0:
        ttr = len(Set[String](wds))
        if ttr == 1:
            factor_count += 1
        else:
            factor_count += (1 - ttr) / (1 - threshold)
    var output: Float64 = n_wds / factor_count
    return output

fn mtld(inout wds: List[String]) raises -> Float64:
    var forward_measure: Float64 = sub_mtld(wds, 0.72, False)
    var reverse_measure: Float64 = sub_mtld(wds, 0.72, True)
    return (forward_measure + reverse_measure) / 2

# define function to read text in file and uppercase (v.) it
fn get_txt(borrowed file_pathway: Path) raises -> String:
	return file_pathway.read_text().upper()

fn get_mtld(borrowed file_pathway: String) raises -> Float64:
    var txt: String = get_txt(Path(file_pathway))
    var wds: List[String] = tokenize(txt)
    return mtld(wds)

fn main() raises:
    # var file_pathway: String = "/Users/ekb5/Downloads/input/0a0HuaT4Vm7FoYvccyRRQj.txt"
    # var file_pathway: String = "/Users/ekb5/Downloads/delete.txt"
    var file_pathway: String = "/Users/ekb5/Downloads/big_badboy.txt"
    var t0 = now()
    var mtld: Float64 = get_mtld(file_pathway)
    var t1 = now()
    print(mtld)
    print((t1-t0) / 1_000_000_000)
