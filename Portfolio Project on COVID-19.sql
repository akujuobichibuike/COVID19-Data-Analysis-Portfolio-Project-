-- Looking at the Total Deaths vs Population
SELECT location, date, population, total_cases,(total_cases/population)*100 as Infected_population_percentage
FROM CovidDeaths
--WHERE location like '%Nigeria%'
ORDER BY 1, 2

--Looking at countries with the lowest infected population percentage
SELECT location, population, MIN(total_cases) as lowest_infection_count, MIN((total_cases/population))*100 as Infected_population_percentage
FROM CovidDeaths
GROUP BY location, population
ORDER BY Infected_population_percentage

-- Looking at countries with the highest infected population percentage
SELECT location, population, MAX(total_cases) as Highest_infection_count, MAX((total_cases/population))*100 as Infected_population_percentage
FROM CovidDeaths
GROUP BY location, population
ORDER BY Infected_population_percentage DESC

-- Countries with the highest death count per population
SELECT location, MAX(CAST(total_deaths as int)) as highest_death_count 
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY highest_death_count DESC

--BREAKING IT DOWN BY CONTINENT
--Showing continents with the highest death count per population
SELECT continent, MAX(CAST(total_deaths as int)) as highest_death_count 
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY highest_death_count DESC


-- Global Numbers
SELECT date, SUM(new_cases) as sum_of_new_cases, SUM(CAST(new_deaths AS int)) as sum_of_new_deaths, SUM(CAST(new_deaths AS int)) / SUM(new_cases)* 100 AS Death_Percentage
FROM CovidDeaths
WHERE continent IS NOT NULL  
GROUP BY date
ORDER BY 1,2

--Moving to Joins
SELECT *
FROM CovidDeaths cvd
JOIN CovidVaccinations cvv
     ON cvd.location = cvv.location
	 AND cvd.date = cvv.date

--Looking at Total Population vs Vaccinations.
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_Vaccinated_People_Count)
as
(
SELECT cvd.continent, cvd.location, cvd.date, cvd.population, cvv.new_vaccinations, SUM(CAST(cvv.new_vaccinations AS INT)) OVER (PARTITION BY cvd.location ORDER BY cvd.location, cvd.date) AS Rolling_Vaccinated_People_Count
FROM CovidDeaths cvd
JOIN CovidVaccinations cvv
     ON cvd.location = cvv.location
	 AND cvd.date = cvv.date
WHERE cvd.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (Rolling_Vaccinated_People_Count/Population)*100
FROM PopvsVac

--Creating a View to store data for later visualisations

CREATE VIEW PopvsVac AS
SELECT cvd.continent, cvd.location, cvd.date, cvd.population, cvv.new_vaccinations, SUM(CAST(cvv.new_vaccinations AS INT)) OVER (PARTITION BY cvd.location ORDER BY cvd.location, cvd.date) AS Rolling_Vaccinated_People_Count
FROM CovidDeaths cvd
JOIN CovidVaccinations cvv
     ON cvd.location = cvv.location
	 AND cvd.date = cvv.date
WHERE cvd.continent IS NOT NULL
--ORDER BY 2,3