from collections import Dict, List, Set
from pathlib import Path, path
from time import now

@value
struct LexDivModern:
    var in_path: String
    var wds: List[String]

    fn __init__(inout self, in_path: String):
        self.in_path = in_path
        self.wds = List[String]()

    fn get_text(inout self, n_wds: Int) raises:
        self.wds = Path(self.in_path).read_text().upper().split()[:n_wds]

    fn get_ttr(inout self, in_wds: List[String]) raises -> Float64:
        return len(Set(in_wds)) / len(in_wds)

    fn get_mattr(inout self, window_span: Int = 50) raises -> Float64:
        var n_wds = len(self.wds)
        var output: Float64
        if n_wds <= 50:
            output = self.get_ttr(self.wds)
        else:
            var numerator = 0.0
            var n_window = n_wds - window_span + 1
            for i in range(n_window):
                var slice = self.wds[i : (i+window_span)]
                numerator += self.get_ttr(slice)
            output = numerator / n_window
        return output

        
### main ###
fn main() raises:
    var in_path = "/pathway/to/0a0HuaT4Vm7FoYvccyRRQj.txt"
    var out_path = "/pathway/to/times_mojo.csv"
    var lex_div_obj = LexDivModern(in_path)
    with open(out_path, "w") as outfile:
        outfile.write(str("n_wds,lang,sec\n"))
        for i in range(50, 10001, 50):
            print("Working on " + str(i) + " words")
            lex_div_obj.get_text(i)
            var t0 = now()
            var mattr = lex_div_obj.get_mattr()
            var dur_mj = (now() - t0) / 1_000_000_000
            print("Mojo took", dur_mj, "seconds and got", mattr)
            outfile.write(str(i) + ",Mojo," + str(dur_mj) + "\n")



