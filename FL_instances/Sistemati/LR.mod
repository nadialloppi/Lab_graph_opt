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




param mu{1..J} default 0;
param mu_old{1..J} default 1;
param nu{1..K} default 0;
param nu_old{1..K} default 1;

param step default 1; # step size

################################  Variables   ################################


var x{1..I,1..J} binary; 	#1 if client i assigned to mid level facility j, 0 otherwise
var y{1..J,1..K} binary; 	#1 if mid level facility j is assigned to high level facility k, 0 otherwise
var z{1..J} binary; 		#1 if mid level facility j is open, 0 otherwise
var w{1..K} binary; 		#1 if high level facility k is open, 0 otherwise

minimize lagrangian_relaxation:
	sum{j in 1..J, k in 1..K} (l[j,k]+nu[k]*a[j])*y[j,k] + sum{j in 1..J} (c[j]-mu[j]*Gamma)*z[j];

s.t. mid_level_assignment{j in 1..J}:
	sum{k in 1..K} y[j,k] >= z[j];




