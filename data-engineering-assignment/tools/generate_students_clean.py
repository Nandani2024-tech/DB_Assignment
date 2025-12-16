import csv
import random

DEPARTMENTS = ["CS", "EE", "ME", "CE", "IT"]

def generate_students(n=1000):
    rows = []

    for i in range(1, n + 1):
        rows.append({
            "Name": f"Student {i}",
            "Email": f"student{i}@example.com",
            "Phone": f"9{random.randint(100000000, 999999999)}",
            "Year": random.randint(1, 5),
            "Dept": random.choice(DEPARTMENTS)
        })

    return rows


if __name__ == "__main__":
    data = generate_students(1000)

    with open("tools/students_synthetic_clean.csv", "w", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=["Name", "Email", "Phone", "Year", "Dept"]
        )
        writer.writeheader()
        writer.writerows(data)

    print("✅ Generated students_synthetic_clean.csv")
