CREATE TABLE [test].[Case_CrossMidnight_DayType] (
    [CaseID] int IDENTITY(1,1) NOT NULL,
    [CaseName] varchar(100) NOT NULL,
    [AnchorDayType] varchar(30) NOT NULL,
    [PostMidnightDayType] varchar(30) NOT NULL,
    [Minutes_PreMidnight] int NOT NULL,
    [Minutes_PostMidnight] int NOT NULL,
    [ExpectedHighMinutes_CalendarDay] int NOT NULL,
    [ExpectedHighMinutes_AnchorFloor] int NOT NULL,
    [Notes] varchar(300) NULL
);

ALTER TABLE [test].[Case_CrossMidnight_DayType] ADD CONSTRAINT [PK_Case_CrossMidnight_DayType] PRIMARY KEY CLUSTERED ([CaseID]);
