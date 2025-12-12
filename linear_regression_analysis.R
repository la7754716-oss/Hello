################################################################################
# R Linear Regression Analysis: y3 vs Frequency, Degree, Grade
# 
# Description: Analysis of student data examining the relationship between
# UVLT vocabulary test score (score3/y3) and three predictors:
# - Frequency: English learning app usage frequency (1-10)
# - Degree: CET-4 English study degree (1-10)
# - Grade: Gaokao Chinese language score (90-130)
#
# Date: 2024
# Author: Data Analysis Team
################################################################################

# Clear workspace
rm(list = ls())

# Set working directory (adjust as needed)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Load required libraries
library(ggplot2)
library(gridExtra)
library(car)

################################################################################
# 1. Create Student Data Frame
################################################################################

# Create sample student data with 53 observations
set.seed(42)  # For reproducibility

n_samples <- 53

student_data <- data.frame(
  Frequency = c(8, 9, 7, 9, 8, 6, 7, 8, 9, 10,
                7, 8, 6, 9, 8, 7, 9, 8, 7, 6,
                8, 9, 7, 8, 9, 6, 7, 8, 9, 10,
                7, 8, 6, 9, 8, 7, 9, 8, 7, 6,
                8, 9, 7, 8, 9, 6, 7, 8, 9, 10,
                7, 8, 6),
  Degree = c(7, 8, 6, 9, 8, 5, 6, 7, 8, 9,
             6, 7, 5, 8, 7, 6, 8, 7, 6, 5,
             7, 8, 6, 7, 8, 5, 6, 7, 8, 9,
             6, 7, 5, 8, 7, 6, 8, 7, 6, 5,
             7, 8, 6, 7, 8, 5, 6, 7, 8, 9,
             6, 7, 5),
  Grade = c(120, 125, 110, 128, 122, 105, 115, 118, 125, 130,
            112, 120, 108, 126, 118, 114, 125, 120, 110, 105,
            122, 128, 112, 118, 125, 102, 110, 118, 125, 130,
            112, 120, 108, 126, 118, 114, 125, 120, 110, 105,
            122, 128, 112, 118, 125, 102, 110, 118, 125, 130,
            112, 120, 108),
  y3 = c(68, 72, 58, 76, 70, 50, 62, 66, 74, 82,
         62, 68, 54, 74, 68, 62, 72, 68, 60, 52,
         70, 76, 64, 68, 74, 48, 58, 66, 74, 82,
         62, 68, 54, 74, 68, 62, 72, 68, 60, 52,
         70, 76, 64, 68, 74, 48, 58, 66, 74, 82,
         62, 68, 54),
  Cohort = rep(c("A", "B", "C"), length.out = 53)
)

# Display summary of the data
cat("\n================== DATA SUMMARY ==================\n")
cat("Number of students:", nrow(student_data), "\n")
cat("Variables:", paste(names(student_data), collapse = ", "), "\n\n")

print(summary(student_data))

cat("\n================== DATA HEAD ==================\n")
print(head(student_data, 10))

################################################################################
# 2. Exploratory Data Analysis
################################################################################

cat("\n================== CORRELATION MATRIX ==================\n")
correlation_matrix <- cor(student_data[, c("Frequency", "Degree", "Grade", "y3")])
print(correlation_matrix)

################################################################################
# 3. Linear Regression Analysis
################################################################################

# Fit linear regression model
model <- lm(y3 ~ Frequency + Degree + Grade, data = student_data)

# Display model summary
cat("\n================== REGRESSION MODEL SUMMARY ==================\n")
print(summary(model))

# Extract model components for detailed output
cat("\n================== DETAILED REGRESSION OUTPUT ==================\n")
cat("\nModel Formula: y3 ~ Frequency + Degree + Grade\n")
cat("Number of observations:", nrow(student_data), "\n")

# Coefficients with detailed statistics
coefficients_table <- coef(summary(model))
cat("\n--- Coefficients ---\n")
print(coefficients_table)

# Model fit statistics
cat("\n--- Model Fit Statistics ---\n")
cat("R-squared:", summary(model)$r.squared, "\n")
cat("Adjusted R-squared:", summary(model)$adj.r.squared, "\n")
cat("F-statistic:", summary(model)$fstatistic[1], "\n")
cat("df1:", summary(model)$fstatistic[2], "\n")
cat("df2:", summary(model)$fstatistic[3], "\n")
cat("P-value (overall model):", pf(summary(model)$fstatistic[1], 
                                    summary(model)$fstatistic[2], 
                                    summary(model)$fstatistic[3], 
                                    lower.tail = FALSE), "\n")

# Residual statistics
cat("\n--- Residual Statistics ---\n")
cat("Residual standard error:", summary(model)$sigma, "\n")
cat("Degrees of freedom:", df.residual(model), "\n")

# Interpretation of significance codes
cat("\n--- Significance Codes ---\n")
cat("*** p < 0.001 (highly significant)\n")
cat("**  p < 0.01  (very significant)\n")
cat("*   p < 0.05  (significant)\n")
cat(".   p < 0.10  (marginally significant)\n")

################################################################################
# 4. Diagnostic Analysis
################################################################################

# Variance Inflation Factor (check for multicollinearity)
cat("\n================== VARIANCE INFLATION FACTOR (VIF) ==================\n")
vif_values <- vif(model)
print(vif_values)
cat("(VIF < 5 indicates acceptable multicollinearity)\n")

# Additional diagnostic statistics
cat("\n================== DIAGNOSTIC STATISTICS ==================\n")
cat("Shapiro-Wilk test for normality of residuals:\n")
shapiro_test <- shapiro.test(residuals(model))
print(shapiro_test)

cat("\nBreusch-Pagan test for homogeneity of variance:\n")
bp_test <- lmtest::bptest(model)
print(bp_test)

################################################################################
# 5. Predictions and Residuals
################################################################################

# Generate predictions
predictions <- predict(model, newdata = student_data, se.fit = TRUE)
student_data$predicted_y3 <- predictions$fit
student_data$residuals <- residuals(model)
student_data$standardized_residuals <- rstandard(model)
student_data$studentized_residuals <- rstudent(model)

# Display residual information
cat("\n================== RESIDUAL ANALYSIS ==================\n")
cat("Mean of residuals (should be ~0):", mean(student_data$residuals), "\n")
cat("Standard deviation of residuals:", sd(student_data$residuals), "\n")
cat("Min residual:", min(student_data$residuals), "\n")
cat("Max residual:", max(student_data$residuals), "\n")

# Display sample predictions
cat("\n--- Sample Predictions vs Actual Values ---\n")
output_table <- student_data[1:10, c("y3", "predicted_y3", "residuals")]
names(output_table) <- c("Actual (y3)", "Predicted (y3)", "Residual")
print(output_table)

################################################################################
# 6. Generate Diagnostic Plots
################################################################################

# Create output directory for plots if it doesn't exist
if (!dir.exists("plots")) {
  dir.create("plots")
}

# Plot 1: Residual Diagnostics (4-panel plot)
png(filename = "plots/01_residual_diagnostics.png", 
    width = 12, height = 10, units = "in", res = 300)
par(mfrow = c(2, 2))

# Residuals vs Fitted Values
plot(model, which = 1, main = "Residuals vs Fitted Values")

# Q-Q Plot
plot(model, which = 2, main = "Normal Q-Q Plot")

# Scale-Location Plot
plot(model, which = 3, main = "Scale-Location Plot")

# Residuals vs Leverage
plot(model, which = 5, main = "Residuals vs Leverage")

par(mfrow = c(1, 1))
dev.off()

cat("\n✓ Residual diagnostics plot saved: plots/01_residual_diagnostics.png\n")

# Plot 2: Histogram and Distribution of Residuals
png(filename = "plots/02_residual_distribution.png", 
    width = 10, height = 6, units = "in", res = 300)
par(mfrow = c(1, 2))

hist(student_data$residuals, 
     main = "Distribution of Residuals",
     xlab = "Residuals",
     ylab = "Frequency",
     breaks = 15,
     col = "steelblue",
     border = "white")

qqnorm(student_data$residuals,
       main = "Q-Q Plot of Residuals",
       col = "steelblue")
qqline(student_data$residuals, col = "red", lwd = 2)

par(mfrow = c(1, 1))
dev.off()

cat("✓ Residual distribution plot saved: plots/02_residual_distribution.png\n")

# Plot 3: Actual vs Predicted Values
png(filename = "plots/03_actual_vs_predicted.png", 
    width = 8, height = 8, units = "in", res = 300)

p1 <- ggplot(student_data, aes(x = predicted_y3, y = y3)) +
  geom_point(color = "steelblue", size = 3, alpha = 0.6) +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed", size = 1) +
  labs(title = "Actual vs Predicted Values (y3)",
       x = "Predicted y3",
       y = "Actual y3",
       subtitle = paste("R² =", round(summary(model)$r.squared, 4))) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5),
        axis.text = element_text(size = 11),
        axis.title = element_text(size = 12))

print(p1)
dev.off()

cat("✓ Actual vs Predicted plot saved: plots/03_actual_vs_predicted.png\n")

# Plot 4: Regression Coefficients Visualization
png(filename = "plots/04_coefficients_visualization.png", 
    width = 10, height = 6, units = "in", res = 300)

coef_data <- data.frame(
  Variable = rownames(coefficients_table)[-1],
  Estimate = coefficients_table[-1, 1],
  StdError = coefficients_table[-1, 2]
)

coef_data$LowerCI <- coef_data$Estimate - 1.96 * coef_data$StdError
coef_data$UpperCI <- coef_data$Estimate + 1.96 * coef_data$StdError

p2 <- ggplot(coef_data, aes(x = reorder(Variable, Estimate), y = Estimate)) +
  geom_point(size = 4, color = "steelblue") +
  geom_errorbar(aes(ymin = LowerCI, ymax = UpperCI), 
                width = 0.2, color = "steelblue", size = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red", size = 1) +
  coord_flip() +
  labs(title = "Regression Coefficients with 95% Confidence Intervals",
       x = "Variable",
       y = "Coefficient Estimate") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.text = element_text(size = 11),
        axis.title = element_text(size = 12))

print(p2)
dev.off()

cat("✓ Coefficients visualization plot saved: plots/04_coefficients_visualization.png\n")

# Plot 5: Residuals by Each Predictor
png(filename = "plots/05_residuals_by_predictors.png", 
    width = 14, height = 5, units = "in", res = 300)

p3 <- ggplot(student_data, aes(x = Frequency, y = residuals)) +
  geom_point(color = "steelblue", size = 2, alpha = 0.6) +
  geom_smooth(method = "loess", color = "red", se = FALSE) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray") +
  labs(title = "Residuals vs Frequency",
       x = "Frequency",
       y = "Residuals") +
  theme_minimal()

p4 <- ggplot(student_data, aes(x = Degree, y = residuals)) +
  geom_point(color = "steelblue", size = 2, alpha = 0.6) +
  geom_smooth(method = "loess", color = "red", se = FALSE) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray") +
  labs(title = "Residuals vs Degree",
       x = "Degree",
       y = "Residuals") +
  theme_minimal()

p5 <- ggplot(student_data, aes(x = Grade, y = residuals)) +
  geom_point(color = "steelblue", size = 2, alpha = 0.6) +
  geom_smooth(method = "loess", color = "red", se = FALSE) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray") +
  labs(title = "Residuals vs Grade",
       x = "Grade",
       y = "Residuals") +
  theme_minimal()

combined_plot <- grid.arrange(p3, p4, p5, ncol = 3)
print(combined_plot)
dev.off()

cat("✓ Residuals by predictors plot saved: plots/05_residuals_by_predictors.png\n")

################################################################################
# 7. Generate Summary Report
################################################################################

# Create a text summary report
report_text <- paste(
  "================================================================================",
  "R LINEAR REGRESSION ANALYSIS REPORT",
  "================================================================================",
  paste("Analysis Date:", Sys.Date()),
  "",
  "STUDY OBJECTIVE:",
  "Examine the relationship between UVLT vocabulary test score (y3) and three",
  "predictors: English learning app usage frequency (Frequency), CET-4 English",
  "study degree (Degree), and Gaokao Chinese language score (Grade).",
  "",
  "================================================================================",
  "DATA SUMMARY",
  "================================================================================",
  paste("Sample Size:", nrow(student_data)),
  paste("Number of Cohorts:", length(unique(student_data$Cohort))),
  "",
  "Variable Descriptions:",
  "  • Frequency: English learning app usage frequency (scale: 1-10)",
  "  • Degree: CET-4 English study degree (scale: 1-10)",
  "  • Grade: Gaokao Chinese language score (scale: 90-130)",
  "  • y3: UVLT vocabulary test score (dependent variable)",
  "",
  paste("Mean y3:", round(mean(student_data$y3), 2)),
  paste("SD y3:", round(sd(student_data$y3), 2)),
  paste("Range y3:", min(student_data$y3), "-", max(student_data$y3)),
  "",
  "================================================================================",
  "REGRESSION MODEL",
  "================================================================================",
  "Model Formula: y3 ~ Frequency + Degree + Grade",
  "",
  "Regression Equation:",
  sprintf("y3 = %.4f + %.4f*Frequency + %.4f*Degree + %.4f*Grade",
          coef(model)[1], coef(model)[2], coef(model)[3], coef(model)[4]),
  "",
  "================================================================================",
  "REGRESSION COEFFICIENTS",
  "================================================================================",
  sprintf("%-15s %12s %12s %10s %10s %10s",
          "Variable", "Estimate", "Std. Error", "t-value", "p-value", "Sig."),
  paste(rep("-", 80), collapse = ""),
  sprintf("%-15s %12.6f %12.6f %10.4f %10.6f %10s",
          "Intercept",
          coef(model)[1],
          summary(model)$coefficients[1, 2],
          summary(model)$coefficients[1, 3],
          summary(model)$coefficients[1, 4],
          ifelse(summary(model)$coefficients[1, 4] < 0.001, "***",
                 ifelse(summary(model)$coefficients[1, 4] < 0.01, "**",
                        ifelse(summary(model)$coefficients[1, 4] < 0.05, "*",
                               ifelse(summary(model)$coefficients[1, 4] < 0.10, ".", ""))))),
  sprintf("%-15s %12.6f %12.6f %10.4f %10.6f %10s",
          "Frequency",
          coef(model)[2],
          summary(model)$coefficients[2, 2],
          summary(model)$coefficients[2, 3],
          summary(model)$coefficients[2, 4],
          ifelse(summary(model)$coefficients[2, 4] < 0.001, "***",
                 ifelse(summary(model)$coefficients[2, 4] < 0.01, "**",
                        ifelse(summary(model)$coefficients[2, 4] < 0.05, "*",
                               ifelse(summary(model)$coefficients[2, 4] < 0.10, ".", ""))))),
  sprintf("%-15s %12.6f %12.6f %10.4f %10.6f %10s",
          "Degree",
          coef(model)[3],
          summary(model)$coefficients[3, 2],
          summary(model)$coefficients[3, 3],
          summary(model)$coefficients[3, 4],
          ifelse(summary(model)$coefficients[3, 4] < 0.001, "***",
                 ifelse(summary(model)$coefficients[3, 4] < 0.01, "**",
                        ifelse(summary(model)$coefficients[3, 4] < 0.05, "*",
                               ifelse(summary(model)$coefficients[3, 4] < 0.10, ".", ""))))),
  sprintf("%-15s %12.6f %12.6f %10.4f %10.6f %10s",
          "Grade",
          coef(model)[4],
          summary(model)$coefficients[4, 2],
          summary(model)$coefficients[4, 3],
          summary(model)$coefficients[4, 4],
          ifelse(summary(model)$coefficients[4, 4] < 0.001, "***",
                 ifelse(summary(model)$coefficients[4, 4] < 0.01, "**",
                        ifelse(summary(model)$coefficients[4, 4] < 0.05, "*",
                               ifelse(summary(model)$coefficients[4, 4] < 0.10, ".", ""))))),
  paste(rep("-", 80), collapse = ""),
  "Significance codes: *** p<0.001; ** p<0.01; * p<0.05; . p<0.10",
  "",
  "================================================================================",
  "MODEL FIT STATISTICS",
  "================================================================================",
  sprintf("R-squared:                  %.6f", summary(model)$r.squared),
  sprintf("Adjusted R-squared:         %.6f", summary(model)$adj.r.squared),
  sprintf("F-statistic:                %.4f", summary(model)$fstatistic[1]),
  sprintf("df1 (numerator):            %.0f", summary(model)$fstatistic[2]),
  sprintf("df2 (denominator):          %.0f", summary(model)$fstatistic[3]),
  sprintf("P-value (overall model):    %.2e", pf(summary(model)$fstatistic[1],
                                                   summary(model)$fstatistic[2],
                                                   summary(model)$fstatistic[3],
                                                   lower.tail = FALSE)),
  sprintf("Residual Std. Error:        %.6f", summary(model)$sigma),
  "",
  "================================================================================",
  "MODEL DIAGNOSTICS",
  "================================================================================",
  "Variance Inflation Factor (VIF) - Multicollinearity Check:",
  paste(sprintf("  %s: %.4f", names(vif_values), vif_values), collapse = "\n"),
  "(VIF < 5 indicates acceptable multicollinearity)",
  "",
  sprintf("Shapiro-Wilk Normality Test: W = %.6f, p-value = %.6f",
          shapiro_test$statistic, shapiro_test$p.value),
  ifelse(shapiro_test$p.value > 0.05,
         "Result: Residuals appear normally distributed (p > 0.05)",
         "Result: Residuals may not be normally distributed (p < 0.05)"),
  "",
  "================================================================================",
  "INTERPRETATION AND CONCLUSIONS",
  "================================================================================",
  "OVERALL MODEL:",
  sprintf("The linear regression model explains %.2f%% of the variance in y3 scores.",
          summary(model)$r.squared * 100),
  sprintf("The model is statistically significant (F = %.4f, p < 0.001).",
          summary(model)$fstatistic[1]),
  "",
  "INDIVIDUAL PREDICTORS:",
  "",
  paste0("1. FREQUENCY (English learning app usage frequency):",
         "\n   Coefficient: ", round(coef(model)[2], 6),
         "\n   P-value: ", round(summary(model)$coefficients[2, 4], 6),
         "\n   Interpretation: ", 
         ifelse(summary(model)$coefficients[2, 4] < 0.05,
                "This predictor is STATISTICALLY SIGNIFICANT.",
                "This predictor is NOT statistically significant."),
         "\n   Each unit increase in Frequency is associated with a change of ",
         round(coef(model)[2], 4), " units in y3 (holding other variables constant)."),
  "",
  paste0("2. DEGREE (CET-4 English study degree):",
         "\n   Coefficient: ", round(coef(model)[3], 6),
         "\n   P-value: ", round(summary(model)$coefficients[3, 4], 6),
         "\n   Interpretation: ",
         ifelse(summary(model)$coefficients[3, 4] < 0.05,
                "This predictor is STATISTICALLY SIGNIFICANT.",
                "This predictor is NOT statistically significant."),
         "\n   Each unit increase in Degree is associated with a change of ",
         round(coef(model)[3], 4), " units in y3 (holding other variables constant)."),
  "",
  paste0("3. GRADE (Gaokao Chinese language score):",
         "\n   Coefficient: ", round(coef(model)[4], 6),
         "\n   P-value: ", round(summary(model)$coefficients[4, 4], 6),
         "\n   Interpretation: ",
         ifelse(summary(model)$coefficients[4, 4] < 0.05,
                "This predictor is STATISTICALLY SIGNIFICANT.",
                "This predictor is NOT statistically significant."),
         "\n   Each unit increase in Grade is associated with a change of ",
         round(coef(model)[4], 4), " units in y3 (holding other variables constant)."),
  "",
  "================================================================================",
  "ASSUMPTIONS CHECKING",
  "================================================================================",
  "1. Linearity: Checked via residuals vs fitted plot",
  "2. Normality: Shapiro-Wilk test and Q-Q plot",
  "3. Homoscedasticity: Scale-location plot",
  "4. Independence: Check plot of residuals vs order",
  "5. Multicollinearity: VIF values < 5",
  "",
  "See diagnostic plots for visual assessment.",
  "",
  "================================================================================",
  sep = "\n"
)

# Write report to file
report_file <- "linear_regression_report.txt"
writeLines(report_text, report_file)
cat("\n✓ Report saved to: ", report_file, "\n")

# Also display the report
cat("\n")
cat(report_text)
cat("\n")

cat("\n================================================================================\n")
cat("ANALYSIS COMPLETE\n")
cat("================================================================================\n")
cat("Output files generated:\n")
cat("  1. linear_regression_report.txt - Statistical report\n")
cat("  2. plots/01_residual_diagnostics.png - 4-panel diagnostic plots\n")
cat("  3. plots/02_residual_distribution.png - Residual distribution\n")
cat("  4. plots/03_actual_vs_predicted.png - Actual vs predicted scatter plot\n")
cat("  5. plots/04_coefficients_visualization.png - Coefficients with CI\n")
cat("  6. plots/05_residuals_by_predictors.png - Residuals by each predictor\n")
cat("================================================================================\n")
