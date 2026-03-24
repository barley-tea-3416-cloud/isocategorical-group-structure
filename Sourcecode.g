# Load the SONATA package.
LoadPackage("sonata");


# Returns a list containing the orders of all elements in the given group x.
Orders := function(x)
  local p;
  p := List(Elements(x), i -> Order(i));
  return p;
end;


# Iterates through all groups of a given order n to compute their element orders.
# Returns a list of pairs: [Element Orders List, Group Structure Description].
OrderLists := function(n)
  local all, s;
  all := AllSmallGroups(n);
  s := List(all, i -> [Orders(i), StructureDescription(i)]);
  return s;
end;


# Counts the occurrences of a specific value n within a given list.
# This utility helps in analyzing the frequency of element orders in a group.
Count := function(n, list)
  local number, j;
  number := 0;
  for j in list do
    if j = n then
      number := number + 1;
    fi;
  od;
  return number;
end;


# Computes the frequency profile of element orders for a given group G.
# Specifically, it counts elements of orders 2^0, 2^1, ..., 2^6 and 
# returns them as a list [1, count(2), count(4), ..., count(64)].
OrderListGroup := function(G)
  local list, i, wantlist;
  list := Orders(G);
  wantlist := [1];
  for i in [2..7] do
    wantlist[i] := Count(2^(i-1), list);
  od;
  return wantlist;
end;


# Processes group data from OrderLists and displays the frequency of element orders.
# Each line outputs [StructureDescription, [Count(1), Count(2), ..., Count(n)]]
# where only divisors of n are recorded in the count list for clarity.
WantListView := function(n)
  local glists, pop, want, gg, k, yy, space;
  want := [];
  glists := OrderLists(n);

  for gg in glists do
    space := [];
    pop := [gg[2], space];
    for k in [1..n] do
      if Count(k, gg[1]) > 0 then
        Add(space, Count(k, gg[1]));
      elif Lcm(k, n) = n then
        Append(space, [0]);
      fi;
    od;
    Add(want, pop);
  od;

  for yy in want do
    Print(yy, "\n");
  od;
end;


# Similar to WantListView, this function computes the distribution of 
# element orders for all groups of order n, but returns the results 
# as a list for further computational processing instead of printing.
WantList := function(n)
  local glists, pop, want, gg, k, yy, space;
  want := [];
  glists := OrderLists(n);

  for gg in glists do
    space := [];
    pop := [gg[2], space];
    for k in [1..n] do
      if Count(k, gg[1]) > 0 then
        Add(space, Count(k, gg[1]));
      elif Lcm(k, n) = n then
        Append(space, [0]);
      fi;
    od;
    Add(want, pop);
  od;

  return want;
end;


# Retrieves the set of all unique element order lists that appear among 
# groups of a given order n. This identifies all possible "isocategorical 
# profiles" for the specified order.
OrderUnion := function(n)
  local wlist, ss, tut, final;
  wlist := WantList(n);
  tut := [];

  for ss in wlist do
    Add(tut, ss[2]);
  od;

  final := Set(tut);
  return final;
end;


# Aggregates all groups of order n that share a specific element order list (olist).
# Returns a list starting with the target olist, followed by the 
# StructureDescriptions of all matching groups in the Small Groups library.
SmallCategory := function(n, olist)
  local wlist, s, k, pp, qq;

  wlist := WantList(n);
  s := Number(wlist);
  qq := [olist];

  for k in [1..s] do
    pp := wlist[k];
    # Checks if the provided olist matches the element order profile of the group.
    if olist in pp then
      Add(qq, pp[1]);
    fi;
  od;

  return qq;
end;


# Executes SmallCategory for every unique element order list of order n.
# This function prints a comprehensive list of all groups of order n,
# categorized into subsets based on their isocategorical profiles.
CategoryView := function(n)
  local unionlist, olist, smallc, LastFinal, yy;
  LastFinal := [];
  unionlist := OrderUnion(n);

  for olist in unionlist do
    # Retrieves all groups that match the current order list (olist).
    smallc := SmallCategory(n, olist);
    Add(LastFinal, smallc);
  od;

  # Displays each category on a new line for easier review.
  for yy in LastFinal do
    Print(yy, "\n");
  od;
end;


# Executes SmallCategory for every unique element order list of order n.
# Returns a nested list where each entry contains an order list followed 
# by the StructureDescriptions of all groups sharing that profile.
Category := function(n)
  local unionlist, olist, smallc, LastFinal, yy;
  LastFinal := [];
  unionlist := OrderUnion(n);

  for olist in unionlist do
    # For each unique order profile, aggregate all matching groups.
    smallc := SmallCategory(n, olist);
    Add(LastFinal, smallc);
  od;

  return LastFinal;
end;


# Returns a list containing the orders of all elements in the given group x.
# This serves as the fundamental calculation for identifying isocategorical groups.
Orders := function(x)
  local p;
  p := List(Elements(x), i -> Order(i));
  return p;
end;


# Iterates through all groups of order n and computes their element orders.
# Returns a list of pairs: [Element Orders List, Group Object].
# Unlike OrderLists, this returns the group object itself for further calculation.
OrderListsCal := function(n)
  local all, s;
  all := AllSmallGroups(n);
  s := List(all, i -> [Orders(i), i]);
  return s;
end;


# Counts the number of times a specific integer n appears in a given list.
# This helper function is used to build the frequency profile of element orders.
Count := function(n, list)
  local number, j;
  number := 0;
  for j in list do
    if j = n then
      number := number + 1;
    fi;
  od;
  return number;
end;


# Unlike WantList, this function returns the actual Group Objects instead of 
# structure strings, making it suitable for direct algebraic computations.
WantListCal := function(n)
  local glists, pop, want, gg, k, yy, space;
  want := [];
  glists := OrderListsCal(n);

  for gg in glists do
    space := [];
    # Pairs the group object (gg[2]) with its frequency list of element orders.
    pop := [gg[2], space];
    for k in [1..n] do
      if Count(k, gg[1]) > 0 then
        Add(space, Count(k, gg[1]));
      elif Lcm(k, n) = n then
        Append(space, [0]);
      fi;
    od;
    Add(want, pop);
  od;

  return want;
end;


# Computes the set of all unique element order lists for groups of order n.
# This identifies every distinct "order profile" possible for the given order,
# using the group objects processed by WantListCal.
OrderUnionCal := function(n)
  local wlist, ss, tut, final;
  wlist := WantListCal(n);
  tut := [];

  for ss in wlist do
    Add(tut, ss[2]);
  od;

  final := Set(tut);
  return final;
end;


# Arguments: n (order), olist (target order list)
# Purpose: Collects group identifiers (pp[1]) that share the same olist
SmallCategoryCal := function(n, olist)
    local wlist, s, k, pp, qq;

    # Fetch group data for order n and initialize results with olist
    wlist := WantListCal(n);
    s := Number(wlist);
    qq := [olist];

    # Iterate through each group entry pp in wlist
    for k in [1..s] do
        pp := wlist[k];
        
        # If olist is found in the entry pp, add the group's name/ID (pp[1])
        if olist in pp then
            Add(qq, pp[1]);
        fi;
    od;

    return qq;
end;


# Create a free group with 64 generators
Free64 := FreeGroup(64);

# Extract the list of generators for the free group
f := GeneratorsOfGroup(Free64);



#izumikosakiの群Gの構成
F4 := FreeGroup("x","y","s","t");
AssignGeneratorVariables(F4);
G:= F4/
[
x^4,
y^4,
x*y*x^-1*y^-1,
s^2,
t^2,
s*t*s^-1*t^-1,
s*x*s^-1*x^-1,
s*y*s^-1*y^-1*x^-2,
t*x*t^-1*y^-2*x^-1,
t*y*t^-1*y^-1
];


#izumikosakiの群が属する位数グループの群たち
izumigroups:=SmallCategoryCal(64,[1,19,44,0,0,0,0]);
izumigroups:=izumigroups{[2..10]};
Gizumikosaki:=izumigroups[5];



#sub2はGの部分群のうち位数平方数、正規、可換な部分群のリスト
sub1:=[];
for i in Subgroups(G) do
if Order(i)=4 or Order(i)=16 then
Add(sub1,i);
fi;
od;
sub2:=[];
for i in sub1 do
if IsAbelian(i) and IsNormal(G,i) then
Add(sub2,i);
fi;
od;

#C4xC4
C4xC4:=AbelianGroup(IsFpGroup,[4,4]);


#C2xC2
C2xC2:=AbelianGroup(IsFpGroup,[2,2]);

#C2xC2xC2xC2
C2xC2xC2xC2:=FreeGroup("c","d","e","g");
AssignGeneratorVariables(C2xC2xC2xC2);
C2xC2xC2xC2:=C2xC2xC2xC2/
[
c^2,
d^2,
e^2,
g^2,
c*d*c^-1*d^-1,
c*e*c^-1*e^-1,
c*g*c^-1*g^-1,
d*e*d^-1*e^-1,
d*g*d^-1*g^-1,
e*g*e^-1*g^-1,
];



#C4xC4の2-cocycle（4つ）を構成する
#groupp,groupqで生成元としてのp,qを表している
#non-degなのはCocycle_C4xC4_1、Cocycle_C4xC4_3
groupp:=GeneratorsOfGroup(C4xC4)[1];
groupq:=GeneratorsOfGroup(C4xC4)[2];
Cycle4x4:=function(g)
local j,k;
for j in [0..3] do
for k in [0..3] do
if g=groupp^j*groupq^k then
return[j,k];
fi;
od;
od;
end;

Cocycle_C4xC4_0:=function(g,h)
local want,list1,list2;
list1:=Cycle4x4(g);
list2:=Cycle4x4(h);
want:= E(4)^(list1[1]*list2[2]*0);
return want;
end;

Cocycle_C4xC4_1:=function(g,h)
local want,list1,list2;
list1:=Cycle4x4(g);
list2:=Cycle4x4(h);
want:= E(4)^(list1[1]*list2[2]);
return want;
end;

Cocycle_C4xC4_2:=function(g,h)
local want,list1,list2;
list1:=Cycle4x4(g);
list2:=Cycle4x4(h);
want:= E(4)^(list1[1]*list2[2]*2);
return want;
end;

Cocycle_C4xC4_3:=function(g,h)
local want,list1,list2;
list1:=Cycle4x4(g);
list2:=Cycle4x4(h);
want:= E(4)^(list1[1]*list2[2]*3);
return want;
end;



#C2xC2の2-cocycle（2つ）を構成する
#groupa,groupbで生成元としてのa,bを表している
#non-degなのはCocycle_C2xC2_1
groupa:=GeneratorsOfGroup(C2xC2)[1];
groupb:=GeneratorsOfGroup(C2xC2)[2];
Cycle2x2:=function(g)
local j,k;
for j in [0,1] do
for k in [0,1] do
if g=groupa^j*groupb^k then
return[j,k];
fi;
od;
od;
end;

Cocycle_C2xC2_0:=function(g,h)
local want,list1,list2;
list1:=Cycle2x2(g);
list2:=Cycle2x2(h);
want:= E(2)^(list1[1]*list2[2]*0);
return want;
end;

Cocycle_C2xC2_1:=function(g,h)
local want,list1,list2;
list1:=Cycle2x2(g);
list2:=Cycle2x2(h);
want:= E(2)^(list1[1]*list2[2]*1);
return want;
end;



#C2xC2xC2xC2のnon-degな2-cocycle(28個)を構成する。
Binary64:=function(n)
local list,k;
list:=[0,0,0,0,0,0];
for k in [1..6] do
list[7-k]:= n mod 2;
n:=(n- n mod 2)/2;
od;
return list;
end;		#Binary64は63までの二進数展開をリストとして返す。

List01x6:=[];
for k in [0..63] do
Add(List01x6,Binary64(k));
od;		#List01x6は6つの0,1の数字組み合わせのリスト。

MatrixesC2xC2xC2xC2:=[];
for list in List01x6 do
matrix:=
[
[0,list[1],list[2],list[3]],
[list[1],0,list[4],list[5]],
[list[2],list[4],0,list[6]],
[list[3],list[5],list[6],0]
];
if RankMatrix(matrix)=4 then
Add(MatrixesC2xC2xC2xC2,matrix);
fi;
od;		#MatrixesC2xC2xC2xC2はnon-degな2-cocycleの元になる行列の集まり

ChangeMatrix:=function(matrix)
local i,j,wantmat;
wantmat:=[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]];
for i in [1..4] do
for j in [1..4] do
if matrix[i][j] = 0 then
wantmat[i][j]:=1;
elif matrix[i][j] = 1 then
wantmat[i][j]:=-1;
fi;
od;
od;
return wantmat;
end;		#ChangeMatrixは加法による行列表示を積による行列表示に戻す


groupc:=GeneratorsOfGroup(C2xC2xC2xC2)[1];
groupd:=GeneratorsOfGroup(C2xC2xC2xC2)[2];
groupe:=GeneratorsOfGroup(C2xC2xC2xC2)[3];
groupf:=GeneratorsOfGroup(C2xC2xC2xC2)[4];







#ObtainedSubgroupsは条件を満たす部分群のリストを返す
ObtainedSubgroups := function(G)
local sub1,sub2,j,k;
sub1:=[];
sub2:=[];
for j in Subgroups(G) do
if IsNormal(G,j) then
Add(sub1,j);
fi;
od;
for k in sub1 do
if
IsIsomorphicGroup(k,C2xC2) or
IsIsomorphicGroup(k,C4xC4) or
IsIsomorphicGroup(k,C2xC2xC2xC2) then
Add(sub2,k);
fi;
od;
return sub2;
end;



#C2xC2に同型な部分群Nに対し、(1,0)と(0,1)に対応する元を抜き出す
C2xC2GeneratorsOfSubgroup := function(N)
local iso,gen1,gen2;
iso:= IsomorphismGroups(C2xC2,N);
gen1:= Image(iso,groupa);
gen2:= Image(iso,groupb);
return [gen1,gen2];
end;


#C2xC2に同型な部分群Nの埋め込みによる2-cocycleがg不変か調べる
#GAP中でaとbの区別がつかない問題が発生中。これによりginvの値がまちまちになる。
#これを回避するため、Gizumikosakiの結果を利用して一意に定める。
#その必要はないことが分かった

N2:=ObtainedSubgroups(Gizumikosaki)[1];
homhom:=IsomorphismGroups(G,Gizumikosaki);
elementx:=Image(homhom,GeneratorsOfGroup(G)[1]);
Ax:=[[1,0],[1,1]];


Checkginv_C2xC2 := function(g,N)
local i,j,m,n,list1,list2,gen1,gen2;
gen1:= C2xC2GeneratorsOfSubgroup(N)[1];
gen2:= C2xC2GeneratorsOfSubgroup(N)[2];

for i in [0,1] do
for j in [0,1] do
if
g*gen1*g^-1 = gen1^i * gen2^j  then
list1:=[i,j];
fi;
od;
od;

for m in [0,1] do
for n in [0,1] do
if
g*gen2*g^-1 = gen1^m * gen2^n  then
list2:=[m,n];
fi;
od;
od;
return [list1,list2];
end;




#C2xC2に同型な部分群Nの埋め込みによる2-cocycleがG不変か調べる
CheckGinv_C2xC2 := function(G,N)
local want,list,g,check;
list := GeneratorsOfGroup(G);
want:=[];

for g in list do
Add(want,Checkginv_C2xC2(g,N));
od;

check:=List(want,Determinant);
check:=List(check,i-> i mod 2);
check:=Set(check);

if check=[1] then
Print(N," is G invariant.");

else
Print(N," is not G invariant.");
fi;
end;



#C2xC2に同型な部分群Nの埋め込みによる2-cocycleがG不変か調べる
CheckGinv_C2xC2Cal := function(G,N)
local want,list,g,check;
list := GeneratorsOfGroup(G);
want:=[];

for g in list do
Add(want,Checkginv_C2xC2(g,N));
od;

check:=List(want,Determinant);
check:=List(check,i-> i mod 2);
check:=Set(check);

if
check=[1] then
return 1;

else
return 0;
fi;
end;





#\eta(g,h)を定める。部分群Nでの\eta(g,h)の値はこれ。
Eta_C2xC2 := function(N,g,h)
local gen1,gen2,mat1,mat2,mat3,k,l,m,n,a,b,c,d,p,q,r,s,check1,check2,want1,want2;

gen1:= C2xC2GeneratorsOfSubgroup(N)[1];
gen2:= C2xC2GeneratorsOfSubgroup(N)[2];

mat1:=Checkginv_C2xC2(g,N);
mat2:=Checkginv_C2xC2(h,N);
mat3:=Checkginv_C2xC2(g*h,N);

k:=mat1[1][1];
l:=mat1[1][2];
m:=mat1[2][1];
n:=mat1[2][2];
a:=mat2[1][1];
b:=mat2[1][2];
c:=mat2[2][1];
d:=mat2[2][2];
p:=mat3[1][1];
q:=mat3[1][2];
r:=mat3[2][1];
s:=mat3[2][2];

check1:= -k*m -a*c*k^2 -b*d*m^2 -2*b*c*k*m +p*r;
check2:= -l*n -a*c*l^2 -b*d*n^2 -2*b*c*l*n +q*s;

want1:= check1 /2;
want2:= check2 /2;

want1:=want1 mod 2;
want2:=want2 mod 2;

return gen1^want1 * gen2^want2;
end;



#C4xC4に同型な部分群Nに対し、(1,0)と(0,1)に対応する元を抜き出す
C4xC4GeneratorsOfSubgroup := function(N)
local iso,gen1,gen2;
iso:= IsomorphismGroups(C4xC4,N);
gen1:= Image(iso,groupp);
gen2:= Image(iso,groupq);
return [gen1,gen2];
end;


#GAP中でpとqの区別がつかない問題が発生中。これによりginvの値がまちまちになる。
#これを回避するため、Gizumikosakiの結果を利用して一意に定める。
#この試みは失敗している

N1:=ObtainedSubgroups(Gizumikosaki)[7];
homhom:=IsomorphismGroups(G,Gizumikosaki);
elements:=Image(homhom,GeneratorsOfGroup(G)[3]);
As:=[[1,0],[2,1]];

Checkginv_C4xC4 := function(g,N)
local i,j,m,n,list1,list2,gen1,gen2;
gen1:= C4xC4GeneratorsOfSubgroup(N)[1];
gen2:= C4xC4GeneratorsOfSubgroup(N)[2];

for i in [0..3] do
for j in [0..3] do
if
g * gen1 * g^-1 = gen1^i * gen2^j  then
list1:=[i,j];
fi;
od;
od;

for m in [0..3] do
for n in [0..3] do
if
g * gen2 * g^-1 = gen1^m * gen2^n  then
list2:=[m,n];
fi;
od;
od;
return [list1,list2];
end;



#C4xC4に同型な部分群Nの埋め込みによる2-cocycleがG不変か調べる(OK)
CheckGinv_C4xC4 := function(G,N)
local want,list,g,check,k,i;
list := GeneratorsOfGroup(G);
want:=[];

for g in list do
Add(want,Checkginv_C4xC4(g,N));   #Candidate1,2でGinv性の結果は一致する
od;

check:=List(want,Determinant);
check:=List(check, i-> i mod 4);
check:=Set(check);

if check = [1] then
Print(N," is G invariant.");

else
Print(N," is not G invariant.");
fi;
end;


#C4xC4に同型な部分群Nの埋め込みによる2-cocycleがG不変か調べる(計算用)
CheckGinv_C4xC4Cal := function(G,N)
local want,list,g,check,k,i;
list := GeneratorsOfGroup(G);
want:=[];

for g in list do
Add(want,Checkginv_C4xC4(g,N));
od;

check:=List(want,Determinant);
check:=List(check, i-> i mod 4);
check:=Set(check);

if check = [1] then
return 1;

else
return 0;;
fi;
end;


#\eta(g,h)を定める。部分群Nでの\eta(g,h)の値はこれ。
Eta_C4xC4 := function(N,g,h)
local gen1,gen2,mat1,mat2,mat3,k,l,m,n,a,b,c,d,p,q,r,s,check1,check2,want1,want2;

gen1:= C4xC4GeneratorsOfSubgroup(N)[1];
gen2:= C4xC4GeneratorsOfSubgroup(N)[2];

mat1:=Checkginv_C4xC4(g,N);
mat2:=Checkginv_C4xC4(h,N);
mat3:=Checkginv_C4xC4(g*h,N);

k:=mat1[1][1];
l:=mat1[1][2];
m:=mat1[2][1];
n:=mat1[2][2];
a:=mat2[1][1];
b:=mat2[1][2];
c:=mat2[2][1];
d:=mat2[2][2];
p:=mat3[1][1];
q:=mat3[1][2];
r:=mat3[2][1];
s:=mat3[2][2];


check1:= -k*m -a*c*k^2 -b*d*m^2 -2*b*c*k*m +p*r;
check2:= -l*n -a*c*l^2 -b*d*n^2 -2*b*c*l*n +q*s;

want1:= check1 /2;
want2:= check2 /2;

want1:=want1 mod 4;
want2:=want2 mod 4;

return gen1^want1 * gen2^want2;  #群の要素そのものを出力するように改良
end;




#Gの中で要素gが何番目のものなのか特定する。
PickupElementNumber:=function(G,g)
local elist,i,want;
elist:=Elements(G);
for i in [1..64] do
if g = elist[i] then
want:= i;
fi;
od;
return want;
end;



#C2xC2の埋め込みによるチルダgとチルダhの関係式。
GomegaRelationsC2xC2 := function(G,N,g,h)
local m1,m2,m3,Eta,want,product;

Eta:= Eta_C2xC2(N,g,h);

product:= Eta * g * h ;

m1:= PickupElementNumber(G,g);
m2:= PickupElementNumber(G,h);
m3:= PickupElementNumber(G,product);

want:=
f[m3] * f[m2]^-1 *f[m1]^-1;

return want;
end;



#C2xC2の埋め込みによるチルダgとチルダhの全ての関係式。
AllGomegaRelationsC2xC2:= function(G,N)
local list,relation,g,h;

list:=[];

for g in Elements(G) do
for h in Elements(G) do

relation := GomegaRelationsC2xC2(G,N,g,h);
Add(list,relation);

od;od;
return list;
end;




#FinalAllGomegaRelationsは最終的に自由群を割るイデアルを表す

FinalAllGomegaRelationsC2xC2:= function(G,N)

local want,element10,element01,number1,number2;

want:= AllGomegaRelationsC2xC2(G,N);

element10:=C2xC2GeneratorsOfSubgroup(N)[1];
element01:=C2xC2GeneratorsOfSubgroup(N)[2];

number1:=PickupElementNumber(G,element10);
number2:=PickupElementNumber(G,element01);

Add(want,f[number1]^2);
Add(want,f[number2]^2);

return want;

end;



#C4xC4の埋め込みによるチルダgとチルダhの関係式。
GomegaRelationsC4xC4:= function(G,N,g,h)
local m1,m2,m3,Eta,want,n1,n2,product;

Eta:= Eta_C4xC4(N,g,h);

product:= Eta * g * h ;

m1:= PickupElementNumber(G,g);
m2:= PickupElementNumber(G,h);
m3:= PickupElementNumber(G,product);

want:=
f[m3] * f[m2]^-1 *f[m1]^-1;

return want;
end;



#C4xC4の埋め込みによるチルダgとチルダhの全ての関係式。
AllGomegaRelationsC4xC4 := function(G,N)
local list,relation,g,h;

list:=[];

for g in Elements(G) do
for h in Elements(G) do

relation := GomegaRelationsC4xC4(G,N,g,h);
Add(list,relation);

od;od;
return list;
end;




#FinalAllGomegaRelationsは最終的に自由群を割るイデアルを表す

FinalAllGomegaRelationsC4xC4 := function(G,N)

local want,element10,element01,number1,number2;

want:= AllGomegaRelationsC4xC4(G,N);

element10:=C4xC4GeneratorsOfSubgroup(N)[1];
element01:=C4xC4GeneratorsOfSubgroup(N)[2];

number1:=PickupElementNumber(G,element10);
number2:=PickupElementNumber(G,element01);

Add(want,f[number1]^4);
Add(want,f[number2]^4);

return want;

end;










#Gw判定に使う関数たち

GwStructureC2xC2:=function(G,N)

local Gw,Gfinal,orderlist,listnumber,v,isomorphicnumber;

orderlist:=OrderListGroup(G);
listnumber:= Number(SmallCategory(64,orderlist));

if CheckGinv_C2xC2Cal(G,N) = 1 then
 
 Gw:= Free64 / FinalAllGomegaRelationsC2xC2(G,N);
 
 if IsIsomorphicGroup(G,Gw) then Gfinal:=G;
 else Gfinal:=Gw; fi;
   
  for v in [2..listnumber] do
  
   if IsIsomorphicGroup(Gw,SmallCategoryCal(64,orderlist)[v]) then
   
   isomorphicnumber:=v;

   fi;od;

 return [C2xC2GeneratorsOfSubgroup(N),StructureDescription(N),"G-inv",IsIsomorphicGroup(G,Gw),isomorphicnumber-1,StructureDescription(Gfinal)];

else

 return [C2xC2GeneratorsOfSubgroup(N),StructureDescription(N),"not G-inv"];

fi;

end;




GwStructureC4xC4 :=function(G,N)

local Gw,Gfinal,orderlist,listnumber,v,isomorphicnumber;

orderlist:=OrderListGroup(G);
listnumber:= Number(SmallCategory(64,orderlist));

if CheckGinv_C4xC4Cal(G,N) = 1 then
 
 Gw:= Free64 / FinalAllGomegaRelationsC4xC4(G,N);
 
 if IsIsomorphicGroup(G,Gw) then Gfinal:=G;
 else Gfinal:=Gw; fi;

  for v in [2..listnumber] do
  
   if IsIsomorphicGroup(Gw,SmallCategoryCal(64,orderlist)[v]) then
   
   isomorphicnumber:=v;

   fi;od;
   
 return [C4xC4GeneratorsOfSubgroup(N),StructureDescription(N),"G-inv",IsIsomorphicGroup(G,Gw),isomorphicnumber-1,StructureDescription(Gfinal)];

else

 return [C4xC4GeneratorsOfSubgroup(N),StructureDescription(N),"not G-inv"];

fi;

end;






GwStructure:= function(G)  

local N;

if IsAbelian(G) then 
 Print(G,"is Abel.");
else

for N in ObtainedSubgroups(G) do

if IsIsomorphicGroup(N,C4xC4) then
 Print(GwStructureC4xC4(G,N),"\n");

elif IsIsomorphicGroup(N,C2xC2) then
 Print(GwStructureC2xC2(G,N),"\n");

else
 Print([N,StructureDescription(N)],"\n");

fi;
od;
fi;
end;





GwStructureCategory:= function(list)
local checkgroups,lastnumber,i;
checkgroups:=SmallCategoryCal(64,list);
 
lastnumber:=Number(checkgroups);
 
for i in [2..lastnumber] do
 
Print(StructureDescription(checkgroups[i]),"\n");

ShowMultiplicationTable(GeneratorsOfGroup(checkgroups[i]));

GwStructure(checkgroups[i]);
 
Print("\n\n");
od;
end;







GwStructureC2xC2ForTeX:=function(G,N)

local Gw,Gfinal,orderlist,listnumber,v,isomorphicnumber,checkmark;

orderlist:=OrderListGroup(G);
listnumber:= Number(SmallCategory(64,orderlist));

if CheckGinv_C2xC2Cal(G,N) = 1 then
 
 Gw:= Free64 / FinalAllGomegaRelationsC2xC2(G,N);
 
 if IsIsomorphicGroup(G,Gw) then Gfinal:=G; checkmark:="〇";
 else Gfinal:=Gw; checkmark:="×"; fi;
   
  for v in [2..listnumber] do
  
   if IsIsomorphicGroup(Gw,SmallCategoryCal(64,orderlist)[v]) then
   
   isomorphicnumber:=v;

   fi;od;

return
[
"$", 
C2xC2GeneratorsOfSubgroup(N), 
"$",
" & ",
"$C_2\\times C_2$",
" & ",
"〇",
" & ",
checkmark,
" & ",
isomorphicnumber-1,
" \\\\ \\hline "
];

else

return 
[
"$", 
C2xC2GeneratorsOfSubgroup(N), 
"$",
" & ",
"$C_2\\times C_2$",
" & ",
"×",
" & ",
"-",
" & ",
"-",
" \\\\ \\hline"
];

fi;

end;




GwStructureC4xC4ForTeX:=function(G,N)

local Gw,Gfinal,orderlist,listnumber,v,isomorphicnumber,checkmark;

orderlist:=OrderListGroup(G);
listnumber:= Number(SmallCategory(64,orderlist));

if CheckGinv_C4xC4Cal(G,N) = 1 then
 
 Gw:= Free64 / FinalAllGomegaRelationsC4xC4(G,N);
 
 if IsIsomorphicGroup(G,Gw) then Gfinal:=G; checkmark:="〇";
 else Gfinal:=Gw; checkmark:="×"; fi;
   
  for v in [2..listnumber] do
  
   if IsIsomorphicGroup(Gw,SmallCategoryCal(64,orderlist)[v]) then
   
   isomorphicnumber:=v;

   fi;od;

return
[
"$", 
C4xC4GeneratorsOfSubgroup(N), 
"$",
" & ",
"$C_4\\times C_4$",
" & ",
"〇",
" & ",
checkmark,
" & ",
isomorphicnumber-1,
" \\\\ \\hline "
];

else

return 
[
"$", 
C4xC4GeneratorsOfSubgroup(N), 
"$",
" & ",
"$C_4\\times C_4$",
" & ",
"×",
" & ",
"-",
" & ",
"-",
" \\\\ \\hline"
];

fi;

end;



#Print(want[1],want[2],want[3],want[4],want[5],want[6],want[7],want[8],want[9],want[10],want[11],want[12],"\n");


ForTeX:=function(n)
if Order(n)=1 then
return 1;
else
return n;
fi;
end;


GroupTableForTeX:=function(G)
local Ele1,Ele2,Ele3,Ele4,Ele5,Ele6;
Ele1:=GeneratorsOfGroup(G)[1];
Ele2:=GeneratorsOfGroup(G)[2];
Ele3:=GeneratorsOfGroup(G)[3];
Ele4:=GeneratorsOfGroup(G)[4];
Ele5:=GeneratorsOfGroup(G)[5];
Ele6:=GeneratorsOfGroup(G)[6];
return
[
" "," & ","$f1$"," & ","$f2$"," & ","$f3$"," & ","$f4$"," & ","$f5$"," & ","$f6$"," \\\\ \\hline\\hline","\n",
"$f1$"," & ","$",ForTeX(Ele1*Ele1),"$"," & ","$",ForTeX(Ele1*Ele2),"$"," & ","$",ForTeX(Ele1*Ele3),"$"," & ","$",ForTeX(Ele1*Ele4),"$"," & ","$",ForTeX(Ele1*Ele5),"$"," & ","$",ForTeX(Ele1*Ele6),"$"," \\\\ \\hline","\n",
"$f2$"," & ","$",ForTeX(Ele2*Ele1),"$"," & ","$",ForTeX(Ele2*Ele2),"$"," & ","$",ForTeX(Ele2*Ele3),"$"," & ","$",ForTeX(Ele2*Ele4),"$"," & ","$",ForTeX(Ele2*Ele5),"$"," & ","$",ForTeX(Ele2*Ele6),"$"," \\\\ \\hline","\n",
"$f3$"," & ","$",ForTeX(Ele3*Ele1),"$"," & ","$",ForTeX(Ele3*Ele2),"$"," & ","$",ForTeX(Ele3*Ele3),"$"," & ","$",ForTeX(Ele3*Ele4),"$"," & ","$",ForTeX(Ele3*Ele5),"$"," & ","$",ForTeX(Ele3*Ele6),"$"," \\\\ \\hline","\n",
"$f4$"," & ","$",ForTeX(Ele4*Ele1),"$"," & ","$",ForTeX(Ele4*Ele2),"$"," & ","$",ForTeX(Ele4*Ele3),"$"," & ","$",ForTeX(Ele4*Ele4),"$"," & ","$",ForTeX(Ele4*Ele5),"$"," & ","$",ForTeX(Ele4*Ele6),"$"," \\\\ \\hline","\n",
"$f5$"," & ","$",ForTeX(Ele5*Ele1),"$"," & ","$",ForTeX(Ele5*Ele2),"$"," & ","$",ForTeX(Ele5*Ele3),"$"," & ","$",ForTeX(Ele5*Ele4),"$"," & ","$",ForTeX(Ele5*Ele5),"$"," & ","$",ForTeX(Ele5*Ele6),"$"," \\\\ \\hline","\n",
"$f6$"," & ","$",ForTeX(Ele6*Ele1),"$"," & ","$",ForTeX(Ele6*Ele2),"$"," & ","$",ForTeX(Ele6*Ele3),"$"," & ","$",ForTeX(Ele6*Ele4),"$"," & ","$",ForTeX(Ele6*Ele5),"$"," & ","$",ForTeX(Ele6*Ele6),"$"," \\\\ \\hline","\n"
];
end;


GwStructureCategoryForTeX:= function(list)
local checkgroups,lastnumber,i,k,N,cc;
checkgroups:=SmallCategoryCal(64,list);
 
lastnumber:=Number(checkgroups);
 
for i in [2..lastnumber] do

Print(StructureDescription(checkgroups[i]),"\n");

for k in GroupTableForTeX(checkgroups[i]) do
Print(k);
od;

Print("\n");

if IsAbelian(checkgroups[i]) then Print(checkgroups[i]," is Abel.");

else

for N in ObtainedSubgroups(checkgroups[i]) do

if IsIsomorphicGroup(N,C2xC2) then

cc:=GwStructureC2xC2ForTeX(checkgroups[i],N);

Print(
cc[1],
cc[2],
cc[3],
cc[4],
cc[5],
cc[6],
cc[7],
cc[8],
cc[9],
cc[10],
cc[11],
cc[12],"\n");


elif IsIsomorphicGroup(N,C4xC4) then

cc:=GwStructureC4xC4ForTeX(checkgroups[i],N);

Print(
cc[1],
cc[2],
cc[3],
cc[4],
cc[5],
cc[6],
cc[7],
cc[8],
cc[9],
cc[10],
cc[11],
cc[12],"\n");

else 

Print(
"$", 
GeneratorsOfGroup(N), 
"$",
" & ",
"$C_2\\times C_2\\times C_2\\times C_2$",
" & ",
" ",
" & ",
" ",
" & ",
" ",
" \\\\ \\hline ","\n"
);

fi;
od;
 
Print("\n\n");
fi;
od;
end;




C2xC2xC2xC2GeneratorsOfSubgroup := function(N)
 local iso,gen1,gen2,gen3,gen4;
 iso:= IsomorphismGroups(C2xC2xC2xC2,N);
 gen1:= Image(iso,groupc);
 gen2:= Image(iso,groupd);
 gen3:= Image(iso,groupe);
 gen4:= Image(iso,groupf);
 return [gen1,gen2,gen3,gen4];
 end;


RightactionC2xC2xC2xC2_1:=function(gen1,gen2,gen3,gen4,g)
 local x1,x2,x3,x4,list1;
 
 for x1 in [0,1] do
 for x2 in [0,1] do
 for x3 in [0,1] do
 for x4 in [0,1] do
 if
 g*gen1*g^-1 = gen1^x1 * gen2^x2 * gen3^x3 * gen4^x4 then
 list1:=[x1,x2,x3,x4];
 fi;
 od;
 od;
 od;
 od;
 return list1;
 end;


RightactionC2xC2xC2xC2_2:=function(gen1,gen2,gen3,gen4,g)
 local x1,x2,x3,x4,list1;
 
 for x1 in [0,1] do
 for x2 in [0,1] do
 for x3 in [0,1] do
 for x4 in [0,1] do
 if
 g*gen2*g^-1 = gen1^x1 * gen2^x2 * gen3^x3 * gen4^x4 then
 list1:=[x1,x2,x3,x4];
 fi;
 od;
 od;
 od;
 od;
 return list1;
 end;


RightactionC2xC2xC2xC2_3:=function(gen1,gen2,gen3,gen4,g)
 local x1,x2,x3,x4,list1;
 
 for x1 in [0,1] do
 for x2 in [0,1] do
 for x3 in [0,1] do
 for x4 in [0,1] do
 if
 g*gen3*g^-1 = gen1^x1 * gen2^x2 * gen3^x3 * gen4^x4 then
 list1:=[x1,x2,x3,x4];
 fi;
 od;
 od;
 od;
 od;
 return list1;
 end;




RightactionC2xC2xC2xC2_4:=function(gen1,gen2,gen3,gen4,g)
 local x1,x2,x3,x4,list1;
 
 for x1 in [0,1] do
 for x2 in [0,1] do
 for x3 in [0,1] do
 for x4 in [0,1] do
 if
 g*gen4*g^-1 = gen1^x1 * gen2^x2 * gen3^x3 * gen4^x4 then
 list1:=[x1,x2,x3,x4];
 fi;
 od;
 od;
 od;
 od;
 return list1;
 end;

Checkginv_C2xC2xC2xC2 := function(g,N)
 local wantlist,gen1,gen2,gen3,gen4;
 gen1:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[1];
 gen2:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[2];
 gen3:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[3];
 gen4:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[4];
 
 wantlist:=[
 RightactionC2xC2xC2xC2_1(gen1,gen2,gen3,gen4,g),
 RightactionC2xC2xC2xC2_2(gen1,gen2,gen3,gen4,g),
 RightactionC2xC2xC2xC2_3(gen1,gen2,gen3,gen4,g),
 RightactionC2xC2xC2xC2_4(gen1,gen2,gen3,gen4,g)];
 
 return wantlist;
 end;



Checkginv_C2xC2xC2xC2_ForElement:= function(g,i,j,N,k)
 local mat,r12,r13,r14,r23,r24,r34,Ag,ram12,ram13,ram14,ram23,ram24,ram34;
 
 mat:=MatrixesC2xC2xC2xC2[k];
 mat:=ChangeMatrix(mat);
 
 r12:=mat[1][2];
 r13:=mat[1][3];
 r14:=mat[1][4];
 r23:=mat[2][3];
 r24:=mat[2][4];
 r34:=mat[3][4];
 
 Ag:=Checkginv_C2xC2xC2xC2(g,N);
 
 ram12:=r12^(Ag[1][i]*Ag[2][j]-Ag[1][j]*Ag[2][i]);
 ram13:=r13^(Ag[1][i]*Ag[3][j]-Ag[1][j]*Ag[3][i]);
 ram14:=r14^(Ag[1][i]*Ag[4][j]-Ag[1][j]*Ag[4][i]);
 ram23:=r23^(Ag[2][i]*Ag[3][j]-Ag[2][j]*Ag[3][i]);
 ram24:=r24^(Ag[2][i]*Ag[4][j]-Ag[2][j]*Ag[4][i]);
 ram34:=r34^(Ag[3][i]*Ag[4][j]-Ag[3][j]*Ag[4][i]);
 
 if ram12*ram13*ram14*ram23*ram24*ram34 = mat[i][j] then
 
 return 1;
 
 else
 
 return 0;
 
 fi;
 
 end;


CheckGinv_C2xC2xC2xC2:=function(G,N,k)
 local g,finallist,num12,num13,num14,num23,num24,num34;
 
 finallist:=[];
 
 for g in G do
 
 num12:=Checkginv_C2xC2xC2xC2_ForElement(g,1,2,N,k);
 num13:=Checkginv_C2xC2xC2xC2_ForElement(g,1,3,N,k);
 num14:=Checkginv_C2xC2xC2xC2_ForElement(g,1,4,N,k);
 num23:=Checkginv_C2xC2xC2xC2_ForElement(g,2,3,N,k);
 num24:=Checkginv_C2xC2xC2xC2_ForElement(g,2,4,N,k);
 num34:=Checkginv_C2xC2xC2xC2_ForElement(g,3,4,N,k);
 
 Append(finallist,[num12,num13,num14,num23,num24,num34]);
 
 od;
 
 finallist:=Set(finallist);
 
 if finallist=[1] then
 return 1;
 
 else
 return 0;
 
 fi;
 
 end;




C2xC2xC2xC2GeneratorsRepn:=function(n,N)
local gen1,gen2,gen3,gen4,x1,x2,x3,x4,list1;

gen1:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[1];
gen2:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[2];
gen3:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[3];
gen4:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[4];

 for x1 in [0,1] do
 for x2 in [0,1] do
 for x3 in [0,1] do
 for x4 in [0,1] do
 if
 n = gen1^x1 * gen2^x2 * gen3^x3 * gen4^x4 then
 list1:=[x1,x2,x3,x4];
 fi;
 od;
 od;
 od;
 od;
 return list1;
 end;







2Cocycle_C2xC2xC2xC2:= function(a,b,N,k)
local mat,r12,r13,r14,r23,r24,r34,elementa,elementb,want;

mat:=MatrixesC2xC2xC2xC2[k];
mat:=ChangeMatrix(mat);

 r12:=mat[1][2];
 r13:=mat[1][3];
 r14:=mat[1][4];
 r23:=mat[2][3];
 r24:=mat[2][4];
 r34:=mat[3][4];

elementa:=C2xC2xC2xC2GeneratorsRepn(a,N);
elementb:=C2xC2xC2xC2GeneratorsRepn(b,N);

want:=
r12^(elementa[1]*elementb[2]) *
r13^(elementa[1]*elementb[3]) *
r14^(elementa[1]*elementb[4]) *
r23^(elementa[2]*elementb[3]) *
r24^(elementa[2]*elementb[4]) *
r34^(elementa[3]*elementb[4]);

return want;

end;




MatrixCalC2xC2xC2xC2:=function(mat,list)
local wantlist;

list:=TransposedMat([list]);

list:= mat * list;

wantlist:=[list[1][1],list[2][1],list[3][1],list[4][1]];

return wantlist;

end;






DellXi_C2xC2xC2xC2:=function(g,a,b,N,k)
local elementa,elementb,Ag,Aga,Agb,gen1,gen2,gen3,gen4,want;

elementa:=C2xC2xC2xC2GeneratorsRepn(a,N);
elementb:=C2xC2xC2xC2GeneratorsRepn(b,N);

Ag:=Checkginv_C2xC2xC2xC2(g,N);

Aga:= MatrixCalC2xC2xC2xC2(Ag,elementa);
Agb:= MatrixCalC2xC2xC2xC2(Ag,elementb);


gen1:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[1];
gen2:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[2];
gen3:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[3];
gen4:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[4];

Aga:=gen1^Aga[1] * gen2^Aga[2] * gen3^Aga[3] * gen4^Aga[4];
Agb:=gen1^Agb[1] * gen2^Agb[2] * gen3^Agb[3] * gen4^Agb[4];


want:=
2Cocycle_C2xC2xC2xC2(Aga,Agb,N,k)/ 2Cocycle_C2xC2xC2xC2(a,b,N,k);

return want;

end;





DellXiList_C2xC2xC2xC2:=function(g,N,k)
local gen1,gen2,gen3,gen4,wantmat;

gen1:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[1];
gen2:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[2];
gen3:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[3];
gen4:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[4];

wantmat:=
[
[DellXi_C2xC2xC2xC2(g,gen1,gen1,N,k),DellXi_C2xC2xC2xC2(g,gen1,gen2,N,k),
DellXi_C2xC2xC2xC2(g,gen1,gen3,N,k),DellXi_C2xC2xC2xC2(g,gen1,gen4,N,k)],
[DellXi_C2xC2xC2xC2(g,gen2,gen1,N,k),DellXi_C2xC2xC2xC2(g,gen2,gen2,N,k),
DellXi_C2xC2xC2xC2(g,gen2,gen3,N,k),DellXi_C2xC2xC2xC2(g,gen2,gen4,N,k)],
[DellXi_C2xC2xC2xC2(g,gen3,gen1,N,k),DellXi_C2xC2xC2xC2(g,gen3,gen2,N,k),
DellXi_C2xC2xC2xC2(g,gen3,gen3,N,k),DellXi_C2xC2xC2xC2(g,gen3,gen4,N,k)],
[DellXi_C2xC2xC2xC2(g,gen4,gen1,N,k),DellXi_C2xC2xC2xC2(g,gen4,gen2,N,k),
DellXi_C2xC2xC2xC2(g,gen4,gen3,N,k),DellXi_C2xC2xC2xC2(g,gen4,gen4,N,k)]
];

return wantmat;

end;



Xi_C2xC2xC2xC2:=function(g,N,a,k)
local DellXi,want,elementa,i,j;

want:=1;

DellXi:=DellXiList_C2xC2xC2xC2(g,N,k);

elementa:=C2xC2xC2xC2GeneratorsRepn(a,N);

for i in [1..4] do
for j in [1..4] do

if i<=j and DellXi[i][j]=-1 then 

want:=want * E(4)^(-elementa[i]*elementa[j]);

fi;
od;od;

return want;

end;



Eta_C2xC2xC2xC2:=function(g,h,N,k)
local gen1,gen2,gen3,gen4,e1,e2,e3,e4,Ag,Age1,Age2,Age3,Age4,eta1,eta2,eta3,eta4;

gen1:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[1];
gen2:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[2];
gen3:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[3];
gen4:= C2xC2xC2xC2GeneratorsOfSubgroup(N)[4];

e1:=C2xC2xC2xC2GeneratorsRepn(gen1,N);
e2:=C2xC2xC2xC2GeneratorsRepn(gen2,N);
e3:=C2xC2xC2xC2GeneratorsRepn(gen3,N);
e4:=C2xC2xC2xC2GeneratorsRepn(gen4,N);

Ag:=Checkginv_C2xC2xC2xC2(g,N);

Age1:=MatrixCalC2xC2xC2xC2(Ag,e1);
Age2:=MatrixCalC2xC2xC2xC2(Ag,e2);
Age3:=MatrixCalC2xC2xC2xC2(Ag,e3);
Age4:=MatrixCalC2xC2xC2xC2(Ag,e4);

Age1:= gen1^Age1[1] * gen2^Age1[2] * gen3^Age1[3] * gen4^Age1[4];
Age2:= gen1^Age2[1] * gen2^Age2[2] * gen3^Age2[3] * gen4^Age2[4];
Age3:= gen1^Age3[1] * gen2^Age3[2] * gen3^Age3[3] * gen4^Age3[4];
Age4:= gen1^Age4[1] * gen2^Age4[2] * gen3^Age4[3] * gen4^Age4[4];

eta1:= Xi_C2xC2xC2xC2(g,N,gen1,k) * Xi_C2xC2xC2xC2(h,N,Age1,k) / Xi_C2xC2xC2xC2(g*h,N,gen1,k);
if eta1=-1 then eta1:=1;
elif eta1=1 then eta1:=0;
fi;

eta2:= Xi_C2xC2xC2xC2(g,N,gen2,k) * Xi_C2xC2xC2xC2(h,N,Age2,k) / Xi_C2xC2xC2xC2(g*h,N,gen2,k);
if eta2=-1 then eta2:=1;
elif eta2=1 then eta2:=0;
fi;

eta3:= Xi_C2xC2xC2xC2(g,N,gen3,k) * Xi_C2xC2xC2xC2(h,N,Age3,k) / Xi_C2xC2xC2xC2(g*h,N,gen3,k);
if eta3=-1 then eta3:=1;
elif eta3=1 then eta3:=0;
fi;

eta4:= Xi_C2xC2xC2xC2(g,N,gen4,k) * Xi_C2xC2xC2xC2(h,N,Age4,k) / Xi_C2xC2xC2xC2(g*h,N,gen4,k);
if eta4=-1 then eta4:=1;
elif eta4=1 then eta4:=0;
fi;

return gen1^eta1 * gen2^eta2  * gen3^eta3 * gen4^eta4;

end;












AllDellXiList_C2xC2xC2xC2:=function(G,N,k)
local Coset,cos,repn,mat;

Coset:=RightCosets(G,N);

for cos in Coset do

repn:=Representative(cos);
mat:=DellXiList_C2xC2xC2xC2(repn,N,k);

Print(repn);
Print(
"\n",
mat[1][1],mat[1][2],mat[1][3],mat[1][4],"\n",
mat[2][1],mat[2][2],mat[2][3],mat[2][4],"\n",
mat[3][1],mat[3][2],mat[3][3],mat[3][4],"\n",
mat[4][1],mat[4][2],mat[4][3],mat[4][4]
);

Print("\n\n");

od;

end;




CheckGinvAll_C2xC2xC2xC2:=function(G,N)
local list1;
 list1:=List([1..28],i->CheckGinv_C2xC2xC2xC2(G,N,i));
 return list1;
 end;



GomegaRelationsC2xC2xC2xC2:= function(G,N,coset1,coset2,k)
local m0,m1,m2,m3,Eta,want,wantlist,g,h,rep1,rep2;

wantlist:=[];

rep1:=Representative(coset1);
rep2:=Representative(coset2);

Eta:= Eta_C2xC2xC2xC2(rep1,rep2,N,k);

m0:= PickupElementNumber(G,Eta);


for g in coset1 do
for h in coset2 do

m1:= PickupElementNumber(G,g);
m2:= PickupElementNumber(G,h);
m3:= PickupElementNumber(G,g*h);

want:=
f[m0] * f[m3] * f[m2]^-1 *f[m1]^-1;

Add(wantlist,want);

od;od;

return wantlist;
end;



AllGomegaRelationsC2xC2xC2xC2 := function(G,N,k)
local Coset,cos1,cos2,list,relation;

Coset:=RightCosets(G,N);

list:=[];

for cos1 in Coset do
for cos2 in Coset do

relation := GomegaRelationsC2xC2xC2xC2(G,N,cos1,cos2,k);
Add(list,relation);

od;od;

list:=Union(list);
return list;
end;




MoreGomegaRelationsC2xC2xC2xC2:=function(G,N)
local n,g,num0,num1,num2,relation,wantlist;

wantlist:=[];

for n in Elements(N) do
for g in Elements(G) do

num0:=PickupElementNumber(G,n);
num1:=PickupElementNumber(G,g);
num2:=PickupElementNumber(G,n*g);

relation:= f[num0] * f[num1] * f[num2]^-1;

Add(wantlist,relation);

od;od;

return wantlist;
end;



FinalAllGomegaRelationsC2xC2xC2xC2 := function(G,N,k)

local finalwant,want,want2,element1000,element0100,element0010,element0001,number1,number2,number3,number4;

want:= AllGomegaRelationsC2xC2xC2xC2(G,N,k);
want2:=MoreGomegaRelationsC2xC2xC2xC2(G,N);

element1000:=C2xC2xC2xC2GeneratorsOfSubgroup(N)[1];
element0100:=C2xC2xC2xC2GeneratorsOfSubgroup(N)[2];
element0010:=C2xC2xC2xC2GeneratorsOfSubgroup(N)[3];
element0001:=C2xC2xC2xC2GeneratorsOfSubgroup(N)[4];

number1:=PickupElementNumber(G,element1000);
number2:=PickupElementNumber(G,element0100);
number3:=PickupElementNumber(G,element0010);
number4:=PickupElementNumber(G,element0001);

Add(want,f[number1]^2);
Add(want,f[number2]^2);
Add(want,f[number3]^2);
Add(want,f[number4]^2);

finalwant:=Union(want,want2);

return finalwant;

end;




GwStructureC2xC2xC2xC2 :=function(G,N)
local invlist,k,t,Relation,Gfinal,want;

invlist:=[];
want:=[];

for k in [1..28] do

if CheckGinv_C2xC2xC2xC2(G,N,k)=1 then

Add(invlist,k);

fi;
od;

for t in invlist do

Relation:=FinalAllGomegaRelationsC2xC2xC2xC2(G,N,t);

Gfinal:=Free64/Relation;

Add(want,[t,IsIsomorphicGroup(G,Gfinal)]);
od;

return want;
end;



GwStructureAllC2xC2xC2xC2:=function(G)
local subgroups,checkgroups,H,subg;

subgroups:=ObtainedSubgroups(G);

checkgroups:=[];

for H in subgroups do
if IsIsomorphicGroup(C2xC2xC2xC2,H) then
Add(checkgroups,H);
fi;
od;

for subg in checkgroups do

Print(GeneratorsOfGroup(subg),"\n");
Print(GwStructureC2xC2xC2xC2(G,subg),"\n\n");

od;
end;






Cycle2x2x2x2:=function(g)
local j,k,m,n;
for j in [0,1] do
for k in [0,1] do
for m in [0,1] do
for n in [0,1] do
if g=groupc^j*groupd^k*groupe^m*groupf^n then
return[j,k,m,n];
fi;
od;
od;
od;
od;
end;

for k in [1..28] do
Cocycle_C2xC2xC2xC2_k:=function(a,x)
local list1,list2,matrix,want;
matrix:=ChangeMatrix(MatrixesC2xC2xC2xC2[k]);
list1:=Cycle2x2x2x2(a);
list2:=Cycle2x2x2x2(x);
want:=matrix[1][2]^(list1[1]*list2[2]) * matrix[1][3]^(list1[1]*list2[3]) *
      matrix[1][4]^(list1[1]*list2[4]) * matrix[2][3]^(list1[2]*list2[3]) *
      matrix[2][4]^(list1[2]*list2[4]) * matrix[3][4]^(list1[3]*list2[4]) ;
return want;
end;
od;		#末尾の番号がそれぞれ対応する2-cocycle



