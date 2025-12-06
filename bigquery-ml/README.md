# BigQuery ML

[![BigQuery ML](https://img.shields.io/badge/BigQuery%20ML-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/bigquery-ml)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master BigQuery ML - Machine Learning with SQL**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is BigQuery ML?

BigQuery ML enables data analysts to create and execute machine learning models using standard SQL queries. You can train models on data already in BigQuery without moving it or learning Python/R. Models are trained using SQL and can be deployed for predictions directly in BigQuery.

---

## Supported Model Types

- **Linear Regression**: Predict numeric values
- **Logistic Regression**: Binary/multiclass classification
- **K-Means Clustering**: Unsupervised clustering
- **Matrix Factorization**: Recommendations
- **Time Series (ARIMA_PLUS)**: Forecasting
- **Deep Neural Networks**: Complex patterns
- **XGBoost**: Gradient boosted trees
- **AutoML Tables**: Automated model selection

---

## Quick Start

```sql
-- Create a classification model
CREATE OR REPLACE MODEL `project.dataset.my_model`
OPTIONS(
    model_type='LOGISTIC_REG',
    input_label_cols=['label']
) AS
SELECT
    feature1,
    feature2,
    feature3,
    label
FROM `project.dataset.training_data`;

-- Evaluate the model
SELECT *
FROM ML.EVALUATE(MODEL `project.dataset.my_model`);

-- Make predictions
SELECT *
FROM ML.PREDICT(MODEL `project.dataset.my_model`,
    (SELECT feature1, feature2, feature3 FROM `project.dataset.new_data`)
);

-- Feature importance
SELECT *
FROM ML.FEATURE_IMPORTANCE(MODEL `project.dataset.my_model`);
```

---

## Time Series Forecasting

```sql
-- Create ARIMA model for forecasting
CREATE OR REPLACE MODEL `project.dataset.sales_forecast`
OPTIONS(
    model_type='ARIMA_PLUS',
    time_series_timestamp_col='date',
    time_series_data_col='sales',
    auto_arima=TRUE,
    data_frequency='DAILY'
) AS
SELECT date, sales
FROM `project.dataset.historical_sales`;

-- Forecast next 30 days
SELECT *
FROM ML.FORECAST(MODEL `project.dataset.sales_forecast`,
    STRUCT(30 AS horizon, 0.95 AS confidence_level)
);
```

---

## Interview Tips

**Q: When would you use BigQuery ML vs Vertex AI?**
> BigQuery ML for quick prototyping, SQL-based workflows, and when data is already in BigQuery. Vertex AI for complex custom models, deep learning, and production ML pipelines.

**Q: How do you handle feature engineering in BigQuery ML?**
> Use TRANSFORM clause to define preprocessing, or create views with engineered features. BigQuery ML supports automatic one-hot encoding for categorical variables.

---

## Next Steps

- [Vertex AI](../vertex-ai/) - Advanced ML platform
- [BigQuery Advanced](../bigquery-advanced/) - Complex queries for feature engineering
