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

# Current total number of cover inequalities
param cm default 0;
param ch default 0;

set C_mid := 1..cm;
set C_high := 1..ch;

# Set of items composing each cover
set CI_mid{C_mid} within {1..I} cross {1..J};
set CI_high{C_high} within {1..J} cross {1..K};


var x{1..I,1..J} >=0, <=1; 	#1 if client i assigned to mid level facility j
var y{1..J,1..K} >=0, <=1; 	#1 if mid level facility j is assigned to high level facility k
var z{1..J}  binary;#>=0, <=1; 		#1 if mid level facility j is open
var w{1..K}  binary;#>=0, <=1; 		#1 if high level facility k is open

minimize totalcost:
	sum{j in 1..J}c[j]*z[j] + sum{k in 1..K} g[k]*w[k] + sum{j in 1..J} ( sum{ k in 1..K} l[j,k]*y[j,k]) + sum{i in 1..I} ( sum{j in 1..J} d[i,j]*x[i,j]);
	
s.t. client_assignment{i in 1..I}:
	sum{j in 1..J: d[i,j] <= R} x[i,j]	>=	1; 
	
s.t. capacity_mid_level{j in 1..J}:
	sum{i in 1..I} t[i]*x[i,j]	<=	Gamma;
	
s.t. capacity_high_level{k in 1..K}:
	sum{j in 1..J} a[j]*y[j,k]	<=	Lambda;
	
s.t. link_x_z{i in 1..I, j in 1..J}:
	x[i,j]<=z[j];
	
s.t. link_y_w{j in 1..J, k in 1..K}:
	y[j,k]<=w[k];
	
s.t. mid_level_assignment{j in 1..J}:
	sum{k in 1..K} y[j,k] >= z[j];
	
s.t. coverineq_mid{cc in C_mid}:
	sum{ (i,j)in CI_mid[cc]} (1-x[i,j])>=1;
	
s.t. coverineq_high{cc in C_high}:
	sum{(j,k) in CI_high[cc]} (1-y[j,k])>=1;
		
	
	
#--------------------------------------------------
#                 Separation problem
#--------------------------------------------------

# The separation problem looks for a cover inequality violated by the current LP solution

# Fractional solution of current LP
param x_star{1..I,1..J} >= 0, <= 1;
param j_bar;
#store the value of the current opt sol

# Binary variable for item in the cover
var u{1..I,1..J} binary;

# Objective function: Find the most violated cover inequality
minimize objfnc_mid:
	sum{i in {1..I}} (1-x_star[i,j_bar])*u[i,j_bar];

# Cover condition constraint
s.t. covercond_mid:
	sum{i in {1..I}} t[i]*u[i,j_bar]>=Gamma+1;
	
# Fractional solution of current LP
param y_star{1..J,1..K};
param k_bar;
#store the value of the current opt sol

# Binary variable for item in the cover
var v{1..J,1..K} binary;

# Objective function: Find the most violated cover inequality
minimize objfnc_high:
	sum{j in {1..J}} (1-y_star[j,k_bar])*v[j,k_bar];

# Cover condition constraint
s.t. covercond_high:
	sum{j in {1..J}} a[j]*v[j,k_bar]>=Lambda+1;