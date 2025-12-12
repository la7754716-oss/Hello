# R线性回归分析完整指南

## 目录
1. [统计方法概述](#统计方法概述)
2. [回归分析理论基础](#回归分析理论基础)
3. [R脚本详细说明](#r脚本详细说明)
4. [结果解释指南](#结果解释指南)
5. [诊断和验证](#诊断和验证)
6. [常见错误和排查](#常见错误和排查)

---

## 统计方法概述

### 什么是线性回归?

线性回归是一种统计方法，用于:
- **探索因变量与自变量间的线性关系**
- **定量预测**：给定自变量的值，预测因变量
- **因果推断**：评估自变量对因变量的因果影响

### 本研究的背景

我们关注的研究问题：
> **英语学习频率、四级学习程度和高考语文成绩如何共同影响UVLT词汇测试成绩？**

---

## 回归分析理论基础

### 1. 多元线性回归模型

**总体模型：**
```
y = β₀ + β₁x₁ + β₂x₂ + β₃x₃ + ε
```

**样本模型：**
```
ŷ = b₀ + b₁x₁ + b₂x₂ + b₃x₃
```

其中：
- **y (y3)** - 因变量(UVLT词汇测试成绩)
- **x₁ (Frequency)** - 第一个自变量(英语学习App使用频率)
- **x₂ (Degree)** - 第二个自变量(英语四级学习程度)
- **x₃ (Grade)** - 第三个自变量(高考语文成绩)
- **β₀, β₁, β₂, β₃** - 总体参数(未知)
- **b₀, b₁, b₂, b₃** - 样本估计量(已知)
- **ε** - 随机误差项

### 2. 基本假设

线性回归建立在以下假设之上：

#### (1) 线性关系 (Linearity)
- 因变量与各自变量的关系为线性
- 检验方法：残差vs拟合值图中应无明显模式

#### (2) 正态分布 (Normality)
- 误差项ε服从正态分布：ε ~ N(0, σ²)
- 检验方法：Q-Q图、Shapiro-Wilk检验、残差直方图

#### (3) 等方差性/齐次性 (Homoscedasticity)
- 各点的方差应相等：Var(εᵢ) = σ² (常数)
- 检验方法：尺度-位置图、Breusch-Pagan检验

#### (4) 独立性 (Independence)
- 各观测的误差项相互独立：Cov(εᵢ, εⱼ) = 0 (i ≠ j)
- 检验方法：Durbin-Watson检验、自相关函数图

#### (5) 无多重共线性 (No Multicollinearity)
- 自变量间不存在完全或高度相关
- 检验方法：VIF < 5 (理想 < 2)、相关矩阵

### 3. 参数估计：最小二乘法 (OLS)

#### 估计原理

目标：最小化残差平方和(SSE)
```
SSE = Σ(yᵢ - ŷᵢ)² → 最小
```

#### 计算公式

```
b = (X'X)⁻¹X'y
```

其中：
- X = 设计矩阵(包含常数列)
- y = 因变量列向量
- b = 系数向量

#### 方差估计

```
Var(b) = σ² × (X'X)⁻¹
SE(bⱼ) = √Var(bⱼ)
```

---

## R脚本详细说明

### 脚本结构

```
1. 环境设置和库加载
2. 创建数据框 (n=53)
3. 探索性数据分析
4. 拟合线性回归模型
5. 模型总结和系数输出
6. 诊断检验
7. 预测和残差分析
8. 生成诊断图表
9. 生成统计报告
```

### 关键代码段解释

#### (1) 数据创建

```r
student_data <- data.frame(
  Frequency = c(...),  # 1-10的向量
  Degree = c(...),     # 1-10的向量
  Grade = c(...),      # 90-130的向量
  y3 = c(...),         # 因变量
  Cohort = rep(c("A", "B", "C"), length.out = 53)  # 分组变量
)
```

**说明：**
- 创建53×5的数据框
- 每行代表一个学生的观测值
- Cohort为分组变量，用于后续的分组分析

#### (2) 相关矩阵

```r
correlation_matrix <- cor(student_data[, c("Frequency", "Degree", "Grade", "y3")])
```

**输出示例：**
```
          Frequency  Degree    Grade      y3
Frequency  1.000000  0.870  0.650  0.820
Degree     0.870000  1.000  0.720  0.850
Grade      0.650000  0.720  1.000  0.780
y3         0.820000  0.850  0.780  1.000
```

**解释：**
- 对角线为1(变量与自身的相关系数)
- 其他值显示变量间的线性相关程度(-1到1)
- 0.7-0.9为中等相关，>0.9为高相关

#### (3) 模型拟合

```r
model <- lm(y3 ~ Frequency + Degree + Grade, data = student_data)
```

**`lm()`函数参数：**
- 第一个参数：公式(y ~ x1 + x2 + x3)
- `data`：数据框名称

**输出类型：**lm对象，包含模型的所有信息

#### (4) 模型总结

```r
summary(model)
```

**输出包含：**

```
Call:
lm(formula = y3 ~ Frequency + Degree + Grade, data = student_data)

Residuals:
    Min      1Q  Median      3Q     Max 
-8.5532 -1.9870 -0.1234  2.0156  9.8743

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) -10.5432    5.2103  -2.023   0.0482 *  
Frequency     0.8524    0.1234   6.909   <2e-16 ***
Degree        0.6234    0.1567   3.980   0.0002 ***
Grade         0.0456    0.0123   3.707   0.0005 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 3.456 on 49 degrees of freedom
Multiple R-squared:  0.7823
Adjusted R-squared:  0.7654
F-statistic: 46.23 on 3 and 49 DF,  p-value: <2e-16
```

**关键指标解释：**

| 项目 | 说明 |
|------|------|
| Estimate | 回归系数的点估计 |
| Std. Error | 系数的标准误 |
| t value | t统计量 = 系数/标准误 |
| Pr(>|t|) | p值，显著性水平 |
| Residual standard error | 残差标准误(σ̂) |
| Degrees of freedom | 自由度(n-p-1) |
| R-squared | R²，模型解释的方差比例 |
| Adjusted R-squared | 调整后的R² |
| F-statistic | F统计量，整体模型显著性 |

#### (5) VIF计算

```r
vif_values <- vif(model)
```

**输出示例：**
```
Frequency    Degree      Grade 
     2.145     1.987     1.567
```

**解释标准：**
- VIF = 1：无相关性
- VIF < 5：可接受的多重共线性
- VIF < 2：理想情况，无明显多重共线性
- VIF > 10：严重的多重共线性，需要解决

#### (6) 正态性检验

```r
shapiro.test(residuals(model))
```

**零假设 (H₀)：**残差来自正态分布
**拒绝准则：**p < 0.05，则拒绝零假设，残差非正态

#### (7) 方差齐次性检验

```r
lmtest::bptest(model)
```

**零假设 (H₀)：**方差为常数(齐次)
**拒绝准则：**p < 0.05，则拒绝零假设，方差非齐次

#### (8) 预测和残差

```r
predictions <- predict(model, newdata = student_data, se.fit = TRUE)
student_data$predicted_y3 <- predictions$fit
student_data$residuals <- residuals(model)
```

**计算内容：**
- `predicted_y3`：预测的y3值(ŷ)
- `residuals`：残差(y - ŷ)
- `se.fit`：预测值的标准误

---

## 结果解释指南

### 1. 回归方程的解释

**示例回归方程：**
```
ŷ3 = -10.54 + 0.852×Frequency + 0.623×Degree + 0.046×Grade
```

**含义：**
- **截距 (-10.54)：**当所有预测变量都为0时，y3的期望值为-10.54
  - *实际意义：*由于Frequency和Degree的最小值为1(不能为0)，截距的实际意义有限

- **Frequency系数 (0.852)：**在控制Degree和Grade不变的情况下，Frequency每增加1个单位，y3增加0.852个单位
  - *数值示例：*若其他变量不变，Frequency从6提高到7，y3增加0.852分

- **Degree系数 (0.623)：**在控制Frequency和Grade不变的情况下，Degree每增加1个单位，y3增加0.623个单位

- **Grade系数 (0.046)：**在控制Frequency和Degree不变的情况下，Grade每增加1个单位，y3增加0.046个单位
  - *数值示例：*若其他变量不变，Grade从100增加到110(增加10分)，y3增加0.46分

### 2. 显著性检验的解释

#### 系数显著性检验

**过程：**
```
1. 建立假设
   H₀: βⱼ = 0 (变量对y3无线性影响)
   H₁: βⱼ ≠ 0 (变量对y3有线性影响)

2. 计算检验统计量
   t = bⱼ / SE(bⱼ)
   
3. 计算p值
   p = P(|T| > |t观测|), T ~ t(n-p-1)
   
4. 决策准则
   若 p < α，拒绝H₀，系数显著
   若 p ≥ α，不拒绝H₀，系数不显著
```

**显著性标记解释：**
```
*** p < 0.001    (p-value在千分之一以下) - 高度显著
**  p < 0.01     (p-value在百分之一以下) - 非常显著
*   p < 0.05     (p-value在百分之五以下) - 显著
.   p < 0.10     (p-value在百分之十以下) - 边际显著
    p ≥ 0.10     无显著性标记 - 不显著
```

**示例解释：**
- `Frequency: b=0.852, p=<2e-16 ***` 
  > Frequency系数高度显著，意味着英语学习频率对词汇成绩有很强的显著影响

- `Grade: b=0.046, p=0.145` 
  > Grade系数不显著，意味着在控制其他变量后，高考语文成绩对词汇成绩的影响不显著

#### 整体模型显著性检验

**F检验：**
```
H₀: β₁ = β₂ = β₃ = 0 (所有自变量都不显著)
H₁: 至少一个βⱼ ≠ 0 (至少一个自变量显著)

F = [SSR/p] / [SSE/(n-p-1)]
   = [解释的方差] / [未解释的方差]
   
自由度：(p, n-p-1)
```

- `F-statistic: 46.23, p-value: <2e-16`
  > 整体模型高度显著，意味着作为一个整体，这三个预测变量能够显著解释y3的变异

### 3. 模型拟合度的解释

#### R² (决定系数)

**定义：**
```
R² = SSR / SST = 1 - SSE / SST

其中：
SST = Σ(yᵢ - ȳ)²   (总平方和)
SSR = Σ(ŷᵢ - ȳ)²   (回归平方和)
SSE = Σ(yᵢ - ŷᵢ)²  (残差平方和)
```

**含义：**
R² 表示被自变量解释的因变量方差的比例

**示例：**
- `R² = 0.7823` 意味着 78.23% 的y3变异可以被Frequency、Degree和Grade解释
- 剩余的 21.77% 由其他未在模型中考虑的因素和随机误差解释

**评价标准：**
```
R² > 0.80    优秀(解释力强)
R² = 0.50-0.80    良好(解释力较强)
R² = 0.30-0.50    一般(解释力一般)
R² < 0.30    较差(解释力弱)
```

#### 调整R² (Adjusted R²)

**定义：**
```
Adjusted R² = 1 - (1 - R²) × [(n-1)/(n-p-1)]
            = 1 - [SSE/(n-p-1)] / [SST/(n-1)]
```

**为什么需要调整？**
- R² 会随着变量增加而自动增加，即使新变量没有实际预测力
- 调整R² 考虑了模型的复杂度(变量数)和样本量
- 用于比较具有不同变量数的模型

**示例：**
- `Adjusted R² = 0.7654` 略低于 R² = 0.7823
- 这种差异不大，表明添加的三个变量都相对有用

### 4. 残差的解释

**残差 = 实际值 - 预测值**
```
eᵢ = yᵢ - ŷᵢ
```

**残差的含义：**
- 正残差：模型低估了该观测值
- 负残差：模型高估了该观测值
- 绝对值大的残差：模型预测不准确的观测值

**残差诊断：**
- **平均值应为0：** mean(residuals) ≈ 0
- **应呈正态分布：** Shapiro-Wilk p > 0.05
- **应具有常数方差：** Breusch-Pagan p > 0.05
- **应无自相关：** Durbin-Watson ≈ 2

---

## 诊断和验证

### 1. 诊断图表解读

#### (1) Residuals vs Fitted 图

**含义：** 检查线性关系和等方差性

**理想情况：**
- 点随机散布在红线周围(水平的)
- 无明显的模式或趋势
- 点的方差保持相对恒定

**问题迹象：**
- 呈弧形或其他明显模式 → 非线性关系
- 点的方差随fitted值增加 → 异方差性
- 有明显的离群点 → 异常观测值

#### (2) Normal Q-Q 图

**含义：** 检查残差的正态分布

**理由：** 
- Q = Quantile(分位数)
- 理论分位数 vs 样本分位数的对比图

**理想情况：**
- 所有点都在或接近45度直线上
- 只有两端可能有轻微偏差

**问题迹象：**
- 明显偏离直线 → 非正态分布
- S形曲线 → 残差有重尾或轻尾
- 下端向下/上端向上 → 左偏或右偏分布

#### (3) Scale-Location 图

**含义：** 检查等方差性(齐次性)

**显示：** √|标准化残差| vs Fitted值

**理想情况：**
- 点随机散布，红线水平
- 点的高度保持相对一致

**问题迹象：**
- 红线明显上升或下降 → 异方差性
- 点的离散程度明显变化 → 方差非恒定

#### (4) Residuals vs Leverage 图

**含义：** 识别有影响力的观测值(异常点)

**关键概念：**
- Leverage：该观测对回归线的影响力
- 高Leverage点远离X的均值
- 高Leverage + 大残差 = 高影响力异常值

**问题迹象：**
- 跨越虚线(Cook距离)的点 → 需要检查
- 这些点可能是错误的观测或真实的异常

### 2. 多重共线性诊断

#### VIF 解释

```
VIF = 1 / (1 - R_j²)
```

其中 R_j² 是第j个变量与其他变量回归的R²

**计算示例：**
```
如果 Frequency 的 VIF = 2.145，那么：
- 2.145 = 1 / (1 - R_j²)
- R_j² = 1 - 1/2.145 = 0.534
- Frequency 与其他变量的相关性为 √0.534 ≈ 0.73
```

**VIF 影响：**
- VIF越大，该变量的标准误越大
- 系数估计的精度越低
- 假设检验的检验力越低

**判断标准：**
```
VIF < 2       无多重共线性(理想)
2 ≤ VIF < 5   可接受的多重共线性
5 ≤ VIF < 10  较强的多重共线性(需要警惕)
VIF ≥ 10      严重的多重共线性(需要解决)
```

**解决方法：**
1. **删除相关的变量** - 移除高VIF的变量
2. **变量组合** - 创建主成分或指数
3. **收集更多数据** - 增加样本量
4. **正则化** - 使用岭回归或Lasso回归

### 3. 关键假设的完整检验

#### 正态性检验 - Shapiro-Wilk测试

```r
shapiro.test(residuals(model))
```

**原理：**
```
W = [Σ aᵢ x(ᵢ)]² / Σ(xᵢ - x̄)²
```

**决策：**
- p > 0.05：不拒绝H₀，可认为残差正态分布
- p ≤ 0.05：拒绝H₀，残差不符合正态分布

**补充检验：**
```r
# Anderson-Darling检验
library(nortest)
ad.test(residuals(model))

# Kolmogorov-Smirnov检验
ks.test(residuals(model), "pnorm")
```

#### 齐次性检验 - Breusch-Pagan测试

```r
lmtest::bptest(model)
```

**原理：** 检验误差方差是否依赖于拟合值

**决策：**
- p > 0.05：不拒绝H₀，方差齐次
- p ≤ 0.05：拒绝H₀，方差非齐次

**若检测到异方差：**
```r
# 加权最小二乘法(WLS)
library(AER)
model_wls <- lm(y3 ~ Frequency + Degree + Grade, 
                weights = 1/fitted(lm(abs(residuals(model)) ~ fitted(model)))^2,
                data = student_data)

# 或使用稳健标准误
library(sandwich)
library(lmtest)
coeftest(model, vcov = vcovHC)
```

---

## 常见错误和排查

### 错误1：数据框变量名不匹配

**症状：**
```
Error: object 'y3' not found
```

**原因：** 变量名大小写错误或不存在

**解决方案：**
```r
# 检查数据框中的变量名
names(student_data)

# 确保公式中的变量名与数据框中的变量名完全相同
model <- lm(y3 ~ Frequency + Degree + Grade, data = student_data)
```

### 错误2：缺少必要的包

**症状：**
```
Error: could not find function "vif"
```

**原因：** 未加载所需的包

**解决方案：**
```r
# 安装包
install.packages("car")

# 加载包
library(car)

# 然后执行函数
vif(model)
```

### 错误3：样本量不足

**症状：**
```
Warning: cannot compute exact p-value with ties
```

**原因：** 样本量太小(通常n < 30)

**影响：**
- 参数估计不稳定
- 假设检验可靠性下降
- 置信区间过宽

**建议：**
- 尽可能收集更多数据
- 降低显著性水平(如使用0.10而非0.05)

### 错误4：完美多重共线性

**症状：**
```
Warning: singularities in the model

Coefficients: (1 not defined because of singularities)
```

**原因：** 自变量间存在完全线性关系

**示例：**
```r
# 错误：包含redundant变量
model <- lm(y3 ~ Frequency + Degree + Grade + 
            (Frequency + Degree), # 这是冗余的！
            data = student_data)
```

**解决方案：**
```r
# 移除冗余变量
model <- lm(y3 ~ Frequency + Degree + Grade, data = student_data)

# 检查变量间的相关性
cor(student_data[, c("Frequency", "Degree", "Grade")])
```

### 错误5：异常值的影响

**症状：**
- R² 过低或过高
- 回归系数的符号出乎意料
- 标准误异常大

**诊断：**
```r
# 识别Cook距离大的点
cooks_dist <- cooks.distance(model)
outlier_threshold <- 4/nrow(student_data)
outliers <- which(cooks_dist > outlier_threshold)

# 查看异常观测
student_data[outliers, ]

# 计算不含异常值的模型
model_robust <- lm(y3 ~ Frequency + Degree + Grade, 
                   data = student_data, 
                   subset = -outliers)

# 比较两个模型
summary(model)
summary(model_robust)
```

### 错误6：模型假设不满足

**问题：**Q-Q图严重偏离、残差呈非线性模式

**解决方案：**

**(1) 变量转换：**
```r
# 对因变量进行对数转换
model_log <- lm(log(y3) ~ Frequency + Degree + Grade, 
                data = student_data)

# 对自变量进行平方根转换
model_sqrt <- lm(y3 ~ sqrt(Frequency) + sqrt(Degree) + Grade, 
                 data = student_data)
```

**(2) 添加交互项或多项式项：**
```r
# 交互项
model_interaction <- lm(y3 ~ Frequency + Degree + Grade + 
                        Frequency:Degree, 
                        data = student_data)

# 二次项
model_poly <- lm(y3 ~ Frequency + I(Frequency^2) + Degree + Grade, 
                 data = student_data)
```

**(3) 广义线性模型(GLM)：**
```r
# 如果因变量为二分类或计数数据
model_glm <- glm(y3 ~ Frequency + Degree + Grade, 
                 family = gaussian(link = "log"),
                 data = student_data)
```

---

## 总结和最佳实践

### 完整的分析工作流程

```
1. 数据准备和探索
   - 加载数据
   - 检查缺失值
   - 描述性统计
   - 相关矩阵

2. 模型拟合
   - 建立回归模型
   - 查看回归输出
   - 检查模型拟合度

3. 诊断检验
   - 线性性：残差vs拟合值
   - 正态性：Q-Q图 + Shapiro-Wilk
   - 齐次性：尺度-位置 + Breusch-Pagan
   - 多重共线性：VIF
   - 独立性：Durbin-Watson
   - 异常值：Cook距离

4. 模型改进
   - 如果假设不满足，考虑变换或模型调整
   - 比较备选模型
   - 选择最优模型

5. 结果报告
   - 回归方程
   - 系数解释
   - 显著性描述
   - 模型拟合度
   - 诊断图表
```

### 报告写作要点

在撰写分析报告时，应该包含：

1. **研究问题** - 清晰阐述研究目标
2. **数据和方法** - 样本描述、变量定义、分析方法
3. **主要结果** - 回归系数、显著性、R²、F统计量
4. **诊断结果** - 模型假设检验结果
5. **实质性解释** - 用非统计语言解释发现
6. **局限性** - 讨论研究的限制和假设
7. **结论和建议** - 总结主要发现和实际意义

---

**相关资源**

- R官方文档：https://www.r-project.org/
- CRAN包文档：https://cran.r-project.org/
- RStudio支持：https://rstudio.com/support/

