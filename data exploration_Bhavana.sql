Select *
From portfolioproject..coviddeath
order by 3,4

Select *
From portfolioproject..covidvaccination
order by 3,4

Select Location,date,total_cases,new_cases,total_deaths,population
From portfolioproject..coviddeath
order by 1,2

-- TOTAL CASES Vs TOTAL DEATH
Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
From portfolioproject..coviddeath
order by 1,2

Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
From portfolioproject..coviddeath
where location like '%india%'
order by 1,2

-- TOTAL CASES Vs POPULATION
Select Location,date,total_cases,population,(total_cases/population)*100 as 'total_cases vs population'
From portfolioproject..coviddeath
order by 1,2

Select Location,date,total_cases,population,(total_cases/population)*100 as 'total_cases vs population'
From portfolioproject..coviddeath
where location like '%india%'
order by 1,2

-- Highest infection rate compared to population
Select Location,max(total_cases) as highestcases,population,max(total_cases/population)*100 as 'highest infected population'
From portfolioproject..coviddeath
group by location, population
order by 4 desc
 
-- highest death count per population

Select Location,max(cast(total_deaths as int)) as highestdeaths
From portfolioproject..coviddeath
where continent is not null
group by location
order by 2 desc

Select Location,max(cast(total_deaths as int)) as highestdeaths
From portfolioproject..coviddeath
where continent is  null
group by location
order by 2 desc

-- breakdown things by continents
Select continent,min(cast(total_deaths as int))as lowestdeaths
From portfolioproject..coviddeath
where continent is not null
group by continent
order by 2 desc

-- Continents with highest death count

Select continent,max(cast(total_deaths as int)) as highestdeaths
From portfolioproject..coviddeath
where continent is not null
group by continent
order by 2 desc

-- Global 
Select date,sum(new_cases)--total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
From portfolioproject..coviddeath
where continent is not null
group by date
order by 1,2
 
Select date,sum(new_cases),sum(cast(new_deaths as int))
From portfolioproject..coviddeath
where continent is not null
group by date
order by 1,2

Select date,sum(new_cases) as 'sum of new cases',
sum(cast(new_deaths as int)) as 'sum of new death', 
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercent
From portfolioproject..coviddeath
where continent is not null
group by date
order by 1 ,2
-- death percent
Select sum(new_cases) as 'sum of new cases',
sum(cast(new_deaths as int)) as 'sum of new death', 
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercent
From portfolioproject..coviddeath
where continent is not null
order by 1 ,2
  

-- Total population Vs Vaccination

Select *
From portfolioproject..covidvaccination vac 
join portfolioproject..coviddeath dea
on dea.location = vac.location and dea.date= vac.date

Select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations
From portfolioproject..covidvaccination vac 
join portfolioproject..coviddeath dea
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location  order by dea.location,dea.date) as rollong_people_vaccinated
From portfolioproject..covidvaccination vac 
join portfolioproject..coviddeath dea
	On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
order by 2,3

--Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, rollong_people_vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as rollong_people_vaccinated
--, (RollingPeopleVaccinated/population)*100
From portfolioproject..covidvaccination vac 
join portfolioproject..coviddeath dea
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (rollong_people_vaccinated/Population)*100
From PopvsVac









 