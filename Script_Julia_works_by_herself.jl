using BenchmarkTools

function get_freqs(wds)
    freqs = Dict{String,Int}()
    for wd in wds
        freqs[wd] = get(freqs, wd, 0) + 1
    end
    return freqs
end

function get_ttr(in_wds)
    return length(Set(in_wds)) / length(in_wds)
end

function get_mattr(in_list, window_span::Int=50)
    in_list = [Vector{UInt8}(word) for word in in_list]

    n_wds = length(in_list)
    if n_wds <= 50
        output = get_ttr(in_list)
    else
        numerator = 0.0
        n_window = n_wds - window_span + 1
        for i in 1:n_window
            numerator += get_ttr(in_list[i:(i+window_span-1)])
        end
        output = numerator / n_window
    end
    return output
end


function get_mtld_w(intokens, target_ttr::Float64=0.72)
    factor_lengths = Vector{Int}()
    e = Set{String}()
    iterations = length(intokens)
    for n in 1:iterations
        n_tokens::Int = 0
        end_reached::Bool = false
        for i in n:iterations
            lemma::String = intokens[i]
            n_tokens += 1
            push!(e, lemma)
            if n_tokens >= 10
                types = Float64(length(e))
                ttr = Float64(types / n_tokens)
                if ttr < target_ttr
                    push!(factor_lengths, n_tokens)
                    empty!(e)
                    end_reached = true
                    break
                end
            end
        end
        if end_reached == false
            for i in 1:iterations
                lemma = intokens[i]
                n_tokens += 1
                push!(e, lemma)
                if n_tokens >= 10
                    types = Float64(length(e))
                    ttr = Float64(types / n_tokens)
                    if ttr < target_ttr
                        push!(factor_lengths, n_tokens)
                        break
                    end
                end
            end
            break
        end
    end
    sum_of_factors = sum(factor_lengths)
    number_of_factors = Float64(length(factor_lengths))
    mtld_wrap = Float64(sum_of_factors / number_of_factors)
    return mtld_wrap
end


function main()
    #region
    inpath = "/pathway/war_and_peace.txt"
    #endregion
    wds = open(inpath, "r") do infile
        txt = uppercase(read(infile, String))
        [m.match for m in eachmatch(r"[-'’A-Z]+", txt)]
    end

    #region
    outpath = "/pathway/times_jl.csv"
    #endregion
    open(outpath, "w") do outfile
        write(outfile, "iter,lang,task,sec\n")

        for i in 1:10
            dur = @elapsed freqs_jl = get_freqs(wds)
            write(outfile, "$i,Julia,freqs,$dur\n")
            println("\tjl freq of 'THE': ", freqs_jl["THE"])

            dur = @elapsed mattr = get_mattr(wds)
            write(outfile, "$i,Julia,MATTR,$dur\n")
            println("\tjl MATTR: ", mattr)

            dur = @elapsed mtld_w = get_mtld_w(wds)
            write(outfile, "$i,Julia,MTLD-W,$dur\n")
            println("\tjl MTLD-W: ", mtld_w)

        end
    end
end

main()
