# Julia script to calculate MTLD (Measure of Textual Lexical Diversity) in one file_pathway
# Earl Kjar Brown

using Statistics
using BenchmarkTools
using Dates

# remove Arabic numerals and dashes
function preprocess(txt)
    txt = replace(lowercase(txt), r"[0-9]+" => "")
    txt = replace(txt, "–" => "")
    txt = replace(txt, "—" => "")
    txt = replace(txt, "-" => "")
    return txt    
end

# tokenize text into words
function tokenize(txt)
    txt = preprocess(txt)
    punct = "!\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
    for p in punct
        txt = replace(txt, p => " ")
    end
    wds = split(txt, r"\s+")
    filter!(x -> length(x) > 0, wds)
    return wds   
end

# define the workhorse MTLD function
function sub_mtld(wds, threshold, reversed)
    if reversed
        reverse!(wds)
    end

    n_wds::Int = length(wds)

    terms = Set{String}()
    word_counter = 0
    factor_count = 0

    for w in wds
        word_counter += 1
        push!(terms, w)
        ttr = length(terms) / word_counter

        if ttr::Float64 <= threshold::Float64
            word_counter = 0
            terms = Set{String}()
            factor_count += 1
        end
    end  # next word

    if word_counter > 0
        factor_count += (1 - ttr) / (1 - threshold)
    end

    if factor_count == 0
        ttr = length(Set(wds)) / 
        if ttr == 1
            factor_count += 1
        else
            factor_count += (1 - ttr) / (1 - threshold)
        end
    end
    return n_wds / factor_count
end

# define main MTLD function
function mtld(wds) 
    forward_measure = sub_mtld(wds, 0.72, false)
    reverse_measure = sub_mtld(wds, 0.72, true)

    output = mean([forward_measure, reverse_measure])

    return output
end

# get text out of file on harddrive
function get_txt(pathway::String) 
    open(pathway::String) do infile
        return read(infile, String)
    end
end

# main function
function get_mtld(file_pathway::String)
    txt = get_txt(file_pathway::String)
    wds = tokenize(txt)
    return mtld(wds)
end

# helper function to run ten trials to benchmark algorithm
function manual_benchmark(file_pathway::String, n_iter = 10)
    times = Vector()
    for i in 1:n_iter
        t1 = now()
        mtld = get_mtld(file_pathway::String)
        elapsed_time = (now() - t1).value / 1000
        push!(times, elapsed_time)
        println("Julia: MTLD = $mtld, which took $elapsed_time seconds")
    end    
    return times
end

### main ###
file_pathway = "/Users/ekb5/Downloads/big_badboy.txt"
# file_pathway = "/Users/ekb5/Downloads/input/0a0HuaT4Vm7FoYvccyRRQj.txt"
n_iter = 10
times = manual_benchmark(file_pathway, n_iter)
times_mean = mean(times)
times_median = median(times)
println("\nOver $n_iter iterations, Julia: mean = $times_mean; median = $times_median\n")
