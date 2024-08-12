using Dates

function get_ttr(in_wds)
    return length(Set(in_wds)) / length(in_wds)
end

function get_mattr(in_list, window_span = 50)
    n_wds = length(in_list)
    if n_wds <= 50
        output = get_ttr(in_list)
    else
        numerator = 0.0
        n_window = n_wds - window_span + 1
        for i in 1:n_window
            numerator += get_ttr(in_list[i : (i+window_span-1)])
        end
        output = numerator / n_window
    end
    return output
end

### main ###
#region
in_path = "/Users/ekb5/Downloads/input/0a0HuaT4Vm7FoYvccyRRQj.txt"
out_path = "/Users/ekb5/Downloads/times_jl.csv"
#endregion
txt = open(in_path) do infile
    uppercase(read(infile, String))
end
wds = split(txt)
println("number of words = ", length(wds))
println(typeof(wds))
open(out_path, "w") do outfile
    write(outfile, "n_wds,lang,sec\n")
    for i in 50:50:10000
        println(i)
        t1= time_ns()
        mattr = get_mattr(wds[1:i])
        dur_jl = (time_ns()-t1)/1_000_000_000
        println("Julia took ", dur_jl, " and got ", mattr)
        write(outfile, "$i,Julia,$dur_jl\n")        
    end
end
