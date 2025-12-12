# R线性回归分析：y3与三变量关系分析

## 项目概述

本项目使用R语言对学生数据进行线性回归分析，研究UVLT词汇测试3000等级成绩(score3/y3)与三个自变量的关系。

### 研究变量说明

| 变量名 | 描述 | 取值范围 | 角色 |
|--------|------|---------|------|
| Frequency | 英语学习App使用频率 | 1-10 | 自变量(预测变量) |
| Degree | 英语四级学习程度 | 1-10 | 自变量(预测变量) |
| Grade | 高考语文成绩 | 90-130 | 自变量(预测变量) |
| score3 (y3) | UVLT词汇测试3000等级成绩 | - | 因变量(被解释变量) |
| Cohort | 队列分组 | A, B, C等 | 分组变量(仅用于分析) |

### 样本规模

- **总样本数**: 53名学生
- **变量数**: 4个主要分析变量 + 1个分组变量

---

## 项目结构

```
project/
├── linear_regression_analysis.R      # 主要R分析脚本
├── linear_regression_report.txt      # 统计分析报告
├── README.md                         # 本文件
└── plots/                            # 输出图表目录
    ├── 01_residual_diagnostics.png   # 残差诊断4面板图
    ├── 02_residual_distribution.png  # 残差分布直方图和Q-Q图
    ├── 03_actual_vs_predicted.png    # 实际值vs预测值散点图
    ├── 04_coefficients_visualization.png  # 回归系数可视化(附置信区间)
    └── 05_residuals_by_predictors.png    # 按预测变量分组的残差图
```

---

## 使用方法

### 前置要求

- R版本: 3.5.0 或更高版本
- 必需R包:
  - `ggplot2` - 数据可视化
  - `gridExtra` - 多图排列
  - `car` - 方差膨胀因子(VIF)计算
  - `lmtest` - Breusch-Pagan测试

### 安装依赖包

```r
install.packages(c("ggplot2", "gridExtra", "car", "lmtest"))
```

### 运行分析

#### 方法1: 在RStudio中运行

1. 打开RStudio
2. 打开 `linear_regression_analysis.R` 文件
3. 点击 "Source" 按钮，或使用快捷键 Ctrl+Shift+S (Windows/Linux) 或 Cmd+Shift+S (Mac)
4. 脚本会自动生成所有分析结果和图表

#### 方法2: 在R控制台运行

```r
source("linear_regression_analysis.R")
```

#### 方法3: 使用命令行运行

```bash
Rscript linear_regression_analysis.R
```

### 输出文件

脚本运行完成后会生成:

1. **linear_regression_report.txt** - 详细的统计分析报告(文本格式)
2. **plots/** 目录下的5个PNG格式图表

---

## 统计分析概览

### 线性回归模型

**模型公式：**
```
y3 = β₀ + β₁×Frequency + β₂×Degree + β₃×Grade + ε
```

其中:
- β₀ = 截距(常数项)
- β₁, β₂, β₃ = 回归系数(斜率)
- ε = 随机误差项

### 主要统计指标

#### 1. 模型拟合度指标

| 指标 | 说明 | 解释 |
|------|------|------|
| R² (决定系数) | 0-1之间 | 模型解释因变量方差的比例 |
| 调整R² | - | 考虑样本量和变量数的修正R² |
| F统计量 | - | 检验整体模型的显著性 |
| 残差标准误 | - | 预测误差的大小 |

#### 2. 回归系数统计

每个回归系数包含以下信息:

- **Estimate** - 系数估计值(回归系数)
- **Std. Error** - 标准误(系数估计的精度)
- **t value** - t统计量(=系数/标准误)
- **Pr(>|t|)** - p值(显著性水平)

#### 3. 显著性标记

```
*** p < 0.001    (极度显著)
**  p < 0.01     (非常显著)
*   p < 0.05     (显著)
.   p < 0.10     (边际显著)
    p ≥ 0.10     (不显著)
```

### 模型诊断

#### 关键假设检验

1. **线性关系假设** - 变量间为线性关系
   - 检验方法: "残差vs拟合值"图

2. **正态分布假设** - 残差应服从正态分布
   - 检验方法: Shapiro-Wilk检验 + Q-Q图

3. **等方差性假设** - 残差方差应保持恒定
   - 检验方法: "尺度-位置"图 + Breusch-Pagan检验

4. **独立性假设** - 各观测值应相互独立
   - 检验方法: 点顺序图、自相关检验

5. **多重共线性检验** - 自变量间不应存在高相关
   - 检验方法: 方差膨胀因子(VIF), VIF < 5为可接受

---

## 图表说明

### 1. 残差诊断四面板图 (01_residual_diagnostics.png)

- **左上** - Residuals vs Fitted: 检查线性关系和等方差性
- **右上** - Normal Q-Q: 检查残差正态分布
- **左下** - Scale-Location: 检查等方差性(尺度恒定性)
- **右下** - Residuals vs Leverage: 检查异常值和高杠杆点

### 2. 残差分布图 (02_residual_distribution.png)

- **左侧** - 残差直方图: 观察残差的分布形状
- **右侧** - Q-Q图: 与理论正态分布进行比较

### 3. 实际值vs预测值散点图 (03_actual_vs_predicted.png)

- 点应围绕45度虚线分布
- R²值显示在标题中
- 点越靠近直线，模型拟合度越好

### 4. 回归系数可视化 (04_coefficients_visualization.png)

- 显示每个变量的系数点估计
- 误差棒表示95%置信区间
- 跨越0的置信区间表示该系数不显著

### 5. 各预测变量的残差图 (05_residuals_by_predictors.png)

- 三个子图分别显示残差与每个预测变量的关系
- 红色曲线为局部加权平滑(LOESS)
- 应无明显的模式或趋势

---

## 解释指南

### 如何解释回归系数

**示例：** 假设Frequency的系数为0.5, p值为0.001

```
解释: 在控制Degree和Grade不变的前提下，
     Frequency每增加1个单位，y3会增加0.5个单位。
     这个效应是统计显著的(p < 0.001)。
```

### 如何判断模型质量

| 标准 | 优秀 | 良好 | 一般 | 差 |
|------|------|------|------|-----|
| R² | > 0.8 | 0.5-0.8 | 0.3-0.5 | < 0.3 |
| F检验p值 | < 0.001 | < 0.01 | < 0.05 | ≥ 0.05 |
| VIF | < 2 | < 5 | < 10 | ≥ 10 |

---

## 修改和自定义

### 修改数据

要使用自己的数据，编辑脚本中的"创建学生数据框"部分:

```r
student_data <- data.frame(
  Frequency = c(...),  # 修改这里
  Degree = c(...),     # 修改这里
  Grade = c(...),      # 修改这里
  y3 = c(...),         # 修改这里
  Cohort = c(...)      # 修改这里
)
```

或从CSV文件读取:

```r
student_data <- read.csv("your_data.csv")
```

### 修改回归模型

更改模型公式(第3部分):

```r
# 移除某个变量
model <- lm(y3 ~ Frequency + Degree, data = student_data)

# 添加交互项
model <- lm(y3 ~ Frequency + Degree + Grade + Frequency:Degree, data = student_data)

# 添加二次项
model <- lm(y3 ~ Frequency + I(Frequency^2) + Degree + Grade, data = student_data)
```

### 修改输出目录

更改第6部分中的目录:

```r
if (!dir.exists("my_output")) {
  dir.create("my_output")
}

png(filename = "my_output/01_residual_diagnostics.png", ...)
```

---

## 常见问题(FAQ)

### Q: 如何导出详细的系数表格?

A: 使用以下代码:

```r
library(stargazer)
stargazer(model, type = "text")

# 或导出为LaTeX表格
stargazer(model, type = "latex", out = "regression_table.tex")
```

### Q: 如何计算预测区间而非置信区间?

A: 修改第5部分的predict语句:

```r
predictions <- predict(model, newdata = student_data, 
                       interval = "prediction", level = 0.95)
```

### Q: 如何进行逐步回归(变量选择)?

A: 使用step函数:

```r
library(MASS)
model_stepwise <- step(model)
summary(model_stepwise)
```

### Q: 如何检测异常值?

A: 添加以下代码:

```r
# Cook距离
cooks_dist <- cooks.distance(model)
plot(cooks_dist, type = "h")
abline(h = 4/nrow(student_data), col = "red")

# 识别异常值
outliers <- which(cooks_dist > 4/nrow(student_data))
print(student_data[outliers, ])
```

---

## 技术细节

### 回归系数的计算

使用最小二乘法(OLS)估计:

β = (X'X)⁻¹X'y

其中:
- X = 设计矩阵(包括常数列)
- y = 因变量向量

### 假设检验原理

**零假设 (H₀):** βᵢ = 0 (变量不显著)
**备择假设 (H₁):** βᵢ ≠ 0 (变量显著)

**检验统计量:** t = β̂ᵢ / SE(β̂ᵢ)
**拒绝准则:** |t| > t_{α/2, n-p-1}

---

## 参考文献

- Fox, J. (2016). Applied Regression Analysis and Generalized Linear Models. Sage Publications.
- Wooldridge, J. M. (2015). Introductory Econometrics: A Modern Approach (6th ed.). Cengage Learning.
- James, G., Witten, D., Hastie, T., & Tibshirani, R. (2013). An Introduction to Statistical Learning. Springer.

---

## 许可证

本项目为教育用途。请遵守R及所使用包的许可证要求。

---

## 更新记录

- **2024年** - 初始版本创建，包含完整的线性回归分析框架

---

## 联系和支持

如有问题，请检查:

1. 确保已安装所有必需的R包
2. 检查数据文件格式是否正确
3. 确保工作目录设置正确
4. 查阅R官方文档和包vignette

---

**最后更新：** 2024年12月

