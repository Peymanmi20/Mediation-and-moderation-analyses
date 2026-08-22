# Results Interpretation

## Overview

This document provides the interpretation of the statistical findings
obtained from the analyses conducted in IBM SPSS Statistics, JASP and RStudio.

The interpretation is based on the statistical results reported in
the corresponding output files.

---
## 1. Normality testing
Normality results in the file (`normality_testing.xlsx`) showed that Shapiro-Wilk test of all variables
are significant (p < 0.001), but their skewness and kurtosis all are below 1. In addition, Mardia's test indicated
significance for skewness (p < 0.001), but not for kurtosis(p > 0.05). Taken together, I decided to compute both Spearman and Pearson in correlation analysis to empirically verify the appropriateness of parametric methods. Also, in mediation analysis, estimator left as ML (Maximum Likelihood), with 5000 bootstraps followed by percentile method. 

---

## 2. Correlation results

AHigher executive dysfunction was moderately-to-strongly associated with greater negative affect (r = .57, p < .001) and perceived stress (r = .65, p < .001), and with lower positive affect (r = –.49, p < .001). Negative and positive affect were moderately inversely related (r = –.40, p < .001). Perceived stress showed a strong positive correlation with negative affect (r = .73, p < .001) and a moderate negative correlation with positive affect (r = –.58, p < .001). Sex correlated weakly but significantly with negative affect (r = –.11, p = .026), perceived stress (r = –.12, p = .014), and—by Spearman only—positive affect (ρ = .11, p = .037).
Non-significant correlations:
No significant associations emerged for age with any psychological variable (all ps > .09), nor for sex/age with executive dysfunction (all ps > .19). Age and sex were also unrelated (p = .468).
In summary, executive dysfunction, negative affect, and perceived stress form a tightly linked cluster, whereas age showed no meaningful associations with any variable.

### Interpretation

The observed association indicates that individual differences in
generalized executive functioning are related to differences in
negative affect. However, the correlational nature of the analysis
does not allow a causal interpretation.

---

## 2. Regression

A Pearson correlation was conducted to examine the association between
generalized executive functioning (`brief_GEC_T`) and positive affect
(`panas_pos`).

The analysis indicated a negative association between the variables,
with Pearson's r = -0.49.

This suggests that higher generalized executive functioning scores
were associated with lower levels of positive affect in the present
sample.

The magnitude of the association can be interpreted as moderate.

### Interpretation

This finding indicates a meaningful inverse association between the
two variables. However, the observed correlation should not be
interpreted as evidence that generalized executive functioning causes
changes in positive affect.

---

## 3. Statistical Considerations

The sample consisted of 397 participants.

Although several variables showed statistically significant
departures from normality according to the Shapiro-Wilk test,
inspection of the distributions and scatterplots suggested that the
relationships were approximately linear.

Pearson correlations were therefore used as the primary correlation
analysis.

Spearman correlations may additionally be examined as a sensitivity
analysis.

---

## 4. Limitations of Interpretation

The observed correlations represent associations rather than causal
effects.

The findings should therefore be interpreted as evidence of
relationships between the measured constructs rather than evidence
that one variable directly influences another.

The magnitude and direction of the associations should also be
considered alongside the measurement properties of the instruments,
sampling characteristics, and other potential confounding variables.
