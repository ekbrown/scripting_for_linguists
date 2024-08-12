fn get_mattr(in_vector: &[&str], window_span: usize) -> f64 {
    let n_wds = in_vector.len();
    let output: f64;
    if n_wds <= 50 {
        output = get_ttr(in_vector);
    } else {
        let mut numerator = 0.0;
        let n_window = n_wds - window_span + 1;
        for cur_window in in_vector.windows(window_span) {
            numerator += get_ttr(cur_window)
        }
        output = numerator / n_window as f64;
    }
    output
}
