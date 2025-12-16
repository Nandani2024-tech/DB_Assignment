from etl.transform.transform_pipeline import run_students_transform
from etl.load.load_pipeline import run_load_pipeline
from etl.extract.csv_extractor import extract_from_csv


def run_pipeline_from_rows(raw_rows):
    """
    Used by FastAPI / Google App Script (Task 6)
    """
    transform_result = run_students_transform(raw_rows)

    transformed_data = transform_result["data"]
    transform_metrics = transform_result["metrics"]

    load_summary = run_load_pipeline(transformed_data)

    return {
        "transform_metrics": transform_metrics,
        "load_summary": load_summary
    }


def run_etl_pipeline():
    """
    Used for batch ETL runs (Task 4)
    """
    print("🚀 ETL Pipeline Started")

    #raw_rows = extract_from_csv("tools/students_synthetic_clean.csv")
    #raw_rows = extract_from_csv("tools/students_synthetic_messy.csv")
    raw_rows = extract_from_csv("tools/StudentsPerformance.csv")


    print(f"📤 Extracted {len(raw_rows)} raw rows")

    result = run_pipeline_from_rows(raw_rows)

    print("🧹 Transform Metrics:", result["transform_metrics"])
    print("📥 Load Summary:", result["load_summary"])
    print("✅ ETL Pipeline Completed Successfully")

    return result


if __name__ == "__main__":
    run_etl_pipeline()
