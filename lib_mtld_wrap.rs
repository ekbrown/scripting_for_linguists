use pyo3::prelude::*;
use std::collections::HashSet;

// Implement the MTLD_wrap (Measure of Textual Lexical Diversity - wrap around) algorithm in Rust and make the function callable in Python.
#[pyfunction]
fn get_mtld_wrap_jarvis_rs(in_list: Vec<String>) -> PyResult<f64>{
    // See: Vidal, Karina & Jarvis, Scott. 2020. Effects of English-medium instruction on Spanish students’ proficiency and lexical diversity in English. Language Teaching Research 24(5). 568–587. (doi:10.1177/1362168818817945)

    let mut factor_lengths: Vec<usize> = Vec::new();
    let mut e: HashSet<&str> = HashSet::new();
    let iterations = in_list.len();
    for n in 0..iterations {
        let mut tokens = 0;
        let mut end_reached = false;
        for i in n..iterations {
            let lemma = in_list[i].as_str();
            tokens += 1;
            e.insert(lemma);
            if tokens >= 10 {
                let types = e.len();
                let ttr = types as f64 / tokens as f64;
                if ttr < 0.72 {
                    factor_lengths.push(tokens);
                    e.clear();
                    end_reached = true;
                    break;
                } // if ttr is less than 0.72
            } // if tokens is >= 10
        } // next i iteration
        if end_reached == false {
            for i in 0..iterations {
                let lemma = in_list[i].as_str();
                tokens += 1;
                e.insert(lemma);
                if tokens >= 10 {
                    let types = e.len();
                    let ttr = types as f64 / tokens as f64;
                    if ttr < 0.72 {
                        factor_lengths.push(tokens);
                        break;
                    }
                }  // if tokens >= 10
            } // next i iteration
            break;
        } // if end_reached == false
    } // next n iteration
    let sum_of_factors: usize = factor_lengths.iter().sum();
    let number_of_factors = factor_lengths.len();
    let mtld_wrap = sum_of_factors as f64 / number_of_factors as f64;

    return Ok(mtld_wrap);
}

/// A Python module implemented in Rust.
#[pymodule]
fn lex_div_operationalizations(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(get_mtld_wrap_jarvis_rs, m)?)?;
    Ok(())
}
