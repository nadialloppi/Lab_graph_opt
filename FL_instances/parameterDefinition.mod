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

var x{I,J} binary; #1 if client i assigned to mid level facility j
var y{J,K} binary; #1 if mid level facility j is assigned to high level facility k
var z{J} binary; #1 if mid level facility j is open
var w{K} binary; #1 if high level facility k is open

minimize totalcost:
	sum{j in J}c[j]*z[j] + sum{k in K} g[k]*w[k] + sum{j in J} ( sum{ k in K} l[j,k]*y[j,k]) + sum{i in I} ( sum{j in J} d[i,j]*x[i,j]);
	
s.t. client_assignment{i in I}:
	sum{j in J: d[i,j] <= R} x[i,j]>=1;
	
s.t. capacity_mid_level{j in J}:
	sum{i in I} t[i]*x[i,j]<=Gamma*z[j];
	
s.t. capacity_high_level{k in K}:
	sum{j in J} a[j]*y[j,k]<=Lambda*w[k];
	
s.t. mid_level_assignment{j in J}:
	sum{k in K} y[j,k] >= z[j];