import pandas as pd
import numpy as np
from pathlib import Path

# Make the generated data reproducible
np.random.seed(42)

# Output folders
source_dir = Path("sample_data/source")
target_dir = Path("sample_data/target")

source_dir.mkdir(parents=True, exist_ok=True)
target_dir.mkdir(parents=True, exist_ok=True)

# Number of synthetic orders
n_rows = 5000

# -------------------------
# BUILD SOURCE DATASET
# -------------------------

orders = pd.DataFrame({
    "order_id": range(100001, 100001 + n_rows),
    "customer_id": np.random.randint(1000, 1800, n_rows),
    "order_date": pd.to_datetime(
        np.random.choice(
            pd.date_range("2026-01-01", "2026-06-30"),
            n_rows
        )
    ),
    "channel": np.random.choice(
        ["web", "phone", "store"],
        n_rows,
        p=[0.55, 0.25, 0.20]
    ),
    "region": np.random.choice(
        ["northeast", "south", "midwest", "west"],
        n_rows
    ),
    "product": np.random.choice(
        ["basic", "premium", "enterprise"],
        n_rows,
        p=[0.50, 0.35, 0.15]
    ),
    "quantity": np.random.randint(1, 5, n_rows),
    "unit_price": np.random.choice(
        [19.99, 29.99, 49.99, 79.99],
        n_rows
    ),
})

orders["revenue"] = (
    orders["quantity"] * orders["unit_price"]
).round(2)

orders["status"] = np.random.choice(
    ["completed", "cancelled", "refunded"],
    n_rows,
    p=[0.90, 0.07, 0.03]
)

source = orders.copy()

# -------------------------
# CREATE MIGRATED TARGET
# -------------------------

target = source.copy()

# Defect 1:
# Seven records disappear during migration
target = target.drop(
    index=target.sample(7, random_state=1).index
)

# Defect 2:
# Three records are accidentally duplicated
duplicates = target.sample(3, random_state=2)
target = pd.concat([target, duplicates], ignore_index=True)

# Defect 3:
# Five product values are mapped incorrectly
product_error_rows = target.sample(5, random_state=3).index
target.loc[product_error_rows, "product"] = "basic"

# Defect 4:
# Four revenue values are altered
revenue_error_rows = target.sample(4, random_state=4).index
target.loc[revenue_error_rows, "revenue"] += 25.00

# Defect 5:
# Two channel values become null
null_error_rows = target.sample(2, random_state=5).index
target.loc[null_error_rows, "channel"] = None

# -------------------------
# WRITE FILES
# -------------------------

source.to_csv(
    source_dir / "orders.csv",
    index=False
)

target.to_csv(
    target_dir / "orders.csv",
    index=False
)

print("Synthetic migration data created.")
print(f"Source rows: {len(source):,}")
print(f"Target rows: {len(target):,}")