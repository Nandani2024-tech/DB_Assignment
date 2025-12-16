from typing import Dict, List, Any
import json
from pathlib import Path


def load_mapping(mapping_path: str) -> Dict[str, Any]:
    with open(mapping_path, "r") as f:
        return json.load(f)


def map_rows(rows, mapping):
    target_table = mapping["target_table"]
    column_map = mapping["columns"]

    mapped_rows = []

    for row in rows:
        mapped = {}

        for source_col, target_col in column_map.items():
            table, col = target_col.split(".")

            # 🔑 IMPORTANT FIX
            if table == "departments":
                mapped["department_name"] = row.get(source_col)
            else:
                mapped[col] = row.get(source_col)

        mapped_rows.append(mapped)
        if mapped.get("department_name") == "":
            mapped["department_name"] = None


    return {target_table: mapped_rows}
