use pyo3::prelude::*;
use std::collections::HashMap;

// Python gives Rust a string and Rust gives Python a HashMap that PyO3 converts into a Python dictionary
#[pyfunction]
fn insert_into_dictionary_rs(in_str: &str) -> HashMap<&str, usize> {
    let mut out_dict = HashMap::new();
    for wd in in_str.split(" ") {
        *out_dict.entry(wd).or_insert(0) += 1;
    }
    return out_dict;
}

/// A Python module implemented in Rust.
#[pymodule]
fn rs_helps_py_hashmap(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(insert_into_dictionary_rs, m)?)?;
    Ok(())
}
