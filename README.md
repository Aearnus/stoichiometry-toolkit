Stoichiometry Toolkit
===
An interactive toolkit to analyze chemical formulas and perform stoichiometric conversions.

Usage
---
`ruby main.rb`

Requires: a relatively new version of Ruby (>2.0.0)

Example session
---
~~~
┌────────────────────────────────────────────────────┐
│░█▀▀░▀█▀░█▀█░▀█▀░█▀▀░█░█░▀█▀░█▀█░█▄█░█▀▀░▀█▀░█▀▄░█░█│
│░▀▀█░░█░░█░█░░█░░█░░░█▀█░░█░░█░█░█░█░█▀▀░░█░░█▀▄░░█░│
│░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░░▀░░▀░▀░░▀░│
└────────────────────────────────────────────────────┘
Hello, and welcome to the stoichiometry toolbox. Type `r` for a reaction or `f` for a single chemical formula, then strike `Return`.
r
Input the reactant(s), separated by a `+`. Note: do not add the coefficients. They will be automatically generated.
MgCl2 + Al2(SO3)3
Input the product(s), separated by a `+`.
MgSO3 + AlCl3
Original reaction:
    MgCl2 + Al2(SO3)3 → MgSO3 + AlCl3
Balanced reaction:
    3MgCl2 + Al2(SO3)3 → 3MgSO3 + 2AlCl3
What would you like to do with this reaction?
    Perform a stoichiometric (c)onversion
    Find the (l)imiting reactant
    (Q)uit to the main page
c
What unit are you asking for?
(l): liters
(mc): molecules
(g): grams
mc
Of?
Reactants:
    (0): MgCl2
    (1): Al2(SO3)3
Products:
    (2): MgSO3
    (3): AlCl3
0
What quantity are you given?
4.78e24
What unit are you given?
(l): liters
(mc): molecules
(g): grams
mc
Of?
Reactants:
    (0): MgCl2
    (1): Al2(SO3)3
Products:
    (2): MgSO3
    (3): AlCl3
1
4.78e+24 mc Al2(SO3)3 | 1 mol        | 3 mol MgCl2     | 6.022e+23 mc
--------------------------------------------------------------------- = 1.434e+25 mc MgCl2
                      | 6.022e+23 mc | 1 mol Al2(SO3)3 | 1 mol
What would you like to do with this reaction?
    Perform a stoichiometric (c)onversion
    Find the (l)imiting reactant
    (Q)uit to the main page
q
~~~

About
---
Please submit a pull request or an issue if something doesn't work right. I'm a one man team, so I'm not going to be able to get to every issue ASAP. Expect flaws, etc, etc. Message me on https://twitter.com/aearnus or on Discord: @Aearnus#7521 for something urgent.
