-- COVID CASE STUDY IN AFRICA

-- Necessary Insights Gathered

-- Looking at the number of countries in Africa that was affected by Covid -1 (Place this at the top of the report using a card feature)
SELECT COUNT(DISTINCT location) AS number_of_countries_affected
FROM CovidDeaths
WHERE continent = 'Africa'
GO

--List of countries that have given booster shots (Place this at the top of the report using a card feature)
SELECT COUNT(DISTINCT location) AS gotten_booster_shots
FROM CovidVaccinations
WHERE continent = 'Africa' and total_boosters != 0

--Total Number of Deaths in Africa from Covid -13 (Place this at the top of the report using a card feature)
SELECT SUM(CONVERT(int, new_deaths)) AS total_number_of_deaths
FROM CovidDeaths
WHERE continent = 'Africa' and new_deaths IS NOT NULL
GROUP BY continent

--Looking for the number of times countries have implemmented the booster shots -2 
--List of countries that have given citizens booster shots
SELECT location, COUNT(DISTINCT total_boosters) AS booster_shot
FROM CovidVaccinations
WHERE continent = 'Africa' and total_boosters != 0
GROUP BY location
ORDER BY booster_shot DESC

--List of countries that have not given citizens boster shots -2A
SELECT location AS not_gotten_booster_shots
FROM CovidVaccinations
WHERE continent = 'Africa' 
GROUP BY location
HAVING COUNT(total_boosters) = 0
ORDER BY not_gotten_booster_shots

--Looking for the number of times countries have vaccinated since the vaccination program started in Africa. -3
SELECT location, COUNT(DISTINCT CAST(total_vaccinations as numeric)) AS total_vaccinated
FROM CovidVaccinations
WHERE continent ='Africa' and total_vaccinations !=0
GROUP BY location
ORDER BY total_vaccinated DESC

-- Looking at the total cases vs total death (percentage) in Africa -4
-- Shows likelihood of dying if you contract covid in Africa
SELECT DISTINCT location, population, SUM(CAST(new_cases AS float)) AS total_cases, SUM(CONVERT(float,new_deaths)) AS total_deaths, (SUM(CONVERT(float,new_deaths))/SUM(CAST(new_cases AS float)))*100 AS death_percentage
FROM CovidDeaths
WHERE continent = 'Africa' and new_cases IS NOT NULL and new_deaths IS NOT NULL
GROUP BY location, population
ORDER BY death_percentage DESC

-- Looking at the Total Cases vs the Population in Africa -5
-- This shows the percentage of population that got COVID
SELECT DISTINCT location, population, SUM(CONVERT(int,new_cases)) AS number_of_cases, (SUM(CONVERT(int,new_cases))/population)*100 AS population_percentage
FROM CovidDeaths
WHERE continent = 'Africa' 
GROUP BY location, population
ORDER BY population_percentage DESC

-- Looking at Countries in Africa with highest infection rate. -6
SELECT location, population, MAX(new_cases) AS highest_infection_count, MAX(new_cases/population)*100 AS population_percentage
FROM CovidDeaths
WHERE continent = 'Africa'
GROUP BY location, population                                                                                                                                                                                                                                                  
ORDER BY 4 desc

-- Top 10 days that had the higest new cases in Africa -7
SELECT TOP 10 location, date, new_cases
FROM CovidDeaths
WHERE continent = 'Africa'
GROUP BY location, date, new_cases
ORDER BY 3 DESC

--Showing Countries with the TOP 20 Highest Death Count per Population in Africa -8
SELECT location, SUM(CAST(new_deaths as int)) AS highest_death_count, population, (SUM(CAST(new_deaths as int))/population)*100 AS fatality_percentage
FROM CovidDeaths
WHERE continent = 'Africa' and new_deaths IS NOT NULL
GROUP BY location, population
ORDER BY fatality_percentage DESC


--Looking at Total Population vs Vaccinations in Africa -9
--Total amount of individuals in Africa that have been vaccinated
SELECT DISTINCT DEA.location, DEA.population, SUM(CONVERT(int,vac.new_people_vaccinated_smoothed)) AS number_of_people_vaccinated, SUM(CAST(vac.new_people_vaccinated_smoothed AS int))/ DEA.population * 100 AS people_vaccinated_percentage
FROM CovidDeaths AS DEA
INNER JOIN CovidVaccinations AS VAC
 ON DEA.location = VAC.location
 and DEA.date = VAC. date
WHERE DEA.continent = 'Africa' and new_people_vaccinated_smoothed IS NOT NULL
GROUP BY  DEA.location, DEA.population
ORDER BY people_vaccinated_percentage DESC

--Looking at the Countries with the highest ICU Patients -10
SELECT location, COUNT(CONVERT(int, icu_patients)) AS total_icu_patients, population
FROM CovidDeaths
WHERE continent = 'Africa' and icu_patients IS NOT NULL
GROUP BY location, population
ORDER BY population DESC

--Countries that have gotten the booster shots -11
--Number of days in each country that the boosters have been administered
SELECT vac.location, COUNT(DISTINCT CONVERT(int,total_boosters)) AS total_booster, dea.population
FROM CovidVaccinations AS vac
INNER JOIN CovidDeaths AS dea
ON vac.location = dea.location and vac.date = dea.date
WHERE vac.continent = 'Africa' and total_boosters IS NOT NULL
GROUP BY vac.location, population_density, dea.population
ORDER BY total_booster DESC

--Countries that have been fully vaccinated -12
-- Shows the number of people tht have been vaccinated and the number of total vaccinations given.
SELECT DISTINCT vac.location, COUNT(CAST(people_vaccinated AS numeric)) AS people_vaccinated, COUNT(CONVERT(numeric, total_vaccinations)) AS total_vaccinations, dea. population
FROM CovidVaccinations vac
FULL OUTER JOIN CovidDeaths dea
ON vac.location = dea.location
WHERE vac.continent = 'Africa' 
GROUP BY vac.location, dea.population
ORDER BY population DESC

--Total Number of Deaths for Each Country in Africa -14
SELECT SUM(CONVERT(int,new_deaths)) AS total_deaths_for_countries,location
FROM CovidDeaths
WHERE continent = 'Africa' and new_deaths IS NOT NULL
GROUP BY location

--SELECT SUM(CONVERT(int,total_vaccinations))
----SELECT date, total_vaccinations
--FROM CovidVaccinations
--WHERE location = 'Nigeria'
----ORDER BY total_vaccinations 

--SELECT SUM(CONVERT(float,total_vaccinations))
--FROM CovidVaccinations
--WHERE location = 'United Kingdom' 

--SELECT SUM(CONVERT(float,total_vaccinations))
----SELECT date, total_vaccinations
--FROM CovidVaccinations
--WHERE location = 'Nigeria'
----ORDER BY total_vaccinations 

----SELECT date, total_vaccinations

----ORDER BY total_vaccinations DESC


----SELECT DISTINCT Location
----FROM CovidDeaths
----WHERE continent IS NOT NULL
--ORDER BY location

--SELECT *
--FROM CovidDeaths
--WHERE continent ='Africa'
--ORDER BY 3,4

--SELECT *
--FROM CovidVaccinations
--WHERE continent ='Africa'
--ORDER BY 3,4

---- Select the dataset that will be used.
--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM CovidDeaths
--ORDER BY 1,2

-- Top 10 countries in Africa that had the highest Population that contacted Covid
--SELECT TOP 10 location, population, MAX(total_cases) AS highest_infection_count, MAX(total_cases/population)*100 AS population_percentage
--FROM CovidDeaths
--WHERE continent = 'Africa'
--GROUP BY location, population
--ORDER BY 4 desc

 --SELECT DISTINCT *
 --FROM CovidDeaths
 --WHERE continent ='Africa' and location = 'Nigeria'

-- SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations,
--SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) 
--AS rolling_people_vaccinated
--FROM CovidDeaths AS DEA
--INNER JOIN CovidVaccinations AS VAC
-- ON DEA.location = VAC.location
-- and DEA.date = VAC. date
--WHERE DEA.continent = 'Africa'
--GROUP BY DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
--ORDER BY 1,2,3


-- To get the Percentage of People that have been Vaccinated in Africa, we have to either use a CTE or a Temp Table
-- With CTE 

--WITH PopvsVac (Continent, location, date, population, rolling_people_vaccination, new_vaccinations)
--AS
--(
--SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations, SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) AS rolling_people_vaccinated
--FROM CovidDeaths AS DEA
--INNER JOIN CovidVaccinations AS VAC
-- ON DEA.location = VAC.location
-- and DEA.date = VAC. date
--WHERE DEA.continent = 'Africa'
----ORDER BY 2,3
--)
--SELECT *, (rolling_people_vaccination/population)*100 AS percentage_people_vaccinated
--FROM PopvsVac

---- Looking at the Top 10 Maximum percentage of people vaccinated in Africa
---- With CTE

--WITH PopvsVac (Continent, location, population, rolling_people_vaccination, new_vaccinations)
--AS
--(
--SELECT DEA.continent, DEA.location, DEA.population, VAC.new_vaccinations, SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY DEA.location ORDER BY DEA.location) AS rolling_people_vaccinated
--FROM CovidDeaths AS DEA
--INNER JOIN CovidVaccinations AS VAC
-- ON DEA.location = VAC.location
-- and DEA.date = VAC. date
--WHERE DEA.continent = 'Africa'
----ORDER BY 2,3
--)
--SELECT TOP 10 *,  (rolling_people_vaccination/population)*100 AS percentage_people_vaccinated --MAX(rolling_people_vaccination/population)*100
--FROM PopvsVac
--ORDER BY percentage_people_vaccinated DESC

----Looking at the top 10 countries in Africa that has the highest population
--SELECT TOP 10 location, population
--FROM CovidDeaths
--WHERE continent = 'Africa'
--GROUP BY location, population
--ORDER BY population DESC