# Complete Isocategorical Classification of Groups of Order 64 via GAP
# Overview
This repository contains the GAP source code used in the paper "Complete Isocategorical Classification of Groups of Order 64 via GAP".
The classification of finite groups under monoidal equivalence is a fundamental topic in the study of finite quantum groups. While a complete classification has been established for all groups of order strictly less than 64, the case for order 64 has remained limited to the construction of specific examples. In this study, we achieve the complete classification for groups of order 64 by developing an original computational approach using GAP. We describe our methodology and demonstrate that there exist exactly two pairs of non-isomorphic isocategorical groups of this order.

# Prerequisites
- GAP 4.11+
- Package 'sonata'

# Usage
Verification is performed using Izumi–Kosaki groups. The target groups are identified by the order list `[1, 19, 44, 0, 0, 0, 0]`.
Within `Sourcecode.g`, the primary group for analysis, `Gizumikosaki`, is extracted as follows:
```gap
izumigroups := SmallCategoryCal(64, [1, 19, 44, 0, 0, 0, 0]);
izumigroups := izumigroups{[2..10]};
Gizumikosaki := izumigroups[5];
