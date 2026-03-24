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



