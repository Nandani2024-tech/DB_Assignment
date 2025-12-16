import csv
import random

DEPARTMENTS = ["CS", "EE", "ME", "", None]
YEARS = [1, 2, 3, 4, 5, 6, "first", None]

def generate_students(n=1000):
    rows = []

    for i in range(1, n + 1):
        email = f"student{i}@example.com"

        # Introduce duplicate emails
        if random.random() < 0.05:
            email = f"student{random.randint(1, i)}@example.com"

        # Introduce invalid emails
        if random.random() < 0.1:
            email = "invalid-email"

        rows.append({
            "Name": f"Student {i}" if random.random() > 0.1 else "",
            "Email": email,
            "Phone": "" if random.random() < 0.3 else f"9{random.randint(100000000, 999999999)}",
            "Year": random.choice(YEARS),
            "Dept": random.choice(DEPARTMENTS)
        })

    return rows


if __name__ == "__main__":
    data = generate_students(1000)

    with open("tools/students_synthetic_messy.csv", "w", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=["Name", "Email", "Phone", "Year", "Dept"]
        )
        writer.writeheader()
        writer.writerows(data)

    print("⚠️ Generated students_synthetic_messy.csv")
