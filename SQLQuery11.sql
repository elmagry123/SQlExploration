select * 
from Project1..CovidDeaths
where continent is not null
order by 3,4


--select * 
--from Project1..Covidvaccinations
--order by 3,4


-- select Data that we are going to be using


select location , date , total_cases , new_cases,total_deaths, population
from Project1..CovidDeaths
where continent is not null
order by 1,2

-- Looking at total cases vs total Deaths  
-- shows likelihood of dying if you contract covid in your Country


select location , date , total_cases ,total_deaths,(total_deaths/total_cases)*100 as Deathpersentage 
from Project1..CovidDeaths
where location like '%states%'
and continent is not null
order by 1,2


-- Looking at total cases vs population 
-- shows what persentage of population got Covid 

select location , date ,population, total_cases ,(total_cases/population)*100 as percentpopulationInfected 
from Project1..CovidDeaths
--where location like '%states%'
order by 1,2

-- Looking at Countries with Highest Infection Rate Compared to population 

select location ,population, Max(total_cases) as HighestInfectionCount  ,Max((total_cases/population))*100 as percentpopulationInfected 
from Project1..CovidDeaths
--where location like '%states%'
Group by location,population
order by percentpopulationInfected desc

-- Showing Countries with Highest Death Count per population 


select location,Max(cast(total_deaths as int)) as TotaldeathCount
from Project1..CovidDeaths
where continent is not null
Group by location 
order by TotaldeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT 

-- Showing contintents with the highest death count per population

select continent,Max(cast(total_deaths as int)) as TotaldeathCount
from Project1..CovidDeaths
where continent is not null
Group by continent 
order by TotaldeathCount desc


-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Project1..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- Looking at Total Population vs Vaccinations

select dea.continent,dea.location,dea.date,dea.population, dea.new_vaccinations
, sum(convert(int,  dea.new_vaccinations)) OVER (partition by dea.Location order by dea.Location,
dea.Date) as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100

from Project1..CovidDeaths dea
join Project1..Covidvaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
order by 2,3
 


-- USE CTI 
with PopvsVac(Continent,Location,Date , population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population, dea.new_vaccinations
, sum(convert(int,  dea.new_vaccinations)) OVER (partition by dea.Location order by dea.Location,
dea.Date) as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100

from Project1..CovidDeaths dea
join Project1..Covidvaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * , (RollingPeopleVaccinated/Population)*100

from PopvsVac


-- TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)



insert into 

select dea.continent,dea.location,dea.date,dea.population, dea.new_vaccinations
, sum(convert(int,  dea.new_vaccinations)) OVER (partition by dea.Location order by dea.Location,
dea.Date) as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100

from Project1..CovidDeaths dea
join Project1..Covidvaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
select * , (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated



-- Creating View to store data for later visualizations
create view PercentPopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.population, dea.new_vaccinations
, sum(convert(int,  dea.new_vaccinations)) OVER (partition by dea.Location order by dea.Location,
dea.Date) as RollingPeopleVaccinated --, (RollingPeopleVaccinated/population)*100

from Project1..CovidDeaths dea
join Project1..Covidvaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select * 
from PercentPopulationVaccinated




