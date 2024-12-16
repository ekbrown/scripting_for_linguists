using BenchmarkTools
pathway = "/pathway/to/four.txt"
lines = open(pathway) do infile
    readlines(infile)
end


### part one ###

# create four-character strings
function create_four_char_strings(lines, y, x, direction)
    out_str = ""
    for i in 0:3
        try
            if direction == "right"
                out_str *= string(lines[y][x+i])
            elseif direction == "left"
                out_str *= string(lines[y][x-i])
            elseif direction == "down"
                out_str *= string(lines[y+i][x])
            elseif direction == "up"
                out_str *= string(lines[y-i][x])
            elseif direction == "left up"
                out_str *= string(lines[y-i][x-i])
            elseif direction == "left down"
                out_str *= string(lines[y+i][x-i])
            elseif direction == "right up"
                out_str *= string(lines[y-i][x+i])
            elseif direction == "right down"
                out_str *= string(lines[y+i][x+i])
            else
                return "Your 'direction' is jacked up! Try again pal."
            end
        catch BoundsError
            return nothing
        end
    end
    return out_str
end

function part_one()
    n = 0
    for y in 1:length(lines)
        for x in 1:length(lines[y])
            cur_char = lines[y][x]
            if cur_char == 'X'
                for d in ["right", "left", "up", "down", "left up", "left down", "right up", "right down"]
                    if create_four_char_strings(lines, y, x, d) == "XMAS"
                        n += 1
                    end
                end
            end
        end
    end
    return n
end

### part two ###
function get_cross_strings(lines, y, x)
    try
        forward_slash = sort([lines[y+1][x-1], lines[y][x], lines[y-1][x+1]])
        back_slash = sort([lines[y-1][x-1], lines[y][x], lines[y+1][x+1]])
        return [forward_slash; back_slash]
    catch BoundsError
        return nothing
    end
end

function part_two()
    n = 0
    for y in 1:length(lines)
        for x in 1:length(lines[y])
            cur_char = lines[y][x]
            if cur_char == 'A'
                if get_cross_strings(lines, y, x) == ['A', 'M', 'S', 'A', 'M', 'S']
                    n += 1
                end
            end
        end
    end
    return n
end

open("/pathway/to/times_jl.csv", "w") do outfile
    lang = "Julia 1.11.2"
    write(outfile, "lang,iter,part,sec\n")
    for i in 1:10
        dur1 = @elapsed part_one()
        write(outfile, "$lang,$i,Part One,$dur1\n")

        dur2 = @elapsed part_two()
        write(outfile, "$lang,$i,Part Two,$dur2\n")
    end
    println("All done!")
end
