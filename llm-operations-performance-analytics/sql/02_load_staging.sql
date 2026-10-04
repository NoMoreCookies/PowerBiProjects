USE AIAnalytics;
GO

IF OBJECT_ID('dbo.AIUsage_Staging', 'U') IS NOT NULL
    DROP TABLE dbo.AIUsage_Staging;
GO

CREATE TABLE dbo.AIUsage_Staging (
    timestamp       VARCHAR(50),
    team            VARCHAR(50),
    task            VARCHAR(50),
    model           VARCHAR(30),
    input_tokens    VARCHAR(30),
    output_tokens   VARCHAR(30),
    latency_ms      VARCHAR(30),
    success         VARCHAR(10),
    quality_score   VARCHAR(30),
    cost_usd        VARCHAR(30)
);
GO

BULK INSERT dbo.AIUsage_Staging
FROM '/data/ai_usage_logs.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    TABLOCK
);
GO

SELECT COUNT(*) AS staging_rows
FROM dbo.AIUsage_Staging;
GO
