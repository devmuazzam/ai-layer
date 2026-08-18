CREATE TABLE [dim].[Date] (
    [DateKey] int NOT NULL,
    [Date] date NOT NULL,
    [CalendarYear] int NOT NULL,
    [CalendarQuarter] int NOT NULL,
    [MonthOfYear] int NOT NULL,
    [MonthName] nvarchar(20) NOT NULL,
    [DayOfMonth] int NOT NULL,
    [DayOfWeekName] nvarchar(20) NOT NULL,
    [FiscalYear] int NOT NULL,
    [FiscalQuarter] int NOT NULL,
    [FiscalPeriod] int NOT NULL,
    [PayrollWeekNumber] int NOT NULL,
    [PayrollYear] int NOT NULL,
    [PayrollWeekLabel] nvarchar(20) NOT NULL,
    [MonthIndex] int NOT NULL,
    [YearIndex] int NOT NULL
);

ALTER TABLE [dim].[Date] ADD CONSTRAINT [PK_dim_Date] PRIMARY KEY CLUSTERED ([DateKey]);
