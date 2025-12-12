# 快速开始指南

## 5分钟内开始分析

### 第1步：安装所需包（仅需一次）

在R控制台中运行：

```r
install.packages(c("ggplot2", "gridExtra", "car", "lmtest"))
```

### 第2步：运行分析

**方式A - RStudio（推荐）**
1. 打开RStudio
2. 打开 `linear_regression_analysis.R`
3. 点击 "Source" 按钮（或按 Ctrl+Shift+S）

**方式B - R控制台**
```r
source("linear_regression_analysis.R")
```

**方式C - 命令行**
```bash
Rscript linear_regression_analysis.R
```

### 第3步：查看结果

脚本完成后会生成：
- `linear_regression_report.txt` - 统计报告
- `plots/` 目录中的5个PNG图表

---

## 主要输出文件说明

| 文件名 | 内容 | 用途 |
|--------|------|------|
| linear_regression_report.txt | 详细统计结果 | 数值结果参考 |
| 01_residual_diagnostics.png | 4面板诊断图 | 检查模型假设 |
| 02_residual_distribution.png | 残差分布图 | 检查正态性 |
| 03_actual_vs_predicted.png | 实际vs预测 | 评估预测精度 |
| 04_coefficients_visualization.png | 系数及CI | 可视化系数 |
| 05_residuals_by_predictors.png | 按预测变量分组残差 | 检查线性性 |

---

## 核心统计指标速查

### 如何判断模型好坏？

| 指标 | 优秀 | 良好 | 需改进 |
|------|------|------|--------|
| R² | > 0.80 | 0.50-0.80 | < 0.50 |
| F检验p值 | < 0.001 | < 0.05 | > 0.05 |
| 变量p值 | < 0.05 | - | > 0.05 |
| VIF | < 2 | < 5 | > 10 |

### 回归系数解释模板

**示例：Frequency的系数为0.852, p < 0.001**

```
Frequency每增加1个单位，y3增加0.852个单位
（在控制其他变量不变的情况下）
这个关系是统计显著的(p < 0.001)
```

---

## 常见任务

### 任务1：修改数据

编辑第34行的数据框定义：

```r
student_data <- data.frame(
  Frequency = c(...),  # 修改这里
  Degree = c(...),     # 修改这里
  Grade = c(...),      # 修改这里
  y3 = c(...),         # 修改这里
  Cohort = c(...)      # 修改这里
)
```

或从CSV文件读取：
```r
student_data <- read.csv("your_data.csv")
```

### 任务2：修改模型

编辑第119行：

```r
# 当前模型
model <- lm(y3 ~ Frequency + Degree + Grade, data = student_data)

# 移除某个变量
model <- lm(y3 ~ Frequency + Degree, data = student_data)

# 添加交互项
model <- lm(y3 ~ Frequency + Degree + Grade + Frequency:Degree, data = student_data)
```

### 任务3：导出结果到Word/Excel

```r
# 导出系数表到LaTeX (可导入Word)
library(stargazer)
stargazer(model, type = "latex", out = "coefficients.tex")

# 导出摘要到文本
sink("my_summary.txt")
print(summary(model))
sink()
```

### 任务4：进行更多诊断

```r
# 检测异常值
cooks_dist <- cooks.distance(model)
plot(cooks_dist, type = "h")
abline(h = 4/nrow(student_data), col = "red")

# 自相关检验 (Durbin-Watson)
library(lmtest)
dwtest(model)

# 彩色残差图
plot(model, which = 1)
```

---

## 故障排除

### 问题1：包加载失败
```
Error: there is no package called 'ggplot2'
```
**解决:** 运行 `install.packages("ggplot2")`

### 问题2：数据找不到
```
Error: object 'student_data' not found
```
**解决:** 确保在定义模型前运行了数据框创建代码

### 问题3：工作目录错误
```
Error in file(...) : cannot open the connection
```
**解决:** 运行 `setwd("your/path/to/project")`

### 问题4：图表保存失败
```
Error in png(...) : cannot open file
```
**解决:** 确保plots目录存在，或修改保存路径

---

## 完整的工作流程

```
1. 安装包 (install.packages)
     ↓
2. 打开脚本 (linear_regression_analysis.R)
     ↓
3. 修改数据(可选)
     ↓
4. 运行脚本 (Source)
     ↓
5. 查看控制台输出
     ↓
6. 查看生成的报告和图表
     ↓
7. 解释结果
     ↓
8. 撰写分析报告
```

---

## 更多帮助

- **详细用法:** 见 `README.md`
- **理论说明:** 见 `ANALYSIS_GUIDE.md`
- **输出示例:** 见 `EXAMPLE_OUTPUT.md`
- **R官方文档:** https://www.r-project.org/

---

## 关键R命令速查

```r
# 加载数据
data <- read.csv("file.csv")

# 拟合模型
model <- lm(y ~ x1 + x2 + x3, data = data)

# 查看结果
summary(model)

# 获取系数
coef(model)

# 获取残差
residuals(model)

# 获取预测值
predict(model)

# 方差膨胀因子
library(car)
vif(model)

# 诊断图
plot(model)

# 保存图
png("myplot.png", width=8, height=6, units="in", res=300)
plot(model)
dev.off()

# 正态性检验
shapiro.test(residuals(model))

# 齐次性检验
library(lmtest)
bptest(model)

# 信息准则(用于模型比较)
AIC(model1, model2)  # 赤池信息准则
BIC(model1, model2)  # 贝叶斯信息准则
```

---

**提示:** 首次运行时，脚本可能需要1-2分钟来生成所有图表。

