from fastapi import FastAPI
from etl.pipeline import run_pipeline_from_rows

app = FastAPI(title="Student ETL API")

@app.post("/ingest/student")
def ingest_student(student: dict):
    run_pipeline_from_rows([student])
    return {"status": "success"}
