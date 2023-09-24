# COVID-19 Data Analysis Project

## Overview
This repository contains SQL queries for analyzing COVID-19 data, specifically focusing on the relationship between COVID-19 cases, deaths, vaccinations, and population statistics. The queries are designed to provide insights at both the global and country levels.

## SQL Queries

### Total Deaths vs. Population
- The first set of queries examines the relationship between total deaths and population for various locations, calculating the percentage of the population infected by COVID-19.

### Countries with the Lowest Infected Population Percentage
- This query identifies countries with the lowest percentage of their population infected by COVID-19 and provides the exact numbers.

### Countries with the Highest Infected Population Percentage
- Conversely, this query identifies countries with the highest percentage of their population infected by COVID-19 and provides the corresponding numbers.

### Countries with the Highest Death Count per Population
- This query focuses on countries with the highest number of deaths per population.

### Breakdown by Continent
- This section delves into continent-level data to identify which continent has the highest number of deaths per population.

### Global Numbers
- These queries provide global statistics, including the total number of new cases, new deaths, and the death percentage worldwide.

### Joining Data
- This query combines data from two tables, `CovidDeaths` and `CovidVaccinations`, to facilitate further analysis.

### Total Population vs. Vaccinations
- Here, we analyze the total population and vaccinations, including a rolling count of vaccinated individuals for each location.

## Creating a View
- We create a view named `PopvsVac` to store the combined data from the previous query for future visualizations or analysis.

## Usage
You can execute these SQL queries on your database containing COVID-19 data to gain valuable insights into the pandemic's impact on different regions. Adjust the queries as needed to suit your specific dataset and requirements.

## Contributors
- [Chibuike Victor Akujuobi]
