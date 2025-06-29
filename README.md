# HazardousSites
Regression discontinuity model of effects of waste site cleanup on housing prices

# Overview
- This project implements a regression discontinuity design (RDD) to estimate the effect of federally funded hazardous waste site cleanup on nearby housing prices. The analysis uses data from 14 U.S. states on home characteristics and the Hazardous Ranking Score (HRS) of the nearest environmental site.

- Due to budget constraints, the government cleaned up only those sites with HRS ≥ 26, creating a quasi-experimental cutoff. Homes near sites just above this threshold were treated (cleanup occurred), while homes near sites just below were not. This sharp policy cutoff provides an opportunity to assess causal effects using RDD.

# Data
## The Dataset contains the following variables
- price (monthly housing cost)
- rooms
- age (years)
- state
- HRS
- treated (binary)
## I constructed the folloiwng
- logPrice (used as the outcome variable to stabilize variance and interpret results in percentage terms)
- runvar (centered HRS around cutoff of 26)
- runvarsq (square of running variable for quadratic effects)

# Methodology
## We estimate the treatment effect using both regression and comparison of means:
- Regression Discontinuity (Quadratic Model)
- Controls include the number of rooms, house age, and state fixed effects.
- tr1: Coefficient on treated from this model; represents the estimated effect of site cleanup on log housing prices at the threshold.
- We exponentiate this to interpret it in percentage price changes.

## Comparison of Means in a Bandwidth:
- We also compute a parametric difference in average log prices:
- Treated group: HRS ∈ [26, 32]
- Control group: HRS ∈ [20, 26)
- tr2: The difference in means between these two groups.

## McCrary Density Test
- We test for manipulation of the running variable (HRS) at the threshold using the rddensity package.
- pm: The p-value from the McCrary test indicates whether the density of HRS is continuous at 26.
- A low p-value suggests possible sorting/manipulation around the threshold, violating RD assumptions.

## Placebo Outcome Test
- We estimate the RD model with rooms as the outcome instead of logPrice to check whether treatment affects an unrelated variable.
- trp: A near-zero coefficient supports the assumption that no other factors jump at the cutoff.

# Key Findings
- tr1: exponentiating the coefficient on treatment, we get 1.061, indicating that a house being treated has an average increase of 6.1% on house price
- tr2: Homes near cleaned-up sites were ~3.2 % more expensive on average, relative to nearby untreated homes
- the difference in tr1 and tr2 is the additional impact that is picked up by home characteristics such as age and rooms in tr1 that are not in tr2 (tr2 is just a simple difference in averages of log prices of treated vs untreated homes near the 26 cutoff)
- dp: 	An average home’s monthly price rose by ~$148.8 after treatment
- pm: low p value of .00011 on mccrary test indicates that model may be compromised by a discontinuation in the density of the running variable at the cutoff, meaning that the observations just above and just below the cutoff may not truly be comparable, and that the treatment effect may encapsulate preexisting factors in each group rather than the true treatment effect
- trp: the trp tells us the treatment effect on the number of rooms. The trp of -0.05249 indicates that at the cutoff there was on average 0.05249 less rooms in houses that received treatment vs houses that did not, controlling for age, state, runvar and runvarsq. Since this is close to zero its possible that it serves as a placebo showing that treatment likely did not affect unrelated home characteristics like the number of rooms

# Files
- hazardoussite.rds
