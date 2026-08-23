FROM apache/airflow:2.9.3-python3.11

USER airflow

# Install dbt-duckdb and dependencies inside the Airflow image
RUN pip install --no-cache-dir \
    dbt-core==1.8.0 \
    dbt-duckdb==1.8.0 \
    duckdb==1.1.0