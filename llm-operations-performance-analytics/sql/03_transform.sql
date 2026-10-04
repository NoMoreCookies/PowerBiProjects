USE AIAnalytics;
GO

TRUNCATE TABLE dbo.AIUsage;
GO

INSERT INTO dbo.AIUsage (
    timestamp,
    team,
    task,
    model,
    input_tokens,
    output_tokens,
    latency_ms,
    success,
    quality_score,
    cost_usd
)
SELECT
    TRY_CONVERT(DATETIME2, timestamp),
    team,
    task,
    model,
    TRY_CONVERT(INT, input_tokens),
    TRY_CONVERT(INT, output_tokens),
    TRY_CONVERT(INT, latency_ms),
    CASE
        WHEN LOWER(success) = 'true' THEN 1
        WHEN LOWER(success) = 'false' THEN 0
        ELSE NULL
    END,
    TRY_CONVERT(DECIMAL(4,2), quality_score),
    TRY_CONVERT(
        DECIMAL(12,6),
        TRY_CONVERT(FLOAT, cost_usd)
    )
FROM dbo.AIUsage_Staging
WHERE
    TRY_CONVERT(DATETIME2, timestamp) IS NOT NULL
    AND TRY_CONVERT(INT, input_tokens) IS NOT NULL
    AND TRY_CONVERT(INT, output_tokens) IS NOT NULL
    AND TRY_CONVERT(INT, latency_ms) IS NOT NULL
    AND LOWER(success) IN ('true', 'false')
    AND TRY_CONVERT(DECIMAL(4,2), quality_score) IS NOT NULL
    AND TRY_CONVERT(FLOAT, cost_usd) IS NOT NULL;
GO

SELECT
    COUNT(*) AS final_rows,
    SUM(CASE WHEN cost_usd IS NULL THEN 1 ELSE 0 END) AS null_costs
FROM dbo.AIUsage;
GO
