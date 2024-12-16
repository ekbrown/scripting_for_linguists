from time import perf_counter

### part one ###

# create four-character strings
def create_four_char_strings(lines, y, x, direction):
    out_str = ""
    for i in range(4):
        try:
            if direction == "right":
                out_str += str(lines[y][x+i])
            elif direction == "left":
                if x-i < 0:
                    return None
                else:
                    out_str += str(lines[y][x-i])
            elif direction == "down":
                out_str += str(lines[y+i][x])
            elif direction == "up":
                if y-i < 0:
                    return None
                else:
                    out_str += str(lines[y-i][x])
            elif direction == "left up":
                if (y-i < 0) or (x-i < 0):
                    return None
                else:
                    out_str += str(lines[y-i][x-i])
            elif direction == "left down":
                if x-i < 0:
                    return None
                else:
                    out_str += str(lines[y+i][x-i])
            elif direction == "right up":
                if y-i < 0:
                    return None
                else:
                    out_str += str(lines[y-i][x+i])
            elif direction == "right down":
                out_str += str(lines[y+i][x+i])
            else:
                return "Your 'direction' is jacked up! Try again pal."
        except IndexError:
            return None
    return out_str

def part_one(lines):
    n = 0
    for y in range(len(lines)):
        for x in range(len(lines[y])):
            cur_char = lines[y][x]
            if cur_char == 'X':
                for d in ["right", "left", "up", "down", "left up", "left down", "right up", "right down"]:
                    if create_four_char_strings(lines, y, x, d) == "XMAS":
                        n += 1
    return n    

### part two ###
def get_cross_strings(lines, y, x):
    try:
        if y-1 < 0 or x-1 < 0:
            return None
        else:
            forward_slash = sorted([lines[y+1][x-1], lines[y][x], lines[y-1][x+1]])
            back_slash = sorted([lines[y-1][x-1], lines[y][x], lines[y+1][x+1]])
            forward_slash.extend(back_slash)
            return forward_slash
    except IndexError:
        return None

def part_two(lines):
    n = 0
    for y in range(len(lines)):
        for x in range(len(lines[y])):
            cur_char = lines[y][x]
            if cur_char == 'A':
                if get_cross_strings(lines, y, x) == ['A', 'M', 'S', 'A', 'M', 'S']:
                    n += 1
    return n

if __name__ == "__main__":
    pathway = "/pathway/to/four.txt"
    with open(pathway) as infile, open("/pathway/to/times_py.csv", "w") as outfile:
        lines = infile.readlines()
        lines = [l.rstrip() for l in lines]
        lang = "Python 3.13.1"
        outfile.write("lang,iter,part,sec\n")

        for i in range(10):
            t0 = perf_counter()
            result1 = part_one(lines)
            dur1 = perf_counter() - t0
            outfile.write(f"{lang},{i+1},Part One,{dur1}\n")
            print("Part_one: ", result1)
            print("took", dur1, "seconds")

            t1 = perf_counter()
            result2 = part_two(lines)
            dur2 = perf_counter() - t1
            print("Part two: ", result2)
            outfile.write(f"{lang},{i+1},Part Two,{dur2}\n")
            print("took", dur2, "seconds")

    print("All done!")
