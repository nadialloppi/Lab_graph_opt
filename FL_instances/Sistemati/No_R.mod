

################################  Parameters   ################################

param I; # number of clients

param J; # number of facilities of mid level

param K; # number of facilities of high level


param c{j in 1..J}; # mid level facility installation cost

param g{k in 1..K}; # high level facility installation cost


param d{i in 1..I, j in 1..J}; # assignment cost clients->mid level

param l{j in 1..J, k in 1..K}; # assignment cost mid level -> high level


param t{i in 1..I} default 1; # client weight

param a{j in 1..J} default 1; # mid level facility weight


param Gamma;		# mid level facility capacity

param Lambda;		# high level facility capacity

param R default 0; # max assignment cost clients->mid level


################################  Variables   ################################


var x{1..I,1..J} binary; 	#1 if client i assigned to mid level facility j, 0 otherwise
var y{1..J,1..K} binary; 	#1 if mid level facility j is assigned to high level facility k, 0 otherwise
var z{1..J} binary; 		#1 if mid level facility j is open, 0 otherwise
var w{1..K} binary; 		#1 if high level facility k is open, 0 otherwise

################################  Model   ################################

minimize totalcost:
	sum{j in 1..J}c[j]*z[j] + sum{k in 1..K} g[k]*w[k] + sum{j in 1..J} ( sum{ k in 1..K} l[j,k]*y[j,k]) + sum{i in 1..I} ( sum{j in 1..J} d[i,j]*x[i,j]);
	
s.t. client_assignment{i in 1..I}:
	sum{j in 1..J} x[i,j]	>=	1; 
	
s.t. capacity_mid_level{j in 1..J}:
	sum{i in 1..I} t[i]*x[i,j]	<=	Gamma*z[j];
	
s.t. capacity_high_level{k in 1..K}:
	sum{j in 1..J} a[j]*y[j,k]	<=	Lambda*w[k];
	
s.t. mid_level_assignment{j in 1..J}:
	sum{k in 1..K} y[j,k] >= z[j];


