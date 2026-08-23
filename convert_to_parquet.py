import os
import time
import duckdb

# List of the 6 required IMDb dataset files
IMDB_FILES = [
    "name.basics",
    "title.akas",
    "title.basics",
    "title.crew",
    "title.principals",
    "title.ratings",
]

RAW_DIR = "raw"


def convert_tsv_gz_to_parquet():
    con = duckdb.connect()

    print("--- Starting TSV.GZ to PARQUET conversion ---")

    for file_name in IMDB_FILES:
        input_path = os.path.join(RAW_DIR, f"{file_name}.tsv.gz")
        output_path = os.path.join(RAW_DIR, f"{file_name}.parquet")

        if not os.path.exists(input_path):
            print(f"Warning: {input_path} not found. Skipping.")
            continue

        print(f"\nProcessing: {file_name}.tsv.gz ...")
        start_time = time.time()

        # DuckDB directly reads compressed TSV and writes optimized Parquet
        # nullstr='\\N' maps IMDb's default null indicator to actual SQL NULLs
        query = f"""
            COPY (
                SELECT * 
                FROM read_csv(
                    '{input_path}', 
                    delim='\\t', 
                    header=True, 
                    quote='', 
                    nullstr='\\N',
                    all_varchar=True
                )
            ) TO '{output_path}' (FORMAT PARQUET, COMPRESSION ZSTD);
        """

        con.execute(query)
        elapsed = round(time.time() - start_time, 2)
        print(f"Done! Saved to: {output_path} ({elapsed} seconds)")

    print("\n--- All files successfully converted to Parquet! ---")


if __name__ == "__main__":
    convert_tsv_gz_to_parquet()