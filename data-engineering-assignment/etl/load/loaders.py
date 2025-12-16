from typing import List, Dict, Any
import psycopg2
from psycopg2 import sql
from psycopg2.extras import execute_values
from etl.load.upsert_strategies import UPSERT_STRATEGIES


def resolve_department_ids(
    conn,
    students: List[Dict[str, Any]]
) -> List[Dict[str, Any]]:
    with conn.cursor() as cur:
        cur.execute("SELECT id, name FROM departments")
        dept_map = {name: id for id, name in cur.fetchall()}

    resolved = []
    for s in students:
        dept_name = s.pop("department_name", None)
        s["department_id"] = dept_map.get(dept_name)
        resolved.append(s)

    return resolved


def upsert_rows(
    conn,
    table: str,
    rows: List[Dict[str, Any]]
) -> int:
    if not rows:
        return 0

    strategy = UPSERT_STRATEGIES[table]

    columns = list(rows[0].keys())
    values = [[row[col] for col in columns] for row in rows]

    if strategy["update_columns"]:
        update_assignments = [
            sql.SQL("{} = EXCLUDED.{}").format(
                sql.Identifier(col),
                sql.Identifier(col)
            )
            for col in strategy["update_columns"]
        ]
        update_clause = sql.SQL("DO UPDATE SET ").join([
            sql.SQL(""),
            sql.SQL(", ").join(update_assignments)
        ])
    else:
        update_clause = sql.SQL("DO NOTHING")

    insert_sql = sql.SQL("""
        INSERT INTO {table} ({fields})
        VALUES %s
        ON CONFLICT ({conflict_fields})
        {update_clause}
    """).format(
        table=sql.Identifier(table),
        fields=sql.SQL(", ").join(map(sql.Identifier, columns)),
        conflict_fields=sql.SQL(", ").join(
            map(sql.Identifier, strategy["conflict_columns"])
        ),
        update_clause=update_clause
    )

    with conn.cursor() as cur:
        execute_values(cur, insert_sql, values)
        return cur.rowcount
