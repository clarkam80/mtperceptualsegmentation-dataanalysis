function  F = erf_p_fit_fun(x, xdata)
F = 0.5 + 0.5 * erf((xdata - x(1)) / (sqrt(2) * x(2)));