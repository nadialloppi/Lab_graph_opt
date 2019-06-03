
param nb_n; 			# Number of nodes
set N := 1..nb_n;
set A within N cross N;

param lambda default 1;

param c {A};              # Arc cost


# Number and set of demands 
param nb_d; 
set K := 1..nb_d;

param o {K} within N; 	# Source
param t {K} within N; 	# Destination
param d {K}; 			# Flow demand

param h default 10;

var l >= 0, integer;
var x{A, K} binary;

minimize capacity:
	l;
	
s.t. flowBalance { k in  K, i in N}:
	sum {(i, j) in A} x[i, j, k] - sum {(j, i) in A} x[j, i, k] = (if i =o[k]
															then 1
															else if i = t[k]
																then -1
																else 0);
																
s.t. maxArcs {k in K}:
	sum {(i, j) in A} x[i, j, k] <= h;
	
s.t. varConsistency {(i, j) in A}:
	sum {k in K} x[i, j, k] * d[k] <= l;
	
	
# Greedy ##-------------------------------------------------------	

var u{A, K} binary; # o rilassato?? 
param k_bar;

minimize Cost:
	sum{(i, j) in A} c[i, j] * u[i, j, k_bar];
	
s.t. flowBalance_SP { i in N}:
	sum {(i, j) in A} u[i, j, k_bar] - sum {(j, i) in A} u[j, i, k_bar] = (if i =o[k_bar]
															then 1
															else if i = t[k_bar]
																then -1
																else 0);
																
s.t. maxArcs_SP:
	sum {(i, j) in A} u[i, j, k_bar] <= h;																

# Relaxation ##--------------------------------------------------

# Continuous#
var l_c >= 0;
var x_c{A, K} >= 0, <= 1;

minimize capacity_c:
	l_c;
	
s.t. flowBalance_c { k in  K, i in N}:
	sum {(i, j) in A} x_c[i, j, k] - sum {(j, i) in A} x_c[j, i, k] = (if i =o[k]
															then 1
															else if i = t[k]
																then -1
																else 0);
																
s.t. maxArcs_c {k in K}:
	sum {(i, j) in A} x_c[i, j, k] <= h;
	
s.t. varConsistency_c {(i, j) in A}:
	sum {k in K} x_c[i, j, k] * d[k] <= l_c;
	
	
# Lagrangian #

param mu{K} default 0;
param mu_old{K} default 1;

param step default 1; # step size

minimize Obj_LR:
	l - sum {k in K} (mu[k]*(h-sum{(i, j) in A} x[i, j, k]));
	

 




