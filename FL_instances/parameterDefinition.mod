param I; # number of clients

param J; # number of facilities of mid level

param K; # number of facilities of high level


param c{j in 1..J}; # mid level facility installation cost

param g{k in 1..K}; # high level facility installation cost


param d{i in 1..I, j in 1..J}; # assignment cost clients->mid level

param l{j in 1..J, k in 1..K}; # assignment cost mid level -> high level


param t{i in 1..I} default 1; # client weight

param a{j in 1..J} default 1; # mid level facility weight


param Gamma;# facility capacity

param Lambda;

param R default 0;

