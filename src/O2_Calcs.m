% Load data
oxy = readtable("oxy_data.csv");

% Calc O2 solubility
oxy.O2sol = gsw_O2sol(oxy.V1, oxy.V2, oxy.V3, oxy.V4, oxy.V5);

writetable(oxy, "oxy_data.csv");