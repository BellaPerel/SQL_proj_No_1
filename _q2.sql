CREATE TABLE investor(
    investorId int primary key,
        CHECK (investorId >= 100000000 AND investorId <= 999999999),
    investorName VARCHAR(100),
    investorBirthday DATE,
        CHECK (YEAR(investorBirthday)<2004),
    investorMail VARCHAR(100) UNIQUE,
    investorRegistration DATE
);

CREATE TABLE premium(
    premiumId int primary key,
        check (premiumId >= 100000000 AND premiumId <= 999999999),
    financialGoals VARCHAR(100),
        FOREIGN KEY(premiumId) REFERENCES investor(investorId)
);

CREATE TABLE economist(
    economistId int primary key,
        CHECK (economistId >= 100000000 AND economistId <= 999999999),
    economistSector varchar(100),
        FOREIGN KEY(economistId) REFERENCES investor(investorId)
);

CREATE TABLE beginner(
    beginnerId int primary key,
        CHECK (beginnerId >= 100000000 AND beginnerId <= 999999999),
    guideId int not null,
        CHECK (guideId >= 100000000 AND guideId <= 999999999),
    FOREIGN KEY(beginnerId) REFERENCES investor(investorId),
    FOREIGN KEY(guideId) REFERENCES economist(economistId)
);

CREATE TABLE lawyer(
    lawyerId int primary key,
        CHECK (lawyerId >= 100000000 AND lawyerId <= 999999999),
    lawyerSector VARCHAR(100),
    FOREIGN KEY(lawyerId) REFERENCES premium(premiumId)
);

CREATE TABLE [transaction](
    transactionDate DATE,
    transactionInvestorId int,
        CHECK (transactionInvestorId >= 100000000 AND transactionInvestorId <= 999999999),
    transactionAmount int,
        CHECK (transactionAmount>=1000),
    FOREIGN KEY(transactionInvestorId) REFERENCES investor(investorId),
    PRIMARY KEY (transactionDate,transactionInvestorId)
);

CREATE TABLE verifiedBy(
    verifiedTransactionDate DATE,
    verifiedInvestorId int,
        CHECK (verifiedInvestorId >= 100000000 AND verifiedInvestorId <= 999999999),
    verifiedLawyerId int,
        CHECK (verifiedLawyerId >= 100000000 AND verifiedLawyerId <= 999999999),
    decision VARCHAR(100),
    FOREIGN KEY (verifiedTransactionDate, verifiedInvestorId) REFERENCES [transaction](transactionDate, transactionInvestorId),
    FOREIGN KEY (verifiedLawyerId) REFERENCES lawyer(lawyerId),
    PRIMARY KEY (verifiedTransactionDate, verifiedInvestorId)
);

CREATE TABLE company(
    symbol VARCHAR(100) primary key,
    companySector VARCHAR(100),
    founded int,
        CHECK ((founded<=YEAR(GETDATE())) AND (founded>=0)),
    location VARCHAR(100)
);

CREATE TABLE rivalTo(
    rivalCause VARCHAR(100),
    firstCompanySymbol VARCHAR(100),
    secondCompanySymbol VARCHAR(100),
        CHECK (firstCompanySymbol!=secondCompanySymbol),
    FOREIGN KEY (firstCompanySymbol) REFERENCES company(symbol),
    FOREIGN KEY (secondCompanySymbol) REFERENCES company(symbol),
    PRIMARY KEY (firstCompanySymbol,secondCompanySymbol)
);

CREATE TABLE covers(
    coveredFirstCompanySymbol VARCHAR(100),
    coveredSecondCompanySymbol VARCHAR(100),
        CHECK (coveredFirstCompanySymbol!=coveredSecondCompanySymbol),
    coveringEconomistId int,
        CHECK (coveringEconomistId >= 100000000 AND coveringEconomistId <= 999999999),
    shortSummary VARCHAR(100),
    FOREIGN KEY(coveredFirstCompanySymbol,coveredSecondCompanySymbol) REFERENCES rivalTo(firstCompanySymbol,secondCompanySymbol),
    FOREIGN KEY(coveringEconomistId) REFERENCES economist(economistId),
    PRIMARY KEY (coveredFirstCompanySymbol, coveredSecondCompanySymbol)
);

CREATE TABLE stock(
    belongsTo VARCHAR(100),
    stockDate DATE,
    stockValue float,
    FOREIGN KEY(belongsTo) REFERENCES company(symbol),
    PRIMARY KEY(stockDate, belongsTo)
);

CREATE TABLE buying(
    buyerId int,
        CHECK (buyerId >= 100000000 AND buyerId <= 999999999),
    stockDateBuying DATE,
    belongsToBuying VARCHAR(100),
    stockAmount int,
    FOREIGN KEY(stockDateBuying, belongsToBuying) REFERENCES stock(stockDate, belongsTo),
    FOREIGN KEY(buyerId) REFERENCES investor(investorId),
    PRIMARY KEY(buyerId, stockDateBuying, belongsToBuying)
);