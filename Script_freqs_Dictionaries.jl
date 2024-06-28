using Dictionaries, BenchmarkTools

function get_freqs_dict(in_wds)
    """Base Julia dictionary"""
    freqs = Dict{String, Int64}()
    for wd in in_wds
        cur_wd = wd.match
        freqs[cur_wd] = get(freqs, cur_wd, 0) + 1
    end  # next word    
    return freqs
end  # function

function get_freqs_dictionary(in_wds)
    """Dictinaries.jl dictionary"""
    freqs = Dictionaries.Dictionary{String, Int64}()
    for wd in in_wds
        cur_wd = wd.match
        iskey, t = gettoken(freqs, cur_wd)
        if iskey
            set!(freqs, cur_wd, gettokenvalue(freqs, t) + 1)
        else
            insert!(freqs, cur_wd, 1)
        end
    end  # next word    
    return freqs
end  # function

### main ###
txt = open("/path/to/filename.txt") do infile
    read(infile, String)
end
wds = eachmatch(r"[-'A-Z]+", uppercase(txt))

println("Base Dict():")
@btime get_freqs_dict(wds)
println("Dictionaries.jl Dictionary()")
@btime get_freqs_dictionary(wds)
