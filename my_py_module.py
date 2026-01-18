def get_freqs(wds):
    freqs = {}
    for wd in wds:
        freqs[wd] = freqs.get(wd, 0) + 1
    return freqs

def get_ttr(in_wds):
    return len(set(in_wds)) / len(in_wds)

def get_mattr(intokens, window_span = 50):
    n_wds = len(intokens)
    if n_wds <= window_span:
        output = get_ttr(intokens)
    else:
        numerator = 0.0
        n_window = n_wds - window_span + 1
        for i in range(n_window):
            numerator += get_ttr(intokens[i : i+window_span])
        output = numerator / float(n_window)
    return output

def get_mtld_wrap(intokens, target_ttr = 0.72):
    """
    Get MTLD_wrap with Python code written by Scott Jarvis
    Vidal, Karina & Jarvis, Scott. 2020. Effects of English-medium instruction on Spanish students’ proficiency and lexical diversity in English. Language Teaching Research. SAGE Publications 24(5). 568–587. (doi:10.1177/1362168818817945)
    """
    factor_lengths = []
    e = set()
    iterations = len(intokens)
    for n in range(0, iterations):
        tokens = 0
        end_reached = False
        for i in range(n, iterations):
            lemma = intokens[i]
            tokens += 1
            e.add(lemma)
            if tokens >= 10:
                types = float(len(e))
                ttr = float(types / tokens)
                if ttr < target_ttr:
                    factor_lengths.append(tokens)
                    e.clear()
                    end_reached = True
                    break
        if end_reached == False:
            for i in range(0, iterations):
                lemma = intokens[i]
                tokens += 1
                e.add(lemma)
                if tokens >= 10:
                    types = float(len(e))
                    ttr = float(types / tokens)
                    if ttr < target_ttr:
                        factor_lengths.append(tokens)
                        break
            break
    sum_of_factors = sum(factor_lengths)
    number_of_factors = float(len(factor_lengths))
    mtld_wrap = float(sum_of_factors / number_of_factors)
    return mtld_wrap
