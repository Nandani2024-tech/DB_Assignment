from typing import Dict, List, Any
from etl.load.db_connection import get_db_connection
from etl.load.loaders import (
    upsert_rows,
    resolve_department_ids
)


def run_load_pipeline(data: Dict[str, List[Dict[str, Any]]]) -> Dict[str, Any]:
    """
    Executes the Load phase of the ETL pipeline.

    Expected input format:
    {
        "departments": [...],
        "students": [...]
    }
    """
    summary = {
        "departments": {"received": 0, "affected": 0},
        "students": {"received": 0, "affected": 0},
    }

    with get_db_connection() as conn:
        # 1️⃣ Load Departments
        departments = data.get("departments", [])
        summary["departments"]["received"] = len(departments)
        summary["departments"]["affected"] = upsert_rows(
            conn, "departments", departments
        )

        # 2️⃣ Resolve FKs for Students
        students = data.get("students", [])
        summary["students"]["received"] = len(students)

        students = resolve_department_ids(conn, students)

        # 3️⃣ Load Students
        summary["students"]["affected"] = upsert_rows(
            conn, "students", students
        )

    return summary
