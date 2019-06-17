
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

###################  Variables  ###################

var l >= 0, ; 	 # installed capacity on each arc
var x{A, K} >=0 <=1;		 # equal to 1 if demand k use arc (i,j), 0 otherwise


###################  Model  ###################

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
	
	