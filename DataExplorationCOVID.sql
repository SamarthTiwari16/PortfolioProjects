select * 
from ProjectPortfolio..CovidDeaths
where continent is not null
order by 3, 4

--select * 
--from ProjectPortfolio..CovidVaccinations
--order by 3, 4

select Location, date, total_cases, new_cases, total_deaths, population
from ProjectPortfolio..CovidDeaths
order by 1, 2

select Location, date, total_cases, total_deaths, (total_deaths/NULLIF(total_cases, 0))*100 as DeathPercentage
from ProjectPortfolio..CovidDeaths
where location like '%states%'
order by 1, 2

select location, date, population, total_cases, (total_cases/ NULLIF(population, 0))*100 as PercentpopulationInfected
from ProjectPortfolio..CovidDeaths
--where location like '%states%'
order by 1, 2

select location, population, max(total_cases) as HighInfectionCount, max((total_cases/ NULLIF(population, 0)))*100 as PercentPopulationInfected
from ProjectPortfolio..CovidDeaths
group by location, population
order by PercentPopulationInfected desc

select continent, max(total_deaths) as TotalDeathsCount
from ProjectPortfolio..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathsCount desc

select date, total_cases, total_deaths, (total_deaths/NULLIF(total_cases, 0))*100 as DeathPercentage
from ProjectPortfolio..CovidDeaths
where continent is not null
group by date
order by 1,2

select sum(new_cases) as total_cases , SUM(new_deaths) as total_deaths, 
case when sum(new_cases)=0 then null
    else sum(new_deaths)/ sum(new_cases)*100
end as DeathPercentage
from ProjectPortfolio..CovidDeaths
where continent is not null
--group by date
order by 1, 2



select * 
from ProjectPortfolio..CovidDeaths dea
join ProjectPortfolio..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from ProjectPortfolio..CovidDeaths dea
join ProjectPortfolio..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE

with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from ProjectPortfolio..CovidDeaths dea
join ProjectPortfolio..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rollingpeoplevaccinated/population)*100
from popvsvac

--TEMP TABLE
drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from ProjectPortfolio..CovidDeaths dea
join ProjectPortfolio..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (rollingpeoplevaccinated/population)*100
from #PercentPopulationVaccinated

--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from ProjectPortfolio..CovidDeaths dea
join ProjectPortfolio..CovidVaccinations vac
    on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from PercentPopulationVaccinated
