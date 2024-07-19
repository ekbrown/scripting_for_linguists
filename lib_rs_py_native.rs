use pyo3::prelude::*;
use pyo3::types::{PyList, PyDict};

#[pyfunction]
fn get_freqs_py_native_types(in_list: &Bound<'_, PyList>, in_dict: &Bound<'_, PyDict>) -> PyResult<()> {
    for wd in in_list {
        let cur_wd: Option<Bound<PyAny>> = in_dict.get_item(&wd)?;
        let cur_value_int = if let Some(cur_value) = cur_wd {
            cur_value.extract::<usize>()?
        } else {
            0
        };
        let new_value = cur_value_int + 1;
        in_dict.set_item(wd, new_value)?;
    }
    Ok(())
}

/// A Python module implemented in Rust.
#[pymodule]
fn rs_helps_py_hashmap(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(get_freqs_py_native_types, m)?)?;
    Ok(())
}
