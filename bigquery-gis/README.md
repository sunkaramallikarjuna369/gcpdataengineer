# BigQuery GIS

[![BigQuery GIS](https://img.shields.io/badge/BigQuery%20GIS-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/bigquery/docs/gis)
[![Difficulty: Advanced](https://img.shields.io/badge/Difficulty-Advanced-red?style=for-the-badge)](.)

> **Master BigQuery GIS - Geospatial Analytics at Scale**

[**Launch 3D Interactive Visualization**](./3d-interactive/index.html)

---

## What is BigQuery GIS?

BigQuery GIS (Geographic Information System) enables geospatial analysis directly in BigQuery using standard SQL with geography functions. It supports points, lines, polygons, and complex geometries using the GEOGRAPHY data type.

---

## Geography Data Types

```sql
-- Create geography from coordinates
SELECT ST_GEOGPOINT(-122.4194, 37.7749) as san_francisco;

-- Create geography from WKT
SELECT ST_GEOGFROMTEXT('POLYGON((-122.5 37.7, -122.5 37.8, -122.4 37.8, -122.4 37.7, -122.5 37.7))');

-- Create geography from GeoJSON
SELECT ST_GEOGFROMGEOJSON('{"type": "Point", "coordinates": [-122.4194, 37.7749]}');
```

---

## Common GIS Functions

### Distance and Area

```sql
-- Calculate distance between two points
SELECT ST_DISTANCE(
    ST_GEOGPOINT(-122.4194, 37.7749),  -- San Francisco
    ST_GEOGPOINT(-118.2437, 34.0522)   -- Los Angeles
) / 1000 as distance_km;

-- Calculate area of a polygon
SELECT ST_AREA(
    ST_GEOGFROMTEXT('POLYGON((-122.5 37.7, -122.5 37.8, -122.4 37.8, -122.4 37.7, -122.5 37.7))')
) / 1000000 as area_sq_km;
```

### Spatial Relationships

```sql
-- Find points within a polygon
SELECT *
FROM `project.dataset.locations`
WHERE ST_WITHIN(
    location,
    ST_GEOGFROMTEXT('POLYGON((-122.5 37.7, -122.5 37.8, -122.4 37.8, -122.4 37.7, -122.5 37.7))')
);

-- Find nearby points (within 10km)
SELECT *
FROM `project.dataset.stores`
WHERE ST_DWITHIN(
    location,
    ST_GEOGPOINT(-122.4194, 37.7749),
    10000  -- 10km in meters
);
```

### Clustering and Aggregation

```sql
-- Cluster nearby points
SELECT 
    ST_CLUSTERDBSCAN(location, 1000, 5) OVER() as cluster_id,
    *
FROM `project.dataset.events`;

-- Create convex hull of points
SELECT ST_CONVEXHULL(ST_UNION_AGG(location)) as boundary
FROM `project.dataset.locations`
WHERE region = 'west';
```

---

## Real-World Examples

### Delivery Zone Analysis

```sql
SELECT 
    zone_name,
    COUNT(*) as deliveries,
    AVG(ST_DISTANCE(store_location, delivery_location)) as avg_distance_m
FROM `project.dataset.deliveries`
GROUP BY zone_name
ORDER BY avg_distance_m;
```

### Geofencing

```sql
SELECT 
    user_id,
    event_time,
    CASE 
        WHEN ST_WITHIN(location, office_boundary) THEN 'office'
        WHEN ST_WITHIN(location, home_boundary) THEN 'home'
        ELSE 'other'
    END as location_type
FROM `project.dataset.user_locations`;
```

---

## Interview Tips

**Q: How do you optimize geospatial queries in BigQuery?**
> Use clustering on geography columns, filter by bounding box before expensive operations, use ST_SIMPLIFY for complex geometries, and consider pre-computing common spatial joins.

**Q: What's the difference between ST_WITHIN and ST_INTERSECTS?**
> ST_WITHIN returns true if geometry A is completely inside B. ST_INTERSECTS returns true if geometries share any point (including boundaries).

---

## Next Steps

- [BigQuery Advanced](../bigquery-advanced/) - Complex queries
- [Looker Studio](../looker-studio/) - Visualize GIS data
