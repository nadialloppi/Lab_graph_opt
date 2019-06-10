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

param R default 0;

var x{1..I,1..J} binary; 	#1 if client i assigned to mid level facility j
var y{1..J,1..K} binary; 	#1 if mid level facility j is assigned to high level facility k
var z{1..J} binary; 		#1 if mid level facility j is open
var w{1..K} binary; 		#1 if high level facility k is open

minimize totalcost:
	sum{j in 1..J}c[j]*z[j] + sum{k in 1..K} g[k]*w[k] + sum{j in 1..J} ( sum{ k in 1..K} l[j,k]*y[j,k]) + sum{i in 1..I} ( sum{j in 1..J} d[i,j]*x[i,j]);
	
s.t. client_assignment{i in 1..I}:
	sum{j in 1..J: d[i,j] <= R} x[i,j]	>=	1; 
												# Attenzione al >= 1 che quando rilasso l'integralita' devo mettere anche <= 1
	
s.t. capacity_mid_level{j in 1..J}:
	sum{i in 1..I} t[i]*x[i,j]	<=	Gamma*z[j];
	
s.t. capacity_high_level{k in 1..K}:
	sum{j in 1..J} a[j]*y[j,k]	<=	Lambda*w[k];
	
s.t. mid_level_assignment{j in 1..J}:
	sum{k in 1..K} y[j,k] >= z[j];
	
# CR -------------------------------------------------------------------------------------------

var x_c{1..I,1..J} >= 0, <=1; 	#1 if client i assigned to mid level facility j
var y_c{1..J,1..K} >= 0, <=1; 	#1 if mid level facility j is assigned to high level facility k
var z_c{1..J} >=0, <=1; 		#1 if mid level facility j is open
var w_c{1..K} >=0, <=1; 		#1 if high level facility k is open

minimize totalcost_c:
	sum{j in 1..J}c[j]*z_c[j] + sum{k in 1..K} g[k]*w_c[k] + sum{j in 1..J} ( sum{ k in 1..K} l[j,k]*y_c[j,k]) + sum{i in 1..I} ( sum{j in 1..J} d[i,j]*x_c[i,j]);
	
s.t. client_assignment_c{i in 1..I}:
	sum{j in 1..J: d[i,j] <= R} x_c[i,j]	>=	1; 
												# Attenzione al >= 1 che quando rilasso l'integralita' devo mettere anche <= 1
	
s.t. capacity_mid_level_c{j in 1..J}:
	sum{i in 1..I} t[i]*x_c[i,j]	<=	Gamma*z_c[j];
	
s.t. capacity_high_level_c{k in 1..K}:
	sum{j in 1..J} a[j]*y_c[j,k]	<=	Lambda*w_c[k];
	
s.t. mid_level_assignment_c{j in 1..J}:
	sum{k in 1..K} y_c[j,k] >= z_c[j];
	
# LR --------------------------------------------------------------------------------------------
param mu{1..I} default 0;
param mu_old{1..I} default 1;

param step default 1; # step size
minimize Obj_LR:
	sum{j in 1..J}c[j]*z[j] + sum{k in 1..K} g[k]*w[k] + sum{j in 1..J} ( sum{ k in 1..K} l[j,k]*y[j,k]) + sum{i in 1..I} ( sum{j in 1..J} d[i,j]*x[i,j]) 
	+ sum{i in 1..I} mu[i]*(sum{j in 1..J} d[i,j]*x[i,j]-R);
	
s.t. LR_assign{i in 1..I}:
	sum{j in 1..J} x[i,j]	>=	1; 	
	