# Cardinalita' non riaggiornata e min cost

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

data p1.dat;

	
set II default 1..I;		# elementi non ancora asseganti/aperti..
set KK default 1..K;	

set OJ default {} ;

set IJ within {1..I,1..J} default {};  # Assegnamenti di primo livello fatti


param min_cost_i default 0;
param min_cost_j default 0;
param min_cost default 0;

param open_c {1..J};
param cap_res{1..J};
for {j in 1..J} {let cap_res[j]:= Gamma; let open_c[j] := c[j];}


param cardinality_i {1..I} default 0;
param min_card_i default 0;

param infeas_flag default 0; 		# Mi dice se esco perche' infeasible

printf "Inizio primo livello\n";
for {i in 1..I}
	let cardinality_i [i] := card(setof{j in 1..J: d[i,  j] <= R}j);

repeat{
	let min_card_i := min{i in II} cardinality_i[i];
	for {i in II}{
		if (cardinality_i[i] = min_card_i) then {
			if (min{ii in II}card(setof{j in 1..J: cap_res[j] >= t[ii] and d[ii, j] <= R}j)=0 ) then let infeas_flag := 1; else {
			let min_cost := min{j in 1..J: cap_res[j] >= t[i] and d[i, j] <= R} (open_c[j]+d[i,j]);
			for {j in 1..J :  cap_res[j] >= t[i] and d[i, j] <= R}{
				if (open_c[j]+d[i,j] = min_cost and i in II) then {
					let IJ:= IJ union {(i, j)} ;
					let II:= II diff {i};
					let cap_res[j] := cap_res[j] - t[i];
					let open_c[j] := 0; 		# metto a zero il costo di apertura per il futuro
				}
			}
		}
	}
	}
	
} until (sum{ii in II} (1) = 0 or infeas_flag=1);


if (infeas_flag = 1) then {printf"***********************Il greedy non riesce a trovare una soluzione feasible\nNon ho assegnato:"; display II;}

let OJ := setof{j in 1..J: cap_res[j] < Gamma}j;

param mid_Cost_pre default 0;
let mid_Cost_pre := sum{j in OJ}c[j] + sum{(i, j) in IJ} d[i,j];
display mid_Cost_pre;
display sum{j in OJ}c[j];
display sum{(i, j) in IJ} d[i,j];

display OJ;

param actual_cost{1..I} default 0;
param actual_midlevel{1..I};

for {(i, j) in IJ} {
	let actual_cost[i] := d[i, j];
	let actual_midlevel[i] := j;
}

for {i in 1..I}{
	for {j in OJ}{
		if (d[i, j] < actual_cost[i] and cap_res[j] >= t[i]) then {
			let IJ := IJ diff {(i, actual_midlevel[i])};
			let IJ := IJ union {(i, j)};
			let cap_res[j] := cap_res[j] - t[i];
			let cap_res[actual_midlevel[i]] := cap_res[actual_midlevel[i]] + t[i];
			if (cap_res[actual_midlevel[i]] = Gamma) then let OJ:= OJ diff {actual_midlevel[i]};
			let actual_cost[i] := d[i, j];
			let actual_midlevel[i] := j;
		}
	}
}

param mid_Cost_post default 0;
let mid_Cost_post := sum{j in OJ}c[j] + sum{(i, j) in IJ} d[i,j];
display mid_Cost_post;
display sum{j in OJ}c[j];
display sum{(i, j) in IJ} d[i,j];

display OJ;


printf "Inizio secondo livello\n";
param min_cost_k default 0;

set OJJ default OJ; 		# mid level aperte, ma non ancora asseganti

set JK within {1..J, 1..K} default {};	# assegnamenti 2ndo livello 

param cap_res_k default Lambda;

repeat{
let min_cost_k := min {k in KK} (g[k] + sum{j in OJ} l[j, k]);
#let cap_res_k:= Lambda;
for {k in KK}{
	let cap_res_k:= Lambda;
	if (min_cost_k = g[k] + sum{j in OJ} l[j, k]) then {
		let KK := KK diff {k};
		
		repeat {
			let min_cost_j := 	min {j in OJJ: cap_res_k >= a[j]} l[ j, k];
			
			for {j in OJJ: cap_res_k >= a[j]} {
				if (min_cost_j = l[j,k] ) then {
						let cap_res_k := cap_res_k - a[j];
						let JK := JK union {( j, k)};
						let OJJ := OJJ diff {j};
						break;
				} 
			}
		} until ( min{jj in OJJ} a[jj] >= cap_res_k);  
	}
}
} until (sum{jjj in OJJ} (1) = 0);

param UB default 0;

let UB := sum{j in OJ}c[j] + sum{k in {1..K diff KK}} g[k] + sum{(j, k) in JK} l[j,k] + sum{(i, j) in IJ} d[i,j];

display UB;


