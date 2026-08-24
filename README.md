
## Architecture Overview
```TEXT
IMDb Bulk Data (TSV.GZ)
│ (HTTP Ingestion)
▼
Raw Parquet Files (raw/)
│ (DuckDB Load)
▼
DuckDB Raw Tables
│
▼
dbt Staging (stg_*) ──► SCD Type 2 Snapshots (snap_*)
│
▼
Intermediate & Bridges (int_*, bridge_*)
│
▼
Dimensional Star Schema (dim_*, fct_*)
│
▼
Analytics Marts (q1_*, q2_*, q3_*)

```
---

## Project Structure

```TEXT
imdbProject/
├── dags/
│   └── ingest_dag.py              # Airflow DAG (4 sequential tasks)
├── dbt_project/
│   ├── models/
│   │   ├── staging/              # 1:1 raw tables, type casting, scoping >= 2020
│   │   ├── intermediate/         # Reshaping, many-to-many bridges
│   │   └── marts/                # Star schema (dim_*, fct_*) & business marts
│   ├── snapshots/                # SCD Type 2 snapshots (snap_dim_title, snap_title_ratings)
│   ├── tests/                    # Custom domain tests
│   ├── dbt_project.yml           # dbt configuration & materializations
│   └── profiles.yml              # DuckDB connection profile
├── docs/
│   └── project_documentation.docx# Comprehensive written report
├── raw/                          # Downloaded Parquet files
├── convert_to_parquet.py         # TSV to Parquet conversion utility
├── docker-compose.yaml           # Container definition
├── Dockerfile                    # Airflow image with dbt-duckdb preinstalled
├── warehouse.duckdb              # Embedded OLAP database
└── README.md                     # Pipeline execution & setup instructions

```

---

## How to Run from Scratch
### 1. Clone the repository

```bash!
git clone https://github.com/nicola3180/IMDbProject.git
cd imdbProject
```
### 2. Initialize an empty DuckDB file

Initialize the database file on the host machine to avoid Docker directory-mount collisions:

```bash
python -c "import duckdb; con = duckdb.connect('warehouse.duckdb'); con.execute('CREATE TABLE _init (id INT); DROP TABLE _init;'); con.close()"

```
### 3. Start Docker services

```bash
docker compose up -d --build

```
### 4. Trigger the Airflow DAG

1. Navigate to the Airflow Web UI at http://localhost:8080 (Credentials: admin / admin).
2. Unpause and trigger the DAG: imdb_ingest_transformation_dag.
3. The DAG will run the following stages:
* extract_and_load_raw_data: Downloads TSV.GZ files, converts to Parquet, and loads into DuckDB.
* dbt_snapshot: Captures SCD Type 2 snapshots for metadata and rating changes.
* dbt_run: Builds all staging, bridge, dimensional, and mart models.
* dbt_test: Runs automated quality checks and validation rules.

---
## Analytical Deliverables

The final analytical models in dbt_project/models/marts/ address the primary business questions:

* Top Directors (q1_top_directors): Identifies top directors ranked by average rating with at least 5 titles and at least 1,000 votes.
* Runtime Trends (q2_runtime_by_decade): Tracks changes in average runtime across decades and runtime-rating correlation.
* Hidden Gems vs. Overrated (q3_hidden_gems_vs_overrated): Measures the ratio of high-rating/low-vote titles against low-rating/high-vote titles per genre.

```

```