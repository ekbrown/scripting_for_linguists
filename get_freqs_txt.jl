using Dates
# using DataStructures

function push_freqs_dict(freqs, wds)
    for wd in wds

        # # Option 1: if else
        # if haskey(freqs, wd)
        #     freqs[wd] += 1
        # else
        #     freqs[wd] = 1
        # end

        # # Option 2:
        # try
        #     freqs[wd] += 1
        # catch KeyError
        #     freqs[wd] = 1
        # end 

        # Option 3: get function
        freqs[wd] = get(freqs, wd, 0) + 1

        # # Option 4: DefaultDict
        # freqs[wd] += 1

    end
    return freqs
end

function get_freqs(in_dir)
    cd(in_dir)
    freqs = Dict{String,Int}()
    # freqs = DefaultDict{String,Int}(0)
    count = 0
    for (root, dirs, files) in walkdir(in_dir)
        for file in files
            if endswith(file, "txt")
                count += 1
                if count > 1000
                    break
                end
                cur_file = joinpath(root, file)
                open(cur_file) do infile
                    txt = uppercase(read(infile, String))
                    wds = [m.match for m in eachmatch(r"[-'’A-Z]+", txt)]
                    push_freqs_dict(freqs, wds)
                end       
            end
        end
    end
    return freqs
end

times = []
for i in 1:2
    print("Working on iteration $i... ")
    t1 = now()
    freqs = get_freqs("/pathway/to/input/dir")
    t2 = now()
    push!(times, (t2 - t1) / Millisecond(1000))
    println("done.")
    wd = "THE"
    println("$wd: ", freqs[wd])
    println("N word types: ", length(freqs))
end
println("Times: ", times)
using Statistics
println("Mean: ", Statistics.mean(times))
println("Median: ", Statistics.median(times))