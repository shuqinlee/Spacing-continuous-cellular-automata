function available = after_dist_available(pre, post)
    safe = safe_distance(pre(1), post(1), pre(3));
    available = (safe < pre(2) - post(2));
end