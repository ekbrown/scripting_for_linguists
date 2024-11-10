# using Formatting, DataFrames
using DataFrames, Printf, Dates

function get_num_wds_freqs(pathway)
    # Helper function to retrieve the number of words and the frequencies of those words in a directory
    cd(pathway)
    files = [file for file in readdir() if occursin(r"\.txt"i, file)]
    freqs = Dict{String, Int64}()
    num_wds = 0
    for file in files
        open(file) do infile
            whole_file = read(infile, String)
            wds = split(whole_file, r"[^-'a-záéíóúüñ]+"i, keepempty = false)
            wds = [uppercase(wd) for wd in wds]
            num_wds += length(wds)
            for wd in wds
                freqs[wd] = get(freqs, wd, 0) + 1
            end
        end
    end
    @printf "There are %s words in %s" num_wds pathway
    return (num_wds, freqs)
end

function get_keywords(target_dir, ref_dir, num_keywords, min_freq)
    #=
    Get keywords in .txt files within a target directory, comparing them with words in .txt files within a reference directory.
    param: target_dir - the directory with the target corpus in .txt files
    param: ref_dir - the directory with the reference corpus in .txt files
    param: num_keywords - number of keywords desired
    param: min_freq - the minimum frequency of keywords in the target corpus
    return value: a DataFrame with three columns: (1) keyword, (2) frequency in target corpus, (3) keyness score
    =#

    # get number of words and freqs in target and reference directories
    target_num_wds, target_freqs = get_num_wds_freqs(target_dir)
    ref_num_wds, ref_freqs = get_num_wds_freqs(ref_dir)

    # # calculate keyness (original way written by Adam Davies)
    # rel_freq = target_num_wds / ref_num_wds # calculate frequency ratio between target corpus and reference corpus
    # keywords = Dict{String, Float64}()
    # for wd in [i[1] for i in sort(collect(target_freqs), by=x->x[2], rev = true)]
    #     if target_freqs[wd] >= min_freq
    #         if haskey(ref_freqs, wd)
    #             keywords[wd] = log2((target_freqs[wd] * rel_freq) / ref_freqs[wd])
    #         end
    #     end
    # end

    # calculate keyness (log likelihood as given Brezina 2018 stats book p. 82)
    n_wds_in_both = target_num_wds + ref_num_wds
    keywords = Dict{String, Float64}()
    for wd in [i[1] for i in sort(collect(target_freqs), by=x->x[2], rev = true)]
        if target_freqs[wd] >= min_freq
            if haskey(ref_freqs, wd)
                freq_wd_in_both = target_freqs[wd] + ref_freqs[wd]
                expected_freq_in_target = (target_num_wds * freq_wd_in_both) / n_wds_in_both
                expected_freq_in_ref = (ref_num_wds * freq_wd_in_both) / n_wds_in_both
                log_likelihood_score = 2 * ((target_freqs[wd] * log(target_freqs[wd] / expected_freq_in_target)) + ((ref_freqs[wd] * log(ref_freqs[wd] / expected_freq_in_ref))))
                keywords[wd] = log_likelihood_score
            end
        end
    end
    
    # # calculate simple maths keyness statistics (cf. Kilgarriff 2009)
    # keywords = Dict{String, Float64}()
    # k = 1
    # for wd in [i[1] for i in sort(collect(target_freqs), by=x->x[2], rev = true)]
    #     if target_freqs[wd] >= min_freq
    #         # if haskey(ref_freqs, wd)
    #         relative_freq_wd_target = target_freqs[wd] / target_num_wds + k
    #         relative_freq_wd_ref = try
    #             ref_freqs[wd] / ref_num_wds + k                
    #         catch KeyError
    #             k
    #         end
    #         simple_maths = (relative_freq_wd_target) / (relative_freq_wd_ref)
    #         keywords[wd] = simple_maths
    #         # end
    #     end
    # end

    # sort keywords and limit to number desired by user
    top_keywords = sort(collect(keywords), by = x -> x[2], rev = true)[1:num_keywords]

    # push keywords to DataFrame
    df = DataFrame(keyword = String[], freq = Int64[], keyness = Float64[])
    # df = DataFrame(A = Int64[], B = Int64[])
    for kw in top_keywords
        push!(df, [kw[1], target_freqs[kw[1]], round(kw[2], digits = 2)])
    end

    return df
end

### test the function
target_dir = "/pathway/to/target/dir/"
ref_dir = "/pathway/to/reference/dir/"
num_keywords = 25
min_freq = 3

open("/pathway/to/times_jl.csv", "w") do outfile
    write(outfile, "lang,iter,dur\n")
    for i in 1:10
        println("Julia's working on iteration ", i)
        t1 = now()
        results = get_keywords(target_dir, ref_dir, num_keywords, min_freq)
        dur = (now()-t1) / Millisecond(1000)
        write(outfile, "Julia_1.11.1,$i,$dur\n")
        println(results)
        println("Julia took: ", dur, " seconds")
    end
end

