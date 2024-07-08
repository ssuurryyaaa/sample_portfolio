Select * 
from PortfolioProject.coviddeaths
order by 3,4;

-- Select * 
-- from PortfolioProject.covidvaccinations
-- order by 3,4;

-- Data Selection 
Select location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject.coviddeaths
order by 1,2;


-- Looking at Total cases vs Total deaths
-- Shows the likelihood of dying if you contract covid in country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as death_percentage
from PortfolioProject.coviddeaths
where location like '%ndia%'
order by 1,2;


-- Looking at Total cases vs Population
-- Shows the percentage of population got covid

Select location, date, population, total_cases, (total_cases/population) * 100 as infected_percentage
from PortfolioProject.coviddeaths
 -- where location like '%ndia%'
order by 1,2;

-- Looking at countries with highest infection rate compared to Population
Select location, population, max(total_cases) as highest_infection_count,  max(total_cases/population) * 100 as most_infected_population
from PortfolioProject.coviddeaths
 -- where location like '%ndia%'
 group by location, population
order by most_infected_population desc;

-- Showing the countries with the most deaths 
Select location, max(total_deaths) as highest_death_count 
from PortfolioProject.coviddeaths
 -- where location like '%ndia%'
 group by location
order by highest_death_count desc;

-- Showing the countries with the most deaths per population
Select location, max(total_deaths) as highest_death_count,  max(total_deaths/population) * 100 as most_deaths_per_population
from PortfolioProject.coviddeaths
 -- where location like '%ndia%'
 group by location
order by most_deaths_per_population desc;

-- Lets break things down by continent
Select location, max(total_deaths) as highest_death_count
from PortfolioProject.coviddeaths
where continent is not null 
group by location
order by highest_death_count desc;


-- continent with most deaths
Select continent, max(total_deaths) as continent_with_highest_death_count
from PortfolioProject.coviddeaths
where continent is not null 
group by continent
order by continent_with_highest_death_count desc;


-- Global numbers

Select sum(new_cases) as tot_cases, sum(new_deaths) as tot_deaths, sum(new_deaths)/sum(new_cases) * 100 as new_death_perc
from PortfolioProject.coviddeaths
where continent is not null
-- group by date
order by 1,2;







Select * 
from PortfolioProject.coviddeaths dea
join PortfolioProject.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date;

-- looking at total population vs vaccination
select dea.continent, dea.location, dea.date, dea.population, dea.new_deaths, 
sum(dea.new_deaths) over (partition by dea.location order by dea.location, dea.date) as rolling_people_death
from PortfolioProject.coviddeaths dea
join PortfolioProject.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
order by 2,3;


-- USE CTE
With PopVsVac (continent, location, date, population, new_deaths, rolling_people_death)
as 
(
select dea.continent, dea.location, dea.date, dea.population, dea.new_deaths, 
sum(dea.new_deaths) over (partition by dea.location order by dea.location, dea.date) as rolling_people_death
from PortfolioProject.coviddeaths dea
join PortfolioProject.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
order by 2,3
)
Select *, (rolling_people_death/ population) * 100 
from PopVsVac;



-- TEMP TABLE

Drop table if exists PortfolioProject.PercentPopulationDeath;

Create table PortfolioProject.PercentPopulationDeath
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_deaths numeric,
rolling_people_death numeric
);



Insert into PortfolioProject.PercentPopulationDeath
select dea.continent, dea.location, dea.date, dea.population, dea.new_deaths, 
sum(dea.new_deaths) over (partition by dea.location order by dea.location, dea.date) as rolling_people_death
from PortfolioProject.coviddeaths dea
join PortfolioProject.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date;
-- order by 2,3

Select *, (rolling_people_death/ population) * 100 
from PortfolioProject.PercentPopulationDeath;



-- Creating view to store data for later visalisations
Create View PortfolioProject.PercentPopulationDeath as 
select dea.continent, dea.location, dea.date, dea.population, dea.new_deaths, 
sum(dea.new_deaths) over (partition by dea.location order by dea.location, dea.date) as rolling_people_death
from PortfolioProject.coviddeaths dea
join PortfolioProject.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date;
percentpopulationdeathpercentpopulationdeath