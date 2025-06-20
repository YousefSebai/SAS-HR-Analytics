# HR Analytics Project

## 📊 Overview

This project focuses on analyzing HR data to uncover key insights related to **employee attrition**, **salary distribution**, and **demographic patterns** using **SAS Studio**. The ultimate goal is to support Human Resource teams in making data-driven decisions that reduce employee turnover and improve workforce planning.

---

## 🎯 Objectives

- Investigate key factors influencing employee attrition.
- Examine the relationship between salary, age, distance from home, and attrition.
- Visualize insights to enable strategic interventions.
- Provide actionable recommendations to HR stakeholders.

---

## 🛠 Tools Used

- **SAS Studio**: Data cleaning, SQL aggregation, and visualization.
- **PROC SQL**: For querying and summarizing HR data.
- **PROC SGPLOT**: For generating interactive and static charts.

---

## 📂 Dataset Overview

The dataset contains employee-level information including:

- `Age`, `AgeGroup`
- `Gender`
- `MonthlyIncome`
- `DistanceFromHome`
- `Department`, `EducationField`, `JobRole`
- `Attrition` (Yes/No)

---

## 📈 Key Insights

### ✅ Attrition Overview
- **Total Attrition**: 229 employees
- **Overall Attrition Rate**: **16.2%**

### 👥 Gender-Based Attrition
- **Male Attrition Rate**: **17.2%**
- **Female Attrition Rate**: **14.84%**

> Male employees experienced a slightly higher attrition rate than female employees.

### 💰 Salary-Based Attrition
- **Highest Attrition**: Employees earning **≤ $5,000/month**
- **Lowest Attrition**: Employees earning **> $15,000/month**

> Clear trend: Higher salary correlates with lower attrition.

### 🎓 Education Field Impact
- **Highest Attrition**: **Human Resources**

> Employees with an HR educational background showed the highest attrition rate among all fields.

### 📍 Distance From Home
- **Highest Attrition**: Employees living **20–25 miles** from the workplace

> Longer commutes appear to be a significant factor in employee turnover.

### 📊 Age Group Insights
- **Highest Attrition Rate**: **18–25 age group** at **36.3%**

> Younger employees are more likely to leave, possibly due to career exploration or job mismatch.

---

## 📊 Visualizations

- **Bar Charts & Line Plots** using `PROC SGPLOT`:
  - Attrition by Department, AgeGroup, Gender, and DistanceFromHome
  - Average Monthly Income by AgeGroup, Gender, and EducationField

---

## 💡 Sample Code Snippet

```sas
/* Attrition Rate by AgeGroup */
proc sql;
select AgeGroup,
       count(*) as Total_Employees,
       sum(case when Attrition = "Yes" then 1 else 0 end) as Total_Attrition,
       calculated Total_Attrition * 100.0 / calculated Total_Employees as Attrition_Rate
from HR_Analytics_Clean
group by AgeGroup
order by Attrition_Rate desc;
quit;
