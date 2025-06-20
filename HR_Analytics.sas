proc import datafile="/home/u64260359/HR_Analytics (1).csv"
    out=HR_Analytics
    dbms=csv
    replace;
    getnames=yes;
run;
/* Info About the Variables and Observations */
proc contents data=HR_Analytics;
run;

/* Descriptive Statistics  */
proc means data=HR_Analytics n nmiss mean std min q1 median q3 max;
run;

/* Investigating missing values in the YearsWithCurrManager variable */


data Missing_YearsWithCurrManager;
    set HR_Analytics;
    if missing(YearsWithCurrManager);
run;
/* New Dataset After Removing Null Values */
data HR_Analytics_Clean;
    set HR_Analytics;
    if not missing(YearsWithCurrManager);
run;

proc print data = HR_Analytics_Clean;
run;

/* Checking Duplicates in Our Dataset */

proc sort data=HR_Analytics_Clean dupout=Duplicates nodupkey;
    by EmpID;
run;
/* No Any Duplicates in Our Dataset */

proc freq data=HR_Analytics_Clean;
    tables JobRole 
           Gender 
           MaritalStatus 
           BusinessTravel 
           EducationField 
           SalarySlab 
           Department
           Attrition/ nocum nopercent;
run;
/* Now we Dont Need to Standridize Any Categorical Column */


/* ---------------------------------------------------------------------------------------------------------------------------------- */
/* Now Lets Ask Questions about Data  */

/* Average Income by EducationField */

proc sql;
create table AvgIncome_By_EduField as
select EducationField,
       avg(MonthlyIncome) as Avg_Income
from HR_Analytics_Clean
group by EducationField;
quit;

proc sgplot data=AvgIncome_By_EduField;
    vbar EducationField / response=Avg_Income datalabel 
                          fillattrs=(color=darkgreen)
                          stat=sum;
    yaxis label="Average Monthly Income";
    xaxis label="Education Field" discreteorder=data;
    title "Average Monthly Income by Education Field";
run;


/* Average Income by Gender */

proc sql;
create table AvgSalary_By_Gender as
select Gender,
       avg(MonthlyIncome) as Avg_Salary
from HR_Analytics_Clean
group by Gender;
quit;

proc sgplot data=AvgSalary_By_Gender;
    vbar Gender / response=Avg_Salary datalabel 
                  fillattrs=(color=purple)
                  stat=sum;
    yaxis label="Average Monthly Salary";
    xaxis label="Gender";
    title "Average Salary by Gender";
run;



/* Average Income by Age */

proc sql;
create table AvgIncome_By_AgeGroup as
select AgeGroup,
       avg(MonthlyIncome) as Avg_Income
from HR_Analytics_Clean
group by AgeGroup;
quit;

proc sgplot data=AvgIncome_By_AgeGroup;
    vbar AgeGroup / response=Avg_Income datalabel 
                    fillattrs=(color=darkgreen)
                    stat=sum;
    xaxis label="Age Group";
    yaxis label="Average Monthly Income";
    title "Average Monthly Income by Age Group";
run;


/* The Highest Income in Each Department */
proc sql ;
	select 
		Department,
		max(MonthlyIncome) as Highest_MIncome
	       
	from HR_Analytics_Clean
	group by Department
	order by Highest_MIncome desc;
quit;	




/* Total Attrition and Attrition Rate */
proc sql;
    select 
        count(*) as Total_Employees,
        sum(case when Attrition = "Yes" then 1 else 0 end) as Total_Attrition,
        calculated Total_Attrition * 100.0 / calculated Total_Employees as Attrition_Rate
    from HR_Analytics_Clean;
quit;


/* Attrition Rate Per Department */
proc sql;
    create table Attrition_By_Department as
    select 
        Department,
        count(*) as Total_Employees,
        sum(case when Attrition = "Yes" then 1 else 0 end) as Total_Attrition,
        calculated Total_Attrition * 100.0 / calculated Total_Employees as Attrition_Rate
    from HR_Analytics_Clean
    group by Department;
quit;

proc gchart data=Attrition_By_Department;
    pie Department / sumvar=Total_Attrition
                     value=inside
                     percent=outside
                     slice=outside
                     coutline=black;
    title "Total Attrition by Department";
run;
quit;

/* Attrition Rate Per Gender */

proc sql;
create table Attrition_By_Gender as
select gender,
       count(*) as Total_Employees,
       sum(case when Attrition = "Yes" then 1 else 0 end) as Total_Attrition,
       calculated Total_Attrition * 100.0 / calculated Total_Employees as Attrition_Rate
from  HR_Analytics_Clean
group by Gender;
quit;

proc gchart data=Attrition_By_Gender;
    pie Gender / sumvar=Attrition_Rate
                 value=inside
                 percent=outside
                 slice=outside
                 coutline=black;
    title "Attrition Rate by Gender";
run;
quit;
       

/* Attrition Rate by Salary */       
       
proc sql;
create table Attrition_By_Salary as
select SalarySlab,
       count(*) as Total_Employees,
       sum(case when Attrition = "Yes" then 1 else 0 end) as Total_Attrition,
       calculated Total_Attrition * 100.0 / calculated Total_Employees as Attrition_Rate
from  HR_Analytics_Clean
group by SalarySlab;
quit;

proc sgplot data=Attrition_By_Salary;
    vbar SalarySlab / response=Attrition_Rate datalabel;
    yaxis label="Attrition Rate (%)";
    xaxis label="Salary Slab";
    title "Attrition Rate by Salary Slab";
run;

/* Attrition Rate by Age */
proc sql;
create table Attrition_By_Age as
select AgeGroup,
       count(*) as Total_Employees,
       sum(case when Attrition = "Yes" then 1 else 0 end) as Total_Attrition,
       calculated Total_Attrition * 100.0 / calculated Total_Employees as Attrition_Rate
from  HR_Analytics_Clean
group by AgeGroup;
quit;

proc sgplot data=Attrition_By_Age;
    vbar AgeGroup / response=Attrition_Rate datalabel;
    yaxis label="Attrition Rate (%)";
    title "Attrition Rate by Age Group";
run;


/* Attrition Rate by Education Field */



proc sql;
create table Attrition_By_Education as
select EducationField,
       count(*) as Total_Employees,
       sum(case when Attrition = "Yes" then 1 else 0 end) as Total_Attrition,
       calculated Total_Attrition * 100.0 / calculated Total_Employees as Attrition_Rate
from HR_Analytics_Clean
group by EducationField;
quit;

proc sgplot data=Attrition_By_Education;
    vbar EducationField / response=Attrition_Rate datalabel;
    yaxis label="Attrition Rate (%)";
    xaxis label="Education Field";
    title "Attrition Rate by Education Field";
run;


/* Attrition Rate by DistanceFromHome */

proc sql;
create table Attrition_By_Distance as
select DistanceFromHome,
       count(*) as Total_Employees,
       sum(case when Attrition = "Yes" then 1 else 0 end) as Total_Attrition,
       calculated Total_Attrition * 100.0 / calculated Total_Employees as Attrition_Rate
from HR_Analytics_Clean
group by DistanceFromHome;
quit;


proc sgplot data=Attrition_By_Distance;
    series x=DistanceFromHome y=Attrition_Rate / markers lineattrs=(color=red thickness=2);
    xaxis label="Distance From Home (in km or units)";
    yaxis label="Attrition Rate (%)";
    title "Attrition Rate by Distance From Home";
run;











