
###################  Parameters  ###################

# Number and set of nodes
param nb_n; 			
set N := 1..nb_n;
set A within N cross N;

param c {A};              # Arc cost


# Number and set of demands 
param nb_d; 
set K := 1..nb_d;

param o {K} within N; 	# Source
param t {K} within N; 	# Destination
param d {K}; 			# Flow demand

param h default 10;
param lambda default 1;
param k_bar; #demands we are considering

###################  Variables  ###################
var u{A, K} binary; 


###################  Model  ###################

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
