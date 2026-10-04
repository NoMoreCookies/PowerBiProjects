# Power BI report

Place the final Power BI report in this directory, for example:

```text
LLM_Operations_Performance.pbix
```

Before committing:

1. Clear accidental slicer selections on the main screenshots.
2. Keep the two report pages:
   - `Executive Overview`
   - `Optimization Opportunities`
3. Verify the report uses:
   - `FactAIUsage`
   - `DimTeamBudget`
   - `DimDate`
4. Do not store SQL credentials inside documentation or source-controlled configuration.
5. Check the PBIX file size before pushing to GitHub.

If the PBIX file is too large for normal GitHub storage, use Git LFS or omit the binary and publish screenshots plus the reproducible pipeline.
