from collections import Set, List
from pathlib import Path
from time import perf_counter_ns
from builtin import sort


fn get_txt(borrowed file_pathway: Path) raises -> List[String]:
    return file_pathway.read_text().splitlines()


fn create_four_char_strings(
    inout lines: List[String], y: Int, x: Int, direction: String
) raises -> String:
    var len_line = len(lines[1]) - 1
    var n_lines = len(lines) - 1
    var out_str = String()
    for i in range(4):
        if direction == str("right"):
            if x + i > len_line:
                return str("none")
            out_str += lines[y][x + i]
        elif direction == str("left"):
            if x - i < 0:
                return str("none")
            out_str += lines[y][x - i]
        elif direction == str("down"):
            if y + i > n_lines:
                return str("none")
            out_str += lines[y + i][x]
        elif direction == str("up"):
            if y - i < 0:
                return str("none")
            out_str += lines[y - i][x]
        elif direction == str("left up"):
            if (y - i < 0) or (x - i < 0):
                return str("none")
            else:
                out_str += lines[y - i][x - i]
        elif direction == str("left down"):
            if x - i < 0:
                return str("none")
            elif y + i > len_line:
                return str("none")
            else:
                out_str += lines[y + i][x - i]
        elif direction == str("right up"):
            if y - i < 0:
                return str("none")
            elif x + i > len_line:
                return str("none")
            else:
                out_str += lines[y - i][x + i]
        elif direction == str("right down"):
            if y + i > n_lines:
                return str("none")
            elif x + i > len_line:
                return str("none")
            out_str += lines[y + i][x + i]
        else:
            return str("Your 'direction' is jacked up! Try again pal.")
    return out_str


fn part_one(inout lines: List[String]) raises -> Int:
    var n = 0
    var directions = List[String](
        "right",
        "left",
        "up",
        "down",
        "left up",
        "left down",
        "right up",
        "right down",
    )
    for y in range(len(lines)):
        for x in range(len(lines[y])):
            cur_char = lines[y][x]
            if cur_char == "X":
                for d in directions:
                    # print(d[])
                    if create_four_char_strings(lines, y, x, d[]) == String(
                        "XMAS"
                    ):
                        n += 1
    return n


### part two ###
fn get_cross_strings(
    lines: List[String], y: Int, x: Int
) raises -> List[String]:
    var len_line = len(lines[1]) - 1
    var n_lines = len(lines) - 1

    if y - 1 < 0 or x - 1 < 0:
        return List[String]("none")
    else:
        if y + 1 > n_lines or x - 1 < 0 or y - 1 < 0 or x + 1 > len_line:
            return List[String]("none")
        else:
            forward_slash = List[String](
                lines[y + 1][x - 1], lines[y][x], lines[y - 1][x + 1]
            )
            back_slash = List[String](
                lines[y - 1][x - 1], lines[y][x], lines[y + 1][x + 1]
            )
            sort.sort(forward_slash)
            sort.sort(back_slash)
            forward_slash.extend(back_slash)
            return forward_slash


def part_two(lines: List[String]):
    var n = 0
    var ordered_letters = List[String]("A", "M", "S", "A", "M", "S")

    for y in range(len(lines)):
        for x in range(len(lines[y])):
            cur_char = lines[y][x]
            if cur_char == "A":
                if get_cross_strings(lines, y, x) == ordered_letters:
                    n += 1
    return n


fn main() raises:
    var file_pathway: String = "/pathway/to/four.txt"
    var lines = get_txt(file_pathway)
    var outfile: Path = Path("/pathway/to/times_mj.csv")
    var output_str = String("lang,iter,part,sec\n")
    # var output_str = String()
    for i in range(10):
        var t0 = perf_counter_ns()
        var n = part_one(lines)
        var t1 = perf_counter_ns()
        var dur = (t1 - t0) / 1000000000
        print(n)
        print(dur)
        output_str += (
            "Mojo 25.1.0," + str(i + 1) + "," + "Part One," + str(dur) + "\n"
        )

        var t2 = perf_counter_ns()
        var n2 = part_two(lines)
        t3 = perf_counter_ns()
        var dur2 = (t3 - t2) / 1000000000
        print(n2)
        print(dur2)
        output_str += (
            "Mojo 25.1.0," + str(i + 1) + "," + "Part Two," + str(dur2) + "\n"
        )

    outfile.write_text(output_str)
