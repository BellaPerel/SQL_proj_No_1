CREATE VIEW industrial_countries
AS
SELECT location, COUNT(symbol) as num_of_countries
FROM company
WHERE founded<1990
group by location
HAVING count(symbol) >5;

CREATE VIEW high_stocks
AS
SELECT company.location, stock.belongsTo, stock.stockValue
FROM company, stock
WHERE company.symbol=stock.belongsTo;

CREATE VIEW max_stocks_by_country
AS
SELECT high_stocks.location, max(high_stocks.stockValue) as max_stock
FROM high_stocks
GROUP BY high_stocks.location;

CREATE VIEW max_stocks_company_by_country
AS
SELECT DISTINCT high_stocks.belongsTo, max_stocks_by_country.max_stock, high_stocks.location
FROM max_stocks_by_country, high_stocks
WHERE max_stocks_by_country.max_stock = high_stocks.stockValue and high_stocks.location = max_stocks_by_country.location;


CREATE VIEW not_improve_companies
AS
SELECT distinct stock1.belongsTo
FROM stock as stock1 inner join stock as stock2
ON stock1.belongsTo = stock2.belongsTo and stock1.stockDate < stock2.stockDate and stock1.stockValue>=stock2.stockValue;

CREATE VIEW improve_companies
AS
SELECT distinct symbol
FROM company
WHERE company.symbol NOT IN (SELECT not_improve_companies.belongsTo FROM not_improve_companies);

CREATE VIEW sector_with_glow
AS
SELECT company.companySector, count(company.symbol) as counter
FROM company INNER JOIN improve_companies
ON company.symbol = improve_companies.symbol
WHERE company.symbol = improve_companies.symbol
GROUP BY companySector
HAVING count(improve_companies.symbol) = 1;

CREATE VIEW companies_that_glow
AS
SELECT company.symbol, company.companySector
FROM company, sector_with_glow
WHERE company.companySector = sector_with_glow.companySector and company.symbol IN (
    SELECT improve_companies.symbol
    FROM improve_companies);

CREATE VIEW lastValue
AS
SELECT stock.belongsTo,MAX(stockDate) AS maxDate
FROM stock, companies_that_glow
WHERE stock.belongsTo = companies_that_glow.symbol
GROUP BY stock.belongsTo;

CREATE VIEW firstValue
AS
SELECT stock.belongsTo,MIN(stockDate) AS minDate
FROM stock, companies_that_glow
WHERE stock.belongsTo = companies_that_glow.symbol
GROUP BY stock.belongsTo;

CREATE VIEW firstPrice
AS
SELECT firstValue.belongsTo, stock.stockValue
FROM firstValue INNER JOIN stock on firstValue.belongsTo = stock.belongsTo and firstValue.minDate = stock.stockDate;

CREATE VIEW lastPrice
AS
SELECT lastValue.belongsTo, stock.stockValue
FROM lastValue INNER JOIN stock on lastValue.belongsTo = stock.belongsTo and lastValue.maxDate = stock.stockDate;

CREATE VIEW symbolVSyield
AS
SELECT firstPrice.belongsTo as Symbol, round(100*(lastPrice.stockValue - firstprice.stockValue)/firstprice.stockValue, 3) as Yield
FROM lastPrice, firstPrice
WHERE firstPrice.belongsTo=lastPrice.belongsTo;



