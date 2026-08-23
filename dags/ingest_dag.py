import os
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

PROJECT_ROOT = "/opt/airflow"
DBT_PROJECT_DIR = os.path.join(PROJECT_ROOT, "dbt_project")


def validate_raw_datasets():
    raw_dir = os.path.join(PROJECT_ROOT, "raw")
    required_files = [
        "name.basics.parquet",
        "title.akas.parquet",
        "title.basics.parquet",
        "title.crew.parquet",
        "title.principals.parquet",
        "title.ratings.parquet",
    ]
    for file_name in required_files:
        file_path = os.path.join(raw_dir, file_name)
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"Required raw file missing: {file_path}")


with DAG(
    dag_id="imdb_ingest_transformation_dag",
    default_args=default_args,
    description="Orchestrates ingestion, SCD2 snapshots, transformations, and tests for IMDb",
    schedule_interval=None,
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=["imdb", "duckdb", "dbt"],
) as dag:

    stage_extract_load = PythonOperator(
        task_id="extract_and_load_raw_data",
        python_callable=validate_raw_datasets,
    )

    stage_dbt_snapshot = BashOperator(
        task_id="dbt_snapshot",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt snapshot --profiles-dir .",
    )

    stage_dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --profiles-dir .",
    )

    stage_dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt test --profiles-dir .",
    )

    stage_extract_load >> stage_dbt_snapshot >> stage_dbt_run >> stage_dbt_test