using DataFrames
using Dates
using Distributed
using Statistics

function get_filenames(in_dir)
    all_files = Array{String, 1}()
    for (root, dirs, files) in walkdir(in_dir)
        for file in files
            if endswith(file, "txt")
                cur_file = joinpath(root, file)
                push!(all_files, cur_file)
            end
        end
    end
    return all_files
end

function get_collocates_one_file(pathway, node, span = 5)
    # freqs_all = Dict()
    # freqs_coll = Dict()
    freqs_all = Dict{String,Int}()
    freqs_coll = Dict{String,Int}()
    open(pathway) do infile
        txt = uppercase(read(infile, String))
        wds = [m.match for m in eachmatch(r"[-'’A-Z]+", txt)]
        for i in 1:length(wds)
            wd = wds[i]
            freqs_all[wd] = get(freqs_all, wd, 0) + 1
            if wd == node
                for j in -span:span
                    if j == 0
                        continue
                    else
                        try
                            coll = wds[i+j]
                            freqs_coll[coll] = get(freqs_coll, coll, 0) + 1
                        catch BoundsError
                            continue
                        end
                    end
                end  # next index within span
                # println(count)
            end  # if current word is the node word
        end  # next index (of words)
    end  # close connection to file
    # return Dict("all" => freqs_all, "coll" => freqs_coll)
    return Dict{String,Dict}("all" => freqs_all, "coll" => freqs_coll)
end

function flatten_dicts(result)
    # freqs_all = Dict()
    # freqs_coll = Dict()
    freqs_all = Dict{String,Int}()
    freqs_coll = Dict{String,Int}()
    for r in result
        for (k, v) in r["all"]
            freqs_all[k] = get(freqs_all, k, 0) + v
        end
        for (k, v) in r["coll"]
            freqs_coll[k] = get(freqs_coll, k, 0) + v
        end
    end
    # return Dict("all" => freqs_all, "coll" => freqs_coll)
    return Dict{String,Dict}("all" => freqs_all, "coll" => freqs_coll)
end

function log_dice(N_collocation, N_node, N_collocate)
    return 14 + log2((2 * N_collocation) / (N_node + N_collocate))
end

function make_df(result, node)
    N_node = result["all"][node]
    df = DataFrame(collocate=String[], N_collocation=Int[], N_node=Int[], N_collocate=Int[], log_dice=Float64[]) 
    
    for (k, v) in result["coll"]
        N_collocate = result["all"][k]
        ld = log_dice(v, N_node, N_collocate)
        push!(df, (k, v, N_node, N_collocate, ld)) 
    end  # next collocate

    sort!(df, [order(:log_dice, rev = true)])

    return df
end

function get_collocates_dir(pathway, node)
    filenames=get_filenames(pathway)
    lk = ReentrantLock()
    println("Julia: N threads = ", Threads.nthreads())
    array_dicts = Array{Dict, 1}()
    Threads.@threads for filename in filenames
        result = get_collocates_one_file(filename, node)
        lock(lk) do 
            push!(array_dicts, result)
        end  # unlock
    end  # next filename
    return make_df(flatten_dicts(array_dicts), node)
end


### main ###

in_dir = "/path/to/dir"
node = uppercase("episode")
times = Array{Float64, 1}()
for i in 1:10
    println("Working on iteration $i...")
    local t1 = now()
    local result = get_collocates_dir(in_dir, node)
    local t2 = now()
    println(result[1:5, :])
    cur_time = (t2 - t1) / Millisecond(1000)
    push!(times, cur_time)    
    open("path/to/times.csv", "a") do outfile
        write(outfile, "NA,$cur_time\n")
    end
end
println("All times: $times")
println("Mean time: ", Statistics.mean(times))
println("Median time: ", Statistics.median(times))
