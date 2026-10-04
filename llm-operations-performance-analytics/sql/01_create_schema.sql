IF DB_ID('AIAnalytics') IS NULL
BEGIN
    CREATE DATABASE AIAnalytics;
END;
GO

USE AIAnalytics;
GO

IF OBJECT_ID('dbo.AIUsage', 'U') IS NOT NULL
    DROP TABLE dbo.AIUsage;
GO

CREATE TABLE dbo.AIUsage (
    timestamp       DATETIME2 NOT NULL,
    team            VARCHAR(50) NOT NULL,
    task            VARCHAR(50) NOT NULL,
    model           VARCHAR(30) NOT NULL,
    input_tokens    INT NOT NULL,
    output_tokens   INT NOT NULL,
    latency_ms      INT NOT NULL,
    success         BIT NOT NULL,
    quality_score   DECIMAL(4,2) NOT NULL,
    cost_usd        DECIMAL(12,6) NOT NULL
);
GO
