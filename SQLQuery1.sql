SELECT * FROM project..CovidDeaths$
ORDER BY 3,4

SELECT * FROM project..CovidVaccinations$
ORDER BY 3,4

-- Total Cases vs Total Deaths in Bangladesh

SELECT location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM project..CovidDeaths$
WHERE location like '%Bangla%'
order by 1,2

--Total Cases vs Population
--What percentage of population got covid

SELECT location, date,total_cases, population, (total_cases/population)*100 AS percentage_of_population_got_covid
FROM project..CovidDeaths$
WHERE location like '%Bangla%'
ORDER BY 1,2

--Countries with heighest infection rate compared to population

SELECT location,population, MAX(total_cases) AS Heighest_infection_count,  MAX((total_cases/population))*100 AS Heighest_Infection_rate
FROM project..CovidDeaths$
GROUP BY location,population
ORDER BY Heighest_Infection_rate DESC

--Countries with heighest death count per population in Asia

SELECT location, population, MAX(CAST(total_deaths AS INT)) AS Heighest_Death_Count
FROM project..CovidDeaths$
WHERE continent = 'Asia'
GROUP BY location,population
ORDER BY Heighest_Death_Count DESC

--Heighest death count by continent

SELECT continent, MAX(CAST(total_deaths AS INT)) AS Heighest_Death_Count
FROM project..CovidDeaths$
WHERE continent is not null
GROUP BY continent
ORDER BY Heighest_Death_Count DESC

--Total death in covid 19 in bangladesh

SELECT location, population, SUM(CAST(total_deaths AS INT)) AS Total_death_in_BD
FROM project..CovidDeaths$
WHERE location like '%Bangla%'
GROUP BY location, population
ORDER BY Total_death_in_BD


--Total people fully vaccinated in Bangladesh 

SELECT location, SUM(CAST(people_fully_vaccinated AS INT)) AS Fully_vaccinated_In_BD
FROM project..CovidDeaths$
WHERE location like '%Bangla%'
GROUP BY location
ORDER BY  Fully_vaccinated_In_BD

--Total population vs vaccinations

WITH Popvsvac (location, date , population ,new_vaccinations, Number_Of_People_Vaccinated)
AS
(
SELECT dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Number_Of_People_Vaccinated
FROM project..CovidDeaths$ dea 
JOIN project..CovidVaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
)
SELECT *, (Number_Of_People_Vaccinated/population)*100
FROM Popvsvac

--Creating View

CREATE VIEW Population_Vaccinated_Percentage 
AS 
SELECT dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CAST(vac.new_vaccin tions AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Number_Of_People_Vaccinated
FROM project..CovidDeaths$ dea 
JOIN project..CovidVaccinations$ vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 


