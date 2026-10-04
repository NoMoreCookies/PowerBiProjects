USE AIAnalytics;
GO

IF OBJECT_ID('dbo.TeamBudgets', 'U') IS NOT NULL
    DROP TABLE dbo.TeamBudgets;
GO

CREATE TABLE dbo.TeamBudgets (
    team VARCHAR(50) PRIMARY KEY,
    monthly_budget_usd DECIMAL(12,2) NOT NULL,
    target_quality DECIMAL(4,2) NOT NULL,
    max_avg_latency_ms INT NOT NULL
);
GO

INSERT INTO dbo.TeamBudgets (
    team,
    monthly_budget_usd,
    target_quality,
    max_avg_latency_ms
)
VALUES
    ('Engineering', 2500.00, 4.50, 2500),
    ('Customer Support', 525.00, 4.20, 1500),
    ('Sales', 800.00, 4.20, 1800),
    ('HR', 1050.00, 4.00, 1800),
    ('Analytics', 775.00, 4.40, 2200);
GO

SELECT *
FROM dbo.TeamBudgets;
GO
