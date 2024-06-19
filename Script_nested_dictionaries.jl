using Dates

function get_words_by_file(in_dir, n_files)
    cd(in_dir)
    filenames = filter(x -> endswith(lowercase(x), "txt"), readdir())[1:n_files]
    all_wds_by_file = Dict{String, Dict}()
    n_wds_corpus = 0
    for filename in filenames
        all_wds_by_file[filename] = Dict{String, Dict}()
        open(filename) do infile
            txt = read(infile, String)
            wds = [m.match for m in eachmatch(r"[-'’a-z]+"i, uppercase(txt))]
            n_wds_file = length(wds)
            n_wds_corpus += n_wds_file
            for i in 1:n_wds_file
                node = wds[i]
                if !haskey(all_wds_by_file[filename], node)
                    all_wds_by_file[filename][node] = Dict{String, Dict}("pre" => Dict{String, Int}(), "post" => Dict{String, Int}())
                end
                if i == 1
                    pre_wd = "<s>"
                else
                    pre_wd = wds[i-1]
                end
                if i == n_wds_file
                    post_wd = "<s>"
                else
                    post_wd = wds[i+1]
                end
                all_wds_by_file[filename][node]["pre"][pre_wd] = get(all_wds_by_file[filename][node]["pre"], pre_wd, 0) + 1
                all_wds_by_file[filename][node]["post"][post_wd] = get(all_wds_by_file[filename][node]["post"], post_wd, 0) + 1
            end  # next word
        end  # close connection to current file
    end  # next filename
    println("Julia: N words in corpus = ", n_wds_corpus)
    return all_wds_by_file

end  # end function

in_dir = "/path/to/dir"
open("/path/to/times.csv", "a") do outfile
    for i in collect(1000:1000:5000)
        println("Working on $i files...")
        for j in 1:10
            println("\tWorking on iteration $j")
            t1 = time()
            result = get_words_by_file(in_dir, i)
            duration = time() - t1
            println("\tJulia took ", duration, " seconds")
            println("\t", result["06vTDY97DIwqHxQSMMxZLq.txt"]["DAY"]) 
            write(outfile, "julia_v1.10.4,$i,$j,$duration\n")  
        end
    end  # next iteration    
end  # close connection to outfile
