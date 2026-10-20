# Failed audit preparation

No Lean audit ran. The inherited header scanner greedily consumed same-line definition assignment markers, so new private scalar helpers triggered a false public-header mismatch. The scanner was repaired to parse each public name and its actual assignment boundary. Use a5-audit-v4.
