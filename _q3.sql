SELECT max_stocks_company_by_country.location as Location, max_stocks_company_by_country.belongsTo as Symbol,
       max_stocks_company_by_country.max_stock as Price
FROM max_stocks_company_by_country, industrial_countries
WHERE max_stocks_company_by_country.location = industrial_countries.location
ORDER BY max_stocks_company_by_country.location ASC;
