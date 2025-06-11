-- Using the Formula 1 Database

-- List all Constructors
SELECT DISTINCT name
FROM constructors;

-- List the names of all drivers in the dataset.
SELECT DISTINCT GivenName, FamilyName
FROM dirvers;


-- How many constructors are there in the dataset?
SELECT COUNT(DISTINCT constructorId) AS constructorCount
FROM constructors;


-- How many drivers are there in the dataset?
SELECT COUNT(DISTINCT driverId) AS driverCount
FROM drivers;


-- Retrieve all races that took place in the 2020 season.
SELECT Season, Round, CircuitID
FROM results_qualy
WHERE Season = 2020;

-- - Retrieve the `Name` and `Nationality` of all constructors.
SELECT Name, Nationality
FROM constructors;



-- - Retrieve driver `GivenName` and `FamilyName` and alias them as `FirstName` and `LastName`.
SELECT GivenName AS FirstName, FamilyName AS LastName
FROM drivers;


-- - Retrieve distinct nationalities of drivers from the `drivers` table.
SELECT DISTINCT Nationality
FROM drivers;


-- - Retrieve the `Position` and `Points` of drivers, and calculate their `PointsPerPosition` (Points divided by Position).
SELECT Points, Position, (Points/Position) AS PointsPerPosition
FROM driver_standings;


-- - Retrieve driver `GivenName` and `FamilyName` concatenated into a single column named `FullName`.
SELECT CONCAT_WS(' ', GivenName, FamilyName) AS FullName
FROM drivers;


-- - Retrieve all races where the `Season` is 2022.
SELECT *
FROM results
WHERE Season = 2022;


-- - Retrieve drivers who are either `German` or `British`.
SELECT *
FROM drivers
WHERE Nationality IN ('German', 'British');


-- - Retrieve all constructors whose name contains 'Ferrari'.
SELECT *
FROM constructors
WHERE Name LIKE '%Ferrari%';


-- - Retrieve all results where the `ConstructorID` is either 'ferrari' or 'williams'.
SELECT *
FROM results
WHERE ConstructorName IN ('Ferrari','Williams');


-- - Retrieve all drivers who were born before 2000.
SELECT *
FROM drivers
WHERE DateOfBirth < '2000-01-01';



-- - Retrieve all races sorted by `Season` in ascending order.
SELECT * 
FROM results
ORDER BY season ASC;


-- - Retrieve all drivers sorted first by `Nationality` and then by `GivenName`.
SELECT *
FROM drivers
ORDER BY Nationality ASC, GivenName ASC;


-- - Retrieve all results sorted by `Points` in descending order.
SELECT *
FROM results
ORDER BY Points DESC;


-- - Retrieve all drivers and sort by `DateOfBirth`, placing NULL values last.
SELECT *
FROM drivers
ORDER BY
    DateOfBirth IS NULL ASC,
    DateOfBirth ASC;


-- - Retrieve the top 5 drivers with the highest `Points` in the 2020 season.
SELECT TOP 5 *
FROM driver_standings
WHERE season = 2020
ORDER BY points DESC;


-- - Retrieve the first 10 constructors from the `constructors` table.
SELECT TOP 10 *
FROM constructors;



-- - Retrieve 10 drivers starting from the 11th driver in the list.
SELECT *
FROM drivers
ORDER BY driverId
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;


-- - Retrieve the next 10 drivers after the top 5 drivers with the most `Points` in the 2021 season.
SELECT DriverID, Points
FROM results
WHERE Season = 2021
ORDER BY points DESC
OFFSET 5 ROWS
FETCH NEXT 10 ROWS ONLY;

-- - Retrieve the first 5 results of the 2020 season without specifying the order.
SELECT TOP 5 *
FROM results
WHERE Season = 2020


-- - Retrieve drivers for the 2020 season, showing results 11 through 20.
SELECT *
FROM results
WHERE Season = 2020
ORDER BY Points ASC
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY;


-- - Calculate the total `Points` scored in the 2024 season.
SELECT SUM(points) AS TotalPoints
FROM results
WHERE Season = 2024;


-- - Calculate the average `Points` scored by drivers in the 2000 season.
SELECT AVG(points) AS AveragePoints
FROM results
WHERE Season = 2000;


-- - Find the maximum and minimum `Points` scored by a driver in the 2021 season.
SELECT MAX(points) AS MaximumPoints, MIN(points) AS MinimumPoints
FROM results
WHERE Season = 2021;


-- - Count the number of races in the 2000 season.
SELECT COUNT(DISTINCT CircuitID) AS Race_Count
FROM results
WHERE Season = 2000;


-- - List all drivers in each constructor, concatenated into a single column.
SELECT ConstructorName, 
       STRING_AGG(
           DriverName,
           ', '
       ) WITHIN GROUP (ORDER BY DriverName ASC) AS Drivers
FROM (
    SELECT DISTINCT r.ConstructorName, 
           CONCAT(d.GivenName, ' ', d.FamilyName) AS DriverName
    FROM results AS r
    JOIN drivers AS d ON r.driverId = d.driverId
) AS UniqueDrivers
GROUP BY ConstructorName;


-- - Retrieve the total `Points` scored by each constructor in the 2000 season.
SELECT ConstructorName, SUM(Points) AS TotalPoints
FROM results
WHERE Season = 2000
GROUP BY ConstructorName;

-- - Retrieve constructors that have more than 20 `Points` in the 2002 season.
SELECT ConstructorName, SUM(Points) AS TotalPoints
FROM results
WHERE Season = 2002 
GROUP BY ConstructorName
HAVING SUM(Points) > 20;


-- - Count the number of races each constructor participated in during 2020.
SELECT ConstructorName, COUNT(*) AS CountOfRaces
FROM results
WHERE Season = 2020
GROUP BY ConstructorName;


-- - Calculate the total `Points` for each driver, grouped by `Nationality`.
SELECT d.Nationality, d.GivenName, d.FamilyName, SUM(r.Points) AS TotalPoints
FROM results r
JOIN drivers d ON r.DriverID = d.driverId
GROUP BY d.Nationality, d.GivenName, d.FamilyName
ORDER BY TotalPoints DESC;


-- - Retrieve the average `Points` for each constructor and season combination.
SELECT ConstructorName, Season, AVG(Points) AS AveragePoints
FROM results
GROUP BY ConstructorName, Season
ORDER BY AveragePoints DESC;


-- - Retrieve driver names and their corresponding constructor names for races in the 2000 season.
SELECT DISTINCT d.GivenName, d.FamilyName, r.ConstructorName
FROM results r
INNER JOIN drivers d ON r.DriverID = d.driverId
WHERE Season = 2000;


-- - Retrieve all constructors and any drivers who raced for theM(include constructors with no drivers).
SELECT c.constructorId, d.GivenName, d.FamilyName
FROM constructors c
LEFT JOIN results r ON c.constructorId = r.ConstructorName
LEFT JOIN drivers d ON r.DriverID = d.driverId
GROUP BY c.constructorId, d.GivenName, d.FamilyName;


-- - Retrieve all results and the corresponding drivers for each result, including results with no drivers.
SELECT d.GivenName, d.FamilyName, r.*
FROM results r
RIGHT JOIN drivers d ON r.DriverID = d.driverId



-- - Retrieve a list of all drivers and their corresponding results, including drivers who have not participated in any races.
SELECT  d.GivenName, d.FamilyName, r.Position, r.Points
FROM drivers d
LEFT JOIN results r ON d.driverId = r.DriverID
ORDER BY d.GivenName, d.FamilyName;


-- - Retrieve the GivenName, FamilyName, and ConstructorName for each driver, along with their total Points earned in the 2000 season.
SELECT d.GivenName, d.FamilyName, c.ConstructorID, SUM(r.Points) AS TotalPoints
FROM drivers d
JOIN results r ON d.driverId = r.DriverID
JOIN constructors c ON r.ConstructorName = c.constructorId
WHERE r.Season = 2000
Group BY d.GivenName, d.FamilyName, c.constructorId
ORDER BY TotalPoints DESC;


-- - Retrieve drivers who have more points than the driver with the least points in the 2000 season.
SELECT d.GivenName, d.FamilyName, SUM(r.points) AS TotalPoints
FROM drivers d
JOIN results r ON d.driverId = r.DriverID
WHERE r.Season = 2000
GROUP BY d.driverId, d.GivenName, d.FamilyName
HAVING SUM(r.points) > (
		SELECT MIN(TotalPoints)
		FROM(
		SELECT SUM(r.Points) AS TotalPoints
		FROM results r
		WHERE r.Season = 2000
		GROUP BY r.DriverID
		) AS DriverTotals
)
ORDER BY TotalPoints DESC;


-- - Retrieve the `GivenName` and `FamilyName` of drivers along with their highest `Points` in any race.
SELECT d.GivenName, d.FamilyName,
	(SELECT MAX(r.Points)
	 FROM results r
	 WHERE r.DriverID = d.driverId) AS HighestPoints
FROM drivers d
ORDER BY HighestPoints DESC;


-- - Retrieve constructors and their drivers where the driver’s `Points` is greater than the average `Points` for that constructor.
SELECT DISTINCT c.constructorId, r.CircuitID, d.GivenName, d.FamilyName, r.Points, r.Season
FROM constructors c
JOIN results r ON c.constructorId = r.ConstructorName
JOIN drivers d ON r.DriverID = d.driverId
WHERE r.Points > (
	SELECT AVG(r2.Points)
	FROM results r2
	WHERE r2.ConstructorName = c.constructorId
	GROUP BY r2.ConstructorName
	);


-- - Retrieve the average points scored per driver in the 2000 season. Use a CTE to first calculate the total points scored by each driver, and then calculate the average from this aggregated data.
WITH TotalPointsCTE AS (
	SELECT d.DriverID, d.GivenName, d.FamilyName, SUM(r.Points) AS total_points
	FROM drivers d
	JOIN results r ON d.driverId = r.DriverID
	WHERE r.Season = 2000
	GROUP BY d.driverId, d.GivenName, d.FamilyName
)
SELECT GivenName, FamilyName, Total_points, 
	(SELECT AVG(total_points)
	 FROM TotalPointsCTE) AS average_points
FROM TotalPointsCTE;


-- - Retrieve drivers who have finished in the top 3 positions in more than 5 races in the 2000 season, along with their average points per race.
WITH topfinishers AS (
	SELECT r.driverId, COUNT(*) AS Top3Count
	FROM results r
	WHERE r.Season = 2000 AND r.Position <= 3
	GROUP BY r.DriverID
	HAVING COUNT(*) > 5
),
driverPoints AS(
	SElECT d.DriverId, d.GivenName, d.FamilyName, AVG(r.points) AS AvgPointsPerRace
	FROM drivers d
	JOIN results r ON r.DriverID = d.driverId
	WHERE r.Season = 2000
	GROUP BY d.driverId, d.GivenName, d.FamilyName
)
SELECT dp.GivenName, dp.FamilyName, ROUND(dp.AvgPointsPerRace, 2) As AvgPoints
FROM driverPoints dp 
JOIN topfinishers t ON t.driverId = dp.DriverID
GROUP BY dp.GivenName, dp.FamilyName, dp.AvgPointsPerRace;


