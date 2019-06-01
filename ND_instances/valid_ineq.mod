
param nb_n; 			# Number of nodes
set N := 1..nb_n;
set A within N cross N;

param lambda default 1;

param S default 0;
param nb_d; 
set K := 1..nb_d;

param a{N, 1..S} default 0; # each col 1 for i in S
param b{K, 1..S} default 0; # each col 1 for k with source in S and destination not or viceversa
param c{A, 1..S} default 0; # 1 if arc ij has an extreme in S and the other not
# Number and set of demands 


param o {K} within N; 	# Source
param t {K} within N; 	# Destination
param d {K}; 			# Flow demand

param h default 10;

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
	
s.t. valid_ineq_c{s in 1..S}:
	l_c>= ceil( sum{k in K} d[k]*b[k,s]/ sum{(i,j) in A} c[i,j,s]);
	
# Valid Inequality

param l_bar;

var mu{A} binary;	# 1 if the arc has one extreme in S and the othe in N\S
var u{K} binary;	# 1 if commodities k have source(destination) in S and destination (source) in N\S
var s{N} binary;	# 1 if node in S
var eps >=0;
var z integer;


minimize obj:
	sum{(i,j) in A} mu[i,j] - z; 
	
s.t. consistency_1{(i,j) in A}:
	mu[i,j]>=s[i]-s[j];
	
s.t. consistency_2{(i,j) in A}:
	mu[i,j]>=s[j]-s[i];

s.t. consistency_3{(i,j) in A}:
	mu[i,j]<=s[i]+s[j];
	
s.t. consistency_4{(i,j) in A}:
	mu[i,j]<=2-s[i]-s[j];

s.t. consistency_5{k in K}:
	u[k]>=s[o[k]]-s[t[k]];
	
s.t. consistency_6{k in K}:
	u[k]>=s[t[k]]-s[o[k]];

s.t. consistency_7{k in K}:
	u[k]<=s[o[k]]+s[t[k]];

s.t. consistency_8{k in K}:
	u[k]<= 2-s[o[k]]-s[t[k]];

#s.t. S_notEmpty:
#	sum{i in N} s[i]>=1;
#s.t. S_notN:
#	sum{i in N} s[i]<=nb_n-1;
s.t. consistency_9:
	z <=(sum{k in K} d[k]*u[k] )/ l_bar + 1 -eps;