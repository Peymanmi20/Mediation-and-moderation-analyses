library(pacman)
p_load(readxl, lavaan, semPlot, psych,ggplot2, corrplot,dplyr, openxlsx)

My_data <- read_excel("C:\\Users\\User\\Documents\\git_proj_clean_cov.xlsx")


# mean_center
My_data$brief_GEC_T <- as.numeric(scale(My_data$brief_GEC_T, center = TRUE, scale = FALSE))
My_data$panas_pos   <- as.numeric(scale(My_data$panas_pos,   center = TRUE, scale = FALSE))
My_data$panas_neg   <- as.numeric(scale(My_data$panas_neg,   center = TRUE, scale = FALSE))
My_data$Age   <- as.numeric(scale(My_data$Age,   center = TRUE, scale = FALSE))

# Covariates are Age and Sex

My_data$Sex <- factor(
  My_data$Sex,
  levels = c(1, 2),
  labels = c("Female", "Male")
)


# Model specification 
model <- "
# Mediation
panas_neg ~ a*brief_GEC_T + Age + Sex
pss ~ b*panas_neg + c*brief_GEC_T + Age + Sex

# Indirect effect
ind_neg := a*b

# Total effect
total := c + (a*b)
"

fit <- sem(model, 
           data = My_data, 
           estimator = "ML",
           se = "bootstrap", 
           bootstrap = 500)         


pe <- parameterestimates(fit, 
                         ci = TRUE, 
                         standardized = TRUE)  
print(pe)                                          

# Summary with fit measures
summary(fit, fit.measures = TRUE, rsquare = TRUE)

# Moderation
m_main  <- lm(pss ~ brief_GEC_T + panas_neg + panas_pos + Age + Sex, data = My_data)           
m_mod   <- lm(pss ~ brief_GEC_T + panas_neg * panas_pos + Age + Sex, data = My_data) 
summary(m_main)
summary(m_mod)
anova(m_main, m_mod)

# R-squared
inspect(fit, "r2")


#Visualization

# =============================================================================
# FIGURE 1: SEM PATH DIAGRAM (High-Resolution Static)
# =============================================================================
dir.create("figures", showWarnings = FALSE)

png(
  "figures/01_mediation_model.png",
  width = 2400,
  height = 1600,
  res = 300
)

semPaths(fit, 
         whatLabels = "std",           # standardized estimates
         layout = "tree2",             # vertical tree layout
         edge.label.cex = 1.3,
         sizeMan = 10,
         sizeLat = 12,
         nCharNodes = 0,               # full variable names
         nCharEdges = 0,
         color = list(lat = "#4ECDC4", man = "#FF6B6B"),
         border.width = 2,
         edge.color = "#2C3E50",
         label.cex = 1.2,
         curvePivot = TRUE,
         title = FALSE)
dev.off()

# =============================================================================
# FIGURE 2: MEDIATION COEFFICIENTS (Forest-style Plot)
# =============================================================================
med_paths <- pe %>% 
  filter(op == "~") %>%
  mutate(
    path = paste(lhs, "←", rhs),
    sig = ifelse(pvalue < .05, "p < .05", "n.s.")
  )

p_med <- ggplot(med_paths, aes(x = std.all, y = reorder(path, est), color = sig)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey50") +
  geom_errorbarh(aes(xmin = ci.lower, xmax = ci.upper), height = 0.2, linewidth = 1) +
  geom_point(size = 4) +
  geom_text(aes(label = sprintf("%.2f", est)), hjust = -0.4, size = 3.5) +
  scale_color_manual(values = c("p < .05" = "#E74C3C", "n.s." = "#95A5A6")) +
  labs(
    title = "Mediation Path Coefficients",
    subtitle = "With 95% Bootstrap Confidence Intervals",
    x = "Standardized Estimate (β)",
    y = NULL,
    color = "Significance"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

ggsave("figures/02_mediation_coefficients.png", p_med, width = 8, height = 5, dpi = 300)


# Saving

# ============================================================
# EXPORT ALL RESULTS TO EXCEL
# ============================================================

# ============================================================
# EXPORT RESULTS TO EXCEL
# ============================================================

p_load(openxlsx, dplyr)

dir.create("results", showWarnings = FALSE)

wb <- createWorkbook()


# ============================================================
# 1. MEDIATION PATHS
# ============================================================

pe <- parameterEstimates(
  fit,
  ci = TRUE,
  standardized = TRUE
)

med_paths <- pe %>%
  filter(op == "~") %>%
  mutate(
    Path = paste(lhs, "<-", rhs)
  ) %>%
  select(
    Path,
    Estimate = est,
    SE = se,
    z = z,
    p_value = pvalue,
    CI_lower = ci.lower,
    CI_upper = ci.upper,
    Standardized_Beta = std.all
  )

addWorksheet(wb, "Mediation Paths")
writeData(wb, "Mediation Paths", med_paths)


# ============================================================
# 2. MEDIATION EFFECTS
#    Indirect effect + Total effect
# ============================================================

med_effects <- pe %>%
  filter(op == ":=") %>%
  mutate(
    Effect = case_when(
      lhs == "ind_neg" ~ "Indirect effect",
      lhs == "total" ~ "Total effect",
      TRUE ~ lhs
    )
  ) %>%
  select(
    Effect,
    Estimate = est,
    SE = se,
    z = z,
    p_value = pvalue,
    CI_lower = ci.lower,
    CI_upper = ci.upper,
    Standardized_Beta = std.all
  )

addWorksheet(wb, "Mediation Effects")
writeData(wb, "Mediation Effects", med_effects)


# ============================================================
# 3. MEDIATION R-SQUARED
# ============================================================

r2_med <- inspect(fit, "r2")

med_r2 <- data.frame(
  Variable = names(r2_med),
  R_squared = as.numeric(r2_med)
)

addWorksheet(wb, "Mediation R2")
writeData(wb, "Mediation R2", med_r2)


# ============================================================
# 4. MODERATION: MAIN EFFECTS MODEL
# ============================================================

main_coef <- as.data.frame(
  summary(m_main)$coefficients
)

main_coef$Predictor <- rownames(main_coef)
rownames(main_coef) <- NULL

main_results <- main_coef %>%
  select(
    Predictor,
    Estimate,
    SE = `Std. Error`,
    t_value = `t value`,
    p_value = `Pr(>|t|)`
  )

addWorksheet(wb, "Moderation Main")
writeData(wb, "Moderation Main", main_results)


# ============================================================
# 5. MODERATION: FULL INTERACTION MODEL
# ============================================================

mod_coef <- as.data.frame(
  summary(m_mod)$coefficients
)

mod_coef$Predictor <- rownames(mod_coef)
rownames(mod_coef) <- NULL

mod_results <- mod_coef %>%
  select(
    Predictor,
    Estimate,
    SE = `Std. Error`,
    t_value = `t value`,
    p_value = `Pr(>|t|)`
  )

addWorksheet(wb, "Moderation Interaction")
writeData(wb, "Moderation Interaction", mod_results)


# ============================================================
# 6. MODERATION: MODEL COMPARISON
# ============================================================

model_comparison <- as.data.frame(
  anova(m_main, m_mod)
)

model_comparison$Model <- rownames(model_comparison)
rownames(model_comparison) <- NULL

# Put Model first
model_comparison <- model_comparison %>%
  select(Model, everything())

addWorksheet(wb, "Model Comparison")
writeData(wb, "Model Comparison", model_comparison)


# ============================================================
# 7. MODERATION: R-SQUARED
# ============================================================

moderation_r2 <- data.frame(
  Model = c(
    "Main effects model",
    "Interaction model"
  ),
  R_squared = c(
    summary(m_main)$r.squared,
    summary(m_mod)$r.squared
  ),
  Adjusted_R_squared = c(
    summary(m_main)$adj.r.squared,
    summary(m_mod)$adj.r.squared
  )
)

# Calculate change in R²
moderation_r2$Delta_R2 <- c(
  NA,
  summary(m_mod)$r.squared -
    summary(m_main)$r.squared
)

addWorksheet(wb, "Moderation R2")
writeData(wb, "Moderation R2", moderation_r2)


# ============================================================
# 8. DESCRIPTIVE STATISTICS
# ============================================================

desc_vars <- c(
  "brief_GEC_T",
  "panas_neg",
  "panas_pos",
  "pss",
  "Age"
)

descriptives <- psych::describe(
  My_data[, desc_vars]
)

descriptives <- data.frame(
  Variable = rownames(descriptives),
  descriptives,
  row.names = NULL
)

addWorksheet(wb, "Descriptives")
writeData(wb, "Descriptives", descriptives)


# ============================================================
# 9. SEX DISTRIBUTION
# ============================================================

sex_distribution <- as.data.frame(
  table(My_data$Sex, useNA = "ifany")
)

names(sex_distribution) <- c(
  "Sex",
  "N"
)

sex_distribution$Percentage <- round(
  sex_distribution$N /
    sum(sex_distribution$N) * 100,
  2
)

addWorksheet(wb, "Sex Distribution")
writeData(wb, "Sex Distribution", sex_distribution)


# ============================================================
# 10. SAMPLE INFORMATION
# ============================================================

sample_info <- data.frame(
  Statistic = c(
    "N",
    "Mean Age",
    "SD Age",
    "Minimum Age",
    "Maximum Age"
  ),
  Value = c(
    nrow(My_data),
    mean(My_data$Age, na.rm = TRUE),
    sd(My_data$Age, na.rm = TRUE),
    min(My_data$Age, na.rm = TRUE),
    max(My_data$Age, na.rm = TRUE)
  )
)

addWorksheet(wb, "Sample Information")
writeData(wb, "Sample Information", sample_info)


# ============================================================
# 11. FORMATTING
# ============================================================

header_style <- createStyle(
  textDecoration = "bold",
  halign = "center",
  border = "Bottom"
)

# Apply formatting to every worksheet
for (sheet in names(wb)) {
  
  # Find number of columns
  sheet_data <- readWorkbook(
    wb,
    sheet = sheet
  )
  
  n_cols <- ncol(sheet_data)
  
  if (n_cols > 0) {
    
    addStyle(
      wb,
      sheet,
      style = header_style,
      rows = 1,
      cols = 1:n_cols,
      gridExpand = TRUE
    )
    
    freezePane(
      wb,
      sheet,
      firstRow = TRUE
    )
    
    setColWidths(
      wb,
      sheet,
      cols = 1:n_cols,
      widths = "auto"
    )
  }
}


# ============================================================
# 12. SAVE
# ============================================================

saveWorkbook(
  wb,
  "results/analysis_results.xlsx",
  overwrite = TRUE
)

cat(
  "\nResults successfully saved to:\n",
  "results/analysis_results.xlsx\n"
)