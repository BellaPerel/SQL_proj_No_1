SELECT symbolVSyield.Symbol as Symbol, company.companySector as Sectot, symbolVSyield.Yield
FROM symbolVSyield INNER JOIN company ON symbolVSyield.Symbol = company.symbol
ORDER BY Yield DESC;
