def get_mtld_wrap_Jarvis(self):
    """
    Get MTLD_wrap with Python code written by Scott Jarvis
    Vidal, Karina & Jarvis, Scott. 2020. Effects of English-medium instruction on Spanish students’ proficiency and lexical diversity in English. Language Teaching Research. SAGE Publications 24(5). 568–587. (doi:10.1177/1362168818817945)
    """
    factor_lengths = []
    e = set()
    iterations = len(self.in_list)
    for n in range(0, iterations):
        tokens = 0
        end_reached = False
        for i in range(n, iterations):
            lemma = self.in_list[i]
            tokens += 1
            e.add(lemma)
            if tokens >= 10:
                types = float(len(e))
                ttr = float(types / tokens)
                if ttr < 0.72:
                    factor_lengths.append(tokens)
                    e.clear()
                    end_reached = True
                    break
        if end_reached == False:
            for i in range(0, iterations):
                lemma = self.in_list[i]
                tokens += 1
                e.add(lemma)
                if tokens >= 10:
                    types = float(len(e))
                    ttr = float(types / tokens)
                    if ttr < 0.72:
                        factor_lengths.append(tokens)
                        break
            break
    sum_of_factors = sum(factor_lengths)
    number_of_factors = float(len(factor_lengths))
    mtld_wrap = float(sum_of_factors / number_of_factors)
    return mtld_wrap
