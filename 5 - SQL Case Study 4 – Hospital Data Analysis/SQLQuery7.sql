

--Q1. For each doctor, count how many distinct patients they have treated.

SELECT
	D.DoctorID,
	D.FirstName + ' ' + D.LastName as full_name,
	count(distinct patientID) as patients_treated
FROM hospital.PatientVisits V
join Hospital.Dim_Doctor D
on V.DoctorID = D.DoctorID
group by D.DoctorID, D.FirstName, D.LastName
order by patients_treated desc




--Q2. Show the revenue split by each payment method, along with total visits.

SELECT
	P.PaymentMethodID,
	P.PaymentMethod,
	SUM(V.BillAmount) as Revenue,
	COUNT(V.VisitID) as Total_Visits
FROM hospital.PatientVisits V
join Hospital.Dim_PaymentMethod P
on V.PaymentMethodID = P.PaymentMethodID
group by P.PaymentMethodID, P.PaymentMethod
order by Revenue desc





--Q3. Categorize patients into age groups and calculate the average bill amount for each age band.(Assume age at time of visit based on VisitDate.)

WITH AgeGroup as
(
	SELECT
		P.PatientID,
		P.DOB,
		DATEDIFF(year, P.DOB, V.VisitDate) as Age,
		CASE 
			WHEN DATEDIFF(year, P.DOB, V.VisitDate) < 18 then '0-17'
			WHEN DATEDIFF(YEAR, P.DOB, V.VisitDate) BETWEEN 18 AND 35 THEN '18-35'
			WHEN DATEDIFF(YEAR, P.DOB, V.VisitDate) BETWEEN 36 AND 55 THEN '36-55'
			ELSE '56+'
		END as AgeBand,
		v.BillAmount
	FROM Hospital.PatientVisits V
	join Hospital.Dim_Patient P
	on V.PatientID = P.PatientID
)
select
	AgeBand,
	AVG(BillAmount) as avg_bill_amount
from AgeGroup
group by AgeBand





--Q4. Find total revenue and number of visits for each department.

SELECT
	D.DepartmentID,
	D.DepartmentName,
	SUM(V.BillAmount) as total_revenue,
	COUNT(V.VisitID) as no_of_visit
FROM Hospital.Dim_Department D
join Hospital.PatientVisits V
on D.DepartmentID = V.DepartmentID
group by D.DepartmentID, D.DepartmentName




--Q5. Rank departments based on their total revenue within each department category.

SELECT
	D.DepartmentCategory,
	D.DepartmentName,
	SUM(V.BillAmount) as total_revenue,
	RANK() OVER(PARTITION BY D.DepartmentCategory ORDER BY SUM(V.BillAmount) DESC) as Dept_Rank
FROM Hospital.Dim_Department D
join Hospital.PatientVisits V
on D.DepartmentID = V.DepartmentID
group by D.DepartmentCategory, D.DepartmentName




--Q6. For each department, find the average satisfaction score and average wait time.

SELECT
	D.DepartmentName,
	AVG(V.SatisfactionScore) AS Avg_Satisfaction_Score,
	AVG(V.WaitTimeMinutes) AS Avg_Wait_Time_Mins
FROM Hospital.Dim_Department D
join Hospital.PatientVisits V
on D.DepartmentID = V.DepartmentID
group by D.DepartmentName




--Q7. Compare the total number of hospital visits on weekdays vs weekends.

with week_weekend as
(
	SELECT
		CASE
			WHEN DATEPART(weekday, VisitDate) = 6 OR DATEPART(weekday, VisitDate) = 7  THEN 'Weekends'
			ELSE
			'Weekdays'
		END AS Week_Category,
		VisitID
	FROM Hospital.PatientVisits
)
select
	Week_Category,
	COUNT(VisitID) as total_visit
from week_weekend
group by Week_Category




--Q8. For each month, calculate total visits and a running cumulative total of visits.

SELECT
	MONTH(VisitDate) AS Month,
	COUNT(VisitID) as total_visits,
	SUM(COUNT(VisitID)) OVER (ORDER BY MONTH(VisitDate) asc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'Cumulative_Total_Visits'
FROM Hospital.PatientVisits
group by MONTH(VisitDate)




--Q9. Find the doctors with the highest average satisfaction score (minimum 100 visits).

SELECT
	D.DoctorID,
	D.FirstName + ' ' + D.LastName AS Full_Name,
	AVG(V.SatisfactionScore) as Avg_Satisfaction_Score,
	COUNT(VisitID) AS Total_Visits
FROM Hospital.PatientVisits V
join Hospital.Dim_Doctor D
on V.DoctorID = D.DoctorID
group by D.DoctorID, D.FirstName, D.LastName
having COUNT(VisitID) >= 100




--Q10. Identify the most commonly prescribed treatment for each diagnosis.

SELECT
	D.DiagnosisName,
	T.TreatmentName,
	COUNT(T.TreatmentName) AS Treatment_Prescribed,
	RANK() OVER (PARTITION BY D.DiagnosisName ORDER BY COUNT(T.TreatmentName) DESC) AS Most_Prescribed
FROM Hospital.PatientVisits V
JOIN Hospital.Dim_Treatment T
ON V.TreatmentID = T.TreatmentID
JOIN Hospital.Dim_Diagnosis D
ON D.DiagnosisID = V.DiagnosisID
GROUP BY D.DiagnosisName, T.TreatmentName
