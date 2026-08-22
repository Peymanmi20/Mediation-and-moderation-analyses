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

With respect to(`regression.pdf`), a multiple linear regression predicting perceived stress (PSS) from executive function (BRIEF GEC T), negative affect, positive affect, age, and sex yielded a large and significant model, F(5, 391) = 161.6, p < .001, R² = .674 (adjusted R² = .670).
Significant predictors: Higher negative affect was the strongest unique predictor (β = .48, p < .001), followed by greater executive dysfunction (β = .26, p < .001) and lower positive affect (β = –.25, p < .001). Age contributed a small negative effect (β = –.07, p = .017).
Non-significant predictor: Sex did not uniquely predict PSS (β = –.04, p = .196).
Collinearity was negligible (all VIFs < 1.8). In sum, affective variables and executive dysfunction together explained approximately two-thirds of the variance in perceived stress, with negative affect showing the largest independent contribution.

### Interpretation

This finding indicates a meaningful prediction of perceived stress 
from NA, PA, and GEC which explained 0.64 of shared variance. 

---

## 3. Mediation analysis

According to the file (`parameter_med.xlsx`), a saturated mediation model tested whether negative affect (PANAS-N) mediated the association between executive dysfunction (BRIEF GEC T) and perceived stress (PSS), controlling for age and sex.
The total effect of executive dysfunction on perceived stress was significant (B = 0.49, SE = 0.03, p < .001). The indirect effect through negative affect was significant (B = 0.22, SE = 0.02, 95% CI [0.18, 0.27], p < .001): higher executive dysfunction predicted greater negative affect (path a: B = 0.35, SE = 0.03, p < .001), which in turn predicted higher perceived stress (path b: B = 0.64, SE = 0.05, p < .001). The direct effect remained significant (path c′: B = 0.27, SE = 0.03, p < .001), indicating partial mediation.
Among covariates, age negatively predicted perceived stress (B = –0.07, p = .002), whereas sex significantly predicted negative affect (B = –1.50, p = .014) but not perceived stress (p = .069).

---
## 3. Moderation analysis
According to the file (`parameter_moder.xlsx`), a moderated analysis tested whether positive affect conditioned the indirect effect of executive dysfunction (BRIEF GEC T) on perceived stress via negative affect. In the conditional model, negative affect remained the strongest predictor of perceived stress (B = 0.57, SE = 0.05, p < .001), followed by positive affect (B = –0.28, SE = 0.04, p < .001) and executive dysfunction (B = 0.20, SE = 0.03, p < .001). The interaction term was marginally significant (B = –0.008, SE = 0.004, p = .073), suggesting positive affect may weakly buffer the mediated pathway, though it fell just short of conventional significance. Age showed a small negative effect (B = –0.06, p = .008), whereas sex was not significant (B = –0.85, p = .121).


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
