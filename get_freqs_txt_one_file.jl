using Dates

function get_txt(in_pathway)
    output = open(in_pathway) do infile
        txt = uppercase(read(infile, String))
    end
    return output
end

function get_freqs(in_pathway)
    txt = get_txt(in_pathway)
    wds = split(txt, " ")
    t1 = now()
    freqs = Dict{String,Int}()
    for wd in wds
        freqs[wd] = get(freqs, wd, 0) + 1
    end
    t2 = now()
    println("took " , (t2 - t1) / Millisecond(1000), " seconds.")
    return freqs["THE"]
end

times = []
for i in 1:5
    print("Julia is working on iteration $i... ")
    println("THE = ", get_freqs("/pathway/to/filename.txt"))
end
