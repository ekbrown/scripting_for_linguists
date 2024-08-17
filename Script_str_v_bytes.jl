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
in_path = "/pathway/to/0a0HuaT4Vm7FoYvccyRRQj.txt"
out_path = "/pathway/to/times_jl.csv"
#endregion
txt = open(in_path) do infile
    uppercase(read(infile, String))
end

### strings ###
wds = split(txt)

### bytes; thanks to @andrebieler7906 for his comment on https://youtu.be/tvLpiDIQMjQ
bwds = [Vector{UInt8}(word) for word in wds]

println("number of words = ", length(wds))
println(typeof(wds))
open(out_path, "w") do outfile
    write(outfile, "n_wds,lang,sec_str,sec_bytes\n")
    for i in 50:50:10000
        println(i)
        t1= time_ns()
        mattr_str = get_mattr(wds[1:i]) # strings
        dur_jl_str = (time_ns()-t1)/1_000_000_000
        t2=time_ns()
        mattr_bytes = get_mattr(@view bwds[1:i]) # bytes
        dur_jl_bytes = (time_ns()-t2)/1_000_000_000
        println("MATTR (str)   = ", mattr_str)
        println("MATTR (bytes) = ", mattr_bytes)
        write(outfile, "$i,Julia,$dur_jl_str,$dur_jl_bytes\n")        
    end
end
