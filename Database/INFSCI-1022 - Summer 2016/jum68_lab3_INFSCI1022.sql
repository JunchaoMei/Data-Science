USE world;
SELECT * FROM Country;
SELECT * FROM CountryLanguage;
SELECt * FROM City;

# Task 2
SELECT City.cityName AS `City Name`, Country.countryName AS `Country Name`, City.District, City.Population
FROM City LEFT JOIN Country ON City.CountryCode = Country.Code
Where Country.countryName = 'Afghanistan'
ORDER BY Population DESC
LImit 5;

# Task 3
SELECT Country.countryName AS `Country Name`, Country.Region, MIN(Country.LifeExpectancy) as `Life Expectancy (Minimum)`
FROM Country
WHERE Region = 'Middle East';

# Task 4
SELECT Country.Region, SUM(GNP) AS `Combined GNP`
FROM Country
WHERE Country.Region = 'Caribbean'
GROUP BY Country.Region;

# Task 5
SELECT Country.Region, Country.countryName AS `Country Name`, CountryLanguage.Language, CountryLanguage.Percentage
FROM Country LEFT JOIN CountryLanguage ON Country.code = CountryLanguage.CountryCode
WHERE Country.Region = 'Western Europe' AND Language = 'French' AND IsOfficial = 'T'
ORDER BY CountryLanguage.Percentage DESC;

# Task 6
SELECT City.cityName AS `City Name`, Country.countryName AS `Country Name`
FROM City LEFT JOIN Country ON Country.code = City.CountryCode
WHERE Country.countryName = 'Madagascar' AND City.cityName LIKE 'A%'
ORDER BY City.cityName ASC;