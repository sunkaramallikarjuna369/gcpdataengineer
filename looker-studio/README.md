# Looker Studio

[![Looker Studio](https://img.shields.io/badge/Looker%20Studio-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://lookerstudio.google.com/)
[![Difficulty: Beginner](https://img.shields.io/badge/Difficulty-Beginner-green?style=for-the-badge)](.)

> **Master Looker Studio - Self-Service Business Intelligence**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Looker Studio?

Looker Studio (formerly Google Data Studio) is a free, self-service business intelligence tool that lets you create interactive dashboards and reports. It connects directly to BigQuery and other data sources, enabling data visualization without coding.

---

## Key Features

- **Free**: No cost for basic usage
- **BigQuery Native**: Direct connector with BI Engine
- **Interactive**: Filters, drill-downs, date ranges
- **Shareable**: Easy collaboration and embedding
- **Custom Visualizations**: Community visualizations

---

## BigQuery Connection

### Direct Query Mode
```
1. Add Data → BigQuery
2. Select Project → Dataset → Table
3. Choose "Direct Query" for real-time data
```

### Custom Query Mode
```sql
SELECT
    DATE(timestamp) as date,
    region,
    COUNT(*) as events,
    SUM(revenue) as total_revenue
FROM `project.dataset.events`
WHERE timestamp >= @DS_START_DATE
  AND timestamp <= @DS_END_DATE
GROUP BY 1, 2
```

---

## BI Engine Optimization

Enable BI Engine for sub-second dashboard performance:

```bash
# Create BI Engine reservation
bq mk --bi_reservation \
    --project_id=PROJECT_ID \
    --location=US \
    --size=1GB

# Check reservation status
bq show --bi_reservation --project_id=PROJECT_ID --location=US
```

---

## Best Practices

### Data Modeling
- Pre-aggregate data for large datasets
- Use materialized views for complex calculations
- Create date dimension tables for time intelligence

### Dashboard Design
- Limit charts per page (5-7 max)
- Use consistent color schemes
- Add context with text and annotations
- Enable caching for better performance

### Performance
- Use BI Engine for frequently accessed data
- Avoid complex calculated fields
- Filter data at the source level
- Use extract mode for stable data

---

## Interview Tips

**Q: How do you optimize Looker Studio dashboard performance?**
> Enable BI Engine, pre-aggregate data in BigQuery, use extract mode for stable data, limit visualizations per page, and avoid complex calculated fields.

**Q: When would you use Looker Studio vs Looker?**
> Looker Studio for self-service dashboards, quick visualizations, and when cost is a concern. Looker for enterprise BI, governed metrics, embedded analytics, and complex data modeling.

---

## Next Steps

- [BigQuery](../bigquery-basics/) - Data source
- [BigQuery ML](../bigquery-ml/) - ML in dashboards
