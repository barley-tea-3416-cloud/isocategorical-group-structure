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


# Define a free group with 4 generators named x, y, s, and t
F4 := FreeGroup("x", "y", "s", "t");

# Assign the generator names to global variables for use in expressions
AssignGeneratorVariables(F4);

# Define Izumi-Kosaki group G as the quotient of F4 by the specified relations
G := F4 / [
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


# Identify groups of order 64 with the specific order profile [1, 19, 44, 0, 0, 0, 0]
izumigroups := SmallCategoryCal(64, [1, 19, 44, 0, 0, 0, 0]);

# Extract group identifiers from the 2nd to the 10th element (skipping the olist at index 1)
izumigroups := izumigroups{[2..10]};

# Pick the 5th group identifier from the sliced list
Gizumikosaki := izumigroups[5];


# Initialize an empty list to store subgroups with specific orders
sub1 := [];
for i in Subgroups(G) do
    # Filter subgroups whose order is 4 or 16 (square numbers)
    if Order(i) = 4 or Order(i) = 16 then
        Add(sub1, i);
    fi;
od;

# Initialize an empty list for the final filtered subgroups
sub2 := [];
for i in sub1 do
    # Filter for subgroups that are both abelian and normal in G
    if IsAbelian(i) and IsNormal(G, i) then
        Add(sub2, i);
    fi;
od;


# Construct the direct product of two cyclic groups of order 4 (C4 x C4)
C4xC4 := AbelianGroup(IsFpGroup, [4, 4]);

# Construct the direct product of two cyclic groups of order 2 (C2 x C2)
C2xC2 := AbelianGroup(IsFpGroup, [2, 2]);

#C2xC2xC2xC2
C2xC2xC2xC2 := FreeGroup("c", "d", "e", "g");
AssignGeneratorVariables(C2xC2xC2xC2);
C2xC2xC2xC2 := C2xC2xC2xC2 / [
    c^2,
    d^2,
    e^2,
    g^2,
    c*d*c^-1*d^-1,
    c*e*c^-1*e^-1,
    c*g*c^-1*g^-1,
    d*e*d^-1*e^-1,
    d*g*d^-1*g^-1,
    e*g*e^-1*g^-1
];


# Assign generators of C4xC4 to groupp and groupq
groupp := GeneratorsOfGroup(C4xC4)[1];
groupq := GeneratorsOfGroup(C4xC4)[2];


# Helper function to decompose element g into exponents [j, k] such that g = p^j * q^k
Cycle4x4 := function(g)
    local j, k;
    for j in [0..3] do
        for k in [0..3] do
            if g = groupp^j * groupq^k then
                return [j, k];
            fi;
        od;
    od;
end;


# Trivial 2-cocycle (constant 1)
Cocycle_C4xC4_0 := function(g, h)
    local want, list1, list2;
    list1 := Cycle4x4(g);
    list2 := Cycle4x4(h);
    want := E(4)^(list1[1] * list2[2] * 0);
    return want;
end;

# Non-degenerate 2-cocycle (Standard bimultiplicative form)
Cocycle_C4xC4_1 := function(g, h)
    local want, list1, list2;
    list1 := Cycle4x4(g);
    list2 := Cycle4x4(h);
    want := E(4)^(list1[1] * list2[2]);
    return want;
end;

# 2-cocycle with exponent factor 2
Cocycle_C4xC4_2 := function(g, h)
    local want, list1, list2;
    list1 := Cycle4x4(g);
    list2 := Cycle4x4(h);
    want := E(4)^(list1[1] * list2[2] * 2);
    return want;
end;

# Non-degenerate 2-cocycle (Inverse of Cocycle_1)
Cocycle_C4xC4_3 := function(g, h)
    local want, list1, list2;
    list1 := Cycle4x4(g);
    list2 := Cycle4x4(h);
    want := E(4)^(list1[1] * list2[2] * 3);
    return want;
end;


# Assign generators of C2xC2 to groupa and groupb
groupa := GeneratorsOfGroup(C2xC2)[1];
groupb := GeneratorsOfGroup(C2xC2)[2];

# Helper function to decompose element g into exponents [j, k] such that g = a^j * b^k
Cycle2x2 := function(g)
    local j, k;
    for j in [0, 1] do
        for k in [0, 1] do
            if g = groupa^j * groupb^k then
                return [j, k];
            fi;
        od;
    od;
end;

# Trivial 2-cocycle for C2xC2 (constant value 1)
Cocycle_C2xC2_0 := function(g, h)
    local want, list1, list2;
    list1 := Cycle2x2(g);
    list2 := Cycle2x2(h);
    want := E(2)^(list1[1] * list2[2] * 0);
    return want;
end;

# Non-degenerate 2-cocycle for C2xC2
Cocycle_C2xC2_1 := function(g, h)
    local want, list1, list2;
    list1 := Cycle2x2(g);
    list2 := Cycle2x2(h);
    want := E(2)^(list1[1] * list2[2] * 1);
    return want;
end;


# Purpose: Returns the 6-bit binary representation of n as a list
Binary64 := function(n)
    local list, k;
    
    # Initialize a list of length 6 with zeros
    list := [0, 0, 0, 0, 0, 0];
    
    # Iterate 6 times to extract each bit
    for k in [1..6] do
        # Store the remainder (bit) starting from the last index
        list[7-k] := n mod 2;
        # Perform integer division by 2 to move to the next bit
        n := (n - n mod 2) / 2;
    od;
    
    return list;
end;


# Initialize an empty list to store binary sequences
List01x6 := [];


# Iterate through integers from 0 to 63 to generate all 6-bit combinations
for k in [0..63] do
    # Call Binary64 for each k and append the resulting bit-list to List01x6
    Add(List01x6, Binary64(k));
od;


# Initialize an empty list to store full-rank matrices
MatrixesC2xC2xC2xC2 := [];

# Iterate through each 6-bit combination to form a 4x4 alternating matrix
for list in List01x6 do
    # Construct a symmetric matrix with zeros on the diagonal (alternating in GF(2))
    # The 6 bits represent the upper/lower triangular entries: (1,2), (1,3), (1,4), (2,3), (2,4), (3,4)
    matrix := [
        [0, list[1], list[2], list[3]],
        [list[1], 0, list[4], list[5]],
        [list[2], list[4], 0, list[6]],
        [list[3], list[5], list[6], 0]
    ];

    # Check if the matrix is non-degenerate (full rank for a 4x4 matrix is 4)
    if RankMatrix(matrix) = 4 then
        Add(MatrixesC2xC2xC2xC2, matrix);
    fi;
od;


# Argument: matrix (4x4 matrix with entries 0 or 1)
# Purpose: Converts an additive matrix (0, 1) to a multiplicative matrix (1, -1)
ChangeMatrix := function(matrix)
    local i, j, wantmat;
    
    # Initialize a 4x4 zero matrix
    wantmat := [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]];
    
    # Iterate through each entry of the matrix
    for i in [1..4] do
        for j in [1..4] do
            # Map the additive identity (0) to the multiplicative identity (1)
            if matrix[i][j] = 0 then
                wantmat[i][j] := 1;
            # Map the non-trivial element (1) to the non-trivial root of unity (-1)
            elif matrix[i][j] = 1 then
                wantmat[i][j] := -1;
            fi;
        od;
    od;
    
    return wantmat;
end;


# Assign the four generators of the elementary abelian group C2xC2xC2xC2 to individual variables
groupc := GeneratorsOfGroup(C2xC2xC2xC2)[1];
groupd := GeneratorsOfGroup(C2xC2xC2xC2)[2];
groupe := GeneratorsOfGroup(C2xC2xC2xC2)[3];
groupf := GeneratorsOfGroup(C2xC2xC2xC2)[4];


# Argument: G (a group)
# Purpose: Returns a list of normal subgroups of G isomorphic to C2xC2, C4xC4, or C2xC2xC2xC2
ObtainedSubgroups := function(G)
    local sub1, sub2, j, k;
    
    sub1 := [];
    sub2 := [];
    
    # Iterate through all subgroups and collect those that are normal in G
    for j in Subgroups(G) do
        if IsNormal(G, j) then
            Add(sub1, j);
        fi;
    od;
    
    # Filter the normal subgroups by checking isomorphism to target abelian groups
    for k in sub1 do
        if IsIsomorphicGroup(k, C2xC2) or 
           IsIsomorphicGroup(k, C4xC4) or 
           IsIsomorphicGroup(k, C2xC2xC2xC2) then
            Add(sub2, k);
        fi;
    od;
    
    return sub2;
end;


# Argument: N (a subgroup isomorphic to C2xC2)
# Purpose: Identifies the elements in N that correspond to the standard generators (groupa, groupb) of C2xC2
C2xC2GeneratorsOfSubgroup := function(N)
    local iso, gen1, gen2;
    
    # Compute an isomorphism from the reference group C2xC2 to the subgroup N
    iso := IsomorphismGroups(C2xC2, N);
    
    # Map the reference generators to their corresponding images in N
    gen1 := Image(iso, groupa);
    gen2 := Image(iso, groupb);
    
    # Return the pair of elements representing the (1,0) and (0,1) components
    return [gen1, gen2];
end;


# Pick the first subgroup that satisfies the criteria from the group Gizumikosaki
N2 := ObtainedSubgroups(Gizumikosaki)[1];

# Compute an isomorphism between the finitely presented group G and Gizumikosaki
homhom := IsomorphismGroups(G, Gizumikosaki);

# Map the first generator of G (x) to its corresponding element in Gizumikosaki
elementx := Image(homhom, GeneratorsOfGroup(G)[1]);

# Define a 2x2 matrix Ax, likely representing a transformation or automorphism
Ax := [[1, 0], [1, 1]];


# Arguments: g (a group element), N (a subgroup isomorphic to C2xC2)
# Purpose: Determines the 2x2 matrix representing the automorphism of N induced by conjugation by g
Checkginv_C2xC2 := function(g, N)
    local i, j, m, n, list1, list2, gen1, gen2;
    
    # Retrieve the basis generators of the subgroup N
    gen1 := C2xC2GeneratorsOfSubgroup(N)[1];
    gen2 := C2xC2GeneratorsOfSubgroup(N)[2];

    # Find the image of gen1 under conjugation by g: g*gen1*g^-1 = gen1^i * gen2^j
    for i in [0, 1] do
        for j in [0, 1] do
            if g * gen1 * g^-1 = gen1^i * gen2^j then
                list1 := [i, j];
            fi;
        od;
    od;

    # Find the image of gen2 under conjugation by g: g*gen2*g^-1 = gen1^m * gen2^n
    for m in [0, 1] do
        for n in [0, 1] do
            if g * gen2 * g^-1 = gen1^m * gen2^n then
                list2 := [m, n];
            fi;
        od;
    od;

    # Return the coefficients as a 2x2 matrix [list1, list2]
    return [list1, list2];
end;


# Arguments: G (the parent group), N (subgroup isomorphic to C2xC2)
# Purpose: Checks if the conjugation action of G on N induces non-singular matrices (automorphisms)
CheckGinv_C2xC2 := function(G, N)
    local want, list, g, check;
    
    # Get the list of generators for group G
    list := GeneratorsOfGroup(G);
    want := [];

    # For each generator g, compute the 2x2 matrix representing the conjugation action on N
    for g in list do
        Add(want, Checkginv_C2xC2(g, N));
    od;

    # Compute the determinant of each matrix and reduce it modulo 2
    check := List(want, Determinant);
    check := List(check, i -> i mod 2);
    
    # Extract unique values to check consistency
    check := Set(check);

    # If the determinant is always 1, the action consists of invertible transformations (GL(2, 2))
    if check = [1] then
        Print(N, " is G invariant.");
    else
        Print(N, " is not G invariant.");
    fi;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C2xC2)
# Purpose: Returns 1 if the conjugation action of G on N preserves the structure (G-invariant), otherwise 0
CheckGinv_C2xC2Cal := function(G, N)
    local want, list, g, check;

    # Retrieve generators of G and initialize the matrix collection
    list := GeneratorsOfGroup(G);
    want := [];

    # Iterate through generators to obtain the 2x2 conjugation matrices acting on N
    for g in list do
        Add(want, Checkginv_C2xC2(g, N));
    od;

    # Compute determinants modulo 2 to check for non-singularity
    check := List(want, Determinant);
    check := List(check, i -> i mod 2);
    check := Set(check);

    # If all generators act as valid automorphisms (det=1), return 1; otherwise, return 0
    if check = [1] then
        return 1;
    else
        return 0;
    fi;
end;


# Arguments: N (subgroup isomorphic to C2xC2), g, h (elements of G)
# Purpose: Computes an element eta(g, h) in N based on the conjugation action matrices of g, h, and gh
Eta_C2xC2 := function(N, g, h)
    local gen1, gen2, mat1, mat2, mat3, k, l, m, n, a, b, c, d, p, q, r, s, check1, check2, want1, want2;

    # Retrieve the basis generators of the subgroup N
    gen1 := C2xC2GeneratorsOfSubgroup(N)[1];
    gen2 := C2xC2GeneratorsOfSubgroup(N)[2];

    # Get the 2x2 conjugation matrices for g, h, and the product g*h
    mat1 := Checkginv_C2xC2(g, N);
    mat2 := Checkginv_C2xC2(h, N);
    mat3 := Checkginv_C2xC2(g * h, N);

    # Extract coefficients of the matrix for g (mat1)
    k := mat1[1][1];
    l := mat1[1][2];
    m := mat1[2][1];
    n := mat1[2][2];

    # Extract coefficients of the matrix for h (mat2)
    a := mat2[1][1];
    b := mat2[1][2];
    c := mat2[2][1];
    d := mat2[2][2];

    # Extract coefficients of the matrix for g*h (mat3)
    p := mat3[1][1];
    q := mat3[1][2];
    r := mat3[2][1];
    s := mat3[2][2];

    # Calculate algebraic check values based on the matrix entries
    check1 := -k*m - a*c*k^2 - b*d*m^2 - 2*b*c*k*m + p*r;
    check2 := -l*n - a*c*l^2 - b*d*n^2 - 2*b*c*l*n + q*s;

    # Determine exponents by halving the check values and taking modulo 2
    want1 := check1 / 2;
    want2 := check2 / 2;

    want1 := want1 mod 2;
    want2 := want2 mod 2;

    # Return the resulting element in N: gen1^want1 * gen2^want2
    return gen1^want1 * gen2^want2;
end;


# Argument: N (a subgroup isomorphic to C4xC4)
# Purpose: Identifies the elements in N that correspond to the standard generators (groupp, groupq) of C4xC4
C4xC4GeneratorsOfSubgroup := function(N)
    local iso, gen1, gen2;
    
    # Compute an isomorphism from the reference group C4xC4 to the subgroup N
    iso := IsomorphismGroups(C4xC4, N);
    
    # Map the reference generators (groupp, groupq) to their corresponding images in N
    gen1 := Image(iso, groupp);
    gen2 := Image(iso, groupq);
    
    # Return the pair of elements representing the (1,0) and (0,1) components in N
    return [gen1, gen2];
end;


# Pick the 7th subgroup from the filtered list for Gizumikosaki
N1 := ObtainedSubgroups(Gizumikosaki)[7];

# Compute the isomorphism between the abstract group G and the concrete group Gizumikosaki
homhom := IsomorphismGroups(G, Gizumikosaki);

# Map the 3rd generator of G (which is 's') to its corresponding element in Gizumikosaki
elements := Image(homhom, GeneratorsOfGroup(G)[3]);

# Define a 2x2 matrix As, likely representing the action of 's' on N1
As := [[1, 0], [2, 1]];


# Arguments: g (group element), N (subgroup isomorphic to C4xC4)
# Purpose: Computes the 2x2 matrix representing the conjugation action of g on N
Checkginv_C4xC4 := function(g, N)
    local i, j, m, n, list1, list2, gen1, gen2;

    # Retrieve basis generators for the subgroup N
    gen1 := C4xC4GeneratorsOfSubgroup(N)[1];
    gen2 := C4xC4GeneratorsOfSubgroup(N)[2];

    # Find exponents i, j such that g*gen1*g^-1 = gen1^i * gen2^j
    for i in [0..3] do
        for j in [0..3] do
            if g * gen1 * g^-1 = gen1^i * gen2^j then
                list1 := [i, j];
            fi;
        od;
    od;

    # Find exponents m, n such that g*gen2*g^-1 = gen1^m * gen2^n
    for m in [0..3] do
        for n in [0..3] do
            if g * gen2 * g^-1 = gen1^m * gen2^n then
                list2 := [m, n];
            fi;
        od;
    od;

    # Return the coordinate matrix [list1, list2]
    return [list1, list2];
end;


# Arguments: G (parent group), N (subgroup isomorphic to C4xC4)
# Purpose: Checks if the conjugation action of G on N induces invertible matrices in GL(2, Z/4Z)
CheckGinv_C4xC4 := function(G, N)
    local want, list, g, check, k, i;
    
    # Retrieve the list of generators for group G
    list := GeneratorsOfGroup(G);
    want := [];

    # For each generator g, compute the 2x2 matrix representing the conjugation action on N
    for g in list do
        # Note: Results for G-invariance are consistent across Candidate 1 and 2
        Add(want, Checkginv_C4xC4(g, N));
    od;

    # Compute the determinant of each matrix and reduce it modulo 4
    check := List(want, Determinant);
    check := List(check, i -> i mod 4);
    
    # Extract the set of unique determinant values
    check := Set(check);

    # A matrix is invertible over Z/4Z if its determinant is 1 or 3 (units in Z/4Z)
    # This specific check verifies if the determinants are strictly 1 mod 4
    if check = [1] then
        Print(N, " is G invariant.");
    else
        Print(N, " is not G invariant.");
    fi;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C4xC4)
# Purpose: Returns 1 if the conjugation action of G on N results in determinants of 1 mod 4, else 0
CheckGinv_C4xC4Cal := function(G, N)
    local want, list, g, check, k, i;
    
    # Fetch generators of G and initialize list for conjugation matrices
    list := GeneratorsOfGroup(G);
    want := [];

    # Iterate through generators of G to compute their action matrices on N
    for g in list do
        Add(want, Checkginv_C4xC4(g, N));
    od;

    # Compute determinants of all matrices and reduce them modulo 4
    check := List(want, Determinant);
    check := List(check, i -> i mod 4);
    
    # Identify unique determinant values
    check := Set(check);

    # Return 1 if the only unique determinant is 1, indicating G-invariance
    if check = [1] then
        return 1;
    else
        return 0;;
    fi;
end;


# Arguments: N (subgroup isomorphic to C4xC4), g, h (elements of G)
# Purpose: Calculates the element eta(g, h) within the subgroup N for C4 x C4
Eta_C4xC4 := function(N, g, h)
    local gen1, gen2, mat1, mat2, mat3, k, l, m, n, a, b, c, d, p, q, r, s, check1, check2, want1, want2;

    # Extract the basis generators for N
    gen1 := C4xC4GeneratorsOfSubgroup(N)[1];
    gen2 := C4xC4GeneratorsOfSubgroup(N)[2];

    # Obtain 2x2 conjugation matrices in Z/4Z
    mat1 := Checkginv_C4xC4(g, N);
    mat2 := Checkginv_C4xC4(h, N);
    mat3 := Checkginv_C4xC4(g * h, N);

    # Coefficients for g
    k := mat1[1][1]; l := mat1[1][2];
    m := mat1[2][1]; n := mat1[2][2];

    # Coefficients for h
    a := mat2[1][1]; b := mat2[1][2];
    c := mat2[2][1]; d := mat2[2][2];

    # Coefficients for g*h
    p := mat3[1][1]; q := mat3[1][2];
    r := mat3[2][1]; s := mat3[2][2];

    # Algebraic transition formulas
    check1 := -k*m - a*c*k^2 - b*d*m^2 - 2*b*c*k*m + p*r;
    check2 := -l*n - a*c*l^2 - b*d*n^2 - 2*b*c*l*n + q*s;

    # Exponent calculation (halving and reducing mod 4)
    want1 := check1 / 2;
    want2 := check2 / 2;

    want1 := want1 mod 4;
    want2 := want2 mod 4;

    # Return the actual group element in N
    return gen1^want1 * gen2^want2; 
end;


# Arguments: G (a group), g (an element of G)
# Purpose: Returns the index of element g within the set of all elements of G
PickupElementNumber := function(G, g)
    local elist, i, want;
    
    # Generate the ordered list of all elements in the group
    elist := Elements(G);
    
    # Iterate through the first 64 elements to find a match
    for i in [1..64] do
        if g = elist[i] then
            want := i;
        fi;
    od;
    
    return want;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C2xC2), g, h (elements of G)
# Purpose: Computes the relation between lifted elements f[g], f[h], and f[eta*g*h]
GomegaRelationsC2xC2 := function(G, N, g, h)
    local m1, m2, m3, Eta, want, product;

    # 1. Calculate the eta element in the subgroup N
    Eta := Eta_C2xC2(N, g, h);

    # 2. Determine the "corrected" product in G using the eta factor
    product := Eta * g * h;

    # 3. Identify the indices (positions) of g, h, and the product in the group G
    m1 := PickupElementNumber(G, g);
    m2 := PickupElementNumber(G, h);
    m3 := PickupElementNumber(G, product);

    # 4. Formulate the relation: f[product] * f[h]^-1 * f[g]^-1
    # This corresponds to the identity: f[g] * f[h] = f[Eta * g * h]
    want := f[m3] * f[m2]^-1 * f[m1]^-1;

    return want;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C2xC2)
# Purpose: Generates the full set of relations for the group extension
AllGomegaRelationsC2xC2 := function(G, N)
    local list, relation, g, h, elements_G;

    list := [];
    elements_G := Elements(G); # Pre-computing elements for efficiency

    for g in elements_G do
        for h in elements_G do
            # Compute the relation: f[eta*g*h] * f[h]^-1 * f[g]^-1 = 1
            relation := GomegaRelationsC2xC2(G, N, g, h);
            Add(list, relation);
        od;
    od;
    
    return list;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C2xC2)
# Purpose: Generates all multiplication relations plus the order relations for the subgroup N
FinalAllGomegaRelationsC2xC2 := function(G, N)
    local want, element10, element01, number1, number2;

    # 1. Get the 4,096 multiplication relations based on the cocycle eta
    want := AllGomegaRelationsC2xC2(G, N);

    # 2. Identify the specific elements in G that form the basis of N
    element10 := C2xC2GeneratorsOfSubgroup(N)[1];
    element01 := C2xC2GeneratorsOfSubgroup(N)[2];

    # 3. Find their corresponding indices in the generator list f
    number1 := PickupElementNumber(G, element10);
    number2 := PickupElementNumber(G, element01);

    # 4. Add the order-2 relations (involutions) for these basis elements
    # This forces f[number1]^2 = 1 and f[number2]^2 = 1 in the quotient group
    Add(want, f[number1]^2);
    Add(want, f[number2]^2);

    return want;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C4xC4), g, h (elements of G)
# Purpose: Computes the relation between lifted elements f[g], f[h], and f[eta*g*h] for C4 x C4
GomegaRelationsC4xC4 := function(G, N, g, h)
    local m1, m2, m3, Eta, want, product;

    # 1. Calculate the eta element specifically for C4 x C4
    # This uses the check1/check2 logic and halving division previously defined
    Eta := Eta_C4xC4(N, g, h);

    # 2. Compute the product in G modified by the cocycle value
    product := Eta * g * h;

    # 3. Identify indices of g, h, and the modified product
    m1 := PickupElementNumber(G, g);
    m2 := PickupElementNumber(G, h);
    m3 := PickupElementNumber(G, product);

    # 4. Create the relation: f[product] = f[g] * f[h]
    # Represented as: f[m3] * f[m2]^-1 * f[m1]^-1 = 1
    want := f[m3] * f[m2]^-1 * f[m1]^-1;

    return want;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C4xC4)
# Purpose: Generates the full set of 4,096 multiplication relations for the extension
AllGomegaRelationsC4xC4 := function(G, N)
    local list, relation, g, h, elements_G;

    list := [];
    elements_G := Elements(G); # Pre-calculating for speed

    for g in elements_G do
        for h in elements_G do
            # Compute the relation based on the C4xC4 cocycle
            relation := GomegaRelationsC4xC4(G, N, g, h);
            Add(list, relation);
        od;
    od;
    
    return list;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C4xC4)
# Purpose: Generates multiplication relations and enforces the order-4 constraint on N
FinalAllGomegaRelationsC4xC4 := function(G, N)
    local want, element10, element01, number1, number2;

    # 1. Collect the 4,096 multiplication relations based on the C4xC4 cocycle
    want := AllGomegaRelationsC4xC4(G, N);

    # 2. Extract the basis generators (p, q) for the subgroup N
    element10 := C4xC4GeneratorsOfSubgroup(N)[1];
    element01 := C4xC4GeneratorsOfSubgroup(N)[2];

    # 3. Find the index positions of these generators within the group G
    number1 := PickupElementNumber(G, element10);
    number2 := PickupElementNumber(G, element01);

    # 4. Enforce the order of the generators: f[i]^4 = 1
    # This ensures that the elements in the kernel have the correct period
    Add(want, f[number1]^4);
    Add(want, f[number2]^4);

    return want;
end;


####################
#Conctruction of Gw#
####################


# Arguments: G (parent group), N (subgroup isomorphic to C2xC2)
# Purpose: Constructs the extension Gw, checks for isomorphisms, and returns a detailed status list
GwStructureC2xC2 := function(G, N)
    local Gw, Gfinal, orderlist, listnumber, v, isomorphicnumber;

    # 1. Get the signature of the group based on the orders of its elements
    orderlist := OrderListGroup(G);
    
    # 2. Determine how many groups of order 64 share this specific order profile
    listnumber := Number(SmallCategory(64, orderlist));

    # 3. Check if the conjugation action of G on N is valid (G-invariant)
    if CheckGinv_C2xC2Cal(G, N) = 1 then
        
        # Construct the extension group using the previously defined 4,098 relations
        # Note: 'Free64' must be defined globally as FreeGroup(64)
        Gw := Free64 / FinalAllGomegaRelationsC2xC2(G, N);
        
        # Compare the new group Gw with the original group G
        if IsIsomorphicGroup(G, Gw) then 
            Gfinal := G;
        else 
            Gfinal := Gw; 
        fi;
        
        # 4. Identify which specific group in your 'SmallCategory' Gw corresponds to
        isomorphicnumber := 1; # Default initialization
        for v in [2..listnumber] do
            if IsIsomorphicGroup(Gw, SmallCategoryCal(64, orderlist)[v]) then
                isomorphicnumber := v;
            fi;
        od;

        # Return comprehensive data about the extension
        return [
            C2xC2GeneratorsOfSubgroup(N), 
            StructureDescription(N), 
            "G-inv", 
            IsIsomorphicGroup(G, Gw), 
            isomorphicnumber - 1, 
            StructureDescription(Gfinal)
        ];

    else
        # If the conjugation action doesn't preserve the structure of N
        return [
            C2xC2GeneratorsOfSubgroup(N), 
            StructureDescription(N), 
            "not G-inv"
        ];
    fi;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C4xC4)
# Purpose: Builds the extension Gw, identifies its structure, and finds its classification ID
GwStructureC4xC4 := function(G, N)
    local Gw, Gfinal, orderlist, listnumber, v, isomorphicnumber;

    # 1. Profile the group based on element orders
    orderlist := OrderListGroup(G);
    listnumber := Number(SmallCategory(64, orderlist));

    # 2. Verify G-invariance for the C4xC4 subgroup
    if CheckGinv_C4xC4Cal(G, N) = 1 then
        
        # 3. Construct the extension group Gw from the FreeGroup 'Free64'
        # Uses the 4,098 relations (multiplication + order-4 constraints)
        Gw := Free64 / FinalAllGomegaRelationsC4xC4(G, N);
        
        # 4. Check if the extension resulted in a structure isomorphic to the original G
        if IsIsomorphicGroup(G, Gw) then 
            Gfinal := G;
        else 
            Gfinal := Gw; 
        fi;

        # 5. Search your category database to find the specific group ID
        isomorphicnumber := 1; 
        for v in [2..listnumber] do
            if IsIsomorphicGroup(Gw, SmallCategoryCal(64, orderlist)[v]) then
                isomorphicnumber := v;
            fi;
        od;
        
        # Return results: [Generators, N-Structure, Status, Is-Self-Ext?, ID, Gw-Structure]
        return [
            C4xC4GeneratorsOfSubgroup(N), 
            StructureDescription(N), 
            "G-inv", 
            IsIsomorphicGroup(G, Gw), 
            isomorphicnumber - 1, 
            StructureDescription(Gfinal)
        ];

    else
        # Return failure status if G does not act as an automorphism on N
        return [
            C4xC4GeneratorsOfSubgroup(N), 
            StructureDescription(N), 
            "not G-inv"
        ];
    fi;
end;


# Argument: G (The group to be analyzed, e.g., Gizumikosaki)
# Purpose: Iterates through subgroups and applies the appropriate extension-classification function
GwStructure := function(G)
    local N;

    # 1. Trivial Case: If the group is already Abelian, the extension analysis is usually redundant
    if IsAbelian(G) then 
        Print(G, " is Abel.");
    else
        # 2. Iterate through the pre-filtered list of subgroups
        for N in ObtainedSubgroups(G) do

            # Case A: Subgroup is isomorphic to C4 x C4 (Order 16)
            if IsIsomorphicGroup(N, C4xC4) then
                Print(GwStructureC4xC4(G, N), "\n");

            # Case B: Subgroup is isomorphic to C2 x C2 (Order 4)
            elif IsIsomorphicGroup(N, C2xC2) then
                Print(GwStructureC2xC2(G, N), "\n");

            # Case C: Any other subgroup type (Order 8, 16, etc. that aren't C4xC4/C2xC2)
            else
                Print([N, StructureDescription(N)], "\n");
            fi;
        od;
    fi;
end;


# Argument: list (A list representing an order profile, e.g., [1, 31, 16, ...])
# Purpose: Iterates through all groups of order 64 matching the profile and runs the full diagnostic
GwStructureCategory := function(list)
    local checkgroups, lastnumber, i;
    
    # 1. Retrieve the specific subset of groups of order 64 matching the input signature
    checkgroups := SmallCategoryCal(64, list);
    lastnumber := Number(checkgroups);
    
    # 2. Iterate through the candidate groups (starting from index 2)
    for i in [2..lastnumber] do
        
        # Display the human-readable structure of the current group G
        Print(StructureDescription(checkgroups[i]), "\n");

        # Output the full 64x64 multiplication table for manual inspection
        # Note: This will generate a very large amount of text in the console!
        ShowMultiplicationTable(GeneratorsOfGroup(checkgroups[i]));

        # Run the subgroup analysis (Check G-inv, calculate Eta, and classify Gw)
        GwStructure(checkgroups[i]);
        
        Print("\n\n");
    od;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C2xC2)
# Purpose: Returns a list formatted as a LaTeX table row for research documentation
GwStructureC2xC2ForTeX := function(G, N)
    local Gw, Gfinal, orderlist, listnumber, v, isomorphicnumber, checkmark;

    orderlist := OrderListGroup(G);
    listnumber := Number(SmallCategory(64, orderlist));

    # 1. Check for G-invariance
    if CheckGinv_C2xC2Cal(G, N) = 1 then
        # 2. Construct the extension
        Gw := Free64 / FinalAllGomegaRelationsC2xC2(G, N);
        
        # 3. Check if the extension is 'trivial' (isomorphic to G)
        if IsIsomorphicGroup(G, Gw) then 
            Gfinal := G; 
            checkmark := "〇"; # Success/Self-isomorphic
        else 
            Gfinal := Gw; 
            checkmark := "×"; # Resulted in a different group structure
        fi;
        
        # 4. Find the ID in your category
        isomorphicnumber := 1;
        for v in [2..listnumber] do
            if IsIsomorphicGroup(Gw, SmallCategoryCal(64, orderlist)[v]) then
                isomorphicnumber := v;
            fi;
        od;

        # Return a LaTeX-ready list of strings
        return [
            "$", C2xC2GeneratorsOfSubgroup(N), "$", # Col 1: Basis elements in math mode
            " & ", "$C_2\\times C_2$",             # Col 2: Kernel structure
            " & ", "〇",                             # Col 3: G-invariant status
            " & ", checkmark,                      # Col 4: Isomorphism to G
            " & ", isomorphicnumber - 1,           # Col 5: Category ID
            " \\\\ \\hline "                       # End of row and horizontal line
        ];

    else
        # Row for non-G-invariant subgroups
        return [
            "$", C2xC2GeneratorsOfSubgroup(N), "$",
            " & ", "$C_2\\times C_2$",
            " & ", "×",                             # Not G-invariant
            " & ", "-",                             # Not applicable
            " & ", "-",                             # Not applicable
            " \\\\ \\hline"
        ];
    fi;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C4xC4)
# Purpose: Generates a LaTeX-formatted row for the C4 x C4 analysis results
GwStructureC4xC4ForTeX := function(G, N)
    local Gw, Gfinal, orderlist, listnumber, v, isomorphicnumber, checkmark;

    orderlist := OrderListGroup(G);
    listnumber := Number(SmallCategory(64, orderlist));

    # 1. Check if G induces a valid automorphism on N
    if CheckGinv_C4xC4Cal(G, N) = 1 then
        
        # 2. Build the extension Gw using the order-4 generators
        Gw := Free64 / FinalAllGomegaRelationsC4xC4(G, N);
        
        # 3. Determine if the extension is trivial (isomorphic to G)
        if IsIsomorphicGroup(G, Gw) then 
            Gfinal := G; 
            checkmark := "〇"; 
        else 
            Gfinal := Gw; 
            checkmark := "×"; 
        fi;
        
        # 4. Search for the classification ID in the order-profile category
        isomorphicnumber := 1;
        for v in [2..listnumber] do
            if IsIsomorphicGroup(Gw, SmallCategoryCal(64, orderlist)[v]) then
                isomorphicnumber := v;
            fi;
        od;

        # Return row: [Generators, Kernel Type, G-inv, Is-Self-Isom, ID]
        return [
            "$", C4xC4GeneratorsOfSubgroup(N), "$",
            " & ", "$C_4\\times C_4$",
            " & ", "〇", 
            " & ", checkmark, 
            " & ", isomorphicnumber - 1, 
            " \\\\ \\hline "
        ];

    else
        # Row for cases where the action is not G-invariant
        return [
            "$", C4xC4GeneratorsOfSubgroup(N), "$",
            " & ", "$C_4\\times C_4$",
            " & ", "×", 
            " & ", "-", 
            " & ", "-", 
            " \\\\ \\hline"
        ];
    fi;
end;


#Print(want[1],want[2],want[3],want[4],want[5],want[6],want[7],want[8],want[9],want[10],want[11],want[12],"\n");


# Argument: n (a group element)
# Purpose: Simplifies the identity element to the integer 1 for cleaner LaTeX output
ForTeX := function(n)
    if Order(n) = 1 then
        return 1;
    else
        return n;
    fi;
end;


# Argument: G (The group object)
# Purpose: Creates a 6x6 LaTeX multiplication table for the primary generators
GroupTableForTeX := function(G)
    local Ele1, Ele2, Ele3, Ele4, Ele5, Ele6;

    # Extract the first 6 generators
    Ele1 := GeneratorsOfGroup(G)[1];
    Ele2 := GeneratorsOfGroup(G)[2];
    Ele3 := GeneratorsOfGroup(G)[3];
    Ele4 := GeneratorsOfGroup(G)[4];
    Ele5 := GeneratorsOfGroup(G)[5];
    Ele6 := GeneratorsOfGroup(G)[6];

    return [
        " ", " & ", "$f1$", " & ", "$f2$", " & ", "$f3$", " & ", "$f4$", " & ", "$f5$", " & ", "$f6$", " \\\\ \\hline\\hline", "\n",
        "$f1$", " & ", "$", ForTeX(Ele1 * Ele1), "$", " & ", "$", ForTeX(Ele1 * Ele2), "$", " & ", "$", ForTeX(Ele1 * Ele3), "$", " & ", "$", ForTeX(Ele1 * Ele4), "$", " & ", "$", ForTeX(Ele1 * Ele5), "$", " & ", "$", ForTeX(Ele1 * Ele6), "$", " \\\\ \\hline", "\n",
        "$f2$", " & ", "$", ForTeX(Ele2 * Ele1), "$", " & ", "$", ForTeX(Ele2 * Ele2), "$", " & ", "$", ForTeX(Ele2 * Ele3), "$", " & ", "$", ForTeX(Ele2 * Ele4), "$", " & ", "$", ForTeX(Ele2 * Ele5), "$", " & ", "$", ForTeX(Ele2 * Ele6), "$", " \\\\ \\hline", "\n",
        "$f3$", " & ", "$", ForTeX(Ele3 * Ele1), "$", " & ", "$", ForTeX(Ele3 * Ele2), "$", " & ", "$", ForTeX(Ele3 * Ele3), "$", " & ", "$", ForTeX(Ele3 * Ele4), "$", " & ", "$", ForTeX(Ele3 * Ele5), "$", " & ", "$", ForTeX(Ele3 * Ele6), "$", " \\\\ \\hline", "\n",
        "$f4$", " & ", "$", ForTeX(Ele4 * Ele1), "$", " & ", "$", ForTeX(Ele4 * Ele2), "$", " & ", "$", ForTeX(Ele4 * Ele3), "$", " & ", "$", ForTeX(Ele4 * Ele4), "$", " & ", "$", ForTeX(Ele4 * Ele5), "$", " & ", "$", ForTeX(Ele4 * Ele6), "$", " \\\\ \\hline", "\n",
        "$f5$", " & ", "$", ForTeX(Ele5 * Ele1), "$", " & ", "$", ForTeX(Ele5 * Ele2), "$", " & ", "$", ForTeX(Ele5 * Ele3), "$", " & ", "$", ForTeX(Ele5 * Ele4), "$", " & ", "$", ForTeX(Ele5 * Ele5), "$", " & ", "$", ForTeX(Ele5 * Ele6), "$", " \\\\ \\hline", "\n",
        "$f6$", " & ", "$", ForTeX(Ele6 * Ele1), "$", " & ", "$", ForTeX(Ele6 * Ele2), "$", " & ", "$", ForTeX(Ele6 * Ele3), "$", " & ", "$", ForTeX(Ele6 * Ele4), "$", " & ", "$", ForTeX(Ele6 * Ele5), "$", " & ", "$", ForTeX(Ele6 * Ele6), "$", " \\\\ \\hline", "\n"
    ];
end;


# Argument: list (The order profile to search for in the category of order-64 groups)
# Purpose: Generates a complete LaTeX-ready report for an entire family of groups
GwStructureCategoryForTeX := function(list)
    local checkgroups, lastnumber, i, k, N, cc;

    # 1. Retrieve the candidate groups
    checkgroups := SmallCategoryCal(64, list);
    lastnumber := Number(checkgroups);

    # 2. Iterate through each group in the category (starting from index 2)
    for i in [2..lastnumber] do

        # Print the Group Name as a section header
        Print(StructureDescription(checkgroups[i]), "\n");

        # 3. Print the 6x6 Multiplication Table in LaTeX format
        for k in GroupTableForTeX(checkgroups[i]) do
            Print(k);
        od;

        Print("\n");

        # 4. Skip analysis if the group is Abelian
        if IsAbelian(checkgroups[i]) then 
            Print(checkgroups[i], " is Abel.");
        else
            # 5. Analyze each subgroup in the pre-filtered 'ObtainedSubgroups' list
            for N in ObtainedSubgroups(checkgroups[i]) do

                if IsIsomorphicGroup(N, C2xC2) then
                    # Generate row for C2 x C2
                    cc := GwStructureC2xC2ForTeX(checkgroups[i], N);
                    # Print all 12 elements of the LaTeX row list
                    for k in [1..12] do Print(cc[k]); od;
                    Print("\n");

                elif IsIsomorphicGroup(N, C4xC4) then
                    # Generate row for C4 x C4
                    cc := GwStructureC4xC4ForTeX(checkgroups[i], N);
                    for k in [1..12] do Print(cc[k]); od;
                    Print("\n");

                else 
                    # Placeholder row for other types (e.g., C2^4)
                    Print(
                        "$", GeneratorsOfGroup(N), "$",
                        " & ", "$C_2\\times C_2\\times C_2\\times C_2$",
                        " & ", " ", " & ", " ", " & ", " ", " \\\\ \\hline ", "\n"
                    );
                fi;
            od;
            
            Print("\n\n");
        fi;
    od;
end;


# Argument: N (a subgroup isomorphic to C2 x C2 x C2 x C2)
# Purpose: Identifies the four elements in N corresponding to the standard generators of C2^4
C2xC2xC2xC2GeneratorsOfSubgroup := function(N)
    local iso, gen1, gen2, gen3, gen4;
    
    # Compute the isomorphism between the reference C2^4 group and the subgroup N
    iso := IsomorphismGroups(C2xC2xC2xC2, N);
    
    # Map the four reference generators (groupc, groupd, groupe, groupf) to N
    gen1 := Image(iso, groupc);
    gen2 := Image(iso, groupd);
    gen3 := Image(iso, groupe);
    gen4 := Image(iso, groupf);
    
    # Return the basis for the 4-dimensional vector space over GF(2)
    return [gen1, gen2, gen3, gen4];
end;


# Arguments: gen1, gen2, gen3, gen4 (basis of N), g (conjugating element)
# Purpose: Each function finds the coordinates [x1, x2, x3, x4] for the image of 
#          the corresponding generator under conjugation by g.

# Image of gen1
RightactionC2xC2xC2xC2_1 := function(gen1, gen2, gen3, gen4, g)
    local x1, x2, x3, x4, list1;
    for x1 in [0, 1] do for x2 in [0, 1] do for x3 in [0, 1] do for x4 in [0, 1] do
        if g * gen1 * g^-1 = gen1^x1 * gen2^x2 * gen3^x3 * gen4^x4 then
            list1 := [x1, x2, x3, x4];
        fi;
    od; od; od; od;
    return list1;
end;

# Image of gen2
RightactionC2xC2xC2xC2_2 := function(gen1, gen2, gen3, gen4, g)
    local x1, x2, x3, x4, list1;
    for x1 in [0, 1] do for x2 in [0, 1] do for x3 in [0, 1] do for x4 in [0, 1] do
        if g * gen2 * g^-1 = gen1^x1 * gen2^x2 * gen3^x3 * gen4^x4 then
            list1 := [x1, x2, x3, x4];
        fi;
    od; od; od; od;
    return list1;
end;

# Image of gen3
RightactionC2xC2xC2xC2_3 := function(gen1, gen2, gen3, gen4, g)
    local x1, x2, x3, x4, list1;
    for x1 in [0, 1] do for x2 in [0, 1] do for x3 in [0, 1] do for x4 in [0, 1] do
        if g * gen3 * g^-1 = gen1^x1 * gen2^x2 * gen3^x3 * gen4^x4 then
            list1 := [x1, x2, x3, x4];
        fi;
    od; od; od; od;
    return list1;
end;

# Image of gen4
RightactionC2xC2xC2xC2_4 := function(gen1, gen2, gen3, gen4, g)
    local x1, x2, x3, x4, list1;
    for x1 in [0, 1] do for x2 in [0, 1] do for x3 in [0, 1] do for x4 in [0, 1] do
        if g * gen4 * g^-1 = gen1^x1 * gen2^x2 * gen3^x3 * gen4^x4 then
            list1 := [x1, x2, x3, x4];
        fi;
    od; od; od; od;
    return list1;
end;


# Arguments: g (element of G), N (subgroup isomorphic to C2^4)
# Purpose: Constructs a 4x4 matrix over GF(2) representing the conjugation action of g on N
Checkginv_C2xC2xC2xC2 := function(g, N)
    local wantlist, gen1, gen2, gen3, gen4, gens;
    
    # Extract the basis generators for the order-16 elementary abelian subgroup
    gens := C2xC2xC2xC2GeneratorsOfSubgroup(N);
    gen1 := gens[1];
    gen2 := gens[2];
    gen3 := gens[3];
    gen4 := gens[4];
    
    # Assemble the matrix rows by finding the coordinates of each g*gen_i*g^-1
    wantlist := [
        RightactionC2xC2xC2xC2_1(gen1, gen2, gen3, gen4, g),
        RightactionC2xC2xC2xC2_2(gen1, gen2, gen3, gen4, g),
        RightactionC2xC2xC2xC2_3(gen1, gen2, gen3, gen4, g),
        RightactionC2xC2xC2xC2_4(gen1, gen2, gen3, gen4, g)
    ];
    
    return wantlist;
end;


# Arguments: g (element), i, j (indices), N (subgroup), k (index for the reference matrix)
# Purpose: Verifies if the conjugation action Ag preserves the structure defined by mat[i][j]
#          using 2x2 minors of the action matrix Ag.
Checkginv_C2xC2xC2xC2_ForElement := function(g, i, j, N, k)
    local mat, r12, r13, r14, r23, r24, r34, Ag, ram12, ram13, ram14, ram23, ram24, ram34;
    
    # 1. Retrieve and prepare the reference structure matrix
    mat := MatrixesC2xC2xC2xC2[k];
    mat := ChangeMatrix(mat); # Assuming this handles formatting/normalization
    
    # 2. Extract specific structure constants (likely related to N's relations)
    r12 := mat[1][2]; r13 := mat[1][3]; r14 := mat[1][4];
    r23 := mat[2][3]; r24 := mat[2][4]; r34 := mat[3][4];
    
    # 3. Compute the 4x4 conjugation matrix for g acting on N
    Ag := Checkginv_C2xC2xC2xC2(g, N);
    
    # 4. Calculate the 'ram' values using 2x2 minors of Ag
    # These represent the induced action on the second exterior power Λ²(N)
    ram12 := r12^(Ag[1][i]*Ag[2][j] - Ag[1][j]*Ag[2][i]);
    ram13 := r13^(Ag[1][i]*Ag[3][j] - Ag[1][j]*Ag[3][i]);
    ram14 := r14^(Ag[1][i]*Ag[4][j] - Ag[1][j]*Ag[4][i]);
    ram23 := r23^(Ag[2][i]*Ag[3][j] - Ag[2][j]*Ag[3][i]);
    ram24 := r24^(Ag[2][i]*Ag[4][j] - Ag[2][j]*Ag[4][i]);
    ram34 := r34^(Ag[3][i]*Ag[4][j] - Ag[3][j]*Ag[4][i]);
    
    # 5. Check if the product of these transformed constants matches the target entry
    if ram12 * ram13 * ram14 * ram23 * ram24 * ram34 = mat[i][j] then
        return 1;
    else
        return 0;
    fi;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C2^4), k (structure matrix index)
# Purpose: Returns 1 if the entire group G preserves the N-structure, else 0
CheckGinv_C2xC2xC2xC2 := function(G, N, k)
    local g, finallist, num12, num13, num14, num23, num24, num34;
    
    finallist := [];
    
    # Iterate through all elements of G to verify structural consistency
    for g in G do
        # Check the 6 independent relations in the second exterior power Λ²(N)
        num12 := Checkginv_C2xC2xC2xC2_ForElement(g, 1, 2, N, k);
        num13 := Checkginv_C2xC2xC2xC2_ForElement(g, 1, 3, N, k);
        num14 := Checkginv_C2xC2xC2xC2_ForElement(g, 1, 4, N, k);
        num23 := Checkginv_C2xC2xC2xC2_ForElement(g, 2, 3, N, k);
        num24 := Checkginv_C2xC2xC2xC2_ForElement(g, 2, 4, N, k);
        num34 := Checkginv_C2xC2xC2xC2_ForElement(g, 3, 4, N, k);
        
        # Collect the results (1 for pass, 0 for fail)
        Append(finallist, [num12, num13, num14, num23, num24, num34]);
    od;
    
    # Identify unique result values
    finallist := Set(finallist);
    
    # Return 1 only if every check for every element returned 1
    if finallist = [1] then
        return 1;
    else
        return 0;
    fi;
end;


# Arguments: n (element of N), N (subgroup isomorphic to C2^4)
# Purpose: Returns the coordinate vector [x1, x2, x3, x4] such that 
#          n = gen1^x1 * gen2^x2 * gen3^x3 * gen4^x4
C2xC2xC2xC2GeneratorsRepn := function(n, N)
    local gen1, gen2, gen3, gen4, x1, x2, x3, x4, list1;

    # Retrieve the basis generators for N
    gen1 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[1];
    gen2 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[2];
    gen3 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[3];
    gen4 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[4];

    # Brute-force search through all 16 elements of the subgroup
    for x1 in [0, 1] do
        for x2 in [0, 1] do
            for x3 in [0, 1] do
                for x4 in [0, 1] do
                    if n = gen1^x1 * gen2^x2 * gen3^x3 * gen4^x4 then
                        list1 := [x1, x2, x3, x4];
                    fi;
                od;
            od;
        od;
    od;
    
    return list1;
end;


# Arguments: a, b (elements of N), N (subgroup), k (index for structure matrix)
# Purpose: Calculates the 2-cocycle value omega(a, b) based on the matrix k
2Cocycle_C2xC2xC2xC2 := function(a, b, N, k)
    local mat, r12, r13, r14, r23, r24, r34, elementa, elementb, want;

    # 1. Retrieve the structural constants from the matrix list
    mat := MatrixesC2xC2xC2xC2[k];
    mat := ChangeMatrix(mat);

    r12 := mat[1][2]; r13 := mat[1][3]; r14 := mat[1][4];
    r23 := mat[2][3]; r24 := mat[2][4]; r34 := mat[3][4];

    # 2. Convert group elements a and b into their F2-vector representations
    elementa := C2xC2xC2xC2GeneratorsRepn(a, N);
    elementb := C2xC2xC2xC2GeneratorsRepn(b, N);

    # 3. Calculate the cocycle using the bilinear form logic:
    # omega(a, b) = Product of r_ij^(a_i * b_j) for i < j
    want := 
        r12^(elementa[1] * elementb[2]) *
        r13^(elementa[1] * elementb[3]) *
        r14^(elementa[1] * elementb[4]) *
        r23^(elementa[2] * elementb[3]) *
        r24^(elementa[2] * elementb[4]) *
        r34^(elementa[3] * elementb[4]);

    return want;
end;


# Arguments: mat (a 4x4 matrix), list (a vector [x1, x2, x3, x4])
# Purpose: Computes the matrix-vector product M * v to determine the transformed coordinates
MatrixCalC2xC2xC2xC2 := function(mat, list)
    local wantlist;

    # 1. Convert the row vector into a column vector (4x1 matrix) for proper multiplication
    list := TransposedMat([list]);

    # 2. Perform the matrix multiplication: v' = M * v
    list := mat * list;

    # 3. Extract the resulting values from the column matrix back into a simple list
    wantlist := [list[1][1], list[2][1], list[3][1], list[4][1]];

    return wantlist;
end;


# Arguments: g (element of G), a, b (elements of N), N (subgroup), k (matrix index)
# Purpose: Calculates the ratio ω(gag⁻¹, gbg⁻¹) / ω(a, b) to check G-invariance
DellXi_C2xC2xC2xC2 := function(g, a, b, N, k)
    local elementa, elementb, Ag, Aga, Agb, gen1, gen2, gen3, gen4, want;

    # 1. Map group elements a and b to their F2-vector coordinates
    elementa := C2xC2xC2xC2GeneratorsRepn(a, N);
    elementb := C2xC2xC2xC2GeneratorsRepn(b, N);

    # 2. Get the 4x4 transformation matrix Ag for the element g
    Ag := Checkginv_C2xC2xC2xC2(g, N);

    # 3. Calculate the new coordinates: v' = Ag * v
    Aga := MatrixCalC2xC2xC2xC2(Ag, elementa);
    Agb := MatrixCalC2xC2xC2xC2(Ag, elementb);

    # 4. Reconstruct the actual group elements in N from the new coordinates
    # These represent gag⁻¹ and gbg⁻¹
    gen1 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[1];
    gen2 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[2];
    gen3 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[3];
    gen4 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[4];

    Aga := gen1^Aga[1] * gen2^Aga[2] * gen3^Aga[3] * gen4^Aga[4];
    Agb := gen1^Agb[1] * gen2^Agb[2] * gen3^Agb[3] * gen4^Agb[4];

    # 5. Compute the ratio (or difference) of the 2-cocycle values
    # In G-invariant cases, this value should be 1
    want := 2Cocycle_C2xC2xC2xC2(Aga, Agb, N, k) / 2Cocycle_C2xC2xC2xC2(a, b, N, k);

    return want;
end;


# Arguments: g (element of G), N (subgroup isomorphic to C2^4), k (matrix index)
# Purpose: Generates a 4x4 matrix representing the "deviation" of the 2-cocycle 
#          under the conjugation action of g.
DellXiList_C2xC2xC2xC2 := function(g, N, k)
    local gen1, gen2, gen3, gen4, wantmat;

    # 1. Retrieve the basis generators of N
    gen1 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[1];
    gen2 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[2];
    gen3 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[3];
    gen4 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[4];

    # 2. Construct the matrix where entry (i, j) is the invariance check for (gen_i, gen_j)
    # Each entry computes: omega(g*gen_i*g^-1, g*gen_j*g^-1) / omega(gen_i, gen_j)
    wantmat := [
        [DellXi_C2xC2xC2xC2(g, gen1, gen1, N, k), DellXi_C2xC2xC2xC2(g, gen1, gen2, N, k),
         DellXi_C2xC2xC2xC2(g, gen1, gen3, N, k), DellXi_C2xC2xC2xC2(g, gen1, gen4, N, k)],
        
        [DellXi_C2xC2xC2xC2(g, gen2, gen1, N, k), DellXi_C2xC2xC2xC2(g, gen2, gen2, N, k),
         DellXi_C2xC2xC2xC2(g, gen2, gen3, N, k), DellXi_C2xC2xC2xC2(g, gen2, gen4, N, k)],
        
        [DellXi_C2xC2xC2xC2(g, gen3, gen1, N, k), DellXi_C2xC2xC2xC2(g, gen3, gen2, N, k),
         DellXi_C2xC2xC2xC2(g, gen3, gen3, N, k), DellXi_C2xC2xC2xC2(g, gen3, gen4, N, k)],
        
        [DellXi_C2xC2xC2xC2(g, gen4, gen1, N, k), DellXi_C2xC2xC2xC2(g, gen4, gen2, N, k),
         DellXi_C2xC2xC2xC2(g, gen4, gen3, N, k), DellXi_C2xC2xC2xC2(g, gen4, gen4, N, k)]
    ];

    return wantmat;
end;


# Arguments: g (element of G), N (subgroup C2^4), a (element of N), k (matrix index)
# Purpose: Computes a phase factor xi_g(a) using the primitive 4th root of unity E(4)
Xi_C2xC2xC2xC2 := function(g, N, a, k)
    local DellXi, want, elementa, i, j;

    want := 1;
    
    # 1. Get the 4x4 matrix of cocycle deviations for the element g
    DellXi := DellXiList_C2xC2xC2xC2(g, N, k);

    # 2. Convert the element a into its F2-vector representation [x1, x2, x3, x4]
    elementa := C2xC2xC2xC2GeneratorsRepn(a, N);

    # 3. Iterate through the upper triangular part of the deviation matrix
    for i in [1..4] do
        for j in [1..4] do
            # If the cocycle flipped sign (-1) for the pairing of generators i and j
            if i <= j and DellXi[i][j] = -1 then 
                
                # Multiply by a power of the complex unit i (E(4) in GAP)
                # The exponent is -1 only if both components i and j are present in a
                want := want * E(4)^(-elementa[i] * elementa[j]);
            fi;
        od;
    od;

    return want;
end;


# Arguments: g, h (elements of G), N (subgroup isomorphic to C2^4), k (matrix index)
# Purpose: Calculates the 2-cocycle element eta(g, h) in N using the coboundary of xi
Eta_C2xC2xC2xC2 := function(g, h, N, k)
    local gen1, gen2, gen3, gen4, e1, e2, e3, e4, Ag, Age1, Age2, Age3, Age4, eta1, eta2, eta3, eta4;

    # 1. Retrieve generators of N
    gen1 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[1];
    gen2 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[2];
    gen3 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[3];
    gen4 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[4];

    # 2. Map generators to coordinate vectors
    e1 := C2xC2xC2xC2GeneratorsRepn(gen1, N);
    e2 := C2xC2xC2xC2GeneratorsRepn(gen2, N);
    e3 := C2xC2xC2xC2GeneratorsRepn(gen3, N);
    e4 := C2xC2xC2xC2GeneratorsRepn(gen4, N);

    # 3. Compute the action of g on these generators
    Ag := Checkginv_C2xC2xC2xC2(g, N);

    Age1 := MatrixCalC2xC2xC2xC2(Ag, e1);
    Age2 := MatrixCalC2xC2xC2xC2(Ag, e2);
    Age3 := MatrixCalC2xC2xC2xC2(Ag, e3);
    Age4 := MatrixCalC2xC2xC2xC2(Ag, e4);

    # 4. Reconstruct images as group elements
    Age1 := gen1^Age1[1] * gen2^Age1[2] * gen3^Age1[3] * gen4^Age1[4];
    Age2 := gen1^Age2[1] * gen2^Age2[2] * gen3^Age2[3] * gen4^Age2[4];
    Age3 := gen1^Age3[1] * gen2^Age3[2] * gen3^Age3[3] * gen4^Age3[4];
    Age4 := gen1^Age4[1] * gen2^Age4[2] * gen3^Age4[3] * gen4^Age4[4];

    # 5. Calculate the coboundary components eta_i = (xi_g * xi_h) / xi_gh
    # Mapping logic: -1 -> 1 (exponent), 1 -> 0 (exponent) for F2 logic
    
    # Generator 1
    eta1 := Xi_C2xC2xC2xC2(g, N, gen1, k) * Xi_C2xC2xC2xC2(h, N, Age1, k) / Xi_C2xC2xC2xC2(g * h, N, gen1, k);
    if eta1 = -1 then eta1 := 1; elif eta1 = 1 then eta1 := 0; fi;

    # Generator 2
    eta2 := Xi_C2xC2xC2xC2(g, N, gen2, k) * Xi_C2xC2xC2xC2(h, N, Age2, k) / Xi_C2xC2xC2xC2(g * h, N, gen2, k);
    if eta2 = -1 then eta2 := 1; elif eta2 = 1 then eta2 := 0; fi;

    # Generator 3
    eta3 := Xi_C2xC2xC2xC2(g, N, gen3, k) * Xi_C2xC2xC2xC2(h, N, Age3, k) / Xi_C2xC2xC2xC2(g * h, N, gen3, k);
    if eta3 = -1 then eta3 := 1; elif eta3 = 1 then eta3 := 0; fi;

    # Generator 4
    eta4 := Xi_C2xC2xC2xC2(g, N, gen4, k) * Xi_C2xC2xC2xC2(h, N, Age4, k) / Xi_C2xC2xC2xC2(g * h, N, gen4, k);
    if eta4 = -1 then eta4 := 1; elif eta4 = 1 then eta4 := 0; fi;

    # 6. Final product in N
    return gen1^eta1 * gen2^eta2 * gen3^eta3 * gen4^eta4;
end;


# Arguments: G (parent group), N (subgroup C2^4), k (matrix index)
# Purpose: Prints the 4x4 deviation matrices for each coset representative of G/N
AllDellXiList_C2xC2xC2xC2 := function(G, N, k)
    local Coset, cos, repn, mat;

    # 1. Get the transversal (one representative for each element in the quotient G/N)
    Coset := RightCosets(G, N);

    for cos in Coset do
        # 2. Extract the representative g
        repn := Representative(cos);
        
        # 3. Compute the 4x4 sign-flip matrix for this specific action
        mat := DellXiList_C2xC2xC2xC2(repn, N, k);

        # 4. Format the output for easy reading in the GAP console
        Print(repn, ":");
        Print(
            "\n",
            " [", mat[1][1], " ", mat[1][2], " ", mat[1][3], " ", mat[1][4], "]\n",
            " [", mat[2][1], " ", mat[2][2], " ", mat[2][3], " ", mat[2][4], "]\n",
            " [", mat[3][1], " ", mat[3][2], " ", mat[3][3], " ", mat[3][4], "]\n",
            " [", mat[4][1], " ", mat[4][2], " ", mat[4][3], " ", mat[4][4], "]"
        );

        Print("\n\n");
    od;
end;


# Arguments: G (parent group), N (subgroup isomorphic to C2^4)
# Purpose: Scans all 28 structure matrices to find which ones are G-invariant
CheckGinvAll_C2xC2xC2xC2 := function(G, N)
    local list1;
    
    # 1. Map the G-invariance check over the indices 1 to 28
    # This checks every matrix in your 'MatrixesC2xC2xC2xC2' global list
    list1 := List([1..28], i -> CheckGinv_C2xC2xC2xC2(G, N, i));
    
    # 2. Return a list of 28 bits (e.g., [0, 0, 1, 0, ...])
    return list1;
end;


# Arguments: G (parent), N (subgroup), coset1/coset2 (G/N elements), k (matrix index)
# Purpose: Generates the multiplication relations for the extension group Gw
GomegaRelationsC2xC2xC2xC2 := function(G, N, coset1, coset2, k)
    local m0, m1, m2, m3, Eta, want, wantlist, g, h, rep1, rep2;

    wantlist := [];

    # 1. Select the transversal (representatives) for the two cosets
    rep1 := Representative(coset1);
    rep2 := Representative(coset2);

    # 2. Compute the 2-cocycle "twist" for this specific pair of representatives
    # Eta is an element in N
    Eta := Eta_C2xC2xC2xC2(rep1, rep2, N, k);

    # 3. Find the integer index of the cocycle element in your group list
    m0 := PickupElementNumber(G, Eta);

    # 4. Iterate through every element in the two cosets to define the full multiplication
    for g in coset1 do
        for h in coset2 do

            # Get the indices for elements g, h, and their product g*h
            m1 := PickupElementNumber(G, g);
            m2 := PickupElementNumber(G, h);
            m3 := PickupElementNumber(G, g * h);

            # 5. Define the relation in the FreeGroup: f[m0] * f[m3] = f[m1] * f[m2]
            # Formatted as: f[m0] * f[m3] * f[m2]^-1 * f[m1]^-1 = Identity
            want := f[m0] * f[m3] * f[m2]^-1 * f[m1]^-1;

            Add(wantlist, want);
        od;
    od;

    return wantlist;
end;


# Arguments: G (parent), N (subgroup C2^4), k (matrix index)
# Purpose: Generates the full set of 4,098 multiplication relations for the extension
AllGomegaRelationsC2xC2xC2xC2 := function(G, N, k)
    local Coset, cos1, cos2, list, relation;

    # 1. Identify the 4 cosets of N in G
    Coset := RightCosets(G, N);
    list := [];

    # 2. Iterate through every possible pair (cos1, cos2) in the quotient group G/N
    # Since there are 4 cosets, there are 16 total pairs to check.
    for cos1 in Coset do
        for cos2 in Coset do
            
            # 3. Generate the 256 relations for this specific coset multiplication
            relation := GomegaRelationsC2xC2xC2xC2(G, N, cos1, cos2, k);
            
            # 4. Collect them into a single list
            Add(list, relation);
        od;
    od;

    # 5. Flatten the list of lists into a single set of unique relations
    list := Union(list);
    
    return list;
end;


# Arguments: G (parent group), N (subgroup C2^4)
# Purpose: Generates 1,024 relations enforcing the rule n * g = (ng) 
#          for all kernel elements n and group elements g
MoreGomegaRelationsC2xC2xC2xC2 := function(G, N)
    local n, g, num0, num1, num2, relation, wantlist;

    wantlist := [];

    # 1. Iterate through every element in the kernel N (Order 16)
    for n in Elements(N) do
        # 2. Iterate through every element in the parent group G (Order 64)
        for g in Elements(G) do

            # 3. Identify the indices of the elements in your global list
            num0 := PickupElementNumber(G, n);
            num1 := PickupElementNumber(G, g);
            num2 := PickupElementNumber(G, n * g);

            # 4. Define the relation: f[n] * f[g] = f[ng]
            # In the FreeGroup, this is: f[num0] * f[num1] * f[num2]^-1 = Identity
            relation := f[num0] * f[num1] * f[num2]^-1;

            Add(wantlist, relation);
        od;
    od;

    return wantlist;
end;


# Arguments: G (parent), N (subgroup C2^4), k (matrix index)
# Purpose: Compiles the complete set of relations (approx. 5,000+) to define the group Gw
FinalAllGomegaRelationsC2xC2xC2xC2 := function(G, N, k)
    local finalwant, want, want2, element1000, element0100, element0010, element0001, 
          number1, number2, number3, number4;

    # 1. Pull the 4,096 relations from the coset multiplication and Eta-cocycle
    want := AllGomegaRelationsC2xC2xC2xC2(G, N, k);

    # 2. Pull the 1,024 relations enforcing the kernel's internal action (n * g = ng)
    want2 := MoreGomegaRelationsC2xC2xC2xC2(G, N);

    # 3. Target the four basis generators of the C2^4 kernel
    element1000 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[1];
    element0100 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[2];
    element0010 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[3];
    element0001 := C2xC2xC2xC2GeneratorsOfSubgroup(N)[4];

    # 4. Identify their positions in the generator list
    number1 := PickupElementNumber(G, element1000);
    number2 := PickupElementNumber(G, element0100);
    number3 := PickupElementNumber(G, element0010);
    number4 := PickupElementNumber(G, element0001);

    # 5. Add the "Rigidity Relations": Ensure basis elements are order-2 (v^2 = 1)
    # This is vital to prevent the FreeGroup from generating an infinite or overly large group.
    Add(want, f[number1]^2);
    Add(want, f[number2]^2);
    Add(want, f[number3]^2);
    Add(want, f[number4]^2);

    # 6. Merge all relations and remove duplicates
    finalwant := Union(want, want2);

    return finalwant;
end;




# This function investigates the group structure of G relative to N 
# for the elementary abelian group C2 x C2 x C2 x C2.
GwStructureC2xC2xC2xC2 := function( G, N )
  local invlist, k, t, Relation, Gfinal, want;

  # Initialize empty lists for valid invariants and the final results
  invlist := [ ];
  want := [ ];

  # Phase 1: Filter valid invariants in the range 1 to 28
  for k in [ 1 .. 28 ] do
    # Check if the invariant 'k' is valid for the given group and subgroup
    if CheckGinv_C2xC2xC2xC2( G, N, k ) = 1 then
      Add( invlist, k );
    fi;
  od;

  # Phase 2: Reconstruct the group and verify isomorphism for each valid invariant
  for t in invlist do
    # Generate the group relations based on invariant 't'
    Relation := FinalAllGomegaRelationsC2xC2xC2xC2( G, N, t );

    # Define Gfinal as the quotient of the predefined Free64 by these relations
    Gfinal := Free64 / Relation;

    # Store the invariant index and the result of the isomorphism test
    Add( want, [ t, IsIsomorphicGroup( G, Gfinal ) ] );
  od;

  # Return the list of [index, boolean] pairs
  return want;
end;


# This function iterates through all subgroups of G to find those 
# isomorphic to C2 x C2 x C2 x C2 and analyzes their structure.
GwStructureAllC2xC2xC2xC2 := function( G )
  local subgroups, checkgroups, H, subg;

  # Retrieve all relevant subgroups of G
  subgroups := ObtainedSubgroups( G );

  # Initialize a list to store matching subgroups
  checkgroups := [ ];

  # Filter subgroups that are isomorphic to C2 x C2 x C2 x C2
  for H in subgroups do
    if IsIsomorphicGroup( C2xC2xC2xC2, H ) then
      Add( checkgroups, H );
    fi;
  od;

  # For each matching subgroup, print its generators and its invariant structure
  for subg in checkgroups do
    # Display the generators of the current subgroup
    Print( GeneratorsOfGroup( subg ), "\n" );
    
    # Call the structure analysis function and print the resulting [index, boolean] list
    Print( GwStructureC2xC2xC2xC2( G, subg ), "\n\n" );
  od;
end;


# This function decomposes an element 'g' into its exponents (j, k, m, n)
# relative to the basis generators: groupc, groupd, groupe, groupf.
Cycle2x2x2x2 := function( g )
  local j, k, m, n;

  for j in [ 0 .. 1 ] do
    for k in [ 0 .. 1 ] do
      for m in [ 0 .. 1 ] do
        for n in [ 0 .. 1 ] do
          # Check if the element matches the specific product of generators
          if g = groupc^j * groupd^k * groupe^m * groupf^n then
            return [ j, k, m, n ];
          fi;
        od;
      od;
    od;
  od;
end;

# Generate 2-cocycle functions for each index k from 1 to 28.
# Each 'Cocycle_C2xC2xC2xC2_k' calculates the cocycle value for elements a and x.
for k in [ 1 .. 28 ] do
  Cocycle_C2xC2xC2xC2_k := function( a, x )
    local list1, list2, matrix, want;

    # Fetch and transform the matrix corresponding to the k-th invariant
    matrix := ChangeMatrix( MatrixesC2xC2xC2xC2[k] );
    
    # Get the exponent vectors for both elements
    list1 := Cycle2x2x2x2( a );
    list2 := Cycle2x2x2x2( x );

    # Compute the cocycle value using the Bilinear form/matrix entries
    want := matrix[1][2]^( list1[1] * list2[2] ) * matrix[1][3]^( list1[1] * list2[3] ) *
            matrix[1][4]^( list1[1] * list2[4] ) * matrix[2][3]^( list1[2] * list2[3] ) *
            matrix[2][4]^( list1[2] * list2[4] ) * matrix[3][4]^( list1[3] * list2[4] );

    return want;
  end;
od; # Each function now corresponds to a specific 2-cocycle index
