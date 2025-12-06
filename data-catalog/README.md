# Data Catalog

[![Data Catalog](https://img.shields.io/badge/Data%20Catalog-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/data-catalog)
[![Difficulty: Intermediate](https://img.shields.io/badge/Difficulty-Intermediate-yellow?style=for-the-badge)](.)

> **Master Data Catalog - Metadata Management and Data Discovery**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is Data Catalog?

Data Catalog is a fully managed, scalable metadata management service that helps organizations discover, understand, and manage their data. It automatically catalogs metadata from BigQuery, Pub/Sub, and Cloud Storage, and allows you to add custom metadata, tags, and business context.

---

## Key Features

- **Auto-Discovery**: Automatically catalogs GCP data assets
- **Search**: Find data across your organization
- **Tagging**: Add business context with tag templates
- **Lineage**: Track data flow and dependencies
- **Policy Tags**: Column-level security for BigQuery

---

## Quick Start

```python
from google.cloud import datacatalog_v1

client = datacatalog_v1.DataCatalogClient()

# Search for data assets
scope = datacatalog_v1.SearchCatalogRequest.Scope()
scope.include_project_ids.append('your-project')

results = client.search_catalog(
    scope=scope,
    query='type=TABLE tag:pii'
)

for result in results:
    print(f"Found: {result.relative_resource_name}")

# Create tag template
template = datacatalog_v1.TagTemplate()
template.display_name = "Data Quality"
template.fields["quality_score"] = datacatalog_v1.TagTemplateField(
    display_name="Quality Score",
    type_=datacatalog_v1.FieldType(primitive_type="DOUBLE")
)

client.create_tag_template(
    parent=f"projects/your-project/locations/us",
    tag_template_id="data_quality",
    tag_template=template
)
```

---

## Data Lineage

Track how data flows through your systems:

```python
from google.cloud import datacatalog_lineage_v1

client = datacatalog_lineage_v1.LineageClient()

# Search lineage
request = datacatalog_lineage_v1.SearchLinksRequest(
    parent="projects/your-project/locations/us",
    source=datacatalog_lineage_v1.EntityReference(
        fully_qualified_name="bigquery:project.dataset.source_table"
    )
)

for link in client.search_links(request):
    print(f"Target: {link.target.fully_qualified_name}")
```

---

## Interview Tips

**Q: How does Data Catalog help with data governance?**
> It provides a central inventory of data assets, enables tagging for classification (PII, sensitive), supports policy tags for access control, and tracks lineage for compliance and impact analysis.

**Q: What's the difference between Data Catalog and a data dictionary?**
> Data Catalog is an active, searchable metadata repository that auto-discovers assets and integrates with access controls. A data dictionary is typically a static document describing data definitions.

---

## Next Steps

- [Data Governance](../data-governance/) - Governance policies
- [BigQuery](../bigquery-basics/) - Catalog BigQuery assets
